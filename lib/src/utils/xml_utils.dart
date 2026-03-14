import 'package:cloudflare/src/entity/r2_bucket.dart';
import 'package:cloudflare/src/entity/r2_object.dart';
import 'package:cloudflare/src/model/r2_error_response.dart';
import 'package:cloudflare/src/model/r2_list_objects_result.dart';
import 'package:http_parser/http_parser.dart';
import 'package:xml/xml.dart';

/// XML utilities for parsing S3-compatible (Cloudflare R2) response bodies
/// and for safely encoding data into XML.
class XmlUtils {
  XmlUtils._();

  // ── String utilities ─────────────────────────────────────────────────────

  /// Escapes XML special characters so a string is safe to embed inside
  /// XML text content or attribute values.
  static String escape(String input) => input
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&apos;');

  /// Parses an S3/R2 date string into a [DateTime].
  ///
  /// Handles both RFC 7231 HTTP-date format used in response headers
  /// (e.g. `Thu, 01 Jan 2026 00:00:00 GMT`) and ISO 8601 format used
  /// inside XML bodies (e.g. `2026-01-01T00:00:00.000Z`).
  ///
  /// Returns `null` for null, empty, or unparseable input.
  static DateTime? parseDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return parseHttpDate(raw);
    } catch (_) {
      return DateTime.tryParse(raw);
    }
  }

  // ── R2 / S3 XML response parsers ─────────────────────────────────────────

  /// Parses an S3/R2 XML error response body into an [R2ErrorResponse].
  ///
  /// Expected XML shape:
  /// ```xml
  /// <Error>
  ///   <Code>NoSuchBucket</Code>
  ///   <Message>The specified bucket does not exist</Message>
  ///   <RequestId>…</RequestId>
  /// </Error>
  /// ```
  /// Returns `null` when [xml] is empty.
  /// Returns an [R2ErrorResponse] with only [R2ErrorResponse.message] set
  /// when the body cannot be parsed as XML.
  static R2ErrorResponse? parseError(String xml) {
    if (xml.isEmpty) return null;
    try {
      final root = XmlDocument.parse(xml).rootElement;
      return R2ErrorResponse(
        code: root.findElements('Code').firstOrNull?.innerText,
        message: root.findElements('Message').firstOrNull?.innerText,
        requestId: root.findElements('RequestId').firstOrNull?.innerText,
      );
    } catch (_) {
      return R2ErrorResponse(message: xml);
    }
  }

  /// Parses a `ListAllMyBucketsResult` XML response into a list of [R2Bucket]s.
  ///
  /// Expected XML shape (abbreviated):
  /// ```xml
  /// <ListAllMyBucketsResult>
  ///   <Buckets>
  ///     <Bucket>
  ///       <Name>my-bucket</Name>
  ///       <CreationDate>2026-01-01T00:00:00.000Z</CreationDate>
  ///     </Bucket>
  ///   </Buckets>
  /// </ListAllMyBucketsResult>
  /// ```
  static List<R2Bucket> parseBuckets(String xml) {
    final doc = XmlDocument.parse(xml);
    return doc
        .findAllElements('Bucket')
        .map(
          (el) => R2Bucket(
            name: el.findElements('Name').firstOrNull?.innerText ?? '',
            creationDate: parseDate(
              el.findElements('CreationDate').firstOrNull?.innerText,
            ),
          ),
        )
        .toList();
  }

  /// Parses a `ListBucketResult` (ListObjectsV2) XML response into an
  /// [R2ListObjectsResult].
  ///
  /// [bucket] is attached to each returned [R2Object] for convenience.
  static R2ListObjectsResult parseListObjectsResult(
    String xml,
    String bucket,
  ) {
    final doc = XmlDocument.parse(xml);

    final objects = doc.findAllElements('Contents').map((el) {
      final sizeStr = el.findElements('Size').firstOrNull?.innerText;
      return R2Object(
        key: el.findElements('Key').firstOrNull?.innerText ?? '',
        bucket: bucket,
        size: sizeStr != null ? int.tryParse(sizeStr) : null,
        etag: el.findElements('ETag').firstOrNull?.innerText.replaceAll(
          '"',
          '',
        ),
        lastModified: parseDate(
          el.findElements('LastModified').firstOrNull?.innerText,
        ),
        storageClass: el.findElements('StorageClass').firstOrNull?.innerText,
      );
    }).toList();

    final prefixes = doc
        .findAllElements('CommonPrefixes')
        .map((el) => el.findElements('Prefix').firstOrNull?.innerText ?? '')
        .where((p) => p.isNotEmpty)
        .toList();

    final isTruncated =
        doc.findAllElements('IsTruncated').firstOrNull?.innerText == 'true';
    final nextToken =
        doc.findAllElements('NextContinuationToken').firstOrNull?.innerText;
    final keyCountStr =
        doc.findAllElements('KeyCount').firstOrNull?.innerText;

    return R2ListObjectsResult(
      objects: objects,
      commonPrefixes: prefixes,
      isTruncated: isTruncated,
      keyCount: int.tryParse(keyCountStr ?? '') ?? objects.length,
      nextContinuationToken: isTruncated ? nextToken : null,
    );
  }

  /// Parses a `DeleteObjects` response body and returns the list of object
  /// keys that **failed** to be deleted.
  ///
  /// Returns an empty list when all deletions succeeded or when [xml] is empty.
  static List<String> parseDeleteFailedKeys(String xml) {
    if (xml.isEmpty) return [];
    try {
      return XmlDocument.parse(xml)
          .findAllElements('Error')
          .map((el) => el.findElements('Key').firstOrNull?.innerText)
          .nonNulls
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Parses an `InitiateMultipartUploadResult` response and returns the
  /// upload ID.
  static String? parseUploadId(String xml) =>
      XmlDocument.parse(xml).findAllElements('UploadId').firstOrNull?.innerText;

  /// Parses a `CopyObjectResult` XML body, returning the ETag and last-modified
  /// date of the newly created copy.
  static ({String? etag, DateTime? lastModified}) parseCopyObjectResult(
    String xml,
  ) {
    final doc = XmlDocument.parse(xml);
    return (
      etag: doc
          .findAllElements('ETag')
          .firstOrNull
          ?.innerText
          .replaceAll('"', ''),
      lastModified: parseDate(
        doc.findAllElements('LastModified').firstOrNull?.innerText,
      ),
    );
  }

  /// Parses a `CompleteMultipartUploadResult` response and returns the final
  /// ETag of the assembled object.
  static String? parseCompleteMultipartEtag(String xml) =>
      XmlDocument.parse(xml)
          .findAllElements('ETag')
          .firstOrNull
          ?.innerText
          .replaceAll('"', '');
}

