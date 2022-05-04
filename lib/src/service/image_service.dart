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
  factory ImageService({required Dio dio, required String accountId}) {
    return _ImageService(dio,
        baseUrl: '${dio.options.baseUrl}/accounts/$accountId/images');
  }

  @POST('/v1')
  @MultiPart()
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> uploadFromFile({
    @Part(name: Params.file) required File file,
    @Part() bool? requireSignedURLs,
    @Part() Map<String, dynamic>? metadata,
    @SendProgress() ProgressCallback? onUploadProgress,
  });

  @POST('/v1')
  @MultiPart()
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> uploadFromBytes({
    @Part(name: Params.file) required List<int> bytes,
    @Part() bool? requireSignedURLs,
    @Part() Map<String, dynamic>? metadata,
    @SendProgress() ProgressCallback? onUploadProgress,
  });

  @POST('/v1')
  @MultiPart()
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> uploadFromUrl({
    @Part(name: Params.url) required String url,
    @Part() bool? requireSignedURLs,
    @Part() Map<String, dynamic>? metadata,
    @SendProgress() ProgressCallback? onUploadProgress,
  });

  @PATCH('/v1/{id}')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> update({
    @Path() required String id,
    @Field() bool? requireSignedURLs,
    @Field() Map<String, dynamic>? metadata,
  });

  @POST('/v2/direct_upload')
  @MultiPart()
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> createDirectUpload({
    @Part() bool? requireSignedURLs,
    @Part() Map<String, dynamic>? metadata,
    @Part() String? expiry,
  });

  @GET('/v1')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> getAll({
    @Query(Params.page) int? page,
    @Query(Params.perPage) int? size,
  });

  @GET('/v1/{id}')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> get({
    @Path() required String id,
  });

  @GET('/v1/{id}/blob')
  @DioResponseType(ResponseType.bytes)
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse> getBase({
    @Path() required String id,
  });

  @DELETE('/v1/{id}')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> delete({
    @Path() required String id,
  });

  @GET('/v1/stats')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> getStats();
}
