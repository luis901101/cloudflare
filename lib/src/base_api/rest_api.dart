import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

class RestAPI {
  Dio dio = Dio();

  HttpClient? httpClient;

  Duration? timeout;
  String apiUrl = '';
  Map<String, dynamic>? headers;

  void init(
      {String? apiUrl,
      Duration? timeout,
      HttpClient? httpClient,
      Map<String, dynamic>? headers}) {
    if ((apiUrl?.isNotEmpty ?? true)) this.apiUrl = apiUrl!;
    if (timeout != null) this.timeout = timeout;
    if (httpClient != null) this.httpClient = httpClient;
    if (headers != null) this.headers = headers;
    _initDio();
  }

  void _initDio() {
    dispose();

    dio = Dio(
        BaseOptions(baseUrl: apiUrl, connectTimeout: timeout?.inMilliseconds));

    // Adding auth token to each request
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      if (headers != null) {
        options.headers.addAll(headers!);
      }
      return handler.next(options);
    }));

    // Adding custom httpClient
    if (httpClient != null) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
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
