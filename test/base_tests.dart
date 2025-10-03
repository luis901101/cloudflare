// ignore_for_file: deprecated_member_use_from_same_package
import 'dart:io';

import 'package:cloudflare/cloudflare.dart';
import 'package:cloudflare/src/base_api/rest_api.dart';
import 'package:cross_file/cross_file.dart';
import 'package:dio/io.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import 'utils/matchers.dart';

///
/// Make sure to set these environment variables before running tests.
/// Take into account not all envs are necessary, it depends on what kind of
/// authentication you want to use.
///
/// export CLOUDFLARE_API_URL=https://api.cloudflare.com/client/v4
/// export CLOUDFLARE_ACCOUNT_ID=xxxxxxxxxxxxxxxxxxxxxxxxxxx
/// export CLOUDFLARE_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxx
/// export CLOUDFLARE_API_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxx
/// export CLOUDFLARE_ACCOUNT_EMAIL=xxxxxxxxxxxxxxxxxxxxxxxxxxx
/// export CLOUDFLARE_USER_SERVICE_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxx
///
/// export CLOUDFLARE_IMAGE_FILE=/Users/user/Desktop/image-test.jpg
/// export CLOUDFLARE_IMAGE_FILE_1=/Users/user/Desktop/image-test-1.jpg
/// export CLOUDFLARE_IMAGE_FILE_2=/Users/user/Desktop/image-test-2.jpg
/// export CLOUDFLARE_IMAGE_URL=https://picsum.photos/id/237/536/354
/// export CLOUDFLARE_VIDEO_FILE=/Users/user/Desktop/video-test.mp4
/// export CLOUDFLARE_VIDEO_FILE_1=/Users/user/Desktop/video-test-1.mp4
/// export CLOUDFLARE_VIDEO_FILE_2=/Users/user/Desktop/video-test-2.mp4
/// export CLOUDFLARE_VIDEO_FILE_3=/Users/user/Desktop/video-test-3.mp4
/// export CLOUDFLARE_VIDEO_URL=http://clips.vorwaerts-gmbh.de/VfE_html5.mp4
///
final String? apiUrl = Platform.environment['CLOUDFLARE_API_URL'];
final String? accountId = Platform.environment['CLOUDFLARE_ACCOUNT_ID'];
final String? token = Platform.environment['CLOUDFLARE_TOKEN'];
final String? apiKey = Platform.environment['CLOUDFLARE_API_KEY'];
final String? accountEmail = Platform.environment['CLOUDFLARE_ACCOUNT_EMAIL'];
final String? userServiceKey =
    Platform.environment['CLOUDFLARE_USER_SERVICE_KEY'];

final XFile imageFile = XFile(
      Platform.environment['CLOUDFLARE_IMAGE_FILE'] ?? '',
    ),
    imageFile1 = XFile(Platform.environment['CLOUDFLARE_IMAGE_FILE_1'] ?? ''),
    imageFile2 = XFile(Platform.environment['CLOUDFLARE_IMAGE_FILE_2'] ?? '');
final String imageUrl = Platform.environment['CLOUDFLARE_IMAGE_URL'] ?? '';
final XFile videoFile = XFile(
      Platform.environment['CLOUDFLARE_VIDEO_FILE'] ?? '',
    ),
    videoFile1 = XFile(Platform.environment['CLOUDFLARE_VIDEO_FILE_1'] ?? ''),
    videoFile2 = XFile(Platform.environment['CLOUDFLARE_VIDEO_FILE_2'] ?? ''),
    videoFile3 = XFile(Platform.environment['CLOUDFLARE_VIDEO_FILE_3'] ?? '');
final String videoUrl = Platform.environment['CLOUDFLARE_VIDEO_URL'] ?? '';

Cloudflare cloudflare = Cloudflare.basic();

extension XFileUtils on XFile {
  bool existsSync() => File(path).existsSync();
  Future<bool> exists() => File(path).exists();
}

void init() {
  if (accountId == null) throw Exception("accountId can't be null");

  cloudflare = Cloudflare(
    apiUrl: apiUrl,
    accountId: accountId!,
    token: token,
    apiKey: apiKey,
    accountEmail: accountEmail,
    userServiceKey: userServiceKey,
  );
}

