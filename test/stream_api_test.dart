import 'dart:io';

import 'package:cloudflare/cloudflare.dart';
import 'package:test/test.dart';

import 'base_tests.dart';
import 'utils/matchers.dart';

void main() async {
  await init();

  group('Stream video tests', () {
    late final File videoFile, videoFile1, videoFile2;
    late final String videoUrl;
    setUpAll(() async {
      videoFile = File(Platform.environment['CLOUDFLARE_VIDEO_FILE'] ?? '');
      videoFile1 = File(Platform.environment['CLOUDFLARE_VIDEO_FILE_1'] ?? '');
      videoFile2 = File(Platform.environment['CLOUDFLARE_VIDEO_FILE_2'] ?? '');
      videoUrl = Platform.environment['CLOUDFLARE_VIDEO_URL'] ?? '';
    });

    test('Simple stream video from file with progress update', () async {
      if (!videoFile.existsSync()) {
        fail('No video file available to stream');
      }
      final response = await cloudflare.streamAPI.stream(
          contentFromFile: DataTransmit<File>(
              data: videoFile,
              progressCallback: (count, total) {
                print('Simple stream video from file progress: $count/$total');
              }));
      expect(response, StreamVideoMatcher());
    }, timeout: Timeout(Duration(minutes: 2)));

    test('Simple stream video from url with progress update', () async {
      if (videoUrl.isEmpty) {
        fail('No video url available to stream');
      }
      final response = await cloudflare.streamAPI.stream(url: videoUrl);
      expect(response, StreamVideoMatcher());
    }, timeout: Timeout(Duration(minutes: 2)));

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
      }
    }, timeout: Timeout(Duration(minutes: 2)));

    test('Simple stream video from path with progress update', () async {
      if (!videoFile.existsSync()) {
        fail('No video file available to stream');
      }
      final response = await cloudflare.streamAPI.stream(
          contentFromPath: DataTransmit<String>(
              data: videoFile.path,
              progressCallback: (count, total) {
                print('Simple stream video from path progress: $count/$total');
              }));
      expect(response, StreamVideoMatcher());
    }, timeout: Timeout(Duration(minutes: 2)));

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
      }
    }, timeout: Timeout(Duration(minutes: 2)));

    test('Simple stream video from bytes with progress update', () async {
      if (!videoFile.existsSync()) {
        fail('No video file available to stream');
      }
      final response = await cloudflare.streamAPI.stream(
          contentFromBytes: DataTransmit<List<int>>(
              data: videoFile.readAsBytesSync(),
              progressCallback: (count, total) {
                print('Simple stream video from bytes progress: $count/$total');
              }));
      expect(response, StreamVideoMatcher());
      print(response.body?.toString());
    }, timeout: Timeout(Duration(minutes: 2)));

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
      }
    }, timeout: Timeout(Duration(minutes: 2)));
  });
  
  group('Retrieve video tests', () {
    String? videoId;

    test('Get video list without filters', () async {
      final responseList = await cloudflare.streamAPI.getAll();
      expect(responseList, ResponseMatcher());
      expect(responseList.body, isNotNull);
      expect(responseList.body, isNotEmpty);
      videoId = responseList.body![0].id;
    });

    test('Get video list with filters', () async {
      final responseList = await cloudflare.streamAPI.getAll(
        before: DateTime.now(),
        limit: 5,
        asc: true,
        includeCounts: true,
      );
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

  // group('Update/Delete video tests', () {
  //   late final File videoFile;
  //   String? videoId;
  //   final metadata = {
  //     'system_id': "video-test-system-id'",
  //     'description': 'This is an video test',
  //   };
  //   setUpAll(() async {
  //     videoFile = File(Platform.environment['CLOUDFLARE_VIDEO_FILE'] ?? '');
  //     final response = await cloudflare.streamAPI.stream(
  //       contentFromFile: DataTransmit<File>(data: videoFile),
  //       // requireSignedURLs: true,
  //       metadata: metadata,
  //     );
  //     videoId = response.body?.id;
  //   });
  //
  //   test('Update video', () async {
  //     if (videoId == null) {
  //       fail('No video available to update');
  //     }
  //     metadata['system_id'] = '${metadata['system_id']}-updated';
  //     metadata['description'] = '${metadata['description']}-updated';
  //     final response = await cloudflare.streamAPI.update(
  //       id: videoId!,
  //       // requireSignedURLs: false,
  //       metadata: metadata,
  //     );
  //     expect(response, StreamVideoMatcher());
  //     // expect(response.body!.requireSignedURLs, false);
  //     expect(response.body!.meta, metadata);
  //   });
  //
  //   test('Delete video', () async {
  //     if (videoId == null) {
  //       fail('No video available to delete');
  //     }
  //     final response = await cloudflare.streamAPI.delete(
  //       id: videoId!,
  //     );
  //     expect(response, ResponseMatcher());
  //   });
  // });
  //
  // test('Delete multiple images', () async {
  //   final responseList = await cloudflare.streamAPI.getAll(page: 1, size: 20);
  //   if (responseList.body?.isEmpty ?? true) {
  //     fail('There are no streamed images to test multi delete.');
  //   }
  //
  //   List<CloudflareStreamVideo> images = [];
  //   for (int i = 0, length = min(3, responseList.body!.length);
  //       i < length;
  //       ++i) {
  //     images.add(responseList.body![i]);
  //   }
  //
  //   final responses = await cloudflare.streamAPI.deleteMultiple(
  //     images: images,
  //   );
  //   for (final response in responses) {
  //     expect(response, ResponseMatcher());
  //   }
  // });
}
