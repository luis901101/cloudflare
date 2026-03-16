import 'dart:convert';
import 'dart:typed_data';

import 'package:aws_common/aws_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:cloudflare/src/entity/r2_bucket.dart';
import 'package:cloudflare/src/entity/r2_object.dart';
import 'package:cloudflare/src/entity/r2_signed_url.dart';
import 'package:cloudflare/src/model/cloudflare_http_response.dart';
import 'package:cloudflare/src/model/data_transmit.dart';
import 'package:cloudflare/src/model/r2_credentials.dart';
import 'package:cloudflare/src/model/r2_error_response.dart';
import 'package:cloudflare/src/model/r2_list_objects_result.dart';
import 'package:cross_file/cross_file.dart';
import 'package:cloudflare/src/utils/xml_utils.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart' as http;

/// Cloudflare R2 object-storage API (S3-compatible).
///
/// R2 exposes an S3-compatible endpoint at:
/// `https://<accountId>.r2.cloudflarestorage.com`
///
/// Requests are signed with AWS Signature Version 4 using [R2Credentials].
///
/// ### Quick start
/// ```dart
/// final r2 = R2CloudflareAPI(
///   accountId: 'my-account-id',
///   credentials: R2Credentials(
///     accessKeyId: 'r2-access-key-id',
///     secretAccessKey: 'r2-secret-access-key',
///   ),
/// );
///
/// // List buckets
/// final res = await r2.listBuckets();
/// if (res.isSuccessful) print(res.body); // List<R2Bucket>
///
/// // Upload an object from an XFile
/// await r2.putObject(
///   'my-bucket', 'images/avatar.png',
///   content: DataTransmit(data: myXFile),
/// );
/// ```
class R2CloudflareAPI {
  /// The default SigV4 region for Cloudflare R2.
  ///
  /// Pass a custom [r2Region] to the constructor to override this (e.g.
  /// `'eu'` for the EU jurisdiction bucket, or `'fedramp'`).
  static const r2Region = 'auto';

  /// Underlying S3 service name used for signing.
  static const r2ServiceName = 's3';

  /// Your Cloudflare account ID.
  final String accountId;

  /// The SigV4 region used for every signed request.
  ///
  /// Defaults to [r2Region] (`'auto'`) when not supplied to the constructor.
  final String region;

  final Uri s3ApiUri;
  final AWSSigV4Signer _signer;
  final AWSHttpClient _httpClient;

  /// Creates an [R2CloudflareAPI] instance.
  ///
  /// [accountId] must be your Cloudflare account ID.
  /// [credentials] contains the R2 API token pair.
  ///
  /// [s3ApiUrl] overrides the default S3-compatible endpoint
  /// (`https://<accountId>.r2.cloudflarestorage.com`). Useful when pointing
  /// at a custom domain, a jurisdiction-specific URL (e.g.
  /// `https://<accountId>.eu.r2.cloudflarestorage.com`), or a local mock.
  ///
  /// [r2Region] overrides the SigV4 signing region. Defaults to `'auto'`.
  /// Set to `'eu'` for the EU-jurisdiction endpoint, or `'fedramp'` for the
  /// FedRAMP-compliant endpoint.
  R2CloudflareAPI({
    required this.accountId,
    required R2Credentials credentials,
    String? s3ApiUrl,
    String? r2Region,
  }) : region = r2Region ?? R2CloudflareAPI.r2Region,
       s3ApiUri = Uri.parse(
         s3ApiUrl ?? 'https://$accountId.r2.cloudflarestorage.com',
       ),
       _signer = AWSSigV4Signer(
         credentialsProvider: AWSCredentialsProvider(
           AWSCredentials(credentials.accessKeyId, credentials.secretAccessKey),
         ),
       ),
       _httpClient = AWSHttpClient();

  // ── Internal helpers ────────────────────────────────────────────────────

  /// Build a fresh credential scope (date must be current for each request).
  AWSCredentialScope get _scope => AWSCredentialScope(
    region: region,
    service: AWSService.s3,
    dateTime: AWSDateTime.now(),
  );

  CloudflareHTTPResponse<T> _errorResp<T>(
    int statusCode,
    R2ErrorResponse? error, {
    Map<String, String> headers = const {},
  }) => CloudflareHTTPResponse<T>(
    http.Response('', statusCode, headers: headers),
    null,
    error: error,
  );

