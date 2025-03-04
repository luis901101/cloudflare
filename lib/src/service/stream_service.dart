import 'dart:io';
import 'package:cloudflare/cloudflare.dart';
import 'package:cloudflare/src/base_api/rest_api_service.dart';
import 'package:cloudflare/src/utils/params.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;

part 'stream_service.g.dart';

@RestApi()
abstract class StreamService {
  factory StreamService({required Dio dio, required String accountId}) {
    return _StreamService(
      dio,
      baseUrl: '${dio.options.baseUrl}/accounts/$accountId/stream',
      errorLogger: null,
    );
  }

  @POST('/copy')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> streamFromUrl({
    @Body() required Map<String, dynamic> data,
    @SendProgress() ProgressCallback? onUploadProgress,
    @CancelRequest() CancelToken? cancelToken,
  });

  @POST('')
  @MultiPart()
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> streamFromFile({
    @Part(name: Params.file) required File file,
    @SendProgress() ProgressCallback? onUploadProgress,
    @CancelRequest() CancelToken? cancelToken,
  });

  @POST('')
  @MultiPart()
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> streamFromBytes({
    @Part(name: Params.file, fileName: 'video-from-bytes')
    required List<int> bytes,
    @SendProgress() ProgressCallback? onUploadProgress,
    @CancelRequest() CancelToken? cancelToken,
  });

  @POST('/direct_upload')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> createDirectUpload({
    @Body() required Map<String, dynamic> data,
  });

  @POST('?direct_user=true')
  @Headers({
    RestAPIService.tusResumableKey: TusAPI.tusVersion,
  })
  Future<HttpResponse> createTusDirectUpload({
    @Header(RestAPIService.uploadLengthKey) required int size,
    @Header(RestAPIService.uploadMetadataKey) String? metadata,
  });

  @GET('')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> getAll({
    @Query(Params.after) String? after,
    @Query(Params.before) String? before,
    @Query(Params.creator) String? creator,
    @Query(Params.includeCounts) bool? includeCounts,
    @Query(Params.search) String? search,
    @Query(Params.limit) int? limit,
    @Query(Params.asc) bool? asc,
    @Query(Params.status) List<String>? status,
  });

  @GET('/{id}')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> get({
    @Path() required String id,
  });

  @DELETE('/{id}')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse> delete({
    @Path() required String id,
  });
}
