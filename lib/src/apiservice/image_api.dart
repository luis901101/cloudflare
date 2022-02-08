import 'dart:io';

import 'package:cloudflare/src/base_api/c_response.dart';
import 'package:cloudflare/src/base_api/rest_api.dart';
import 'package:cloudflare/src/base_api/rest_api_service.dart';
import 'package:cloudflare/src/entity/cloudflare_image.dart';
import 'package:cloudflare/src/model/data_transmit.dart';
import 'package:cloudflare/src/model/error_response.dart';
import 'package:cloudflare/src/service/image_service.dart';

class ImageAPI
    extends RestAPIService<ImageService, CloudflareImage, ErrorResponse> {
  ImageAPI({required RestAPI restAPI, required String accountId})
    : super(
      restAPI: restAPI,
      service: ImageService(dio: restAPI.dio, accountId: accountId),
      dataType: CloudflareImage()
    );

  /// An image up to 10 Megabytes can be upload.
  Future<CResponse<CloudflareImage?>> uploadFromFile({
    /// Image file to upload
    required DataTransmit<File> content,

    /// Indicates whether the image requires a signature token for the access
    /// default value: false
    /// valid values: (true,false)
    bool? requireSignedURLs,

    /// User modifiable key-value store. Can use used for keeping references to
    /// another system of record for managing images.
    /// "{\"meta\": \"metaID\"}"
    Map<String, dynamic>? metadata,
  }) async {
    final response = await parseResponse(service.upload(
      file: content.data,
      requireSignedURLs: requireSignedURLs,
      metadata: metadata,
      onUploadProgress: content.progressCallback,
    ));

    return response;
  }

  /// Uploads multiple images by repeatedly calling uploadFromFile
  Future<List<CResponse<CloudflareImage?>>> uploadFromFiles({
    /// Image file to upload
    required List<DataTransmit<File>> contents,

    /// Indicates whether the image requires a signature token for the access
    /// default value: false
    /// valid values: (true,false)
    bool? requireSignedURLs,

    /// User modifiable key-value store. Can use used for keeping references to
    /// another system of record for managing images.
    /// "{\"meta\": \"metaID\"}"
    Map<String, dynamic>? metadata,
  }) async {
    List<CResponse<CloudflareImage?>> responses = [];
    // responses = await Future.wait(
    //     contents.map((content) async => await uploadFromFile(
    //       content: content,
    //       requireSignedURLs: requireSignedURLs,
    //       metadata: metadata,
    //     )));
    for (final content in contents) {
      final response = await uploadFromFile(
        content: content,
        requireSignedURLs: requireSignedURLs,
        metadata: metadata,
      );
      responses.add(response);
    }
    return responses;
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

  /// Delete a list of images on Cloudflare Images. On success, all copies of the images
  /// are deleted and purged from Cache.
  Future<List<CResponse>> deleteMultiple({
    required List<String> ids,
  }) async {
    List<CResponse> responses = [];
    for (final id in ids) {
      final response = await getSaveResponse(service.delete(id: id,), parseCloudflareResponse: false);
      responses.add(response);
    }
    return responses;
  }

}
