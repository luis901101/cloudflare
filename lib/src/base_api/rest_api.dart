import 'dart:io';

import 'package:cloudflare/src/utils/callbacks.dart';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';

final restAPI = RestAPI();

class RestAPI {
  Dio dio = Dio();

  HttpClient? httpClient;

  Duration? timeout;
  late String apiUrl;
  TokenCallback? tokenCallback;

  RestAPI() {
    apiUrl = '';
  }

  void init({String? apiUrl, Duration? timeout, HttpClient? httpClient, TokenCallback? tokenCallback}) {
    if ((apiUrl?.isNotEmpty ?? true)) this.apiUrl = apiUrl!;
    if (timeout != null) this.timeout = timeout;
    if (httpClient != null) this.httpClient = httpClient;
    if (tokenCallback != null) this.tokenCallback = tokenCallback;
    _initDio();
  }

  void _initDio() {
    dispose();

    dio = Dio(
      BaseOptions(
        baseUrl: apiUrl,
        connectTimeout: timeout?.inMilliseconds
      )
    );

    // Adding auth token to each request
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
      if(tokenCallback != null) {
        final token = tokenCallback!.call();
        options.headers.addAll({
          HttpHeaders.authorizationHeader: 'Bearer $token',
          // HttpHeaders.contentTypeHeader: Headers.jsonContentType,
        });
      }
      return handler.next(options);
    }));

    // Adding custom httpClient
    if(httpClient != null) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate  = (client) {
        return httpClient;
      };
    }
  }

  void dispose() {
    try {
      dio.close();
    } catch (e) {
      print(e);
    }
  }
}
