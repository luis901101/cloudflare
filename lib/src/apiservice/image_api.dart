import 'dart:io';

import 'package:cloudflare/src/base_api/c_response.dart';
import 'package:cloudflare/src/base_api/rest_api.dart';
import 'package:cloudflare/src/base_api/rest_api_service.dart';
import 'package:cloudflare/src/entity/cloudflare_image.dart';
import 'package:cloudflare/src/model/error_response.dart';
import 'package:cloudflare/src/service/image_service.dart';
import 'package:dio/dio.dart';

class ImageAPI
    extends RestAPIService<ImageService, CloudflareImage, ErrorResponse> {
  ImageAPI({required RestAPI restAPI, required String accountId})
    : super(
      restAPI: restAPI,
      service: ImageService(dio: restAPI.dio, accountId: accountId),
      dataType: CloudflareImage()
    );

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

  /// Update image access control. On access control change,
  /// all copies of the image are purged from Cache.
  Future<CResponse<CloudflareImage?>> update({
    required String id,

    /// Indicates whether the image can be accessed only using it's UID.
    /// If set to true, a signed token needs to be generated with a signing key
    /// to view the image. Returns a new UID on a change. No-op if not specified
    bool? requireSignedURLs,

    /// User modifiable key-value store. Can use used for keeping references to
    /// another system of record for managing images. No-op if not specified.
    /// "{\"meta\": \"metaID\"}"
    Map<String, dynamic>? metadata,
  }) async {
    final response = await parseResponse(service.update(
      id: id,
      requireSignedURLs: requireSignedURLs,
      metadata: metadata,
    ));

    return response;
  }

  /// Up to 100 images can be listed with one request, use optional parameters
  /// to get a specific range of images.
  Future<CResponse<List<CloudflareImage>?>> getAll({
    /// Page number of paginated results, default value: 1
    int? page,

    /// Number of items per page, default value: 50
    int? size,
  }) async {
    final response = await parseResponseAsList(service.getAll(
      page: page,
      size: size
    ));

    return response;
  }

  /// Fetch details of a single image.
  Future<CResponse<CloudflareImage?>> get({
    required String id,
  }) async {
    final response = await parseResponse(service.get(
      id: id,
    ));

    return response;
  }

  /// Fetch base image. For most images this will be the originally uploaded
  /// file. For larger images it can be a near-lossless version of the original.
  /// Note: the response is <image blob data>
  Future<CResponse<List<int>?>> getBase({
    required String id,
  }) async {
    final response = await genericParseResponse<List<int>>(
      service.getBase(
        id: id,
      ), parseCloudflareResponse: false
    );

    return response;
  }

  /// Delete an image on Cloudflare Images. On success, all copies of the image
  /// are deleted and purged from Cache.
  Future<CResponse> delete({
    required String id,
  }) async {
    final response = await getSaveResponse(service.delete(id: id,), parseCloudflareResponse: false);
    return response;
  }
}
