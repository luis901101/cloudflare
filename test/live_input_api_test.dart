import 'package:cloudflare/cloudflare.dart';
import 'package:cloudflare/src/utils/params.dart';
import 'package:test/test.dart';

import 'base_tests.dart';
import 'utils/matchers.dart';

/// LiveInputAPI tests on each Cloudflare LiveInput API endpoint.
/// These tests ensures that every created test live input gets deleted.
void main() async {
  init();
  Set<String> cacheIds = {};
  Set<String> outputCacheIds = {};
  void addId(String? id) {
    if (id != null) cacheIds.add(id);
  }

  void addOutputId(String? id) {
    if (id != null) outputCacheIds.add(id);
  }

  group('Create live input tests', () {
    test('Default live input creation test', () async {
      final response = await cloudflare.liveInputAPI.create();
      expect(response, LiveInputMatcher(), reason: response.error?.toString());
      addId(response.body?.id);
    }, timeout: Timeout(Duration(minutes: 1)));

    test('Custom live input creation test', () async {
      final customLiveInput = CloudflareLiveInput(
        meta: {Params.name: 'live input test name'},
        recording: LiveInputRecording(
          mode: LiveInputRecordingMode.automatic,
          allowedOrigins: ['example.com'],
          timeoutSeconds: 4,
          requireSignedURLs: true,
        ),
      );
      final response = await cloudflare.liveInputAPI.create(
        data: customLiveInput,
      );
      expect(response, LiveInputMatcher(), reason: response.error?.toString());
      addId(response.body?.id);
      expect(response.body?.meta, customLiveInput.meta);
      expect(response.body?.recording.mode, customLiveInput.recording.mode);
    }, timeout: Timeout(Duration(minutes: 1)));
  });

  group('Get live input tests', () {
    String? liveInputId;

    test('Get live input list', () async {
      final responseList = await cloudflare.liveInputAPI.getAll();
      expect(
        responseList,
        ResponseMatcher(),
        reason: responseList.error?.toString(),
      );
      expect(responseList.body, isNotNull);
      expect(responseList.body, isNotEmpty);
      liveInputId = responseList.body![0].id;
    });

    test('Get live input byId', () async {
      if (liveInputId == null) {
        // markTestSkipped('Get live input byId skipped: No live input available to get by Id');
        fail('No live input available to get by Id');
      }
      final response = await cloudflare.liveInputAPI.get(id: liveInputId!);
      expect(response, LiveInputMatcher(), reason: response.error?.toString());
    });

    test('Get live input associated videos', () async {
      if (liveInputId == null) {
        fail('No live input available to get associated videos');
      }
      final responseList = await cloudflare.liveInputAPI.getVideos(
        id: liveInputId!,
      );
      expect(
        responseList,
        ResponseMatcher(),
        reason: responseList.error?.toString(),
      );
    });
  });

  group('Update live input tests', () {
    String? liveInputId;
    final metadata = {Params.name: 'live input test name'};
    var recording = LiveInputRecording(
      mode: LiveInputRecordingMode.automatic,
      allowedOrigins: ['example.com'],
      timeoutSeconds: 4,
      requireSignedURLs: true,
    );
    setUpAll(() async {
      final response = await cloudflare.liveInputAPI.create(
        data: CloudflareLiveInput(meta: metadata, recording: recording),
      );
      liveInputId = response.body?.id;
      addId(liveInputId);
    });

    test('Update live input', () async {
      if (liveInputId == null) {
        fail('No live input available to update');
      }
      metadata[Params.name] = '${metadata[Params.name]}-updated';
      recording = recording.copyWith(
        timeoutSeconds: 2,
        allowedOrigins: ['updated.example.com'],
      );
      final response = await cloudflare.liveInputAPI.update(
        liveInput: CloudflareLiveInput(
          id: liveInputId,
          meta: metadata,
          recording: recording,
        ),
      );
      expect(response, LiveInputMatcher(), reason: response.error?.toString());
      cacheIds.remove(
        liveInputId,
      ); //After live input updated the liveInputId changes
      addId(response.body?.id);
      expect(response.body!.meta, metadata);
      expect(response.body!.recording.timeoutSeconds, recording.timeoutSeconds);
      expect(response.body!.recording.allowedOrigins, recording.allowedOrigins);
    });
  });

  group('Outputs tests', () {
    String? liveInputId;
    List<LiveInputOutput>? outputs;
    setUpAll(() async {
      final response = await cloudflare.liveInputAPI.create();
      liveInputId = response.body?.id;
      addId(response.body?.id);
    });

    test('Add an output to a live input', () async {
      if (liveInputId == null) {
        fail('No live input available to add an output to');
      }
      final response = await cloudflare.liveInputAPI.addOutput(
        liveInputId: liveInputId,
        data: LiveInputOutput(
          url: 'rtmp://a.rtmp.youtube.com/live2',
          streamKey: 'uzya-f19y-g2g9-a2ee-51j2',
        ),
      );
      expect(response, OutputMatcher(), reason: response.error?.toString());
      addOutputId(response.body?.id);
    }, timeout: Timeout(Duration(minutes: 1)));

    test(
      'Get the output list associated to a live input',
      () async {
        if (liveInputId == null) {
          fail('No live input available to get output list');
        }
        final responseList = await cloudflare.liveInputAPI.getOutputs(
          liveInputId: liveInputId,
        );
        expect(
          responseList,
          ResponseMatcher(),
          reason: responseList.error?.toString(),
        );
        expect(responseList.body, isNotNull);
        expect(responseList.body, isNotEmpty);
        outputs = responseList.body!;
      },
      timeout: Timeout(Duration(minutes: 1)),
    );

    test(
      'Remove the outputs associated to a live input',
      () async {
        if (liveInputId == null) {
          fail('No live input available to remove outputs');
        }
        if (outputs?.isEmpty ?? true) {
          fail('No outputs available to remove');
        }
        final responses = await cloudflare.liveInputAPI.removeMultipleOutputs(
          liveInputId: liveInputId,
          outputs: outputs,
        );
        for (final response in responses) {
          expect(
            response,
            ResponseMatcher(),
            reason: response.error?.toString(),
          );
        }
      },
      timeout: Timeout(Duration(minutes: 1)),
    );
  });

  test('Delete live input test', () async {
    final liveInputId = cacheIds.isNotEmpty ? cacheIds.first : null;
    if (liveInputId == null) {
      fail('No live input available to delete');
    }
    final response = await cloudflare.liveInputAPI.delete(id: liveInputId);
    expect(response, ResponseMatcher(), reason: response.error?.toString());
    cacheIds.remove(liveInputId);
  });

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
      expect(response, ResponseMatcher(), reason: response.error?.toString());
    }
  }, timeout: Timeout(Duration(minutes: 10)));
}
