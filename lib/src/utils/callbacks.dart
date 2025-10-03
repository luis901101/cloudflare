import 'package:dio/dio.dart';

/// Callback for asynchronous token generation
typedef TokenCallback = Future<String?> Function();
typedef CancelTokenCallback = CancelToken Function();