  CloudflareHTTPResponse<T> _successResp<T>(
    int statusCode,
    T? body, {
    Map<String, String> headers = const {},
  }) => CloudflareHTTPResponse<T>(
    http.Response('', statusCode, headers: headers),
    body,
  );

  /// Signs and executes an HTTP request against the R2 S3 endpoint.
  Future<({int statusCode, Uint8List body, Map<String, String> headers})>
  _execute({
    required AWSHttpMethod method,
    required String path,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    List<int>? body,
    String? contentType,
  }) async {
    final uri = s3ApiUri.replace(
      path: path,
      queryParameters: (queryParams?.isEmpty ?? true) ? null : queryParams,
    );

    final reqHeaders = <String, String>{
      AWSHeaders.contentType: ?contentType,
      ...?headers,
    };

    final request = AWSHttpRequest(
      method: method,
      uri: uri,
      headers: reqHeaders,
      body: body,
    );

    final signedRequest = await _signer.sign(
      request,
      credentialScope: _scope,
      serviceConfiguration: S3ServiceConfiguration(),
    );

    final operation = _httpClient.send(signedRequest);
    final response = await operation.response;
    final responseBody = await response.bodyBytes;
    return (
      statusCode: response.statusCode,
      body: Uint8List.fromList(responseBody),
      headers: Map<String, String>.unmodifiable(
        Map.fromEntries(response.headers.entries),
      ),
    );
  }

  // ── Bucket CRUD ──────────────────────────────────────────────────────────

  /// Lists all R2 buckets in the account.
  ///
  /// ```dart
  /// final res = await r2.listBuckets();
  /// if (res.isSuccessful) {
  ///   for (final bucket in res.body!) { ... }
  /// }
  /// ```
  Future<CloudflareHTTPResponse<List<R2Bucket>?>> listBuckets() async {
    try {
      final result = await _execute(method: AWSHttpMethod.get, path: '/');
      final bodyStr = utf8.decode(result.body);

      if (!_isSuccess(result.statusCode)) {
        return _errorResp(
          result.statusCode,
          XmlUtils.parseError(bodyStr),
          headers: result.headers,
        );
      }

      return _successResp(
        result.statusCode,
        XmlUtils.parseBuckets(bodyStr),
        headers: result.headers,
      );
    } catch (e) {
      return _errorResp(500, R2ErrorResponse(message: e.toString()));
    }
  }

  /// Creates a new R2 bucket.
  ///
  /// [name] must be unique within your account and comply with S3 naming rules:
  /// 3–63 characters, lowercase letters, numbers, and hyphens only.
  ///
  /// Throws no error if the bucket already exists and is owned by the same
  /// account (idempotent).
  Future<CloudflareHTTPResponse<R2Bucket?>> createBucket(String name) async {
    assert(name.isNotEmpty, 'Bucket name must not be empty');
    try {
      final result = await _execute(method: AWSHttpMethod.put, path: '/$name');
      final bodyStr = utf8.decode(result.body);

      if (!_isSuccess(result.statusCode)) {
        return _errorResp(
          result.statusCode,
          XmlUtils.parseError(bodyStr),
          headers: result.headers,
        );
      }

      return _successResp(
        result.statusCode,
        R2Bucket(name: name),
        headers: result.headers,
      );
    } catch (e) {
      return _errorResp(500, R2ErrorResponse(message: e.toString()));
    }
  }

  /// Checks whether [name] exists (HTTP HEAD).
  ///
  /// Returns `true` when the bucket exists, `false` when it does not (404).
  /// A non-200/404 status is surfaced as an error response.
  Future<CloudflareHTTPResponse<bool?>> headBucket(String name) async {
    try {
      final result = await _execute(method: AWSHttpMethod.head, path: '/$name');

      if (result.statusCode == 404) {
        return _successResp(result.statusCode, false, headers: result.headers);
      }
      if (!_isSuccess(result.statusCode)) {
        return _errorResp(
          result.statusCode,
          R2ErrorResponse(code: '${result.statusCode}'),
          headers: result.headers,
        );
      }

      return _successResp(result.statusCode, true, headers: result.headers);
    } catch (e) {
      return _errorResp(500, R2ErrorResponse(message: e.toString()));
    }
  }

