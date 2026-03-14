/// An error response from the Cloudflare R2 S3-compatible API.
///
/// R2 returns XML error bodies for non-2xx responses, following the S3 spec:
/// ```xml
/// <Error>
///   <Code>NoSuchBucket</Code>
///   <Message>The specified bucket does not exist</Message>
///   <RequestId>…</RequestId>
/// </Error>
/// ```
class R2ErrorResponse {
  /// S3 error code (e.g. `NoSuchBucket`, `NoSuchKey`, `AccessDenied`).
  final String? code;

  /// Human-readable error message.
  final String? message;

  /// Request ID, useful when contacting Cloudflare support.
  final String? requestId;

  const R2ErrorResponse({this.code, this.message, this.requestId});

  @override
  String toString() {
    final parts = [
      if (code != null) 'code: $code',
      if (message != null) 'message: $message',
      if (requestId != null) 'requestId: $requestId',
    ];
    return 'R2ErrorResponse(${parts.join(', ')})';
  }
}
