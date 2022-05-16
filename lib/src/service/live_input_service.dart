import 'package:cloudflare/cloudflare.dart';
import 'package:cloudflare/src/base_api/rest_api_service.dart';
import 'package:cloudflare/src/entity/cloudflare_live_input.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'live_input_service.g.dart';

@RestApi()
abstract class LiveInputService {
  factory LiveInputService({required Dio dio, required String accountId}) {
    return _LiveInputService(dio,
        baseUrl: '${dio.options.baseUrl}/accounts/$accountId/stream/live_inputs');
  }

  @POST('')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> create({
    @Body() CloudflareLiveInput? data,
  });

  // @PATCH('/v1/{id}')
  // @Headers(RestAPIService.defaultHeaders)
  // Future<HttpResponse<CloudflareResponse?>> update({
  //   @Path() required String id,
  //   @Field() bool? requireSignedURLs,
  //   @Field() Map<String, dynamic>? metadata,
  // });
  //
  @GET('')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse<CloudflareResponse?>> getAll();
  //
  // @GET('/v1/{id}')
  // @Headers(RestAPIService.defaultHeaders)
  // Future<HttpResponse<CloudflareResponse?>> get({
  //   @Path() required String id,
  // });
  //
  // @GET('/v1/{id}/blob')
  // @DioResponseType(ResponseType.bytes)
  // @Headers(RestAPIService.defaultHeaders)
  // Future<HttpResponse> getBase({
  //   @Path() required String id,
  // });
  //
  @DELETE('/{id}')
  @Headers(RestAPIService.defaultHeaders)
  Future<HttpResponse> delete({
    @Path() required String id,
  });
}