  /// Deletes an R2 bucket.
  ///
  /// The bucket **must be empty** before deletion; R2 returns a 409 otherwise.
  Future<CloudflareHTTPResponse<bool?>> deleteBucket(String name) async {
    try {
      final result = await _execute(
        method: AWSHttpMethod.delete,
        path: '/$name',
      );
      final bodyStr = utf8.decode(result.body);

      if (!_isSuccess(result.statusCode)) {
        return _errorResp(
          result.statusCode,
          XmlUtils.parseError(bodyStr),
          headers: result.headers,
        );
      }

      return _successResp(result.statusCode, true, headers: result.headers);
    } catch (e) {
      return _errorResp(500, R2ErrorResponse(message: e.toString()));
    }
  }

  // ── Object CRUD ──────────────────────────────────────────────────────────

  /// Lists objects in [bucket] using ListObjectsV2.
  ///
  /// [prefix]            – return only keys beginning with this string.
  /// [maxKeys]           – max results per page (1–1000, default 1000).
  /// [continuationToken] – resume a previous truncated listing.
  /// [delimiter]         – groups keys sharing a common prefix (virtual dirs).
  ///
  /// Iterate through all pages:
  /// ```dart
  /// String? token;
  /// do {
  ///   final res = await r2.listObjects('my-bucket', continuationToken: token);
  ///   final page = res.body!;
  ///   // process page.objects …
  ///   token = page.nextContinuationToken;
  /// } while (token != null);
  /// ```
  Future<CloudflareHTTPResponse<R2ListObjectsResult?>> listObjects(
    String bucket, {
    String? prefix,
    int maxKeys = 1000,
    String? continuationToken,
    String? delimiter,
  }) async {
    try {
      final queryParams = <String, String>{
        'list-type': '2',
        'max-keys': '$maxKeys',
        'prefix': ?prefix,
        'continuation-token': ?continuationToken,
        'delimiter': ?delimiter,
      };

      final result = await _execute(
        method: AWSHttpMethod.get,
        path: '/$bucket',
        queryParams: queryParams,
      );
      final bodyStr = utf8.decode(result.body);

      if (!_isSuccess(result.statusCode)) {
        return _errorResp(
          result.statusCode,
          XmlUtils.parseError(bodyStr),
          headers: result.headers,
        );
      }

      return _successResp(
        result.statusCode,
        XmlUtils.parseListObjectsResult(bodyStr, bucket),
        headers: result.headers,
      );
    } catch (e) {
      return _errorResp(500, R2ErrorResponse(message: e.toString()));
    }
  }

  /// Downloads an object and returns its raw bytes.
  ///
  /// For large files, prefer [getObjectStream] to avoid loading the entire
  /// object into memory, or use ranged requests via [getObjectRange].
  Future<CloudflareHTTPResponse<Uint8List?>> getObject(
    String bucket,
    String key, {
    String? versionId,
  }) async {
    try {
      final queryParams = <String, String>{'versionId': ?versionId};

      final result = await _execute(
        method: AWSHttpMethod.get,
        path: '/$bucket/$key',
        queryParams: queryParams.isEmpty ? null : queryParams,
      );

      if (!_isSuccess(result.statusCode)) {
        return _errorResp(
          result.statusCode,
          XmlUtils.parseError(utf8.decode(result.body)),
          headers: result.headers,
        );
      }

      return _successResp(
        result.statusCode,
        result.body,
        headers: result.headers,
      );
    } catch (e) {
      return _errorResp(500, R2ErrorResponse(message: e.toString()));
    }
  }

