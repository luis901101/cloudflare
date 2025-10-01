import 'package:cloudflare/cloudflare.dart';
import 'package:cloudflare/src/base_api/rest_api_service.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'live_input_service.g.dart';

@RestApi()
abstract class LiveInputService {
  factory LiveInputService({required Dio dio, required String accountId}) {
    return _LiveInputService(
      dio,
      baseUrl: '${dio.options.baseUrl}/accounts/$accountId/stream/live_inputs',
      errorLogger: null,
    );
  }

  @POST('')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> create({
    @Body() CloudflareLiveInput? data,
  });

  @GET('')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> getAll();

  @GET('/{id}')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> get({@Path() required String id});

  @GET('/{id}/videos')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> getVideos({
    @Path() required String id,
  });

  @PUT('/{id}')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> update({
    @Path() required String id,
    @Body() CloudflareLiveInput? data,
  });

  @DELETE('/{id}')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse> delete({@Path() required String id});

  @POST('/{liveInputId}/outputs')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> addOutput({
    @Path() required String liveInputId,
    @Body() required Map<String, dynamic> data,
  });

  @GET('/{liveInputId}/outputs')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> getOutputs({
    @Path() required String liveInputId,
  });

  @DELETE('/{liveInputId}/outputs/{outputId}')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse> removeOutput({
    @Path() required String liveInputId,
    @Path() required String outputId,
  });
}
