import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloudflare/cloudflare.dart';
import 'package:cross_file/cross_file.dart';
import 'package:test/test.dart';

/// TusAPI tests, run against a tus server of their own rather than against
/// Cloudflare, so they need no credentials and no network.
void main() {
  final videoBytes = Uint8List.fromList(
    List.generate(20 * 1024, (index) => index % 256),
  );
  const chunkSize = 4 * 1024;

  XFile videoFile() => XFile.fromData(videoBytes, path: 'video.mp4');

  late FakeTusServer server;

  setUp(() async => server = await FakeTusServer.start());
  tearDown(() async => server.close());

  test('creates the upload and reports the upload URI to persist', () async {
    final tusAPI = TusAPI(
      file: videoFile(),
      dataUploadDraft: DataUploadDraft(uploadURL: server.creationUrl),
      chunkSize: chunkSize,
    );
    addTearDown(tusAPI.close);

    String? createdUploadUrl;
    CloudflareStreamVideo? uploadedVideo;
    await tusAPI.startUpload(
      onUploadCreated: (uploadUrl) => createdUploadUrl = uploadUrl,
      onComplete: (streamVideo) => uploadedVideo = streamVideo,
    );

    expect(server.creationRequests, 1);
    expect(
      createdUploadUrl,
      server.uploadUrl,
      reason: 'The resolved upload URI is what a later resume needs',
    );
    expect(tusAPI.uploadURI, server.uploadUrl);
    expect(server.received, videoBytes);
    expect(uploadedVideo?.id, server.videoId);
    expect(uploadedVideo?.readyToStream, true);
  });

  test('resumes from a supplied upload URI, with no draft at all', () async {
    // What is left of an upload the process was killed halfway through.
    server.seedReceived(
      videoBytes.sublist(0, 8 * 1024),
      uploadLength: videoBytes.length,
    );

    final tusAPI = TusAPI(
      file: videoFile(),
      uploadUrl: server.uploadUrl,
      chunkSize: chunkSize,
    );
    addTearDown(tusAPI.close);

    String? createdUploadUrl;
    CloudflareStreamVideo? uploadedVideo;
    await tusAPI.startUpload(
      onUploadCreated: (uploadUrl) => createdUploadUrl = uploadUrl,
      onComplete: (streamVideo) => uploadedVideo = streamVideo,
    );

    expect(
      server.creationRequests,
      0,
      reason: 'A resumed upload must not create a second video',
    );
    expect(
      server.patchRequests,
      3,
      reason: 'Only the 12 KB the server was missing, in 4 KB chunks',
    );
    expect(server.received, videoBytes);
    expect(tusAPI.offset, videoBytes.length);
    expect(
      createdUploadUrl,
      isNull,
      reason: 'The caller already knows the URI it supplied',
    );
    expect(uploadedVideo?.id, server.videoId);
  });

  test('identifies the video by the draft id when the server reports '
      'no stream-media-id', () async {
    await server.close();
    server = await FakeTusServer.start(reportStreamMediaId: false);
    server.seedReceived(
      videoBytes.sublist(0, 16 * 1024),
      uploadLength: videoBytes.length,
    );

    final tusAPI = TusAPI(
      file: videoFile(),
      dataUploadDraft: const DataUploadDraft(id: 'a-video-id'),
      uploadUrl: server.uploadUrl,
      chunkSize: chunkSize,
    );
    addTearDown(tusAPI.close);

    CloudflareStreamVideo? uploadedVideo;
    await tusAPI.startUpload(
      onComplete: (streamVideo) => uploadedVideo = streamVideo,
    );

    expect(server.received, videoBytes);
    expect(uploadedVideo?.id, 'a-video-id');
    expect(tusAPI.dataUploadDraft.id, 'a-video-id');
  });

  test('reports no video when nothing identifies it', () async {
    await server.close();
    server = await FakeTusServer.start(reportStreamMediaId: false);
    server.seedReceived(
      videoBytes.sublist(0, 16 * 1024),
      uploadLength: videoBytes.length,
    );

    final tusAPI = TusAPI(
      file: videoFile(),
      uploadUrl: server.uploadUrl,
      chunkSize: chunkSize,
    );
    addTearDown(tusAPI.close);

    bool completed = false;
    CloudflareStreamVideo? uploadedVideo;
    await tusAPI.startUpload(
      onComplete: (streamVideo) {
        completed = true;
        uploadedVideo = streamVideo;
      },
    );

    expect(completed, true);
    expect(uploadedVideo, isNull);
  });

  test('requires either a draft upload url or an upload url', () {
    expect(() => TusAPI(file: videoFile()), throwsA(isA<AssertionError>()));
    expect(
      () => TusAPI(file: videoFile(), dataUploadDraft: const DataUploadDraft()),
      throwsA(isA<AssertionError>()),
    );
  });

  test('StreamAPI resumes a direct stream upload from an upload URI', () async {
    server.seedReceived(
      videoBytes.sublist(0, 8 * 1024),
      uploadLength: videoBytes.length,
    );

    final tusAPI = await Cloudflare.basic().streamAPI.tusDirectStreamUpload(
      file: videoFile(),
      uploadUrl: server.uploadUrl,
      chunkSize: chunkSize,
    );
    addTearDown(tusAPI.close);

    expect(tusAPI.uploadURI, server.uploadUrl);

    CloudflareStreamVideo? uploadedVideo;
    await tusAPI.startUpload(
      onComplete: (streamVideo) => uploadedVideo = streamVideo,
    );

    expect(server.creationRequests, 0);
    expect(server.received, videoBytes);
    expect(uploadedVideo?.id, server.videoId);
  });
}

