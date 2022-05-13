import 'dart:async';
import 'dart:io';
import 'dart:convert' show base64, utf8;
import 'dart:math' show min;
import 'dart:typed_data' show Uint8List, BytesBuilder;

import 'package:cloudflare/src/apiservice/tus/exceptions.dart';
import 'package:cloudflare/src/apiservice/tus/store.dart';
import 'package:cloudflare/src/utils/map_utils.dart';
import 'package:cross_file/cross_file.dart' show XFile;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

/// Callback to listen the progress for sending data.
/// [count] the length of the bytes that have been sent.
/// [total] the content length.
typedef ProgressCallback = void Function(int count, int total, http.Response? response);

/// Callback to listen when upload finishes
typedef CompleteCallback = void Function(http.Response response);

/// This is a client for the tus(https://tus.io) protocol.
class TusClient {
  /// Version of the tus protocol used by the client. The remote server needs to
  /// support this version, too.
  static const tusVersion = '1.0.0';
  static const contentTypeOffsetOctetStream = 'application/offset+octet-stream';

  static const tusResumableHeader = 'tus-resumable';
  static const uploadMetadataHeader = 'upload-metadata';
  static const uploadOffsetHeader = 'upload-offset';
  static const uploadLengthHeader = 'upload-length';

  /// The tus server URL
  final String url;

  /// The file to upload
  final XFile file;

  /// Storage used to save and retrieve upload URLs by its fingerprint.
  /// This is required if you need to pause/resume uploads.
  final TusStore? store;

  /// Metadata for specific upload server
  final Map<String, dynamic>? metadata;

  /// Any additional headers
  final Map<String, String> headers;

  /// The size in bytes when uploading the file in chunks
  /// Default value: 256 KB
  final int chunkSize;

  /// Timeout duration for tus server requests
  /// Default value: 30 seconds
  final Duration timeout;

  /// Set this if you need to use a custom http client
  final http.Client httpClient;

  int _fileSize = 0;
  late final String _fingerprint;
  late final String _uploadMetadata;
  Uri _uploadURI = Uri();
  int _offset = 0;
  bool _pauseUpload = false;
  Future? _uploadFuture;

  TusClient({
    required this.url,
    required this.file,
    this.store,
    Map<String, dynamic>? headers,
    this.metadata,
    this.chunkSize = 256 * 1024,
    Duration? timeout,
    http.Client? httpClient,
  }) :
      headers = MapUtils.parseMapDynamicHeaders(headers) ?? {},
      timeout = timeout ?? const Duration(seconds: 30),
      httpClient = httpClient ?? http.Client() {
    _fingerprint = generateFingerprint();
    _uploadMetadata = generateMetadata();
  }

  /// Whether the client supports resuming
  bool get resumingEnabled => store != null;

  /// The URI on the server for the file
  String get uploadUrl => _uploadURI.toString();

  /// The fingerprint of the file being uploaded
  String get fingerprint => _fingerprint;

  /// The uploadMetadataHeaderKey header sent to server
  String get uploadMetadata => _uploadMetadata;

  /// Create a new [upload] throwing [ProtocolException] on server error
  Future<void> create() async {
    _fileSize = await file.length();

    final createHeaders = {
      ...headers,
      tusResumableHeader: tusVersion,
      uploadMetadataHeader: _uploadMetadata,
      uploadLengthHeader: '$_fileSize',
    };

    final response = await httpClient.post(Uri.parse(url), headers: createHeaders);

    if (!(response.statusCode >= 200 && response.statusCode < 300)) {
      throw ProtocolException(
          'Unexpected status code (${response.statusCode}) while creating upload', response);
    }

    String locationURL = response.headers[HttpHeaders.locationHeader]?.toString() ?? '';
    if (locationURL.isEmpty) {
      throw ProtocolException(
          'Missing upload URL in response for creating upload', response);
    }

    _uploadURI = _parseUrl(locationURL);
    store?.set(_fingerprint, _uploadURI.toString());
  }

  /// Check if possible to resume an already started upload
  Future<bool> resume() async {
    if (!resumingEnabled) return false;
    _fileSize = await file.length();
    _pauseUpload = false;

    _uploadURI = Uri.parse(await store?.get(_fingerprint) ?? '');

    return _uploadURI.toString().isNotEmpty;
  }

