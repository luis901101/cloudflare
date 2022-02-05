import 'dart:io';

import 'package:cloudflare/cloudflare.dart';
import 'package:cloudflare/src/base_api/c_response.dart';
import 'package:test/test.dart';

import 'base_tests.dart';
import 'utils/matchers.dart';

void main() async {

  await init();

  group('Retrieve image tests', () {
    late final CResponse<List<CloudflareImage>?> responseList;
    String? imageId;
    setUpAll(() async {
      responseList = await cloudflare.imageAPI.getAll(page: 1, size: 20);
    });

    test('Get image list', () async {
      expect(responseList.isSuccessful, true);
      expect(responseList.body, isNotNull);
      expect(responseList.body, isNotEmpty);
      imageId = responseList.body![0].id;
    });

    test('Get image byId', () async {
      if(imageId == null) {
        // markTestSkipped('Get image byId skipped: No image available to get by Id');
        throw Exception('No image available to get by Id');
      }
      final response = await cloudflare.imageAPI.get(id: imageId!);
      expect(response, ImageMatcher());
    });

    test('Get base image byId', () async {
      if(imageId == null) {
        throw Exception('No base image available to get by Id');
      }
      final response = await cloudflare.imageAPI.getBase(id: imageId!);
      expect(response.isSuccessful, true);
      expect(response.body, isNotNull);
    });
  });

  group('Upload image tests', () {
    late final File imageFile;
    setUpAll(() async {
      imageFile = File(Platform.environment['CLOUDFLARE_IMAGE_FILE'] ?? '');
    });

    test('Simple upload image from file', () async {
      if(!imageFile.existsSync()) {
        throw Exception('No image file available to upload');
      }
      final response = await cloudflare.imageAPI.upload(
        file: imageFile
      );
      expect(response, ImageMatcher());
    });

    test('Upload image from file with progress update', () async {
      if(!imageFile.existsSync()) {
        throw Exception('No image file available to upload');
      }
      final response = await cloudflare.imageAPI.upload(
        file: imageFile,
        onUploadProgress: (count, total) {
          print('Upload image from file: $count/$total');
        }
      );
      expect(response, ImageMatcher());
    });

    test('Upload image with requireSignedURLs and metadata', () async {
      if(!imageFile.existsSync()) {
        throw Exception('No image file available to upload');
      }
      final metadata = {
        'system_id': "image-test-system-id'",
        'description': 'This is an image test',
      };
      final response = await cloudflare.imageAPI.upload(
        file: imageFile,
        requireSignedURLs: true,
        metadata: metadata,
      );
      expect(response, ImageMatcher());
      expect(response.body!.requireSignedURLs, true);
      expect(response.body!.meta, metadata);
    });
  });

  group('Update/Delete image tests', () {
    late final File imageFile;
    String? imageId;
    final metadata = {
      'system_id': "image-test-system-id'",
      'description': 'This is an image test',
    };
    setUpAll(() async {
      imageFile = File(Platform.environment['CLOUDFLARE_IMAGE_FILE'] ?? '');
      final response = await cloudflare.imageAPI.upload(
        file: imageFile,
        // requireSignedURLs: true,
        metadata: metadata,

      );
      imageId = response.body?.id;
    });

    test('Update image', () async {
      if(imageId == null) {
        throw Exception('No image available to update');
      }
      metadata['system_id'] = '${metadata['system_id']}-updated';
      metadata['description'] = '${metadata['description']}-updated';
      final response = await cloudflare.imageAPI.update(
        id: imageId!,
        // requireSignedURLs: false,
        metadata: metadata,
      );
      expect(response, ImageMatcher());
      // expect(response.body!.requireSignedURLs, false);
      expect(response.body!.meta, metadata);
    });

    test('Delete image', () async {
      if(imageId == null) {
        throw Exception('No image available to delete');
      }
      final response = await cloudflare.imageAPI.delete(
        id: imageId!,
      );
      expect(response.isSuccessful, true);
    });
  });
}
