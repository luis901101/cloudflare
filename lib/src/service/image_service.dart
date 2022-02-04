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
        baseUrl: '${dio.options.baseUrl}/accounts/$accountId/images/v1');
  }

  @POST('')
  @MultiPart()
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> upload({
    @Part() required File file,
    @Part() bool? requireSignedURLs,
    @Part() Map<String, dynamic>? metadata,
    @SendProgress() ProgressCallback? onUploadProgress,
  });

  @PATCH('/{id}')
  @MultiPart()
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> update({
    @Path() required String id,
    @Part() bool? requireSignedURLs,
    @Part() Map<String, dynamic>? metadata,
  });

  @GET('')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> getAll({
    @Query(Params.page) int? page,
    @Query(Params.perPage) int? size,
  });

  @GET('/{id}')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> get({
    @Path() required String id,
  });

  @GET('/{id}/blob')
  @DioResponseType(ResponseType.bytes)
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse> getBase({
    @Path() required String id,
  });

  @DELETE('/{id}')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> delete({
    @Path() required String id,
  });
}
