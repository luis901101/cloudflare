import 'dart:convert' show base64, utf8;

import 'package:cloudflare/src/utils/params.dart';
import 'package:dio/dio.dart' as dio;
import 'package:cloudflare/cloudflare.dart';
import 'package:cloudflare/src/apiservice/tus/client.dart';
import 'package:cloudflare/src/apiservice/tus/store.dart';
import 'package:cloudflare/src/entity/data_upload_draft.dart';
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
  dio.ProgressCallback? _onProgress;
  Function(CloudflareStreamVideo? cloudflareStreamVideo)? _onComplete;
  Function()? _onTimeoutCallback;

  TusAPI({
    required DataUploadDraft dataUploadDraft,
    required XFile file,
    TusStore? store,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? metadata,
    int? chunkSize,
    Duration? timeout,
    Function()? onTimeoutCallback,
  }) : _dataUploadDraft = dataUploadDraft {
    _tusClient = TusClient(
      url: dataUploadDraft.uploadURL,
      file: file,
      store: store ?? TusMemoryStore(),
      headers: MapUtils.parseMapDynamicHeaders(headers),
      metadata: MapUtils.parseMapDynamicHeaders(metadata),
      chunkSize: chunkSize ?? 5 * 1024 * 1024,
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
  Future<bool> canResume() => _tusClient.resume();

  /// Start or resume an upload in chunks
  /// It throws [ProtocolException] on server error
  Future<void> upload({
    dio.ProgressCallback? onProgress,
    Function(CloudflareStreamVideo? cloudflareStreamVideo)? onComplete,
    Function()? onTimeoutCallback,
  }) {
    _onProgress = onProgress;
    _onComplete = onComplete;
    _onTimeoutCallback = onTimeoutCallback;
    return _tusClient.upload(
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
      onTimeoutCallback: _onTimeoutCallback,
    );
  }

  /// Pause the current upload
  void pause() => _tusClient.pause();

  /// Resume the current upload
  void resume() => upload(
    onProgress: _onProgress,
    onComplete: _onComplete,
    onTimeoutCallback: _onTimeoutCallback,
  );
}
