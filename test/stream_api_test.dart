import 'dart:io';
import 'dart:typed_data';
import 'package:tusc/tusc.dart';
import 'package:path/path.dart' as p;

import 'package:cloudflare/cloudflare.dart';
import 'package:test/test.dart';

import 'base_tests.dart';
import 'utils/matchers.dart';

/// StreamAPI tests on each Cloudflare Stream API endpoint.
/// These tests ensures that every streamed test video gets deleted.
///
// ignore_for_file: void_checks
void main() async {
  await init();
  Set<String> cacheIds = {};
  void addId(String? id) {
    if (id != null) cacheIds.add(id);
  }

  test('Handling video from url tests', () {
    final video0 = CloudflareStreamVideo.fromUrl(
        'https://customer-6sdf6as5fdasd3zo.cloudflarestream.com/e8c4fb942c9e9d287451169a08107cf8/manifest/video.m3u8');
    final video1 = CloudflareStreamVideo.fromUrl(
        'https://videodelivery.net/2dee576797b5448fb3fb32f09f6a607c/thumbnails/thumbnail.jpg');
    final video2 = CloudflareStreamVideo.fromUrl(
        'https://watch.videodelivery.net/2dee576797b5448fb3fb32f09f6a607c');
    final video3 = CloudflareStreamVideo.fromUrl(
        'https://videodelivery.net/2dee576797b5448fb3fb32f09f6a607c/manifest/video.m3u8');
    final video4 = CloudflareStreamVideo.fromUrl(
        'https://videodelivery.net/2dee576797b5448fb3fb32f09f6a607c/manifest/video.mdp');
    final video5 = CloudflareStreamVideo.fromUrl(
        'https://cloudflarestream.com/2dee576797b5448fb3fb32f09f6a607c/thumbnails/thumbnail.jpg');
    final video6 = CloudflareStreamVideo.fromUrl(
        'https://upload.videodelivery.net/2dee576797b5448fb3fb32f09f6a607c');
    final video7 = CloudflareStreamVideo(id: 'c5n485g8q34hrxi2uehdjsnkd');
    final video8 = CloudflareStreamVideo();
    expect(video0?.playback, isNotNull, reason: video0?.playback?.hls);
    expect(video1?.playback, isNotNull, reason: video1?.playback?.hls);
    expect(video2?.playback, isNotNull, reason: video2?.playback?.hls);
    expect(video3?.playback, isNotNull, reason: video3?.playback?.hls);
    expect(video4?.playback, isNotNull, reason: video4?.playback?.hls);
    expect(video5?.playback, isNotNull, reason: video5?.playback?.hls);
    expect(video6?.playback, isNotNull, reason: video6?.playback?.hls);
    expect(video7.playback, isNotNull, reason: video7.playback?.hls);
    expect(video8.playback, isNull, reason: video8.playback?.hls);

    print('video0-> id:${video0?.id}  hls: ${video0?.playback?.hls}');
    print('video1-> id:${video1?.id}  hls: ${video1?.playback?.hls}');
    print('video2-> id:${video2?.id}  hls: ${video2?.playback?.hls}');
    print('video3-> id:${video3?.id}  hls: ${video3?.playback?.hls}');
    print('video4-> id:${video4?.id}  hls: ${video4?.playback?.hls}');
    print('video5-> id:${video5?.id}  hls: ${video5?.playback?.hls}');
    print('video6-> id:${video6?.id}  hls: ${video6?.playback?.hls}');
    print('video7-> id:${video7.id}  hls: ${video7.playback?.hls}');
    print('video8-> id:${video8.id}  hls: ${video8.playback?.hls}');
  });

  group('Stream video tests', () {
    test('Simple stream video from file with progress update', () async {
      if (!videoFile.existsSync()) {
        fail('No video file available to stream');
      }
      final response = await cloudflare.streamAPI.stream(
          contentFromFile: DataTransmit<File>(
              data: videoFile,
              progressCallback: (count, total) {
                print(
                    'Simple stream video: ${p.basename(videoFile.path)} from file progress: $count/$total');
              }));
      expect(response, StreamVideoMatcher());
      addId(response.body?.id);
    }, timeout: Timeout(Duration(minutes: 5)));

    test('Simple stream video from path with progress update', () async {
      if (!videoFile.existsSync()) {
        fail('No video path available to stream');
      }
      final response = await cloudflare.streamAPI.stream(
          contentFromPath: DataTransmit<String>(
              data: videoFile.path,
              progressCallback: (count, total) {
                print(
                    'Simple stream video: ${p.basename(videoFile.path)} from path progress: $count/$total');
              }));
      expect(response, StreamVideoMatcher());
      addId(response.body?.id);
    }, timeout: Timeout(Duration(minutes: 5)));

    test('Simple stream video from bytes with progress update', () async {
      if (!videoFile.existsSync()) {
        fail('No video bytes available to stream');
      }
      final response = await cloudflare.streamAPI.stream(
          contentFromBytes: DataTransmit<Uint8List>(
              data: videoFile.readAsBytesSync(),
              progressCallback: (count, total) {
                print(
                    'Simple stream video: ${p.basename(videoFile.path)} from bytes progress: $count/$total');
              }));
      expect(response, StreamVideoMatcher());
      addId(response.body?.id);
    }, timeout: Timeout(Duration(minutes: 5)));

    test('Simple stream video from url with progress update', () async {
      if (videoUrl.isEmpty) {
        fail('No video url available to stream');
      }
      final response = await cloudflare.streamAPI.stream(
          contentFromUrl: DataTransmit<String>(
              data: videoUrl,
              progressCallback: (count, total) {
                print(
                    'Simple stream video from url: $videoUrl progress: $count/$total');
              }));
      expect(response, StreamVideoMatcher());
      addId(response.body?.id);
    }, timeout: Timeout(Duration(minutes: 5)));

    test('Multiple stream video from file with progress update', () async {
      if (!videoFile.existsSync() ||
          !videoFile1.existsSync() ||
          !videoFile2.existsSync()) {
        fail(
            'videoFile and videoFile1 and videoFile2 are required for multiple stream test. Check if you set each video file for each env var.');
      }
      final files = [videoFile, videoFile1, videoFile2];
      List<DataTransmit<File>> contents = [];
      for (final file in files) {
        contents.add(DataTransmit<File>(
            data: file,
            progressCallback: (count, total) {
              print(
                  'Multiple stream video from file: ${p.basename(file.path)} progress: $count/$total');
            }));
      }
      final responses = await cloudflare.streamAPI.streamMultiple(
        contentFromFiles: contents,
      );
      for (final response in responses) {
        expect(response, StreamVideoMatcher());
        addId(response.body?.id);
      }
    }, timeout: Timeout(Duration(minutes: 5)));

    test('Multiple stream video from path with progress update', () async {
      if (!videoFile.existsSync() ||
          !videoFile1.existsSync() ||
          !videoFile2.existsSync()) {
        fail(
            'videoFile and videoFile1 and videoFile2 are required for multiple stream test. Check if you set each video file for each env var.');
      }
      final paths = [videoFile.path, videoFile1.path, videoFile2.path];
      List<DataTransmit<String>> contents = [];
      for (final path in paths) {
        contents.add(DataTransmit<String>(
            data: path,
            progressCallback: (count, total) {
              print(
                  'Multiple stream video from path: ${p.basename(path)} progress: $count/$total');
            }));
      }
      final responses = await cloudflare.streamAPI.streamMultiple(
        contentFromPaths: contents,
      );
      for (final response in responses) {
        expect(response, StreamVideoMatcher());
        addId(response.body?.id);
      }
    }, timeout: Timeout(Duration(minutes: 5)));

    test('Multiple stream video from bytes with progress update', () async {
      if (!videoFile.existsSync() ||
          !videoFile1.existsSync() ||
          !videoFile2.existsSync()) {
        fail(
            'videoFile and videoFile1 and videoFile2 are required for multiple stream test. Check if you set each video file for each env var.');
      }
      final files = [videoFile, videoFile1, videoFile2];
      List<DataTransmit<Uint8List>> contents = [];
      for (final file in files) {
        contents.add(DataTransmit<Uint8List>(
            data: file.readAsBytesSync(),
            progressCallback: (count, total) {
              print(
                  'Multiple stream video from bytes: ${p.basename(file.path)} progress: $count/$total');
            }));
      }
      final responses = await cloudflare.streamAPI.streamMultiple(
        contentFromBytes: contents,
      );
      for (final response in responses) {
        expect(response, StreamVideoMatcher());
        addId(response.body?.id);
      }
    }, timeout: Timeout(Duration(minutes: 5)));

    test('Multiple stream video from url with progress update', () async {
      if (videoUrl.isEmpty) {
        fail(
            'videoUrl is required for multiple stream test. Check if you set videoUrl in the env vars.');
      }
      final urls = [videoUrl, videoUrl, videoUrl];
      List<DataTransmit<String>> contents = [];
      for (final url in urls) {
        contents.add(DataTransmit<String>(
            data: url,
            progressCallback: (count, total) {
              print(
                  'Multiple stream video from url: $url progress: $count/$total');
            }));
      }
      final responses = await cloudflare.streamAPI.streamMultiple(
        contentFromUrls: contents,
      );
      for (final response in responses) {
        expect(response, StreamVideoMatcher());
        addId(response.body?.id);
      }
    }, timeout: Timeout(Duration(minutes: 5)));

    test('Stream video from url with requireSignedURLs', () async {
      if (!videoFile.existsSync()) {
        fail('No video file available to stream');
      }
      final response = await cloudflare.streamAPI.stream(
        contentFromUrl: DataTransmit<String>(data: videoUrl),
        requireSignedURLs: true,
      );
      expect(response, StreamVideoMatcher());
      expect(response.body!.requireSignedURLs, true);
      addId(response.body?.id);
    }, timeout: Timeout(Duration(minutes: 5)));

    group('Video direct stream tests', () {
      late final CloudflareHTTPResponse<DataUploadDraft?> response;
      late final DataUploadDraft? dataUploadDraft;

      setUpAll(() async {
        print(
            'WARNIGN: Make sure to test with a video with less than 60 seconds duration');
        response = await cloudflare.streamAPI
            .createDirectStreamUpload(maxDurationSeconds: 60);
        dataUploadDraft = response.body;
      });

      test('Create authenticated direct stream video URL', () async {
        expect(response, ResponseMatcher(), reason: response.error?.toString());
        expect(dataUploadDraft?.id, isNotEmpty);
        expect(dataUploadDraft?.uploadURL, isNotEmpty,
            reason: 'Just created video stream uploadURL  can\'t be empty');
      });

      test('Check created video ready to stream status', () async {
        if (dataUploadDraft?.id.isEmpty ?? true) {
          fail('No videoId available to check video status');
        }
        final response =
            await cloudflare.streamAPI.get(id: dataUploadDraft?.id);
        expect(response, StreamVideoMatcher());
        expect(response.body?.readyToStream, false,
            reason: 'Just created video stream can\'t be ready');
      }, timeout: Timeout(Duration(minutes: 1)));

      test('Doing video stream to direct stream URL', () async {
        if (dataUploadDraft?.uploadURL.isEmpty ?? true) {
          fail('No streamURL available to stream to');
        }
        if (!videoFile.existsSync()) {
          fail('No video file available to stream');
        }
        final response = await cloudflare.streamAPI.directStreamUpload(
            dataUploadDraft: dataUploadDraft!,
            contentFromFile: DataTransmit<File>(
                data: videoFile,
                progressCallback: (count, total) {
                  print(
                      'Video stream to direct stream URL from file: ${p.basename(videoFile.path)} progress: $count/$total');
                }));
        expect(response, StreamVideoMatcher());
        addId(response.body?.id);
        expect(response.body?.id, dataUploadDraft?.id,
            reason: 'Uploaded video id doesn\'t match created upload video');
        expect(response.body?.readyToStream, true,
            reason: 'Video stream is not ready');
      }, timeout: Timeout(Duration(minutes: 5)));
    });
  });

  group('tus protocol stream upload tests', () {
    DataUploadDraft? dataUploadDraft;

    test('Doing authenticated stream upload using tus protocol', () async {
      if (!videoFile.existsSync()) {
        fail('No video file available to stream');
      }
      final tusAPI = await cloudflare.streamAPI.tusStream(
        file: videoFile,
        name: 'test-video-upload-authenticated',
        cache: TusPersistentCache(''),
        timeout: Duration(minutes: 5),
      );
      bool isComplete = false;
      onProgress(count, total) {
        if (isComplete) return;
        print(
            'tus authenticated video stream from file: ${p.basename(videoFile.path)} progress: $count/$total');
      }

      final testProgressCallback =
          expectAsyncUntil2(onProgress, () => isComplete);
      try {
        await tusAPI.startUpload(
            onProgress: testProgressCallback,
            onComplete: (cloudflareStreamVideo) {
              addId(cloudflareStreamVideo?.id);
              print(
                  'tus authenticated video stream completed videoId: ${cloudflareStreamVideo?.id}');
              isComplete = true;
              testProgressCallback(0, 0);
            });
      } on ProtocolException catch (e) {
        print('Response status code: ${e.response.statusCode}');
        print('Response status reasonPhrase: ${e.response.reasonPhrase}');
        print('Response body: ${e.response.body}');
        print('Response headers: ${e.response.headers}');
        rethrow;
      } catch (e) {
        print(e);
        rethrow;
      }
    }, timeout: Timeout(Duration(minutes: 20)));

    test('Create authenticated direct stream video URL using tus protocol',
        () async {
      if (!videoFile3.existsSync()) {
        fail('No video file available to get its file size');
      }
      final fileSize = videoFile3.lengthSync();
      final response = await cloudflare.streamAPI.createTusDirectStreamUpload(
        size: fileSize,
        name: 'test-video-direct-upload',
        // maxDurationSeconds: 60, //when using tus protocol [maxDurationSeconds] is not required because Cloudflare reserves a loose amount of minutes for the video to be uploaded
      );
      dataUploadDraft = response.body;
      expect(response, ResponseMatcher(), reason: response.error?.toString());
      expect(dataUploadDraft?.id, isNotEmpty);
      expect(dataUploadDraft?.uploadURL, isNotEmpty,
          reason: 'Just created video stream uploadURL can\'t be empty');
    }, timeout: Timeout(Duration(minutes: 1)));

    test('Check created video ready to stream status', () async {
      if (dataUploadDraft?.id.isEmpty ?? true) {
        fail('No videoId available to check video status');
      }
      final response = await cloudflare.streamAPI.get(id: dataUploadDraft?.id);
      expect(response, StreamVideoMatcher());
      expect(response.body?.readyToStream, false,
          reason: 'Just created video stream can\'t be ready');
    }, timeout: Timeout(Duration(minutes: 1)));

    test('Doing direct stream upload using tus protocol', () async {
      if (dataUploadDraft?.uploadURL.isEmpty ?? true) {
        fail('No streamURL available to stream to');
      }
      if (!videoFile3.existsSync()) {
        fail('No video file available to stream');
      }
      final tusAPI = await cloudflare.streamAPI.tusDirectStreamUpload(
        dataUploadDraft: dataUploadDraft!,
        file: videoFile3,
        timeout: Duration(minutes: 5),
      );
      bool isComplete = false;
      onProgress(count, total) {
        if (isComplete) return;
        print(
            'tus direct video stream from file: ${p.basename(videoFile3.path)} progress: $count/$total');
      }

      final testProgressCallback =
          expectAsyncUntil2(onProgress, () => isComplete);
      tusAPI.startUpload(
          onProgress: testProgressCallback,
          onComplete: (cloudflareStreamVideo) {
            addId(cloudflareStreamVideo?.id);
            print(
                'tus authenticated video stream completed videoId: ${cloudflareStreamVideo?.id}');
            isComplete = true;
            testProgressCallback(0, 0);
            expect(cloudflareStreamVideo, isNotNull,
                reason:
                    'CloudFlareStreamVideo must not be null after tus stream upload');
            expect(cloudflareStreamVideo?.id, isNotEmpty,
                reason:
                    'CloudFlareStreamVideo id must not be empty after tus stream upload');
          },
          onTimeout: () {
            print('Request timeout');
          });

      await Future.delayed(const Duration(seconds: 2), () {
        print('Upload paused');
        tusAPI.pauseUpload();
      });

      await Future.delayed(const Duration(seconds: 5), () {
        print('Upload resumed');
        tusAPI.resumeUpload();
      });
    }, timeout: Timeout(Duration(minutes: 20)));
  });

  group('Retrieve video tests', () {
    late final CloudflareHTTPResponse<List<CloudflareStreamVideo>?>
        responseList;
    String? videoId;
    setUpAll(() async {
      responseList = await cloudflare.streamAPI.getAll(before: DateTime.now());
    });

    test('Get video list', () async {
      expect(responseList, ResponseMatcher(),
          reason: responseList.error?.toString());
      expect(responseList.body, isNotNull);
      expect(responseList.body, isNotEmpty);
      videoId = responseList.body![0].id;
    });

    test('Get video byId', () async {
      if (videoId == null) {
        // markTestSkipped('Get video byId skipped: No video available to get by Id');
        fail('No video available to get by Id');
      }
      final response = await cloudflare.streamAPI.get(id: videoId!);
      expect(response, StreamVideoMatcher());
    });
  });

  test('Delete video test', () async {
    final videoId = cacheIds.isNotEmpty ? cacheIds.first : null;
    if (videoId == null) {
      fail('No video available to delete');
    }
    final response = await cloudflare.streamAPI.delete(
      id: videoId,
    );
    expect(response, ResponseMatcher(), reason: response.error?.toString());
    cacheIds.remove(videoId);
  });

  test('Delete multiple videos', () async {
    /// This code below is not part of the tests and should remain commented, be careful.
    // final responseList = await cloudflare.streamAPI.getAll(status: [MediaProcessingState.pendingUpload, MediaProcessingState.error]);
    // if(responseList.isSuccessful && (responseList.body?.isNotEmpty ?? false)) {
    //   cacheIds = responseList.body!.map((e) => e.id).toSet();
    // }

    if (cacheIds.isEmpty) {
      fail('There are no streamed videos to test multi delete.');
    }

    final responses = await cloudflare.streamAPI.deleteMultiple(
      ids: cacheIds.toList(),
    );
    int deleted = responses.where((response) => response.isSuccessful).length;
    print('Deleted: $deleted of ${cacheIds.length}');
    for (final response in responses) {
      expect(response, ResponseMatcher(), reason: response.error?.toString());
    }
  }, timeout: Timeout(Duration(minutes: 10)));
}