  /// Start or resume an upload in chunks of [chunkSize] throwing
  /// [ProtocolException] on server error
  Future<void> upload({
    ProgressCallback? onProgress,
    CompleteCallback? onComplete,
    Function()? onTimeoutCallback,
  }) async {
    if (!await resume()) {
      await create();
    }

    // get offset from server
    _offset = await _getOffset();

    http.Response? response;

    // start upload
    while (!_pauseUpload && _offset < _fileSize) {

      // update progress
      onProgress?.call(_offset, _fileSize, response);

      final uploadHeaders = {
        ...headers,
        tusResumableHeader: tusVersion,
        uploadOffsetHeader: '$_offset',
        HttpHeaders.contentTypeHeader: contentTypeOffsetOctetStream
      };

      _uploadFuture = httpClient.patch(
        _uploadURI,
        headers: uploadHeaders,
        body: await _getData(),
      );
      response = await _uploadFuture?.timeout(timeout, onTimeout: () {
        onTimeoutCallback?.call();
        return http.Response('', HttpStatus.requestTimeout,
            reasonPhrase: 'Request timeout');
      });
      _uploadFuture = null;

      // check if correctly uploaded
      if (!(response!.statusCode >= 200 && response.statusCode < 300)) {
        throw ProtocolException(
            'Unexpected status code (${response.statusCode}) while uploading chunk', response);
      }

      int? serverOffset = _parseOffset(response.headers[uploadOffsetHeader]);
      if (serverOffset == null) {
        throw ProtocolException(
            'Response to PATCH request contains no or invalid Upload-Offset header', response);
      }
      if (_offset != serverOffset) {
        throw ProtocolException(
            'Response contains different Upload-Offset value ($serverOffset) than expected ($_offset)', response);
      }
    }

    // update progress
    onProgress?.call(_offset, _fileSize, response);

    if (_offset == _fileSize) {
      this.onComplete();
      onComplete?.call(response!);
    }
  }

  /// Pause the current upload
  Future? pause() {
    _pauseUpload = true;
    return _uploadFuture?.timeout(Duration.zero, onTimeout: () {
      return http.Response('', 200,
          reasonPhrase: 'Request paused');
    });
  }

  /// Actions to be performed after a successful upload
  void onComplete() {
    store?.remove(_fingerprint);
  }

  /// Override this method to customize creating file fingerprint
  String generateFingerprint() {
    return file.path.replaceAll(RegExp(r'\W+'), '.');
  }

  /// Override this to customize the header 'Upload-Metadata'
  String generateMetadata() {
    final meta = MapUtils.parseMapDynamicHeaders(metadata) ?? {};

    if (!meta.containsKey('filename')) {
      meta['filename'] = path.basename(file.path);
    }

    return meta.entries.map((entry) => '${entry.key} ${base64.encode(utf8.encode(entry.value))}').join(',');
  }

  /// Get offset from server throwing [ProtocolException] on error
  Future<int> _getOffset() async {
    final offsetHeaders = {
      ...headers,
      tusResumableHeader: tusVersion,
    };
    final response = await httpClient.head(_uploadURI, headers: offsetHeaders);

    if (!(response.statusCode >= 200 && response.statusCode < 300)) {
      throw ProtocolException(
          'Unexpected status code (${response.statusCode}) while resuming upload', response);
    }

    int? serverOffset = _parseOffset(response.headers[uploadOffsetHeader]);
    if (serverOffset == null) {
      throw ProtocolException(
          'Missing upload offset in response for resuming upload', response);
    }
    return serverOffset;
  }

  /// Get data from file to upload

  Future<Uint8List> _getData() async {
    int start = _offset;
    int end = _offset + chunkSize;
    end = end > _fileSize ? _fileSize : end;

    final result = BytesBuilder();
    await for (final chunk in file.openRead(start, end)) {
      result.add(chunk);
    }

    final bytesRead = min(chunkSize, result.length);
    _offset = _offset + bytesRead;

    return result.takeBytes();
  }

  int? _parseOffset(String? offset) {
    if (offset == null || offset.isEmpty) return null;
    if (offset.contains(',')) {
      offset = offset.substring(0, offset.indexOf(','));
    }
    return int.tryParse(offset);
  }

  Uri _parseUrl(String locationURL) {
    if (locationURL.contains(',')) {
      locationURL = locationURL.substring(0, locationURL.indexOf(','));
    }
    Uri uploadURI = Uri.parse(locationURL);
    Uri baseURI = Uri.parse(url);
    if (uploadURI.host.isEmpty) {
      uploadURI = uploadURI.replace(host: baseURI.host, port: baseURI.port);
    }
    if (uploadURI.scheme.isEmpty) {
      uploadURI = uploadURI.replace(scheme: baseURI.scheme);
    }
    return uploadURI;
  }
}
