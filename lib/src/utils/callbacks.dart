
/// Callback for asynchronous token generation
typedef TokenCallback = Future<String?> Function();

/// Callback to listen the progress for sending/receiving data for a specific
/// key.
///
/// [key] an identifier for the data in progress.
///
/// [count] is the length of the bytes have been sent/received.
///
/// [total] is the content length of the response/request body.
/// 1.When receiving data:
///   [total] is the request body length.
/// 2.When receiving data:
///   [total] will be -1 if the size of the response body is not known in advance,
///   for example: response data is compressed with gzip or no content-length header.
typedef GenericProgressCallback<T> = void Function(T? key, int count, int total);