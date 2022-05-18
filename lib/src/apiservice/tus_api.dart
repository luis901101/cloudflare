import 'dart:convert' show base64, utf8;

import 'package:cloudflare/src/utils/params.dart';
import 'package:dio/dio.dart' as dio;
import 'package:cloudflare/cloudflare.dart';
import 'package:tusc/tusc.dart';
import 'package:cloudflare/src/utils/map_utils.dart';
import 'package:cross_file/cross_file.dart' show XFile;

class TusAPI {
  static const tusVersion = '1.0.0';

  static String? generateMetadata(Map<String, dynamic>? map) {
    map?.removeWhere((key, value) => value == null || (value is List && value.isEmpty));
    if(map?.isEmpty ?? true) return null;
    final metadata = MapUtils.parseMapDynamicHeaders(map!);
    return metadata?.entries
      .map((entry) =>
        '${entry.key} ${base64.encode(utf8.encode(entry.value))}')
      .join(',');
  }

  DataUploadDraft _dataUploadDraft;
  late final TusClient _tusClient;

  TusAPI({
    required DataUploadDraft dataUploadDraft,
    required XFile file,
    TusCache? cache,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? metadata,
    int? chunkSize,
    Duration? timeout,
    Function()? onTimeoutCallback,
  }) : _dataUploadDraft = dataUploadDraft {
    _tusClient = TusClient(
      url: dataUploadDraft.uploadURL,
      file: file,
      cache: cache ?? TusMemoryCache(),
      headers: MapUtils.parseMapDynamicHeaders(headers),
      metadata: MapUtils.parseMapDynamicHeaders(metadata),
      chunkSize: chunkSize ?? 5.MB,
      timeout: timeout,
    );
  }

  /// Whether the client supports resuming
  bool get resumingEnabled => _tusClient.resumingEnabled;

  /// The URI on the server for the file
  String get uploadURI => _tusClient.uploadUrl;

  /// The fingerprint of the file being uploaded
  String get fingerprint => _tusClient.fingerprint;

  /// The 'Upload-Metadata' header sent to server
  String get uploadMetadata => _tusClient.uploadMetadata;

  /// Check if possible to resume an already started upload
  Future<bool> canResume() => _tusClient.canResume();

  /// Start or resume an upload in chunks
  /// It throws [ProtocolException] on server error
  Future<void> startUpload({
    dio.ProgressCallback? onProgress,
    Function(CloudflareStreamVideo? cloudflareStreamVideo)? onComplete,
    Function()? onTimeoutCallback,
  }) {
    return _tusClient.startUpload(
      onProgress: (count, total, response) {
        onProgress?.call(count, total);
      },
      onComplete: (response) {
        if(onComplete != null) {
          final streamMediaId = response.headers[Params.streamMediaIdKC] ?? '';
          if(streamMediaId.isNotEmpty) {
            _dataUploadDraft = _dataUploadDraft.copyWith(id: streamMediaId);
          }
          final cloudflareStreamVideo = (_dataUploadDraft.id.isEmpty ?
            CloudflareStreamVideo.fromUrl(_dataUploadDraft.uploadURL) :
            CloudflareStreamVideo(id: _dataUploadDraft.id,))
            ?.copyWith(readyToStream: true);
          onComplete(cloudflareStreamVideo);
        }
      },
      onTimeout: onTimeoutCallback,
    );
  }

  /// Pause the current upload
  Future? pauseUpload() => _tusClient.pauseUpload();

  /// Resume the current upload
  Future<void> resumeUpload() => _tusClient.resumeUpload();
}