  /// Downloads a byte range of an object (HTTP Range header).
  ///
  /// Useful for streaming large files or seeking in media. [start] and [end]
  /// are **inclusive, zero-based** byte indices.
  Future<CloudflareHTTPResponse<Uint8List?>> getObjectRange(
    String bucket,
    String key, {
    required int start,
    int? end,
  }) async {
    final rangeHeader = end != null ? 'bytes=$start-$end' : 'bytes=$start-';
    try {
      final result = await _execute(
        method: AWSHttpMethod.get,
        path: '/$bucket/$key',
        headers: {'Range': rangeHeader},
      );

      if (result.statusCode != 206 && !_isSuccess(result.statusCode)) {
        return _errorResp(
          result.statusCode,
          XmlUtils.parseError(utf8.decode(result.body)),
          headers: result.headers,
        );
      }

      return _successResp(
        result.statusCode,
        result.body,
        headers: result.headers,
      );
    } catch (e) {
      return _errorResp(500, R2ErrorResponse(message: e.toString()));
    }
  }

  /// Fetches metadata of an object without downloading its body (HTTP HEAD).
  ///
  /// Returns an [R2Object] populated from response headers.
  Future<CloudflareHTTPResponse<R2Object?>> headObject(
    String bucket,
    String key,
  ) async {
    try {
      final result = await _execute(
        method: AWSHttpMethod.head,
        path: '/$bucket/$key',
      );

      if (!_isSuccess(result.statusCode)) {
        return _errorResp(
          result.statusCode,
          R2ErrorResponse(code: '${result.statusCode}'),
          headers: result.headers,
        );
      }

      final h = result.headers;
      return _successResp(
        result.statusCode,
        R2Object(
          key: key,
          bucket: bucket,
          size: int.tryParse(h['content-length'] ?? ''),
          etag: h['etag']?.replaceAll('"', ''),
          lastModified: XmlUtils.parseDate(h['last-modified']),
          contentType: h['content-type'],
          storageClass: h['x-amz-storage-class'],
        ),
        headers: result.headers,
      );
    } catch (e) {
      return _errorResp(500, R2ErrorResponse(message: e.toString()));
    }
  }

  /// Uploads raw bytes to [bucket]/[key].
  ///
  /// [contentType] defaults to `application/octet-stream`.
  /// Use [metadata] to attach up to 2 KB of custom headers
  /// (`x-amz-meta-*`).
  ///
  /// For files > ~5 GB use [createMultipartUpload] / [uploadPart] /
  /// [completeMultipartUpload] instead.
  Future<CloudflareHTTPResponse<R2Object?>> _putObjectBytes(
    String bucket,
    String key,
    Uint8List data, {
    String contentType = 'application/octet-stream',
    Map<String, String>? metadata,
  }) async {
    try {
      final metaHeaders = metadata != null
          ? {for (final e in metadata.entries) 'x-amz-meta-${e.key}': e.value}
          : null;

      final result = await _execute(
        method: AWSHttpMethod.put,
        path: '/$bucket/$key',
        headers: metaHeaders,
        body: data,
        contentType: contentType,
      );

      if (!_isSuccess(result.statusCode)) {
        return _errorResp(
          result.statusCode,
          XmlUtils.parseError(utf8.decode(result.body)),
          headers: result.headers,
        );
      }

      return _successResp(
        result.statusCode,
        R2Object(
          key: key,
          bucket: bucket,
          size: data.length,
          etag: result.headers['etag']?.replaceAll('"', ''),
          contentType: contentType,
        ),
        headers: result.headers,
      );
    } catch (e) {
      return _errorResp(500, R2ErrorResponse(message: e.toString()));
    }
  }

  /// Uploads an [XFile] to [bucket]/[key].
  ///
  /// Reads the file into memory, then calls [putObjectBytes].
  /// For very large files consider multipart upload via [createMultipartUpload].
  ///
  /// [content] wraps the [XFile] and optionally carries a [progressCallback]
  /// (currently not propagated through the S3 signing layer; use multipart
  /// upload with per-part progress for granular reporting).
  Future<CloudflareHTTPResponse<R2Object?>> putObject(
    String bucket,
    String key, {
    required DataTransmit<XFile> content,
    String? contentType,
  }) async {
    final bytes = await content.data.readAsBytes();
    final mime =
        contentType ?? content.data.mimeType ?? 'application/octet-stream';
    return _putObjectBytes(bucket, key, bytes, contentType: mime);
  }

