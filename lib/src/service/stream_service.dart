import 'dart:io';
import 'package:cloudflare/src/base_api/rest_api_service.dart';
import 'package:cloudflare/src/entity/cloudflare_response.dart';
import 'package:cloudflare/src/utils/params.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;
import 'dart:convert'; //used by generated code with jsonEncode(...)
import 'package:cloudflare/src/utils/date_time_utils.dart'; //used by generated code with date.toJson()

part 'stream_service.g.dart';

@RestApi()
abstract class StreamService {
  factory StreamService({required Dio dio, required String accountId}) {
    return _StreamService(dio,
        baseUrl: '${dio.options.baseUrl}/accounts/$accountId/stream');
  }

  // @POST('')
  // @MultiPart()
  // @Headers(RestAPIService.defaultHeaders)
  // Future<HttpResponse<CloudflareResponse?>> streamFromUrl({
  //   @Part(name: Params.file) required File file,
  //   @SendProgress() ProgressCallback? onUploadProgress,
  // });

  @POST('')
  @MultiPart()
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> streamFromFile({
    @Part(name: Params.file) required File file,
    @SendProgress() ProgressCallback? onUploadProgress,
  });

  @POST('')
  @MultiPart()
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> streamFromBytes({
    @Part(name: Params.file) required List<int> bytes,
    @SendProgress() ProgressCallback? onUploadProgress,
  });

  // @POST('')
  // @MultiPart()
  // @Headers(RestAPIService.defaultHeaders)
  // Future<HttpResponse<CloudflareResponse?>> directUpload({
  //   @Part(name: Params.file) required List<int> bytes,
  //   @SendProgress() ProgressCallback? onUploadProgress,
  // });

  @GET('')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> getAll({
    @Query(Params.after) DateTime? after,
    @Query(Params.before) DateTime? before,
    @Query(Params.includeCounts) bool? includeCounts,
    @Query(Params.search) String? search,
    @Query(Params.limit) int? limit,
    @Query(Params.asc) bool? asc,
    @Query(Params.status) String? status,
  });

  @GET('/{id}')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> get({
    @Path() required String id,
  });










  //
  // @PATCH('/{id}')
  // @Headers(RestAPIService.defaultHeaders)
  // Future<HttpResponse<CloudflareResponse?>> update({
  //   @Path() required String id,
  //   @Field() bool? requireSignedURLs,
  //   @Field() Map<String, dynamic>? metadata,
  // });
  //
  //
  //
  // @GET('/{id}/blob')
  // @DioResponseType(ResponseType.bytes)
  // @Headers(RestAPIService.defaultHeaders)
  // Future<HttpResponse> getBase({
  //   @Path() required String id,
  // });
  //
  // @DELETE('/{id}')
  // @Headers(RestAPIService.defaultHeaders)
  // Future<HttpResponse<CloudflareResponse?>> delete({
  //   @Path() required String id,
  // });
}
