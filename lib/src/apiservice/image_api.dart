import 'dart:io';

import 'package:cloudflare_sdk/src/base_api/c_response.dart';
import 'package:cloudflare_sdk/src/base_api/rest_api.dart' as rest_api;
import 'package:cloudflare_sdk/src/base_api/rest_api_service.dart';
import 'package:cloudflare_sdk/src/entity/cloudflare_image.dart';
import 'package:cloudflare_sdk/src/service/image_service.dart';
import 'package:cloudflare_sdk/src/model/error_response.dart';
import 'package:dio/dio.dart';

class ImageAPI
    extends RestAPIService<ImageService, CloudflareImage, ErrorResponse> {
  ImageAPI()
      : super(ImageService(rest_api.restAPI.dio), dataType: CloudflareImage());

  Future<CResponse<CloudflareImage?>> upload({
    /// Image file to upload
    required File file,

    /// Indicates whether the image requires a signature token for the access
    /// default value: false
    /// valid values: (true,false)
    bool? requireSignedURLs,

    /// User modifiable key-value store. Can use used for keeping references to
    /// another system of record for managing images.
    /// "{\"meta\": \"metaID\"}"
    Map<String, dynamic>? metadata,

    /// Callback for image file upload progress
    ProgressCallback? onUploadProgress,
  }) async {
    final response = await parseResponse(service.upload(
      file: file,
      requireSignedURLs: requireSignedURLs,
      metadata: metadata,
      onUploadProgress: onUploadProgress,
    ));

    return response;
  }
}
