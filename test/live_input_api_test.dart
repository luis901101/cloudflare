import 'dart:io';
import 'dart:typed_data';
import 'package:cloudflare/src/entity/cloudflare_live_input.dart';
import 'package:cloudflare/src/entity/live_input_recording.dart';
import 'package:cloudflare/src/enumerators/recording_mode.dart';
import 'package:cloudflare/src/utils/params.dart';
import 'package:path/path.dart' as p;

import 'package:cloudflare/cloudflare.dart';
import 'package:cloudflare/src/entity/data_upload_draft.dart';
import 'package:test/test.dart';

import 'base_tests.dart';
import 'utils/matchers.dart';

/// LiveInputAPI tests on each Cloudflare LiveInput API endpoint.
/// These tests ensures that every created test live input gets deleted.
void main() async {
  await init();
  final File videoFile = File(Platform.environment['CLOUDFLARE_VIDEO_FILE'] ?? ''),
      videoFile1 = File(Platform.environment['CLOUDFLARE_VIDEO_FILE_1'] ?? ''),
      videoFile2 = File(Platform.environment['CLOUDFLARE_VIDEO_FILE_2'] ?? ''),
      videoFile3 = File(Platform.environment['CLOUDFLARE_VIDEO_FILE_3'] ?? '');
  final String videoUrl = Platform.environment['CLOUDFLARE_VIDEO_URL'] ?? '';
  Set<String> cacheIds = {};

  void addId(String? id) {
    if(id != null) cacheIds.add(id);
  }

  group('Create live input tests', () {

    test('Default live input creation test', () async {
      final response = await cloudflare.liveInputAPI.create();
      expect(response, LiveInputMatcher());
      addId(response.body?.id);
    }, timeout: Timeout(Duration(minutes: 1)));

    test('Custom live input creation test', () async {
      final customLiveInput = CloudflareLiveInput(
        meta: {
          Params.name: 'live input test name'
        },
        recording: LiveInputRecording(
          mode: RecordingMode.automatic,
          allowedOrigins: ['example.com'],
          timeoutSeconds: 4,
          requireSignedURLs: true
        )
      );
      final response = await cloudflare.liveInputAPI.create(data: customLiveInput);
      expect(response, LiveInputMatcher());
      addId(response.body?.id);
      expect(response.body?.meta, customLiveInput.meta);
      expect(response.body?.recording.mode, customLiveInput.recording.mode);
    }, timeout: Timeout(Duration(minutes: 1)));
  });

  // test('Get live input usage statistics', () async {
  //   final response = await cloudflare.liveInputAPI.getStats();
  //   expect(response, ResponseMatcher());
  //   print('Stats: ${response.body?.toJson()}');
  // });
  //
  // group('Retrieve live input tests', () {
  //   late final CloudflareHTTPResponse<List<CloudflareLiveInput>?> responseList;
  //   String? liveInputId;
  //   setUpAll(() async {
  //     responseList = await cloudflare.liveInputAPI.getAll(page: 1, size: 20);
  //   });
  //
  //   test('Get live input list', () async {
  //     expect(responseList, ResponseMatcher());
  //     expect(responseList.body, isNotNull);
  //     expect(responseList.body, isNotEmpty);
  //     liveInputId = responseList.body![0].id;
  //   });
  //
  //   test('Get live input byId', () async {
  //     if (liveInputId == null) {
  //       // markTestSkipped('Get live input byId skipped: No live input available to get by Id');
  //       fail('No live input available to get by Id');
  //     }
  //     final response = await cloudflare.liveInputAPI.get(id: liveInputId!);
  //     expect(response, LiveInputMatcher());
  //   });
  //
  //   test('Get base live input byId', () async {
  //     if (liveInputId == null) {
  //       fail('No base live input available to get by Id');
  //     }
  //     final response = await cloudflare.liveInputAPI.getBase(id: liveInputId!);
  //     expect(response, ResponseMatcher());
  //     expect(response.body, isNotNull);
  //   });
  // });
  //
  // group('Update live input tests', () {
  //   String? liveInputId;
  //   final metadata = {
  //     'system_id': "live-input-test-system-id'",
  //     'description': 'This is an live input test',
  //   };
  //   setUpAll(() async {
  //     final response = await cloudflare.liveInputAPI.upload(
  //       contentFromFile: DataTransmit<File>(data: videoFile),
  //       requireSignedURLs: true,
  //       metadata: metadata,
  //     );
  //     liveInputId = response.body?.id;
  //     addId(liveInputId);
  //   });
  //
  //   test('Update live input', () async {
  //     if (liveInputId == null) {
  //       fail('No live input available to update');
  //     }
  //     metadata['system_id'] = '${metadata['system_id']}-updated';
  //     metadata['description'] = '${metadata['description']}-updated';
  //     final response = await cloudflare.liveInputAPI.update(
  //       id: liveInputId!,
  //       requireSignedURLs: false,
  //       metadata: metadata,
  //     );
  //     expect(response, LiveInputMatcher());
  //     cacheIds.remove(liveInputId);//After live input updated the liveInputId changes
  //     addId(response.body?.id);
  //     expect(response.body!.requireSignedURLs, false);
  //     expect(response.body!.meta, metadata);
  //   });
  // });
  //
  // test('Delete live input test', () async {
  //   final liveInputId = cacheIds.isNotEmpty ? cacheIds.first : null;
  //   if (liveInputId == null) {
  //     fail('No live input available to delete');
  //   }
  //   final response = await cloudflare.liveInputAPI.delete(
  //     id: liveInputId,
  //   );
  //   expect(response, ResponseMatcher());
  //   cacheIds.remove(liveInputId);
  // });
  //
  test('Delete multiple live inputs', () async {
    /// This code below is not part of the tests and should remain commented, be careful.
    // final responseList = await cloudflare.liveInputAPI.getAll();
    // if(responseList.isSuccessful && (responseList.body?.isNotEmpty ?? false)) {
    //   cacheIds = responseList.body!.map((e) => e.id).toSet();
    // }

    if (cacheIds.isEmpty) {
      fail('There are no uploaded live inputs to test multi delete.');
    }

    final responses = await cloudflare.liveInputAPI.deleteMultiple(
      ids: cacheIds.toList(),
    );
    int deleted = responses.where((response) => response.isSuccessful).length;
    print('Deleted: $deleted of ${cacheIds.length}');
    for (final response in responses) {
      expect(response, ResponseMatcher());
    }
  }, timeout: Timeout(Duration(minutes: 10)));
}
