// ignore_for_file: deprecated_member_use_from_same_package

library cloudflare;

import 'dart:io';

import 'package:cloudflare/src/apiservice/image_api.dart';
import 'package:cloudflare/src/base_api/rest_api.dart';
import 'package:cloudflare/src/utils/callbacks.dart';

export 'package:cloudflare/src/apiservice/image_api.dart';

export 'package:cloudflare/src/model/cloudflare_http_response.dart';

export 'package:cloudflare/src/entity/cloudflare_image.dart';
export 'package:cloudflare/src/entity/cloudflare_response.dart';

export 'package:cloudflare/src/model/data_transmit.dart';
export 'package:cloudflare/src/model/error_info.dart';
export 'package:cloudflare/src/model/cloudflare_error_response.dart';
export 'package:cloudflare/src/model/pagination.dart';

export 'package:cloudflare/src/utils/callbacks.dart';

class Cloudflare {
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

  /// Image API
  late final ImageAPI imageAPI;
  bool _initialized = false;

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
            '\nOtherwise an apiKey and accountEmmail must specified. '
            '\nOtherwise a userServiceKey must specified.'),
        apiUrl = apiUrl ?? 'https://api.cloudflare.com/client/v4',
        tokenCallback = tokenCallback ?? (() async => token);

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
    _initialized = true;
  }
}
