import 'package:cloudflare/src/entity/r2_object.dart';

/// The result of a ListObjectsV2 call against a Cloudflare R2 bucket.
class R2ListObjectsResult {
  /// Objects returned by this page of results.
  final List<R2Object> objects;

  /// Common prefixes (virtual "directories") when [delimiter] was specified.
  final List<String> commonPrefixes;

  /// `true` when there are more results. Use [nextContinuationToken] to page.
  final bool isTruncated;

  /// Number of keys returned in this page.
  final int keyCount;

  /// Token to pass as `continuationToken` to retrieve the next page.
  /// `null` when [isTruncated] is `false`.
  final String? nextContinuationToken;

  const R2ListObjectsResult({
    required this.objects,
    this.commonPrefixes = const [],
    this.isTruncated = false,
    this.keyCount = 0,
    this.nextContinuationToken,
  });
}
