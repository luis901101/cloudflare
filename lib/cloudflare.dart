// ignore_for_file: deprecated_member_use_from_same_package

library;

//Imports
import 'package:cloudflare/src/apiservice/image_api.dart';
import 'package:cloudflare/src/apiservice/live_input_api.dart';
import 'package:cloudflare/src/apiservice/stream_api.dart';
import 'package:cloudflare/src/base_api/rest_api.dart';
import 'package:cloudflare/src/base_api/rest_api_service.dart';
import 'package:cloudflare/src/utils/callbacks.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart' hide Headers;

// Exports
// APIs
export 'package:cloudflare/src/apiservice/image_api.dart';
export 'package:cloudflare/src/apiservice/stream_api.dart';
export 'package:cloudflare/src/apiservice/tus_api.dart';
export 'package:dio/dio.dart';
export 'package:retrofit/retrofit.dart' hide Headers;

// Entities
export 'package:cloudflare/src/entity/cloudflare_image.dart';
export 'package:cloudflare/src/entity/cloudflare_live_input.dart';
export 'package:cloudflare/src/entity/cloudflare_response.dart';
export 'package:cloudflare/src/entity/cloudflare_stream_video.dart';
export 'package:cloudflare/src/entity/data_upload_draft.dart';
export 'package:cloudflare/src/entity/image_stats.dart';
export 'package:cloudflare/src/entity/live_input_output.dart';
export 'package:cloudflare/src/entity/live_input_recording.dart';
export 'package:cloudflare/src/entity/media_nft.dart';
export 'package:cloudflare/src/entity/rtmps.dart';
export 'package:cloudflare/src/entity/srt.dart';
export 'package:cloudflare/src/entity/video_playback_info.dart';
export 'package:cloudflare/src/entity/video_size.dart';
export 'package:cloudflare/src/entity/video_status.dart';
export 'package:cloudflare/src/entity/watermark.dart';

// Enums
export 'package:cloudflare/src/enumerators/thumbnail_fit.dart';
export 'package:cloudflare/src/enumerators/media_processing_state.dart';
export 'package:cloudflare/src/enumerators/recording_mode.dart';
export 'package:cloudflare/src/enumerators/watermark_position.dart';

// Models
export 'package:cloudflare/src/model/cloudflare_error_response.dart';
export 'package:cloudflare/src/model/cloudflare_http_response.dart';
export 'package:cloudflare/src/model/cloudflare_images_error_codes.dart';
export 'package:cloudflare/src/model/cloudflare_stream_videos_error_codes.dart';
export 'package:cloudflare/src/model/data_transmit.dart';
export 'package:cloudflare/src/model/error_info.dart';
export 'package:cloudflare/src/model/pagination.dart';

// Utils
export 'package:cloudflare/src/utils/callbacks.dart';

class Cloudflare {
  static const defaultApiUrl = 'https://api.cloudflare.com/client/v4';
  static const xAuthKeyHeader = 'X-Auth-Key';
  static const xAuthEmailHeader = 'X-Auth-Email';
  static const xAuthUserServiceKeyHeader = 'X-Auth-User-Service-Key';

  final RestAPI restAPI = RestAPI();

  /// APIs
  late final ImageAPI imageAPI;
  late final StreamAPI streamAPI;
  late final LiveInputAPI liveInputAPI;

