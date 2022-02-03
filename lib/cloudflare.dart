library cloudflare;

import 'dart:io';

import 'package:cloudflare/src/apiservice/image_api.dart';
import 'package:cloudflare/src/base_api/rest_api.dart';
import 'package:cloudflare/src/utils/callbacks.dart';

export 'package:cloudflare/src/entity/cloudflare_image.dart';
export 'package:cloudflare/src/entity/cloudflare_response.dart';

export 'package:cloudflare/src/model/error_info.dart';
export 'package:cloudflare/src/model/error_response.dart';
export 'package:cloudflare/src/model/pagination.dart';

export 'package:cloudflare/src/apiservice/image_api.dart';

class Cloudflare {
  /// Cloudflare api url, at the moment of writing this: https://api.cloudflare.com/client/v4
  final String apiUrl;

  /// Cloudflare account id
  final String accountId;

  /// Cloudflare API token
  final String? token;

  /// Callback to asynchronously get Cloudflare API token
  final TokenCallback tokenCallback;

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
    this.timeout,
    this.httpClient,
  }) :
      assert((token != null && tokenCallback == null) ||
          (token == null && tokenCallback != null),
          'A token or tokenCallback must be specified, only one of both.'),
    apiUrl = apiUrl ?? 'https://api.cloudflare.com/client/v4',
    tokenCallback = tokenCallback ?? (() async => token!)
  ;

  bool get isInitialized => _initialized;

  /// Call this function before using Cloudflare APIs
  Future<void> init() async {
    if(isInitialized) return;

    restAPI.init(
      httpClient: httpClient,
      apiUrl: apiUrl,
      timeout: timeout,
      tokenCallback: tokenCallback,
    );

    imageAPI = ImageAPI(restAPI: restAPI, accountId: accountId);
    _initialized = true;
  }
}