/// Common tests for all APIs.
void main() {
  init();
  Set<String> cacheIds = {};
  void addId(String? id) {
    if (id != null) cacheIds.add(id);
  }

  group('RestAPI', () {
    test('Applies headers and apiKey via interceptor', () async {
      final rest = RestAPI();
      final captured = <RequestOptions>[];

      rest.init(
        apiUrl: 'https://example.com',
        headers: {'X-Test': '1'},
        interceptors: [
          InterceptorsWrapper(
            onRequest: (options, handler) {
              captured.add(options);
              handler.next(options);
            },
          ),
        ],
      );

      final options = RequestOptions(path: '/ping');
      try {
        await rest.dio.fetch(options);
      } catch (_) {
        // No adapter; just validate interceptors execution
      }

      expect(captured.length, 1);
      final req = captured.first;
      expect(req.headers['X-Test'], '1');
    });

    test('Custom interceptors run after auth interceptor', () async {
      final rest = RestAPI();
      String? authHeaderSeen;

      rest.init(
        apiUrl: 'https://example.com',
        headers: {'Authorization': 'Bearer override'},
        interceptors: [
          InterceptorsWrapper(
            onRequest: (options, handler) {
              authHeaderSeen =
                  options.headers['authorization'] ??
                  options.headers['Authorization'];
              handler.next(options);
            },
          ),
        ],
      );

      final options = RequestOptions(path: '/ping');
      try {
        await rest.dio.fetch(options);
      } catch (_) {}

      expect(authHeaderSeen, isNotNull);
    });
  });

  group('Using Custom HttpClientAdapter', () {
    cloudflare = Cloudflare(
      apiUrl: apiUrl,
      accountId: accountId!,
      token: token,
      apiKey: apiKey,
      accountEmail: accountEmail,
      userServiceKey: userServiceKey,
      httpClientAdapter: IOHttpClientAdapter(),
    );
    test(
      'Simple upload image from file with progress update, using Custom HttpClientAdapter',
      () async {
        if (!imageFile.existsSync()) {
          fail('No image file available to upload');
        }
        final response = await cloudflare.imageAPI.upload(
          fileName: 'image-from-file',
          contentFromFile: DataTransmit<XFile>(
            data: imageFile,
            progressCallback: (count, total) {
              print(
                'Simple upload image: ${p.basename(imageFile.path)} from file progress: $count/$total',
              );
            },
          ),
        );
        expect(response, ImageMatcher());
        addId(response.body?.id);
      },
      timeout: Timeout(Duration(minutes: 2)),
    );
  });

  group('Cancel requests using cancel token ', () {
    // Reset cloudflare instance to not use Custom HttpClientAdapter
    init();
    test(
      'Cancel simple upload image from file, using cancel token param',
      () async {
        if (!imageFile.existsSync()) {
          fail('No image file available to upload');
        }
        final cancelToken = CancelToken();
        final cancellationReason = 'Cancelled by user using cancel token param';
        cancelToken.cancel(cancellationReason);
        final response = await cloudflare.imageAPI.upload(
          fileName: 'image-from-file',
          contentFromFile: DataTransmit<XFile>(data: imageFile),
          cancelToken: cancelToken,
        );
        expect(response.isSuccessful, false);
        expect(response.error is CloudflareErrorResponse, true);
        print(
          'Cancellation reason from response: ${(response.error as CloudflareErrorResponse).errors.firstOrNull?.message}',
        );
        addId(response.body?.id);
      },
      timeout: Timeout(Duration(minutes: 2)),
    );

    test(
      'Cancel simple upload image from file, using default api cancel token',
      () async {
        if (!imageFile.existsSync()) {
          fail('No image file available to upload');
        }
        final cancelToken = CancelToken();
        final cancellationReason =
            'Cancelled by user using cancel token from api';
        cancelToken.cancel(cancellationReason);
        cloudflare.restAPI.cancelTokenCallback = () => cancelToken;
        final response = await cloudflare.imageAPI.upload(
          fileName: 'image-from-file',
          contentFromFile: DataTransmit<XFile>(data: imageFile),
        );
        cloudflare.restAPI.cancelTokenCallback =
            null; // Reset cancel token callback for future requests
        expect(response.isSuccessful, false);
        expect(response.error is CloudflareErrorResponse, true);
        print(
          'Cancellation reason from response: ${(response.error as CloudflareErrorResponse).errors.firstOrNull?.message}',
        );
        addId(response.body?.id);
      },
      timeout: Timeout(Duration(minutes: 2)),
    );
  });

  test('Delete base test images', () async {
    /// This code below is not part of the tests and should remain commented, be careful.
    // final responseList = await cloudflare.imageAPI.getAll(page: 1, size: 20);
    // if(responseList.isSuccessful && (responseList.body?.isNotEmpty ?? false)) {
    //   cacheIds = responseList.body!.map((e) => e.id).toSet();
    // }

    if (cacheIds.isEmpty) {
      fail('There are no uploaded images to test multi delete.');
    }

    final responses = await cloudflare.imageAPI.deleteMultiple(
      ids: cacheIds.toList(),
    );
    int deleted = responses.where((response) => response.isSuccessful).length;
    print('Deleted: $deleted of ${cacheIds.length}');
    for (final response in responses) {
      expect(response, ResponseMatcher(), reason: response.error?.toString());
    }
  }, timeout: Timeout(Duration(minutes: 10)));
}