  /// Deletes a single object.
  ///
  /// R2 returns 204 No Content on success, even when the key doesn't exist.
  Future<CloudflareHTTPResponse<bool?>> deleteObject(
    String bucket,
    String key, {
    String? versionId,
  }) async {
    try {
      final queryParams = <String, String>{'versionId': ?versionId};

      final result = await _execute(
        method: AWSHttpMethod.delete,
        path: '/$bucket/$key',
        queryParams: queryParams.isEmpty ? null : queryParams,
      );

      if (!_isSuccess(result.statusCode)) {
        return _errorResp(
          result.statusCode,
          XmlUtils.parseError(utf8.decode(result.body)),
          headers: result.headers,
        );
      }

      return _successResp(result.statusCode, true, headers: result.headers);
    } catch (e) {
      return _errorResp(500, R2ErrorResponse(message: e.toString()));
    }
  }

  /// Deletes up to 1000 objects in a single request (S3 Multi-Object Delete).
  ///
  /// Returns the list of keys that **failed** to delete (empty = all OK).
  Future<CloudflareHTTPResponse<List<String>?>> deleteObjects(
    String bucket,
    List<String> keys,
  ) async {
    assert(keys.isNotEmpty, 'keys must not be empty');
    assert(
      keys.length <= 1000,
      'A maximum of 1000 keys can be deleted per call',
    );
    try {
      final buffer = StringBuffer()
        ..write('<?xml version="1.0" encoding="UTF-8"?>')
        ..write('<Delete>');
      for (final key in keys) {
        buffer
          ..write('<Object><Key>')
          ..write(XmlUtils.escape(key))
          ..write('</Key></Object>');
      }
      buffer.write('</Delete>');

      final body = utf8.encode(buffer.toString());

      // S3/R2 batch-delete requires a Content-MD5 header (base64-encoded MD5
      // of the request body). Without it R2 returns InvalidArgument.
      final contentMd5 = base64.encode(crypto.md5.convert(body).bytes);

      final result = await _execute(
        method: AWSHttpMethod.post,
        path: '/$bucket',
        queryParams: {'delete': ''},
        body: body,
        contentType: 'application/xml',
        headers: {'Content-MD5': contentMd5},
      );

      final responseStr = utf8.decode(result.body);

      if (!_isSuccess(result.statusCode)) {
        return _errorResp(
          result.statusCode,
          XmlUtils.parseError(responseStr),
          headers: result.headers,
        );
      }

      return _successResp(
        result.statusCode,
        XmlUtils.parseDeleteFailedKeys(responseStr),
        headers: result.headers,
      );
    } catch (e) {
      return _errorResp(500, R2ErrorResponse(message: e.toString()));
    }
  }

  /// Copies an object from [sourceBucket]/[sourceKey] to
  /// [destBucket]/[destKey].
  ///
  /// Source and destination can be in different buckets within the same
  /// R2 account.
  Future<CloudflareHTTPResponse<R2Object?>> copyObject({
    required String sourceBucket,
    required String sourceKey,
    required String destBucket,
    required String destKey,
    String? contentType,
  }) async {
    try {
      final result = await _execute(
        method: AWSHttpMethod.put,
        path: '/$destBucket/$destKey',
        headers: {
          'x-amz-copy-source': '/$sourceBucket/$sourceKey',
          AWSHeaders.contentType: ?contentType,
        },
      );

      final bodyStr = utf8.decode(result.body);

      if (!_isSuccess(result.statusCode)) {
        return _errorResp(
          result.statusCode,
          XmlUtils.parseError(bodyStr),
          headers: result.headers,
        );
      }

      final copyResult = XmlUtils.parseCopyObjectResult(bodyStr);
      return _successResp(
        result.statusCode,
        R2Object(
          key: destKey,
          bucket: destBucket,
          etag: copyResult.etag,
          lastModified: copyResult.lastModified,
        ),
        headers: result.headers,
      );
    } catch (e) {
      return _errorResp(500, R2ErrorResponse(message: e.toString()));
    }
  }

  // ── Presigned URLs ───────────────────────────────────────────────────────

