import 'package:dio/dio.dart';

class DataTransmit<T> {
  /// Data to transmit
  T data;

  /// Callback to listen the progress for sending/receiving data.
  ProgressCallback? progressCallback;

  /// You can cancel a request by using a cancel token.
  /// One token can be shared with different requests.
  /// when a token's [cancel] method invoked, all requests
  /// with this token will be cancelled.
  CancelToken? cancelToken;

  DataTransmit({required this.data, this.progressCallback, this.cancelToken});
}
