import 'dart:io' hide HttpResponse;
import 'dart:typed_data';

import 'package:cloudflare/cloudflare.dart';
import 'package:cloudflare/src/base_api/rest_api.dart';
import 'package:cloudflare/src/base_api/rest_api_service.dart';
import 'package:cloudflare/src/service/image_service.dart';
import 'package:cloudflare/src/utils/date_time_utils.dart';
import 'package:cloudflare/src/utils/params.dart';
import 'package:cloudflare/src/utils/platform_utils.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';

class ImageAPI extends RestAPIService<ImageService, CloudflareImage,
    CloudflareErrorResponse> {
  ImageAPI({required RestAPI restAPI, required String accountId})
      : super(
            restAPI: restAPI,
            service: ImageService(dio: restAPI.dio, accountId: accountId),
            accountId: accountId,
            dataType: CloudflareImage());

  /// An image up to 10 Megabytes can be upload.
  ///
  /// Documentation: https://api.cloudflare.com/#cloudflare-images-upload-an-image-using-a-single-http-request
  Future<CloudflareHTTPResponse<CloudflareImage?>> upload({
    /// Image file to upload
    DataTransmit<File>? contentFromFile,

    /// Path to the image file to upload
    DataTransmit<String>? contentFromPath,

    /// Image byte array representation to upload
    DataTransmit<Uint8List>? contentFromBytes,

    /// An url to fetch an image from origin and upload it.
    ///
    /// e.g: "https://example.com/some/path/to/image.jpeg"
    DataTransmit<String>? contentFromUrl,

    /// Indicates whether the image requires a signature token for the access.
    ///
    /// default value: false
    ///
    /// valid values: (true,false)
    bool? requireSignedURLs,

    /// User modifiable key-value store. Can use used for keeping references to
    /// another system of record for managing images.
    ///
    /// e.g: "{\"meta\": \"metaID\"}"
    Map<String, dynamic>? metadata,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    assert(
        contentFromFile != null ||
            contentFromPath != null ||
            contentFromBytes != null ||
            contentFromUrl != null,
        'One of the content must be specified.');

    final CloudflareHTTPResponse<CloudflareImage?> response;

    if (contentFromPath != null) {
      contentFromFile ??= DataTransmit<File>(
          data: File(contentFromPath.data),
          progressCallback: contentFromPath.progressCallback);
    }

    /// Web support
    if(contentFromFile != null && PlatformUtils.isWeb) {
      contentFromBytes ??= DataTransmit<Uint8List>(
          data: contentFromFile.data.readAsBytesSync(),
          progressCallback: contentFromFile.progressCallback);
      contentFromFile = null;
    }

    if (contentFromFile != null) {
      response = await parseResponse(service.uploadFromFile(
        file: contentFromFile.data,
        requireSignedURLs: requireSignedURLs,
        metadata: metadata,
        onUploadProgress: contentFromFile.progressCallback,
      ));
    } else if (contentFromBytes != null){
      response = await parseResponse(service.uploadFromBytes(
        bytes: contentFromBytes.data,
        requireSignedURLs: requireSignedURLs,
        metadata: metadata,
        onUploadProgress: contentFromBytes.progressCallback,
      ));
    } else {
      response = await parseResponse(service.uploadFromUrl(
        url: contentFromUrl!.data,
        requireSignedURLs: requireSignedURLs,
        metadata: metadata,
        onUploadProgress: contentFromUrl.progressCallback,
      ));
    }

    return response;
  }

  /// For image direct upload without API key or token.
  /// This function is to be used specifically after an image createDirectUpload
  /// has been requested.
  ///
  /// Documentation: https://api.cloudflare.com/#cloudflare-images-create-authenticated-direct-upload-url-v2
  Future<CloudflareHTTPResponse<CloudflareImage?>> directUpload({
    /// Information on where to upload the image without an API key or token
    required DataUploadDraft dataUploadDraft,

    /// Image file to upload
    DataTransmit<File>? contentFromFile,

    /// Path to the image file to upload
    DataTransmit<String>? contentFromPath,

    /// Image byte array representation to upload
    DataTransmit<Uint8List>? contentFromBytes,
  }) async {
    assert(
        contentFromFile != null ||
            contentFromPath != null ||
            contentFromBytes != null,
        'One of the content must be specified.');

    if (contentFromPath != null) {
      contentFromFile ??= DataTransmit<File>(
          data: File(contentFromPath.data),
          progressCallback: contentFromPath.progressCallback);
    }

    /// Web support
    if(contentFromFile != null && PlatformUtils.isWeb) {
      contentFromBytes ??= DataTransmit<Uint8List>(
          data: contentFromFile.data.readAsBytesSync(),
          progressCallback: contentFromFile.progressCallback);
      contentFromFile = null;
    }

    final dio = restAPI.dio;
    final formData = FormData();
    ProgressCallback? progressCallback;
    if (contentFromFile != null) {
      final file = contentFromFile.data;
      progressCallback = contentFromFile.progressCallback;
      formData.files.add(MapEntry(
        Params.file,
        MultipartFile.fromFileSync(file.path, filename: file.path.split(Platform.pathSeparator).last)));
    } else {
      final bytes = contentFromBytes!.data;
      progressCallback = contentFromBytes.progressCallback;
      formData.files.add(MapEntry(
          Params.file,
          MultipartFile.fromBytes(
            bytes,
            filename: null,
          )));
    }

    final rawResponse = await dio.fetch<Map<String, dynamic>?>(Options(
      method: 'POST',
      // headers: _headers,
      responseType: ResponseType.json,
      contentType: 'multipart/form-data',
    ).compose(
        BaseOptions(
            baseUrl: dataUploadDraft.uploadURL,
            connectTimeout: restAPI.timeout?.inMilliseconds),
        '',
        data: formData,
        onSendProgress: progressCallback));
    final value = rawResponse.data == null
        ? null
        : CloudflareResponse.fromJson(rawResponse.data!);
    final httpResponse = HttpResponse(value, rawResponse);

    final response = await parseResponse(Future.value(httpResponse));
    return response;
  }

  /// Uploads multiple images by repeatedly calling upload
  Future<List<CloudflareHTTPResponse<CloudflareImage?>>> uploadMultiple({
    /// Image files to upload
    List<DataTransmit<File>>? contentFromFiles,

    /// Paths to the image files to upload
    List<DataTransmit<String>>? contentFromPaths,

    /// List of image byte array representations to upload
    List<DataTransmit<Uint8List>>? contentFromBytes,

    /// List of image urls to upload
    List<DataTransmit<String>>? contentFromUrls,

    /// Indicates whether the image requires a signature token for the access
    /// default value: false
    /// valid values: (true,false)
    bool? requireSignedURLs,

    /// User modifiable key-value store. Can use used for keeping references to
    /// another system of record for managing images.
    /// "{\"meta\": \"metaID\"}"
    Map<String, dynamic>? metadata,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    assert(
        (contentFromFiles?.isNotEmpty ?? false) ||
            (contentFromPaths?.isNotEmpty ?? false) ||
            (contentFromBytes?.isNotEmpty ?? false) ||
            (contentFromUrls?.isNotEmpty ?? false),
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
    } else if (contentFromBytes?.isNotEmpty ?? false){
      for (final content in contentFromBytes!) {
        final response = await upload(
          contentFromBytes: content,
          requireSignedURLs: requireSignedURLs,
          metadata: metadata,
        );
        responses.add(response);
      }
    } else {
      for (final content in contentFromUrls!) {
        final response = await upload(
          contentFromUrl: content,
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
  ///
  /// Documentation: https://api.cloudflare.com/#cloudflare-images-update-image
  Future<CloudflareHTTPResponse<CloudflareImage?>> update({
    /// Only [id], [requireSignedURLs] and [meta] properties will be taken into
    /// account when updating image.
    required CloudflareImage image,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    final response = await parseResponse(service.update(
      id: image.id,
      requireSignedURLs: image.requireSignedURLs,
      metadata: image.meta?.map((key, value) => MapEntry<String, dynamic>(key.toString(), value)),
    ));

    return response;
  }

  /// Direct uploads allow users to upload images without API keys. A common
  /// place to use direct uploads is on web apps, client side applications, or
  /// on mobile devices where users upload content directly to Cloudflare
  /// Images. Method creates a draft record for a future image and returns
  /// upload URL and image identifier that can be used later to verify if image
  /// itself has been uploaded or not with the draft: true property in the
  /// image response.
  ///
  /// Documentation: https://api.cloudflare.com/#cloudflare-images-create-authenticated-direct-upload-url-v2
  Future<CloudflareHTTPResponse<DataUploadDraft?>> createDirectUpload({
    /// Indicates whether the image requires a signature token for the access
    ///
    /// Default value: false
    /// e.g: true
    bool? requireSignedURLs,

    /// User modifiable key-value store. Can use used for keeping references to
    /// another system of record for managing images.
    ///
    /// e.g: "{\"meta\": \"metaID\"}"
    Map<String, dynamic>? metadata,

    /// The date after upload will not be accepted.
    ///
    /// Min value: Now + 2 minutes.
    /// Max value: Now + 6 hours.
    /// Default value: Now + 30 minutes.
    /// e.g: "2021-01-02T02:20:00Z"
    DateTime? expiry,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    final response = await genericParseResponse(
      service.createDirectUpload(
        requireSignedURLs: requireSignedURLs,
        metadata: metadata,
        expiry: expiry?.toJson(),
      ),
      dataType: DataUploadDraft(),
    );
    return response;
  }

  /// Up to 100 images can be listed with one request, use optional parameters
  /// to get a specific range of images.
  ///
  /// Documentation: https://api.cloudflare.com/#cloudflare-images-list-images
  Future<CloudflareHTTPResponse<List<CloudflareImage>?>> getAll({
    /// Page number of paginated results.
    ///
    /// Min value: 1
    /// Default value: 1
    int? page,

    /// Number of items per page.
    ///
    /// Min value: 10
    /// Max value: 100
    /// Default value: 50
    int? size,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    final response =
        await parseResponseAsList(service.getAll(page: page, size: size));

    return response;
  }

  /// Fetch details of a single image.
  ///
  /// Documentation: https://api.cloudflare.com/#cloudflare-images-image-details
  Future<CloudflareHTTPResponse<CloudflareImage?>> get({
    /// Image identifier
    String? id,

    /// Image with the required identifier
    CloudflareImage? image,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
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
  ///
  /// Documentation: https://api.cloudflare.com/#cloudflare-images-base-image
  Future<CloudflareHTTPResponse<Uint8List?>> getBase({
    /// Image identifier
    String? id,

    /// Image with the required identifier
    CloudflareImage? image,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    assert(
        id != null || image != null, 'One of id or image must not be empty.');
    id ??= image?.id;
    final response = await genericParseResponse<Uint8List>(
        service.getBase(
          id: id!,
        ),
        parseCloudflareResponse: false);

    return response;
  }

  /// Delete an image on Cloudflare Images. On success, all copies of the image
  /// are deleted and purged from Cache.
  ///
  /// Documentation: https://api.cloudflare.com/#cloudflare-images-delete-image
  Future<CloudflareHTTPResponse> delete({
    /// Image identifier
    String? id,

    /// Image with the required identifier
    CloudflareImage? image,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    assert(
        id != null || image != null, 'One of id or image must not be null.');
    id ??= image?.id;
    final response = await getSaveResponse(
      service.delete(id: id!,),
      parseCloudflareResponse: false);
    return response;
  }

  /// Delete a list of images on Cloudflare Images. On success, all copies of the images
  /// are deleted and purged from Cache.
  Future<List<CloudflareHTTPResponse>> deleteMultiple({
    /// List of image identifiers
    List<String>? ids,

    /// List of images with their required identifiers
    List<CloudflareImage>? images,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    assert((ids?.isNotEmpty ?? false) || (images?.isNotEmpty ?? false),
        'One of ids or images must not be empty.');

    ids ??= images?.map((image) => image.id).toList();

    List<CloudflareHTTPResponse> responses = [];
    for (final id in ids!) {
      final response = await delete(id: id,);
      responses.add(response);
    }
    return responses;
  }

  /// Fetch details of Cloudflare Images usage statistics
  ///
  /// Documentation: https://api.cloudflare.com/#cloudflare-images-images-usage-statistics
  Future<CloudflareHTTPResponse<ImageStats?>> getStats() async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    final response = await genericParseResponse(
      service.getStats(), dataType: ImageStats(),
    );
    return response;
  }
}
