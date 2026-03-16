/// R2 API token credentials (Access Key ID + Secret Access Key).
///
/// Generate R2 API tokens at:
/// `https://dash.cloudflare.com/<accountId>/r2/api-tokens`
///
/// R2 tokens are distinct from Cloudflare Bearer tokens — they use the
/// AWS-style access key / secret key scheme for SigV4 request signing.
class R2Credentials {
  /// The R2 Access Key ID.
  final String accessKeyId;

  /// The R2 Secret Access Key.
  final String secretAccessKey;

  const R2Credentials({
    required this.accessKeyId,
    required this.secretAccessKey,
  });
}