  /// Cloudflare brings you full access to different apis like ImageAPI and
  /// StreamAPI.
  /// The [accountId] is required as well as one of ([token] or [tokenCallback])
  /// or in a legacy case ([apiKey] and [accountEmail]) or [userServiceKey]
  ///
  /// [accountId] Your Cloudflare account ID. You can find it on the link when
  /// you log in to Cloudflare dashboard: `https://dash.cloudflare.com/<[account_id]>/home/domains`
  ///
  /// [apiKey] (Legacy) Global API key is the previous authorization scheme for
  /// interacting with the Cloudflare API. When possible, use API tokens instead
  /// of Global API key.
  /// Check https://developers.cloudflare.com/fundamentals/api/get-started/keys/ for more info.
  ///
  /// [accountEmail] (Legacy) To be used as `X-Auth-Email`.
  /// Email address associated with your account.
  /// When possible, use API tokens instead.
  ///
  /// [userServiceKey] (Legacy) To be used as `X-Auth-User-Service-Key`.
  /// A special Cloudflare API key good for a restricted set of endpoints.
  /// Always begins with "v1.0-", may vary in length.
  /// When possible, use API tokens instead.
  ///
  /// [apiUrl] The Cloudflare api url to request, if not specified this one will be used: https://api.cloudflare.com/client/v4
  ///
  /// [token] Cloudflare API tokens provide a new way to authenticate with the Cloudflare API.
  /// They allow for scoped and permissioned access to resources and use the RFC
  /// compliant Authorization Bearer Token Header.
  ///
  /// [tokenCallback] is a callback that returns the token to be used in the requests,
  /// it is an async way to provide the token, if you use this callback you don't have to provide the [token].
  ///
  /// [connectTimeout] is the maximum amount of time in milliseconds that the request
  /// can take to establish a connection.
  ///
  /// [receiveTimeout] is the maximum amount of time in milliseconds that the request
  /// can take to receive data.
  ///
  /// [sendTimeout] is the maximum amount of time in milliseconds that the request
  /// can take to send data.
  ///
  /// [httpClientAdapter] is the client adapter if you need to customize how http
  /// requests are made, note you should use either [IOHttpClientAdapter] on
  /// `dart:io` native platforms or [BrowserHttpClientAdapter] on `dart:html`
  /// web platforms.
  ///
  /// [parseErrorLogger] is a logger for errors that occur during parsing of response data.
  ///
  /// [headers] allows adding global HTTP headers for all requests.
  ///
  /// [cancelTokenCallback] enables programmatically cancelling in-flight requests for this API.
  /// When cancelling a cancel token all current and future requests using the token
  /// will be cancelled. So make sure you reset the token returned by the [CancelTokenCallback]
  /// if you want to continue using the API.
  ///
  /// [interceptors] enables advanced customization like logging, retries and rate limiting.
  Cloudflare({
    required String accountId,
    @Deprecated('Use token authentication instead.') String? apiKey,
    @Deprecated('Use token authentication instead.') String? accountEmail,
    @Deprecated('Use token authentication instead.') String? userServiceKey,

    String? apiUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    HttpClientAdapter? httpClientAdapter,
    Map<String, dynamic>? headers,
    String? token,
    TokenCallback? tokenCallback,
    CancelTokenCallback? cancelTokenCallback,
    List<Interceptor>? interceptors,
    ParseErrorLogger? parseErrorLogger,
  }) : assert(
         (((token?.isNotEmpty ?? false) && tokenCallback == null) ||
                 ((token?.isEmpty ?? true) && tokenCallback != null)) ||
             ((apiKey?.isNotEmpty ?? false) &&
                 (accountEmail?.isNotEmpty ?? false)) ||
             (userServiceKey?.isNotEmpty ?? false),
         '\n\nA token or tokenCallback must be specified, only one of both. '
         '\nOtherwise an apiKey and accountEmail must be specified. '
         '\nOtherwise a userServiceKey must be specified.',
       ) {
    apiUrl ??= defaultApiUrl;
    (headers ??= <String, dynamic>{}).addAll({
      if (token != null) RestAPIService.authorizationKey: 'Bearer $token',
      if (apiKey != null) xAuthKeyHeader: apiKey,
      if (accountEmail != null) xAuthEmailHeader: accountEmail,
      if (userServiceKey != null) xAuthUserServiceKeyHeader: userServiceKey,
    });

    restAPI.init(
      apiUrl: apiUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
      httpClientAdapter: httpClientAdapter,
      headers: headers,
      tokenCallback:
          tokenCallback ?? (token == null ? null : (() async => token)),
      cancelTokenCallback: cancelTokenCallback,
      interceptors: interceptors,
    );

    imageAPI = ImageAPI(
      restAPI: restAPI,
      accountId: accountId,
      errorLogger: parseErrorLogger,
    );
    streamAPI = StreamAPI(
      restAPI: restAPI,
      accountId: accountId,
      errorLogger: parseErrorLogger,
    );
    liveInputAPI = LiveInputAPI(
      restAPI: restAPI,
      accountId: accountId,
      errorLogger: parseErrorLogger,
    );
  }

  /// Use this constructor when you don't need to make authorized requests
  /// to Cloudflare apis, like when you just need to do image or stream
  /// direct upload to an `uploadURL`
  factory Cloudflare.basic({
    String? apiUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    HttpClientAdapter? httpClientAdapter,
    Map<String, dynamic>? headers,
    CancelTokenCallback? cancelTokenCallback,
    List<Interceptor>? interceptors,
  }) => Cloudflare(
    accountId: '',
    apiUrl: apiUrl,
    connectTimeout: connectTimeout,
    receiveTimeout: receiveTimeout,
    sendTimeout: sendTimeout,
    httpClientAdapter: httpClientAdapter,
    headers: headers,
    cancelTokenCallback: cancelTokenCallback,
    interceptors: interceptors,
  );
}
