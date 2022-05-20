// ignore_for_file: deprecated_member_use_from_same_package

library cloudflare;

//Imports
import 'dart:io';
import 'package:cloudflare/src/apiservice/image_api.dart';
import 'package:cloudflare/src/apiservice/live_input_api.dart';
import 'package:cloudflare/src/apiservice/stream_api.dart';
import 'package:cloudflare/src/base_api/rest_api.dart';
import 'package:cloudflare/src/utils/callbacks.dart';

//Exports
// APIs
export 'package:cloudflare/src/apiservice/image_api.dart';
export 'package:cloudflare/src/apiservice/stream_api.dart';
export 'package:cloudflare/src/apiservice/tus_api.dart';

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
export 'package:cloudflare/src/enumerators/fit.dart';
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

  /// Cloudflare api url, at the moment of writing this: https://api.cloudflare.com/client/v4
  final String apiUrl;

  /// Cloudflare account id
  final String accountId;

  /// Cloudflare API token.
  /// API Tokens provide a new way to authenticate with the Cloudflare API.
  /// They allow for scoped and permissioned access to resources and use the RFC
  /// compliant Authorization Bearer Token Header.
  final String? token;

  /// Callback to asynchronously get Cloudflare API token
  final TokenCallback tokenCallback;

  /// Check https://api.cloudflare.com/#getting-started-requests to know how
  /// to authenticate requests
  /// To use legacy authentication there is two ways:
  /// Including `X-Auth-Key` and `X-Auth-Email`.
  /// Requests that usecan use that instead of the Auth-Key and Auth-Email headers.
  /// To be used as `X-Auth-Key` header. API key generated on the "My Account" page
  @Deprecated('Use token authentication instead.')
  final String? apiKey;

  /// To be used as `X-Auth-Email`. Email address associated with your account
  @Deprecated('Use token authentication instead.')
  final String? accountEmail;
  @Deprecated('Use token authentication instead.')

  /// To be used as `X-Auth-User-Service-Key`. A special Cloudflare API key good
  /// for a restricted set of endpoints. Always begins with "v1.0-", may vary in length.
  final String? userServiceKey;

  /// API requests duration timeout
  final Duration? timeout;

  final RestAPI restAPI = RestAPI();

  /// Set this if you need control over http requests like validating certificates and so.
  /// Not supported in Web
  final HttpClient? httpClient;

  /// APIs
  late final ImageAPI imageAPI;
  late final StreamAPI streamAPI;
  late final LiveInputAPI liveInputAPI;
  bool _initialized = false;

  /// Cloudflare brings you full access to different apis like ImageAPI and
  /// StreamAPI.
  ///
  /// By default cloudflare [api url v4](https://api.cloudflare.com/client/v4)
  /// will be used unless you set a specific [apiUrl].
  ///
  /// The `accountId` is required as well as one of (`token` or `tokenCallback`)
  /// or (`apiKey` and `accountEmail`) or `userServiceKey`
  Cloudflare({
    String? apiUrl,
    required this.accountId,
    this.token,
    TokenCallback? tokenCallback,
    this.apiKey,
    this.accountEmail,
    this.userServiceKey,
    this.timeout,
    this.httpClient,
  })  : assert(
            (((token?.isNotEmpty ?? false) && tokenCallback == null) ||
                    ((token?.isEmpty ?? true) && tokenCallback != null)) ||
                ((apiKey?.isNotEmpty ?? false) &&
                    (accountEmail?.isNotEmpty ?? false)) ||
                (userServiceKey?.isNotEmpty ?? false),
            '\n\nA token or tokenCallback must be specified, only one of both. '
            '\nOtherwise an apiKey and accountEmail must be specified. '
            '\nOtherwise a userServiceKey must be specified.'),
        apiUrl = apiUrl ?? defaultApiUrl,
        tokenCallback = tokenCallback ?? (() async => token);

  /// Use this constructor when you don't need to make authorized requests
  /// to Cloudflare apis, like when you just need to do image or stream
  /// direct upload to an `uploadURL`
  factory Cloudflare.basic() =>
    Cloudflare(accountId: '', tokenCallback: () async => '');

  bool get isInitialized => _initialized;

  /// Call this function before using Cloudflare APIs
  Future<void> init() async {
    if (isInitialized) return;
    String? token = await tokenCallback();
    Map<String, dynamic> headers = {
      if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
      if (apiKey != null) xAuthKeyHeader: apiKey,
      if (accountEmail != null) xAuthEmailHeader: accountEmail,
      if (userServiceKey != null) xAuthUserServiceKeyHeader: userServiceKey,
    };

    restAPI.init(
      httpClient: httpClient,
      apiUrl: apiUrl,
      timeout: timeout,
      headers: headers,
    );

    imageAPI = ImageAPI(restAPI: restAPI, accountId: accountId);
    streamAPI = StreamAPI(restAPI: restAPI, accountId: accountId);
    liveInputAPI = LiveInputAPI(restAPI: restAPI, accountId: accountId);
    _initialized = true;
  }
}
