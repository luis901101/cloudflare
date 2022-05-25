class CloudflareImagesErrorCodes {
  static const badRequest = 5400; //Bad Request
  static const variantNameNotFound = 5401; //Variant name not found
  static const givenAccountIsNotValidOrIsNotAuthorizedToAccessThisService =
      5403; //The given account is not valid or is not authorized to access this service
  static const imageNotFound = 5404; //Image not found
  static const clientWasSendingUploadTooSlowly =
      5408; //Client was sending upload too slowly
  static const maximumImageSizeOf10MbIsReached =
      5413; //Maximum image size of 10 Mb is reached
  static const imagesMustBeUploadedAsAFormNotAsRawImageData =
      5415; //Images must be uploaded as a form not as raw image data
  static const requestHasBeenAbortedByTheClient =
      5433; //Request has been aborted by the client
  static const errorWhileReceivingUpload = 5450; //Error while receiving upload
  static const theGivenAccountHasReachedAServiceLimit =
      5453; //The given account has reached a service limit
  static const unsupportedImageFormat = 5455; //Unsupported image format
  static const internalServerError = 5500; //Internal Server Error
  static const serverUnavailable = 5503; //Server Unavailable
  static const errorReceivedFromTheStorage =
      5540; //Error received from the storage
  static const errorWhilePurgingCache = 5541; //Error while purging cache
  static const errorWhileLoadingAccount = 5542; //Error while loading account
  static const errorDuringAudit = 5543; //Error during audit
  static const errorDuringAbuseOperation = 5544; //Error during abuse operation
  static const internalServerError2 = 5550; //Internal Server Error 2
}
