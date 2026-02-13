import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

class CustomParseErrorLogger extends ParseErrorLogger {
  @override
  void logError(
    Object error,
    StackTrace stackTrace,
    RequestOptions options, {
    Response? response,
  }) {
    log(
      'Cloudflare/CustomParseErrorLogger => Error: $error\nStackTrace: $stackTrace\nOptions: $options\nResponse: $response',
    );
  }
}
