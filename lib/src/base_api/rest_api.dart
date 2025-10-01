import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class RestAPI {
  Dio dio = Dio();

  HttpClient? httpClient;

  Duration? connectTimeout;
  Duration? receiveTimeout;
  Duration? sendTimeout;
  String apiUrl = '';
  Map<String, dynamic>? headers;

  void init({
    String? apiUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    HttpClient? httpClient,
    Map<String, dynamic>? headers,
  }) {
    if ((apiUrl?.isNotEmpty ?? true)) this.apiUrl = apiUrl!;
    if (connectTimeout != null) this.connectTimeout = connectTimeout;
    if (receiveTimeout != null) this.receiveTimeout = receiveTimeout;
    if (sendTimeout != null) this.sendTimeout = sendTimeout;
    if (httpClient != null) this.httpClient = httpClient;
    if (headers != null) this.headers = headers;
    _initDio();
  }

  String? get authorizationHeader => headers?[HttpHeaders.authorizationHeader];

  void _initDio() {
    dispose();

    dio = Dio(
      BaseOptions(
        baseUrl: apiUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        sendTimeout: sendTimeout,
        // headers: RestAPIService.contentTypeJson,
        contentType: Headers.jsonContentType,
      ),
    );

    // Adding auth token to each request
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (headers != null) {
            options.headers.addAll(headers!);
          }
          return handler.next(options);
        },
      ),
    );

    // Adding custom httpClient
    if (httpClient != null) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
          httpClient!;
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