  /// Generates a presigned URL for [bucket]/[key] and returns an
  /// [R2SignedUrl] describing it.
  ///
  /// The returned URL embeds SigV4 credentials in its query parameters so it
  /// can be handed directly to an unauthenticated client.  No extra headers
  /// are required to use it — the authority is encoded in the URL itself.
  ///
  /// ### Returned [R2SignedUrl] fields
  /// | Field | Description |
  /// |---|---|
  /// | `url` | The full presigned URL string to share with the client. |
  /// | `bucket` | The R2 bucket the object lives in. |
  /// | `key` | The object key within the bucket. |
  /// | `type` | The HTTP method the URL permits — uppercase, e.g. `"GET"` or `"PUT"`. |
  /// | `expiresAt` | UTC instant the URL expires (locally computed approximation). |
  /// | `isExpired` | Convenience getter: `true` once `expiresAt` is in the past. |
  ///
  /// ### Parameters
  /// - [expiresIn] — validity period; maximum 7 days for R2 (default: 1 hour).
  /// - [method] — HTTP method the URL will permit (default: `GET` for
  ///   downloads). Pass `AWSHttpMethod.put` to allow client-side uploads.
  ///
  /// ### Download example
  /// ```dart
  /// final signed = await r2.presignedUrl('my-bucket', 'docs/report.pdf');
  /// // Share signed.url — client can GET it without credentials.
  /// print(signed.type);      // "GET"
  /// print(signed.expiresAt); // e.g. 2026-03-16T12:00:00.000Z
  /// ```
  ///
  /// ### Client-side upload example
  /// ```dart
  /// // Backend: generate a presigned PUT URL.
  /// final signed = await r2.presignedUrl(
  ///   'my-bucket',
  ///   'uploads/document.pdf',
  ///   method: AWSHttpMethod.put,
  ///   expiresIn: Duration(minutes: 15),
  /// );
  ///
  /// // Client: upload directly — no credentials required.
  /// final response = await http.put(
  ///   Uri.parse(signed.url),
  ///   headers: {'content-type': 'application/pdf'},
  ///   body: pdfBytes,
  /// );
  /// ```
  ///
  /// R2 API docs: https://developers.cloudflare.com/r2/api/s3/presigned-urls/
  Future<R2SignedUrl> presignedUrl(
    String bucket,
    String key, {
    Duration expiresIn = const Duration(hours: 1),
    AWSHttpMethod method = AWSHttpMethod.get,
  }) async {
    assert(
      expiresIn <= const Duration(days: 7),
      'R2 presigned URLs cannot exceed 7 days',
    );

    final uri = s3ApiUri.replace(path: '/$bucket/$key');
    final request = AWSHttpRequest(method: method, uri: uri);

    final presignedUri = await _signer.presign(
      request,
      credentialScope: _scope,
      serviceConfiguration: S3ServiceConfiguration(signPayload: false),
      expiresIn: expiresIn,
    );

    return R2SignedUrl(
      url: presignedUri.toString(),
      bucket: bucket,
      key: key,
      type: method.value,
      expiresAt: DateTime.now().toUtc().add(expiresIn),
    );
  }

  // ── Multipart Upload ─────────────────────────────────────────────────────

  /// Initiates a multipart upload for [bucket]/[key].
  ///
  /// Returns the upload ID that must be passed to [uploadPart] and
  /// [completeMultipartUpload].
  ///
  /// Use multipart upload for files > 100 MB to get resumability and
  /// per-part progress reporting.
  Future<CloudflareHTTPResponse<String?>> createMultipartUpload(
    String bucket,
    String key, {
    String contentType = 'application/octet-stream',
    Map<String, String>? metadata,
  }) async {
    try {
      final metaHeaders = metadata != null
          ? {for (final e in metadata.entries) 'x-amz-meta-${e.key}': e.value}
          : null;

      final result = await _execute(
        method: AWSHttpMethod.post,
        path: '/$bucket/$key',
        queryParams: {'uploads': ''},
        headers: metaHeaders,
        contentType: contentType,
      );

      final bodyStr = utf8.decode(result.body);

      if (!_isSuccess(result.statusCode)) {
        return _errorResp(
          result.statusCode,
          XmlUtils.parseError(bodyStr),
          headers: result.headers,
        );
      }

      return _successResp(
        result.statusCode,
        XmlUtils.parseUploadId(bodyStr),
        headers: result.headers,
      );
    } catch (e) {
      return _errorResp(500, R2ErrorResponse(message: e.toString()));
    }
  }

