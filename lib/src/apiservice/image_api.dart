import 'dart:io';

import 'package:cloudflare/cloudflare.dart';
import 'package:cloudflare/src/base_api/rest_api.dart';
import 'package:cloudflare/src/base_api/rest_api_service.dart';
import 'package:cloudflare/src/service/image_service.dart';

class ImageAPI extends RestAPIService<ImageService, CloudflareImage,
    CloudflareErrorResponse> {
  ImageAPI({required RestAPI restAPI, required String accountId})
      : super(
            restAPI: restAPI,
            service: ImageService(dio: restAPI.dio, accountId: accountId),
            dataType: CloudflareImage());

  /// An image up to 10 Megabytes can be upload.
  Future<CloudflareHTTPResponse<CloudflareImage?>> upload({
    /// Image file to upload
    DataTransmit<File>? contentFromFile,
    DataTransmit<String>? contentFromPath,
    DataTransmit<List<int>>? contentFromBytes,

    /// Indicates whether the image requires a signature token for the access
    /// default value: false
    /// valid values: (true,false)
    bool? requireSignedURLs,

    /// User modifiable key-value store. Can use used for keeping references to
    /// another system of record for managing images.
    /// "{\"meta\": \"metaID\"}"
    Map<String, dynamic>? metadata,
  }) async {
    assert(
        contentFromFile != null ||
            contentFromPath != null ||
            contentFromBytes != null,
        'One of the content must be specified.');

    final CloudflareHTTPResponse<CloudflareImage?> response;
    if (contentFromPath != null) {
      contentFromFile = DataTransmit<File>(
          data: File(contentFromPath.data),
          progressCallback: contentFromPath.progressCallback);
    }
    if (contentFromFile != null) {
      response = await parseResponse(service.uploadFromFile(
        file: contentFromFile.data,
        requireSignedURLs: requireSignedURLs,
        metadata: metadata,
        onUploadProgress: contentFromFile.progressCallback,
      ));
    } else {
      response = await parseResponse(service.uploadFromBytes(
        bytes: contentFromBytes!.data,
        requireSignedURLs: requireSignedURLs,
        metadata: metadata,
        onUploadProgress: contentFromBytes.progressCallback,
      ));
    }

    return response;
  }

  /// Uploads multiple images by repeatedly calling upload
  Future<List<CloudflareHTTPResponse<CloudflareImage?>>> uploadMultiple({
    /// Image files to upload
    List<DataTransmit<File>>? contentFromFiles,
    List<DataTransmit<String>>? contentFromPaths,
    List<DataTransmit<List<int>>>? contentFromBytes,

    /// Indicates whether the image requires a signature token for the access
    /// default value: false
    /// valid values: (true,false)
    bool? requireSignedURLs,

    /// User modifiable key-value store. Can use used for keeping references to
    /// another system of record for managing images.
    /// "{\"meta\": \"metaID\"}"
    Map<String, dynamic>? metadata,
  }) async {
    assert(
        (contentFromFiles?.isNotEmpty ?? false) ||
            (contentFromPaths?.isNotEmpty ?? false) ||
            (contentFromBytes?.isNotEmpty ?? false),
        'One of the contents must be specified.');

    List<CloudflareHTTPResponse<CloudflareImage?>> responses = [];

    if (contentFromPaths?.isNotEmpty ?? false) {
      contentFromFiles = [];
      for (final content in contentFromPaths!) {
        contentFromFiles.add(DataTransmit<File>(
            data: File(content.data),
            progressCallback: content.progressCallback));
      }
    }
    if (contentFromFiles?.isNotEmpty ?? false) {
      for (final content in contentFromFiles!) {
        final response = await upload(
          contentFromFile: content,
          requireSignedURLs: requireSignedURLs,
          metadata: metadata,
        );
        responses.add(response);
      }
    } else {
      for (final content in contentFromBytes!) {
        final response = await upload(
          contentFromBytes: content,
          requireSignedURLs: requireSignedURLs,
          metadata: metadata,
        );
        responses.add(response);
      }
    }
    return responses;
  }

  /// Update image access control. On access control change,
  /// all copies of the image are purged from Cache.
  Future<CloudflareHTTPResponse<CloudflareImage?>> update({
    String? id,
    CloudflareImage? image,

    /// Indicates whether the image can be accessed only using it's UID.
    /// If set to true, a signed token needs to be generated with a signing key
    /// to view the image. Returns a new UID on a change. No-op if not specified
    bool? requireSignedURLs,

    /// User modifiable key-value store. Can use used for keeping references to
    /// another system of record for managing images. No-op if not specified.
    /// "{\"meta\": \"metaID\"}"
    Map<String, dynamic>? metadata,
  }) async {
    assert(
        id != null || image != null, 'One of id or image must not be empty.');
    id ??= image?.id;
    final response = await parseResponse(service.update(
      id: id!,
      requireSignedURLs: requireSignedURLs,
      metadata: metadata,
    ));

    return response;
  }

  /// Up to 100 images can be listed with one request, use optional parameters
  /// to get a specific range of images.
  Future<CloudflareHTTPResponse<List<CloudflareImage>?>> getAll({
    /// Page number of paginated results, default value: 1
    int? page,

    /// Number of items per page, default value: 50
    int? size,
  }) async {
    final response =
        await parseResponseAsList(service.getAll(page: page, size: size));

    return response;
  }

  /// Fetch details of a single image.
  Future<CloudflareHTTPResponse<CloudflareImage?>> get({
    String? id,
    CloudflareImage? image,
  }) async {
    assert(
        id != null || image != null, 'One of id or image must not be empty.');
    id ??= image?.id;
    final response = await parseResponse(service.get(
      id: id!,
    ));
    return response;
  }

  /// Fetch base image. For most images this will be the originally uploaded
  /// file. For larger images it can be a near-lossless version of the original.
  /// Note: the response is <image blob data>
  Future<CloudflareHTTPResponse<List<int>?>> getBase({
    String? id,
    CloudflareImage? image,
  }) async {
    assert(
        id != null || image != null, 'One of id or image must not be empty.');
    id ??= image?.id;
    final response = await genericParseResponse<List<int>>(
        service.getBase(
          id: id!,
        ),
        parseCloudflareResponse: false);

    return response;
  }

  /// Delete an image on Cloudflare Images. On success, all copies of the image
  /// are deleted and purged from Cache.
  Future<CloudflareHTTPResponse> delete({
    String? id,
    CloudflareImage? image,
  }) async {
    assert(
        id != null || image != null, 'One of id or image must not be empty.');
    id ??= image?.id;
    final response = await getSaveResponse(
        service.delete(
          id: id!,
        ),
        parseCloudflareResponse: false);
    return response;
  }

  /// Delete a list of images on Cloudflare Images. On success, all copies of the images
  /// are deleted and purged from Cache.
  Future<List<CloudflareHTTPResponse>> deleteMultiple({
    List<String>? ids,
    List<CloudflareImage>? images,
  }) async {
    assert((ids?.isNotEmpty ?? false) || (images?.isNotEmpty ?? false),
        'One of ids or images must not be empty.');

    ids ??= images?.map((image) => image.id).toList();

    List<CloudflareHTTPResponse> responses = [];
    for (final id in ids!) {
      final response = await getSaveResponse(
          service.delete(
            id: id,
          ),
          parseCloudflareResponse: false);
      responses.add(response);
    }
    return responses;
  }
}
