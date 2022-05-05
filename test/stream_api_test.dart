import 'dart:io';

import 'package:cloudflare/cloudflare.dart';
import 'package:test/test.dart';

import 'base_tests.dart';
import 'utils/matchers.dart';

/// StreamAPI tests on each Cloudflare Stream API endpoint.
/// These tests ensures that every streamed test video gets deleted.
void main() async {
  await init();
  final File videoFile = File(Platform.environment['CLOUDFLARE_VIDEO_FILE'] ?? ''),
      videoFile1 = File(Platform.environment['CLOUDFLARE_VIDEO_FILE_1'] ?? ''),
      videoFile2 = File(Platform.environment['CLOUDFLARE_VIDEO_FILE_2'] ?? '');
  final String videoUrl = Platform.environment['CLOUDFLARE_VIDEO_URL'] ?? '';
  Set<String> videoIds = {};

  void addId(String? id) {
    if(id != null) videoIds.add(id);
  }

  group('Stream video tests', () {
    test('Simple stream video from file with progress update', () async {
      if (!videoFile.existsSync()) {
        fail('No video file available to stream');
      }
      final response = await cloudflare.streamAPI.stream(
          contentFromFile: DataTransmit<File>(
              data: videoFile,
              progressCallback: (count, total) {
                final split = videoFile.path.split(Platform.pathSeparator);
                String? filename = split.isNotEmpty ? split.last : null;
                print('Simple stream video: $filename from file progress: $count/$total');
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
                final split = videoFile.path.split(Platform.pathSeparator);
                String? filename = split.isNotEmpty ? split.last : null;
                print('Simple stream video: $filename from path progress: $count/$total');
              }));
      expect(response, StreamVideoMatcher());
      addId(response.body?.id);
    }, timeout: Timeout(Duration(minutes: 5)));

    test('Simple stream video from bytes with progress update', () async {
      if (!videoFile.existsSync()) {
        fail('No video bytes available to stream');
      }
      final response = await cloudflare.streamAPI.stream(
          contentFromBytes: DataTransmit<List<int>>(
              data: videoFile.readAsBytesSync(),
              progressCallback: (count, total) {
                final split = videoFile.path.split(Platform.pathSeparator);
                String? filename = split.isNotEmpty ? split.last : null;
                print('Simple stream video: $filename from bytes progress: $count/$total');
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
                print('Simple stream video from url: $videoUrl progress: $count/$total');
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
              final split = file.path.split(Platform.pathSeparator);
              String? filename = split.isNotEmpty ? split.last : null;
              print(
                  'Multiple stream video from file: $filename progress: $count/$total');
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
              final split = path.split(Platform.pathSeparator);
              String? filename = split.isNotEmpty ? split.last : null;
              print(
                  'Multiple stream video from path: $filename progress: $count/$total');
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
      List<DataTransmit<List<int>>> contents = [];
      for (final file in files) {
        contents.add(DataTransmit<List<int>>(
            data: file.readAsBytesSync(),
            progressCallback: (count, total) {
              final split = file.path.split(Platform.pathSeparator);
              String? filename = split.isNotEmpty ? split.last : null;
              print(
                  'Multiple stream video from bytes: $filename progress: $count/$total');
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

    // group('Video direct stream tests', () {
    //   late final CloudflareHTTPResponse<DataUploadDraft?> response;
    //   late final String? videoId;
    //   late final String? uploadURL;
    //
    //   setUpAll(() async {
    //     // response = await cloudflare.streamAPI.createDirectUpload();
    //     // videoId = response.body?.id;
    //     // uploadURL = response.body?.uploadURL;
    //   });
    //
    //   test('Create authenticated direct video stream URL', () async {
    //     expect(response, ResponseMatcher());
    //     expect(response.body?.id, isNotEmpty);
    //     expect(response.body?.uploadURL, isNotEmpty);
    //   }, timeout: Timeout(Duration(minutes: 5)));
    //
    //   test('Check created video draft status', () async {
    //     if (videoId?.isEmpty ?? true) {
    //       fail('No videoId available to check draft status');
    //     }
    //     final response = await cloudflare.streamAPI.get(id: videoId);
    //     expect(response, StreamVideoMatcher());
    //     expect(response.body?.draft, true);
    //   }, timeout: Timeout(Duration(minutes: 5)));
    //
    //   test('Doing video stream to direct stream URL', () async {
    //     if (uploadURL?.isEmpty ?? true) {
    //       fail('No streamURL available to stream to');
    //     }
    //     final response = await cloudflare.streamAPI.directUpload(
    //         streamURL: uploadURL!,
    //         contentFromFile: DataTransmit<File>(
    //             data: videoFile,
    //             progressCallback: (count, total) {
    //               print('Video stream to direct stream URL from file progress: $count/$total');
    //             })
    //     );
    //     expect(response, StreamVideoMatcher());
    //     addId(response.body?.id);
    //     expect(response.body?.id, videoId);
    //     expect(response.body?.draft, false);
    //   }, timeout: Timeout(Duration(minutes: 5)));
    // });
  });

  group('Retrieve video tests', () {
    late final CloudflareHTTPResponse<List<CloudflareStreamVideo>?> responseList;
    String? videoId;
    setUpAll(() async {
      responseList = await cloudflare.streamAPI.getAll(/*page: 1, size: 20*/);
    });

    test('Get video list', () async {
      expect(responseList, ResponseMatcher());
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
    final videoId = videoIds.isNotEmpty ? videoIds.first : null;
    if (videoId == null) {
      fail('No video available to delete');
    }
    final response = await cloudflare.streamAPI.delete(
      id: videoId,
    );
    expect(response, ResponseMatcher());
    videoIds.remove(videoId);
  });

  test('Delete multiple videos', () async {
    /// This code below is not part of the tests and should remain commented, be careful.
    // final responseList = await cloudflare.streamAPI.getAll();
    // if(responseList.isSuccessful && (responseList.body?.isNotEmpty ?? false)) {
    //   videoIds = responseList.body!.map((e) => e.id).toSet();
    // }
    
    if (videoIds.isEmpty) {
      fail('There are no streamed videos to test multi delete.');
    }

    final responses = await cloudflare.streamAPI.deleteMultiple(
      ids: videoIds.toList(),
    );
    int deleted = responses.where((response) => response.isSuccessful).length;
    print('Deleted: $deleted of ${videoIds.length}');
    for (final response in responses) {
      expect(response, ResponseMatcher());
    }
  }, timeout: Timeout(Duration(minutes: 10)));
}
