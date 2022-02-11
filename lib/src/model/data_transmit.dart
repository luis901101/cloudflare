import 'package:dio/dio.dart';

class DataTransmit<T> {
  /// Data to transmit
  T data;

  /// Callback to listen the progress for sending/receiving data.
  ProgressCallback? progressCallback;

  DataTransmit({required this.data, this.progressCallback});
}