  /// Uploads a single part of a multipart upload.
  ///
  /// [uploadId]   – the ID returned by [createMultipartUpload].
  /// [partNumber] – 1-based part number (1–10 000).
  /// [data]       – the raw bytes for this part (min 5 MB except the last).
  ///
  /// Returns the ETag of the uploaded part; collect these to pass to
  /// [completeMultipartUpload].
  Future<CloudflareHTTPResponse<String?>> uploadPart(
    String bucket,
    String key,
    String uploadId,
    int partNumber,
    Uint8List data,
  ) async {
    assert(
      partNumber >= 1 && partNumber <= 10000,
      'partNumber must be between 1 and 10000',
    );
    try {
      final result = await _execute(
        method: AWSHttpMethod.put,
        path: '/$bucket/$key',
        queryParams: {'partNumber': '$partNumber', 'uploadId': uploadId},
        body: data,
        contentType: 'application/octet-stream',
      );

      if (!_isSuccess(result.statusCode)) {
        return _errorResp(
          result.statusCode,
          XmlUtils.parseError(utf8.decode(result.body)),
          headers: result.headers,
        );
      }

      final etag = result.headers['etag']?.replaceAll('"', '');
      return _successResp(result.statusCode, etag, headers: result.headers);
    } catch (e) {
      return _errorResp(500, R2ErrorResponse(message: e.toString()));
    }
  }

  /// Completes a multipart upload, assembling all parts into a final object.
  ///
  /// [parts] maps each `partNumber` to its ETag (as returned by [uploadPart]).
  /// Parts are sorted by part number automatically.
  Future<CloudflareHTTPResponse<R2Object?>> completeMultipartUpload(
    String bucket,
    String key,
    String uploadId,
    Map<int, String> parts,
  ) async {
    assert(parts.isNotEmpty, 'parts must not be empty');
    try {
      final sorted = parts.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));

      final buffer = StringBuffer()
        ..write('<?xml version="1.0" encoding="UTF-8"?>')
        ..write('<CompleteMultipartUpload>');
      for (final part in sorted) {
        buffer
          ..write('<Part>')
          ..write('<PartNumber>${part.key}</PartNumber>')
          ..write('<ETag>${part.value}</ETag>')
          ..write('</Part>');
      }
      buffer.write('</CompleteMultipartUpload>');

      final body = utf8.encode(buffer.toString());

      final result = await _execute(
        method: AWSHttpMethod.post,
        path: '/$bucket/$key',
        queryParams: {'uploadId': uploadId},
        body: body,
        contentType: 'application/xml',
      );

      final responseStr = utf8.decode(result.body);

      if (!_isSuccess(result.statusCode)) {
        return _errorResp(
          result.statusCode,
          XmlUtils.parseError(responseStr),
          headers: result.headers,
        );
      }

      return _successResp(
        result.statusCode,
        R2Object(
          key: key,
          bucket: bucket,
          etag: XmlUtils.parseCompleteMultipartEtag(responseStr),
        ),
        headers: result.headers,
      );
    } catch (e) {
      return _errorResp(500, R2ErrorResponse(message: e.toString()));
    }
  }

  /// Aborts a multipart upload and discards all uploaded parts.
  ///
  /// Always call this if you do not intend to complete the upload, to avoid
  /// storage charges for incomplete parts.
  Future<CloudflareHTTPResponse<bool?>> abortMultipartUpload(
    String bucket,
    String key,
    String uploadId,
  ) async {
    try {
      final result = await _execute(
        method: AWSHttpMethod.delete,
        path: '/$bucket/$key',
        queryParams: {'uploadId': uploadId},
      );

      if (!_isSuccess(result.statusCode)) {
        return _errorResp(
          result.statusCode,
          XmlUtils.parseError(utf8.decode(result.body)),
          headers: result.headers,
        );
      }

      return _successResp(result.statusCode, true, headers: result.headers);
    } catch (e) {
      return _errorResp(500, R2ErrorResponse(message: e.toString()));
    }
  }

  // ── Utilities ────────────────────────────────────────────────────────────

  bool _isSuccess(int code) => code >= 200 && code < 300;

  /// Releases the underlying HTTP client. Call this when the [R2CloudflareAPI]
  /// instance is no longer needed.
  void dispose() => _httpClient.close();
}
