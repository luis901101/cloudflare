import 'dart:io';
import 'package:cloudflare/src/base_api/rest_api_service.dart';
import 'package:cloudflare/src/entity/cloudflare_response.dart';
import 'package:cloudflare/src/utils/params.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;
import 'dart:convert'; //used by generated code with jsonEncode(...)

part 'image_service.g.dart';

@RestApi()
abstract class ImageService {
  factory ImageService(Dio dio, {String? accountId, String? baseUrl}) {
    return _ImageService(dio,
        baseUrl:
            baseUrl ?? '${dio.options.baseUrl}/accounts/$accountId/images/v1');
  }

  /// You can upload an image up to 10 Megabytes using a single HTTP POST
  /// (multipart/form-data) request.
  // @POST('/images/v1')
  @POST('')
  @MultiPart()
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> upload({
    /// Image file to upload
    @Part() required File file,

    /// Indicates whether the image requires a signature token for the access
    /// default value: false
    /// valid values: (true,false)
    @Part() bool? requireSignedURLs,

    /// User modifiable key-value store. Can use used for keeping references to
    /// another system of record for managing images.
    /// "{\"meta\": \"metaID\"}"
    @Part() Map<String, dynamic>? metadata,

    /// Callback for image file upload progress
    @SendProgress() ProgressCallback? onUploadProgress,
  });

  /// Update image access control. On access control change,
  /// all copies of the image are purged from Cache.
  @PATCH('/{id}')
  @MultiPart()
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> update({
    @Path() required String id,

    /// Indicates whether the image can be accessed only using it's UID.
    /// If set to true, a signed token needs to be generated with a signing key
    /// to view the image. Returns a new UID on a change. No-op if not specified
    @Part() bool? requireSignedURLs,

    /// User modifiable key-value store. Can use used for keeping references to
    /// another system of record for managing images. No-op if not specified.
    /// "{\"meta\": \"metaID\"}"
    @Part() Map<String, dynamic>? metadata,
  });

  /// Up to 100 images can be listed with one request, use optional parameters
  /// to get a specific range of images.
  @GET('')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> getAll({
    /// Page number of paginated results, default value: 1
    @Query(Params.page) int? page,

    /// Number of items per page, default value: 50
    @Query(Params.perPage) int? size,
  });

  /// Fetch details of a single image.
  @GET('/{id}')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> get({
    @Path() required String id,
  });

  /// Fetch base image. For most images this will be the originally uploaded
  /// file. For larger images it can be a near-lossless version of the original.
  /// Note: the response is <image blob data>
  @GET('/{id}/blob')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> getBase({
    @Path() required String id,
  });

  /// Delete an image on Cloudflare Images. On success, all copies of the image
  /// are deleted and purged from Cache.
  @DELETE('/{id}')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> delete({
    @Path() required String id,
  });
}
