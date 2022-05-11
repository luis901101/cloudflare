import 'dart:convert';

import 'package:tus_client/tus_client.dart';
import 'package:cross_file/cross_file.dart' show XFile;

class TusAPI {
  final String uploadURL;
  late final TusClient _tusClient;

  TusAPI({
    required this.uploadURL,
    required XFile file,
    TusStore? store,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? metadata,
    int chunkSize = 5 * 1024 * 1024,
  }) {
    _tusClient = TusClient(
      Uri.parse(uploadURL),
      file,
      store: store ?? TusMemoryStore(),
      headers: headers?.map((key, value) => MapEntry<String, String>(key, value is String ? value : jsonEncode(value))),
      metadata: metadata?.map((key, value) => MapEntry<String, String>(key, value is String ? value : jsonEncode(value))),
      maxChunkSize: chunkSize,
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
    Function(double)? onProgress,
    Function()? onComplete,
  }) => _tusClient.upload(onProgress: onProgress, onComplete: onComplete);

  /// Pause the current upload
  void pause() => _tusClient.pause();
}
