import 'package:cloudflare/src/base_api/rest_api_service.dart';
import 'package:cloudflare/src/entity/cloudflare_live_input.dart';
import 'package:cloudflare/src/entity/cloudflare_response.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'live_input_service.g.dart';

@RestApi()
abstract class LiveInputService {
  factory LiveInputService({
    required Dio dio,
    required String accountId,
    ParseErrorLogger? errorLogger,
  }) {
    return _LiveInputService(
      dio,
      baseUrl: '${dio.options.baseUrl}/accounts/$accountId/stream/live_inputs',
      errorLogger: errorLogger,
    );
  }

  @POST('')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> create({
    @Body() CloudflareLiveInput? data,
    @CancelRequest() CancelToken? cancelToken,
  });

  @GET('')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> getAll({
    @CancelRequest() CancelToken? cancelToken,
  });

  @GET('/{id}')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> get({
    @Path() required String id,
    @CancelRequest() CancelToken? cancelToken,
  });

  @GET('/{id}/videos')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> getVideos({
    @Path() required String id,
    @CancelRequest() CancelToken? cancelToken,
  });

  @PUT('/{id}')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> update({
    @Path() required String id,
    @Body() CloudflareLiveInput? data,
    @CancelRequest() CancelToken? cancelToken,
  });

  @DELETE('/{id}')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse> delete({
    @Path() required String id,
    @CancelRequest() CancelToken? cancelToken,
  });

  @POST('/{liveInputId}/outputs')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> addOutput({
    @Path() required String liveInputId,
    @Body() required Map<String, dynamic> data,
    @CancelRequest() CancelToken? cancelToken,
  });

  @GET('/{liveInputId}/outputs')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> getOutputs({
    @Path() required String liveInputId,
    @CancelRequest() CancelToken? cancelToken,
  });

  @DELETE('/{liveInputId}/outputs/{outputId}')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse> removeOutput({
    @Path() required String liveInputId,
    @Path() required String outputId,
    @CancelRequest() CancelToken? cancelToken,
  });
}
