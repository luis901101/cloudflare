class CloudflareStreamVideosErrorCodes {
  static const internalServerError = 10000; //Internal Server Error
  static const authenticationFailure = 10001; //Authentication Failure
  static const conflictMediaHasBeenModifiedSinceLastRequest =
      100013; //Conflict Media has been modified since last request
  static const authorizationFailureCredentialNotAuthorized =
      10002; //Authorization Failure Credential not authorized
  static const notFoundResourceNotFound = 10003; //Not Found Resource not found
  static const decodingErrorCannotDecodeRequestBody =
      10004; //Decoding Error Cannot decode request body
  static const badRequest = 10005; //Bad Request
  static const betaAccessError = 10006; //Beta Access Error
  static const forbiddenCopyUploadNotEnabled =
      10007; //Forbidden Copy upload not enabled
  static const invalidDuration = 10008; //Invalid Duration
  static const forbiddenAllowedKeyCountExceeded =
      10009; //Forbidden Allowed key count exceeded
  static const invalidUrl = 10010; //Invalid URL
  static const fileSizeTooLarge = 10011; //File size too large
  static const forbiddenWebhookFeatureNotEnabled =
      10012; //Forbidden Webhook feature not enabled
  static const fileSizeTooLarge2 = 10014; //File size too large 2
  static const chunkSizeIsTooSmall = 10015; //Chunk size is too small
  static const tooManyRequests = 10016; //Too Many Requests
  static const expirationForUploadHasPassed =
      10017; //Expiration for upload has passed
  static const videoAlreadyUploaded = 10018; //Video already uploaded
  static const invalidPercentageRange = 10019; //Invalid Percentage Range
}
