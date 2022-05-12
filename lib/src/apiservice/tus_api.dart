import 'dart:convert' show base64, utf8;

import 'package:cloudflare/cloudflare.dart';
import 'package:cloudflare/src/entity/data_upload_draft.dart';
import 'package:cloudflare/src/utils/map_utils.dart';
import 'package:dio/dio.dart';
import 'package:tus_client/tus_client.dart';
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

  final DataUploadDraft dataUploadDraft;
  late final TusClient _tusClient;
  ProgressCallback? _onProgress;
  Function(CloudflareStreamVideo? cloudflareStreamVideo)? _onComplete;

  TusAPI({
    required this.dataUploadDraft,
    required XFile file,
    TusStore? store,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? metadata,
    int? chunkSize,
  }) {
    _tusClient = TusClient(
      Uri.parse(dataUploadDraft.uploadURL),
      file,
      store: store ?? TusMemoryStore(),
      headers: MapUtils.parseMapDynamicHeaders(headers),
      metadata: MapUtils.parseMapDynamicHeaders(metadata),
      maxChunkSize: chunkSize ?? 5 * 1024 * 1024,
    );
  }

  /// Whether the client supports resuming
  bool get resumingEnabled => _tusClient.resumingEnabled;

  /// The URI on the server for the file
  Uri? get uploadURI => _tusClient.uploadUrl;

  /// The fingerprint of the file being uploaded
  String get fingerprint => _tusClient.fingerprint;

  /// The 'Upload-Metadata' header sent to server
  String get uploadMetadata => _tusClient.uploadMetadata;

  /// Check if possible to resume an already started upload
  Future<bool> canResume() => _tusClient.resume();

  /// Start or resume an upload in chunks
  /// It throws [ProtocolException] on server error
  Future<void> upload({
    ProgressCallback? onProgress,
    Function(CloudflareStreamVideo? cloudflareStreamVideo)? onComplete,
  }) {
    _onProgress = onProgress;
    _onComplete = onComplete;
    return _tusClient.upload(
      onProgress: (progress) {
        onProgress?.call(progress.toInt(), 100);
      },
      onComplete: () {
        if(onComplete != null) {
          final cloudflareStreamVideo = (dataUploadDraft.id.isEmpty ?
            CloudflareStreamVideo.fromUrl(dataUploadDraft.uploadURL) :
            CloudflareStreamVideo(id: dataUploadDraft.id,))
            ?.copyWith(readyToStream: true);
          onComplete(cloudflareStreamVideo);
        }
      }
    );
  }

  /// Pause the current upload
  void pause() => _tusClient.pause();

  /// Resume the current upload
  void resume() => upload(
    onProgress: _onProgress,
    onComplete: _onComplete,
  );
}
