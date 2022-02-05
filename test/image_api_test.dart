import 'package:cloudflare/cloudflare.dart';
import 'package:cloudflare/src/base_api/c_response.dart';
import 'package:test/test.dart';

import 'base_tests.dart';

void main() async {

  await init();

  group('Retrieve image use cases', () {
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
        markTestSkipped('Get image byId skipped: No image available to get by Id');
        return;
      }
      final response = await cloudflare.imageAPI.get(id: imageId!);
      expect(response.isSuccessful, true);
      expect(response.body!.variants.isNotEmpty, isNotNull);
    });

    test('Get base image byId', () async {
      if(imageId == null) {
        markTestSkipped('Get image byId skipped: No image available to get by Id');
        return;
      }
      final response = await cloudflare.imageAPI.getBase(id: imageId!);
      expect(response.isSuccessful, true);
      expect(response.body, isNotNull);
    });
  });
}