/// A minimal [tus](https://tus.io) server, enough to exercise upload creation,
/// offset lookup and chunk uploads without talking to Cloudflare.
class FakeTusServer {
  FakeTusServer._(this._server, this.videoId, this.reportStreamMediaId);

  static Future<FakeTusServer> start({
    String videoId = '0123456789abcdef0123456789abcdef',

    /// Whether the response to the last chunk carries the `stream-media-id`
    /// header Cloudflare identifies the resulting video with.
    bool reportStreamMediaId = true,
  }) async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final fakeTusServer = FakeTusServer._(server, videoId, reportStreamMediaId);
    unawaited(fakeTusServer._serve());
    return fakeTusServer;
  }

  final HttpServer _server;
  final String videoId;
  final bool reportStreamMediaId;
  final List<int> _received = [];

  /// How long the upload was declared to be, as the tus `Upload-Length`.
  int uploadLength = 0;

  /// How many uploads were created and how many chunks were taken, which is
  /// what tells a resumed upload apart from one that started over.
  int creationRequests = 0;
  int patchRequests = 0;

  String get baseUrl => 'http://${_server.address.address}:${_server.port}';
  String get creationUrl => '$baseUrl/stream';
  String get uploadUrl => '$baseUrl/tus/$videoId';
  Uint8List get received => Uint8List.fromList(_received);

  /// Leaves the server holding [bytes] of an upload of [uploadLength] bytes, as
  /// an upload interrupted partway through would.
  void seedReceived(List<int> bytes, {required int uploadLength}) {
    _received
      ..clear()
      ..addAll(bytes);
    this.uploadLength = uploadLength;
  }

  Future<void> close() => _server.close(force: true);

  Future<void> _serve() async {
    await for (final request in _server) {
      final response = request.response..headers.set('Tus-Resumable', '1.0.0');
      switch (request.method) {
        case 'POST':
          creationRequests++;
          uploadLength =
              int.tryParse(request.headers.value('Upload-Length') ?? '') ?? 0;
          response
            ..statusCode = HttpStatus.created
            ..headers.set('Location', uploadUrl);
        case 'HEAD':
          response
            ..statusCode = HttpStatus.ok
            ..headers.set('Upload-Offset', '${_received.length}')
            ..headers.set('Upload-Length', '$uploadLength');
        case 'PATCH':
          final offset =
              int.tryParse(request.headers.value('Upload-Offset') ?? '') ?? -1;
          final chunk = <int>[];
          await for (final data in request) {
            chunk.addAll(data);
          }
          if (offset != _received.length) {
            response.statusCode = HttpStatus.conflict;
            break;
          }
          patchRequests++;
          _received.addAll(chunk);
          response
            ..statusCode = HttpStatus.noContent
            ..headers.set('Upload-Offset', '${_received.length}');
          if (reportStreamMediaId && _received.length == uploadLength) {
            response.headers.set('stream-media-id', videoId);
          }
        default:
          response.statusCode = HttpStatus.methodNotAllowed;
      }
      await response.close();
    }
  }
}
