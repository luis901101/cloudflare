import 'dart:typed_data';

import 'package:aws_common/aws_common.dart' show AWSHttpMethod;
import 'package:cloudflare/cloudflare.dart';
import 'package:cross_file/cross_file.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

import 'base_tests.dart';
import 'utils/matchers.dart';

///
/// Make sure to set these environment variables before running R2 tests
/// (see base_tests.dart for the full list):
///
/// export CLOUDFLARE_ACCOUNT_ID=xxxxxxxxxxxxxxxxxxxxxxxxxxx
/// export CLOUDFLARE_R2_ACCESS_KEY_ID=xxxxxxxxxxxxxxxxxxxxxxxxxxx
/// export CLOUDFLARE_R2_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxx
/// export CLOUDFLARE_R2_BUCKET=my-existing-bucket  (optional)
/// export CLOUDFLARE_PDF_FILE=/path/to/document.pdf
///

// ── Helpers ──────────────────────────────────────────────────────────────────

R2CloudflareAPI? _r2;

R2CloudflareAPI get r2 {
  if (_r2 == null) {
    throw StateError('r2 is not initialised – did initR2() run?');
  }
  return _r2!;
}

void initR2() {
  if (accountId == null) throw Exception("accountId can't be null");
  if (r2AccessKeyId == null) {
    throw Exception("CLOUDFLARE_R2_ACCESS_KEY_ID can't be null");
  }
  if (r2SecretAccessKey == null) {
    throw Exception("CLOUDFLARE_R2_SECRET_ACCESS_KEY can't be null");
  }

  _r2 = R2CloudflareAPI(
    accountId: accountId!,
    credentials: R2Credentials(
      accessKeyId: r2AccessKeyId!,
      secretAccessKey: r2SecretAccessKey!,
    ),
  );
}

/// Returns a timestamp-based unique bucket name safe for testing.
String _tmpBucketName() =>
    'dart-sdk-test-${DateTime.now().millisecondsSinceEpoch}';

// ── Test entry point ──────────────────────────────────────────────────────────

void main() {
  initR2();

  // ── Bucket CRUD tests ─────────────────────────────────────────────────────

  group('Bucket CRUD tests', () {
    late String testBucket;
    bool createdBucket = false;

    setUpAll(() async {
      if (r2ExistingBucket != null) {
        testBucket = r2ExistingBucket!;
      } else {
        testBucket = _tmpBucketName();
        final res = await r2.createBucket(name: testBucket);
        if (!res.isSuccessful) {
          fail('Could not create test bucket "$testBucket": ${res.error}');
        }
        createdBucket = true;
      }
    });

    tearDownAll(() async {
      if (createdBucket) {
        // Ensure bucket is empty before deleting.
        final listRes = await r2.listObjects(bucket: testBucket);
        if (listRes.isSuccessful &&
            (listRes.body?.objects.isNotEmpty ?? false)) {
          final keys = listRes.body!.objects.map((o) => o.key).toList();
          await r2.deleteObjects(bucket: testBucket, keys: keys);
        }
        await r2.deleteBucket(name: testBucket);
      }
    });

    test('Create bucket', () async {
      if (createdBucket) {
        // Already created in setUpAll; just assert it exists.
        final headRes = await r2.headBucket(name: testBucket);
        expect(headRes, ResponseMatcher(), reason: headRes.error?.toString());
        expect(headRes.body, true);
      } else {
        // Create a separate temporary bucket for the create-test only.
        final tmpName = _tmpBucketName();
        final res = await r2.createBucket(name: tmpName);
        expect(res, R2BucketMatcher(), reason: res.error?.toString());
        expect(res.body?.name, tmpName);
        // Clean up immediately.
        await r2.deleteBucket(name: tmpName);
      }
    });

    test('List buckets', () async {
      final res = await r2.listBuckets();
      expect(res, ResponseMatcher(), reason: res.error?.toString());
      expect(res.body, isNotNull);
      expect(res.body, isA<List<R2Bucket>>());
      expect(
        res.body!.any((b) => b.name == testBucket),
        true,
        reason: 'Test bucket "$testBucket" should appear in bucket list',
      );
      print(
        'Buckets (${res.body!.length}): ${res.body!.map((b) => b.name).join(', ')}',
      );
    });

    test('Head bucket – existing bucket returns true', () async {
      final res = await r2.headBucket(name: testBucket);
      expect(res, ResponseMatcher(), reason: res.error?.toString());
      expect(res.body, true);
    });

    test('Head bucket – non-existent bucket returns false', () async {
      final res = await r2.headBucket(name: 'this-bucket-does-not-exist-xyz-9');
      expect(res.isSuccessful, true);
      expect(res.body, false);
    });

    test('Delete bucket', () async {
      // Create a fresh temporary bucket exclusively for the delete test.
      final tmpName = _tmpBucketName();
      final createRes = await r2.createBucket(name: tmpName);
      expect(createRes, R2BucketMatcher(), reason: createRes.error?.toString());

      final deleteRes = await r2.deleteBucket(name: tmpName);
      expect(deleteRes, ResponseMatcher(), reason: deleteRes.error?.toString());
      expect(deleteRes.body, true);

      // Confirm it is gone.
      final headRes = await r2.headBucket(name: tmpName);
      expect(headRes.body, false);
    });
  });

  // ── Object CRUD tests ─────────────────────────────────────────────────────

  group('Object CRUD tests', () {
    late String testBucket;
    bool createdBucket = false;

    const testKey = 'test-object/document.pdf';
    const copyKey = 'test-object/document-copy.pdf';
    const metaKey = 'test-object/metadata.txt';

    setUpAll(() async {
      if (r2ExistingBucket != null) {
        testBucket = r2ExistingBucket!;
      } else {
        testBucket = _tmpBucketName();
        final res = await r2.createBucket(name: testBucket);
        if (!res.isSuccessful) {
          fail('Could not create test bucket "$testBucket": ${res.error}');
        }
        createdBucket = true;
      }
    });

    tearDownAll(() async {
      // Best-effort cleanup of any objects left behind by failed tests.
      try {
        final listRes = await r2.listObjects(
          bucket: testBucket,
          prefix: 'test-object/',
        );
        if (listRes.isSuccessful &&
            (listRes.body?.objects.isNotEmpty ?? false)) {
          final keys = listRes.body!.objects.map((o) => o.key).toList();
          await r2.deleteObjects(bucket: testBucket, keys: keys);
        }
      } catch (_) {}

      if (createdBucket) {
        final listRes = await r2.listObjects(bucket: testBucket);
        if (listRes.isSuccessful &&
            (listRes.body?.objects.isNotEmpty ?? false)) {
          final keys = listRes.body!.objects.map((o) => o.key).toList();
          await r2.deleteObjects(bucket: testBucket, keys: keys);
        }
        await r2.deleteBucket(name: testBucket);
      }
    });

    test('Put object from XFile', () async {
      if (!pdfFile.existsSync()) {
        fail('No PDF file available – set CLOUDFLARE_PDF_FILE');
      }
      final res = await r2.putObject(
        bucket: testBucket,
        key: testKey,
        content: DataTransmit<XFile>(data: pdfFile),
        contentType: 'application/pdf',
      );
      expect(res, R2ObjectMatcher(), reason: res.error?.toString());
      expect(res.body?.key, testKey);
      expect(res.body?.bucket, testBucket);
      print('putObject etag: ${res.body?.etag}');
    }, timeout: Timeout(Duration(minutes: 2)));

    test('Put object with custom content-type and metadata', () async {
      final bytes = Uint8List.fromList('hello r2'.codeUnits);
      final res = await r2.putObject(
        bucket: testBucket,
        key: metaKey,
        content: DataTransmit<XFile>(
          data: XFile.fromData(bytes, mimeType: 'text/plain'),
        ),
        contentType: 'text/plain',
      );
      expect(res, R2ObjectMatcher(), reason: res.error?.toString());
      expect(res.body?.contentType, 'text/plain');
    });

    test('List objects', () async {
      final res = await r2.listObjects(bucket: testBucket);
      expect(res, ResponseMatcher(), reason: res.error?.toString());
      expect(res.body, isNotNull);
      expect(res.body, isA<R2ListObjectsResult>());
      expect(
        res.body!.objects.any((o) => o.key == testKey),
        true,
        reason: 'Uploaded test object should appear in list',
      );
      print('Listed ${res.body!.keyCount} object(s)');
    });

    test('List objects with prefix filter', () async {
      final res = await r2.listObjects(
        bucket: testBucket,
        prefix: 'test-object/',
        maxKeys: 10,
      );
      expect(res, ResponseMatcher(), reason: res.error?.toString());
      expect(res.body, isNotNull);
      for (final obj in res.body!.objects) {
        expect(obj.key, startsWith('test-object/'));
      }
    });

    test('Head object returns metadata', () async {
      final res = await r2.headObject(bucket: testBucket, key: testKey);
      expect(res, R2ObjectMatcher(), reason: res.error?.toString());
      expect(res.body?.key, testKey);
      expect(res.body?.bucket, testBucket);
      expect(res.body?.size, greaterThan(0));
      expect(res.body?.etag, isNotEmpty);
      print('headObject size=${res.body?.size} etag=${res.body?.etag}');
    });

    test(
      'Get object returns bytes matching original file',
      () async {
        if (!pdfFile.existsSync()) {
          fail('No PDF file available – set CLOUDFLARE_PDF_FILE');
        }
        final originalBytes = await pdfFile.readAsBytes();
        final res = await r2.getObject(bucket: testBucket, key: testKey);
        expect(res, ResponseMatcher(), reason: res.error?.toString());
        expect(res.body, isNotNull);
        expect(res.body, isA<Uint8List>());
        expect(
          res.body!.length,
          originalBytes.length,
          reason: 'Downloaded size should match uploaded file size',
        );
      },
      timeout: Timeout(Duration(minutes: 2)),
    );

    test('Get object range returns partial content', () async {
      const start = 0;
      const end = 99; // first 100 bytes
      final res = await r2.getObjectRange(
        bucket: testBucket,
        key: testKey,
        start: start,
        end: end,
      );
      expect(res, ResponseMatcher(), reason: res.error?.toString());
      expect(res.body, isNotNull);
      expect(res.body!.length, lessThanOrEqualTo(end - start + 1));
      print('Range [0–99] returned ${res.body!.length} bytes');
    });

    test('Copy object', () async {
      final res = await r2.copyObject(
        sourceBucket: testBucket,
        sourceKey: testKey,
        destBucket: testBucket,
        destKey: copyKey,
      );
      expect(res, R2ObjectMatcher(), reason: res.error?.toString());
      expect(res.body?.key, copyKey);

      // Verify copy is accessible.
      final headRes = await r2.headObject(bucket: testBucket, key: copyKey);
      expect(headRes, R2ObjectMatcher(), reason: headRes.error?.toString());
    });

    test('Delete single object', () async {
      final res = await r2.deleteObject(bucket: testBucket, key: copyKey);
      expect(res, ResponseMatcher(), reason: res.error?.toString());
      expect(res.body, true);
    });

    test('Delete multiple objects', () async {
      final res = await r2.deleteObjects(
        bucket: testBucket,
        keys: [testKey, metaKey],
      );
      expect(res, ResponseMatcher(), reason: res.error?.toString());
      expect(res.body, isNotNull);
      expect(
        res.body,
        isEmpty,
        reason: 'No failed-key entries expected when all deletions succeed',
      );
    });
  });

  // ── Presigned URL tests ───────────────────────────────────────────────────

  group('Presigned URL tests', () {
    late String testBucket;
    bool createdBucket = false;
    const testKey = 'presign-test/object.txt';
    const unsignedUploadKey = 'presign-test/unsigned-upload.txt';

    setUpAll(() async {
      if (r2ExistingBucket != null) {
        testBucket = r2ExistingBucket!;
      } else {
        testBucket = _tmpBucketName();
        final res = await r2.createBucket(name: testBucket);
        if (!res.isSuccessful) {
          fail('Could not create test bucket: ${res.error}');
        }
        createdBucket = true;
      }
      // Upload a small object to generate presigned GET URLs for.
      await r2.putObject(
        bucket: testBucket,
        key: testKey,
        content: DataTransmit<XFile>(
          data: XFile.fromData(
            Uint8List.fromList('presign payload'.codeUnits),
            mimeType: 'text/plain',
          ),
        ),
        contentType: 'text/plain',
      );
    });

    tearDownAll(() async {
      await r2.deleteObjects(
        bucket: testBucket,
        keys: [testKey, unsignedUploadKey],
      );
      if (createdBucket) await r2.deleteBucket(name: testBucket);
    });

    test('Presigned GET URL contains SigV4 query parameters', () async {
      final signedUrl = await r2.presignedUrl(
        bucket: testBucket,
        key: testKey,
        expiresIn: Duration(hours: 1),
      );
      expect(signedUrl, isA<R2SignedUrl>());
      expect(signedUrl.bucket, testBucket);
      expect(signedUrl.key, testKey);
      expect(signedUrl.type, 'GET');
      expect(signedUrl.isExpired, isFalse);
      final uri = Uri.parse(signedUrl.url);
      expect(uri.queryParameters, contains('X-Amz-Signature'));
      expect(uri.queryParameters, contains('X-Amz-Credential'));
      expect(uri.queryParameters, contains('X-Amz-Expires'));
      expect(uri.path, endsWith(testKey));
      print('Presigned GET URL: ${signedUrl.url}');
      print('Expires at: ${signedUrl.expiresAt}');
    });

    test('Presigned PUT URL is valid', () async {
      final signedUrl = await r2.presignedUrl(
        bucket: testBucket,
        key: 'presign-test/new-object.txt',
        method: AWSHttpMethod.put,
        expiresIn: Duration(minutes: 30),
      );
      expect(signedUrl, isA<R2SignedUrl>());
      expect(signedUrl.bucket, testBucket);
      expect(signedUrl.type, 'PUT');
      expect(signedUrl.isExpired, isFalse);
      final uri = Uri.parse(signedUrl.url);
      expect(uri.queryParameters, contains('X-Amz-Signature'));
      expect(uri.queryParameters['X-Amz-Credential'], isNotEmpty);
    });

    test('Presigned PUT URL allows unsigned client-side upload', () async {
      // Simulate the backend-generates / client-consumes flow:
      //  1. Backend (authenticated) generates a presigned PUT URL.
      //  2. Client (no credentials) uses the URL to upload directly to R2.
      //  3. Verify the object landed correctly via the authenticated API.

      final payload = Uint8List.fromList(
        'unsigned upload via presigned url'.codeUnits,
      );

      // 1 – Backend generates the presigned PUT URL.
      final signedUrl = await r2.presignedUrl(
        bucket: testBucket,
        key: unsignedUploadKey,
        method: AWSHttpMethod.put,
        expiresIn: Duration(minutes: 15),
      );
      expect(signedUrl, isA<R2SignedUrl>());
      expect(signedUrl.bucket, testBucket);
      expect(signedUrl.key, unsignedUploadKey);
      expect(signedUrl.type, 'PUT');
      expect(signedUrl.isExpired, isFalse);
      final presignedUri = Uri.parse(signedUrl.url);
      expect(presignedUri.queryParameters, contains('X-Amz-Signature'));
      print('Presigned PUT URL (unsigned upload): ${signedUrl.url}');
      print('Expires at: ${signedUrl.expiresAt}');

      // 2 – Client uploads using the presigned URL — no auth headers needed.
      final uploadResponse = await http.put(
        presignedUri,
        headers: {'content-type': 'text/plain'},
        body: payload,
      );
      expect(
        uploadResponse.statusCode,
        anyOf(200, 204),
        reason:
            'Presigned PUT upload failed (${uploadResponse.statusCode}): '
            '${uploadResponse.body}',
      );

      // 3 – Verify the object is accessible via the authenticated API.
      final headRes = await r2.headObject(
        bucket: testBucket,
        key: unsignedUploadKey,
      );
      expect(headRes, R2ObjectMatcher(), reason: headRes.error?.toString());
      expect(headRes.body?.key, unsignedUploadKey);
      expect(
        headRes.body?.size,
        payload.length,
        reason: 'Object size should match the uploaded payload',
      );
      print(
        'Unsigned upload verified – size=${headRes.body?.size} '
        'etag=${headRes.body?.etag}',
      );
    });
  });

  // ── Multipart Upload tests ────────────────────────────────────────────────

  group('Multipart upload tests', () {
    late String testBucket;
    bool createdBucket = false;
    const mpKey = 'multipart-test/big-object.bin';

    setUpAll(() async {
      if (r2ExistingBucket != null) {
        testBucket = r2ExistingBucket!;
      } else {
        testBucket = _tmpBucketName();
        final res = await r2.createBucket(name: testBucket);
        if (!res.isSuccessful) {
          fail('Could not create test bucket: ${res.error}');
        }
        createdBucket = true;
      }
    });

    tearDownAll(() async {
      if (createdBucket) {
        try {
          await r2.deleteObject(bucket: testBucket, key: mpKey);
        } catch (_) {}
        await r2.deleteBucket(name: testBucket);
      }
    });

    test(
      'Full multipart lifecycle: create → uploadPart × 2 → complete',
      () async {
        // R2/S3 requires every part except the last to be ≥ 5 MB.
        const partSize = 5 * 1024 * 1024 + 1; // 5 MB + 1 byte

        // 1. Initiate.
        final initRes = await r2.createMultipartUpload(
          bucket: testBucket,
          key: mpKey,
          contentType: 'application/octet-stream',
        );
        expect(initRes, ResponseMatcher(), reason: initRes.error?.toString());
        expect(initRes.body, isNotEmpty);
        final uploadId = initRes.body!;
        print('createMultipartUpload uploadId: $uploadId');

        // 2. Upload parts.
        final part1Data = Uint8List(partSize); // all zeros
        final part2Data = Uint8List(1024); // 1 KB last part

        final part1Res = await r2.uploadPart(
          bucket: testBucket,
          key: mpKey,
          uploadId: uploadId,
          partNumber: 1,
          data: part1Data,
        );
        expect(part1Res, ResponseMatcher(), reason: part1Res.error?.toString());
        expect(part1Res.body, isNotEmpty);

        final part2Res = await r2.uploadPart(
          bucket: testBucket,
          key: mpKey,
          uploadId: uploadId,
          partNumber: 2,
          data: part2Data,
        );
        expect(part2Res, ResponseMatcher(), reason: part2Res.error?.toString());
        expect(part2Res.body, isNotEmpty);

        // 3. Complete.
        final completeRes = await r2.completeMultipartUpload(
          bucket: testBucket,
          key: mpKey,
          uploadId: uploadId,
          parts: {1: part1Res.body!, 2: part2Res.body!},
        );
        expect(
          completeRes,
          R2ObjectMatcher(),
          reason: completeRes.error?.toString(),
        );
        expect(completeRes.body?.key, mpKey);
        expect(completeRes.body?.etag, isNotEmpty);
        print('completeMultipartUpload etag: ${completeRes.body?.etag}');

        // 4. Verify assembled object.
        final headRes = await r2.headObject(bucket: testBucket, key: mpKey);
        expect(headRes, R2ObjectMatcher(), reason: headRes.error?.toString());
        expect(
          headRes.body?.size,
          partSize + 1024,
          reason: 'Assembled object size should equal the sum of all parts',
        );
      },
      timeout: Timeout(Duration(minutes: 5)),
    );

    test('Abort multipart upload', () async {
      const abortKey = 'multipart-test/abort-object.bin';

      final initRes = await r2.createMultipartUpload(
        bucket: testBucket,
        key: abortKey,
      );
      expect(initRes, ResponseMatcher(), reason: initRes.error?.toString());
      expect(initRes.body, isNotEmpty);

      final abortRes = await r2.abortMultipartUpload(
        bucket: testBucket,
        key: abortKey,
        uploadId: initRes.body!,
      );
      expect(abortRes, ResponseMatcher(), reason: abortRes.error?.toString());
      expect(abortRes.body, true);
    });
  });

  // ── Direct upload tests ───────────────────────────────────────────────────

  group('Direct upload tests (credential-free via presigned URLs)', () {
    late String testBucket;
    bool createdBucket = false;
    const directPutKey = 'direct-upload-test/put-object.pdf';
    const directMpKey = 'direct-upload-test/multipart-object.bin';

    setUpAll(() async {
      if (r2ExistingBucket != null) {
        testBucket = r2ExistingBucket!;
      } else {
        testBucket = _tmpBucketName();
        final res = await r2.createBucket(name: testBucket);
        if (!res.isSuccessful) {
          fail('Could not create test bucket: ${res.error}');
        }
        createdBucket = true;
      }
    });

    tearDownAll(() async {
      try {
        await r2.deleteObjects(
          bucket: testBucket,
          keys: [directPutKey, directMpKey],
        );
      } catch (_) {}
      if (createdBucket) await r2.deleteBucket(name: testBucket);
    });

    // ── directPutObject ─────────────────────────────────────────────────────

    test(
      'directPutObject uploads a file via presigned PUT URL without credentials',
      () async {
        if (!pdfFile.existsSync()) {
          fail(
            'No PDF file available – set CLOUDFLARE_PDF_FILE to a local PDF path',
          );
        }

        // 1. Backend (authenticated): generate a presigned PUT URL.
        final signedUrl = await r2.presignedUrl(
          bucket: testBucket,
          key: directPutKey,
          method: AWSHttpMethod.put,
          expiresIn: Duration(minutes: 15),
        );
        expect(signedUrl.type, 'PUT');
        expect(signedUrl.isExpired, isFalse);
        print('directPutObject presigned URL: ${signedUrl.url}');

        // 2. Client (no credentials): upload via R2CloudflareAPI.basic().
        final r2basic = R2CloudflareAPI.basic();
        int lastCount = 0, lastTotal = 0;

        final res = await r2basic.directPutObject(
          urlData: signedUrl,
          content: DataTransmit<XFile>(
            data: pdfFile,
            progressCallback: (count, total) {
              lastCount = count;
              lastTotal = total;
              print('directPutObject progress: $count / $total');
            },
          ),
        );

        expect(res, R2ObjectMatcher(), reason: res.error?.toString());
        expect(res.body?.key, directPutKey);
        expect(
          lastTotal,
          greaterThan(0),
          reason: 'Progress callback must fire',
        );
        expect(
          lastCount,
          lastTotal,
          reason: 'Final progress count must equal total',
        );
        print(
          'directPutObject done – size=${res.body?.size} etag=${res.body?.etag}',
        );

        // 3. Verify via authenticated API.
        final headRes = await r2.headObject(
          bucket: testBucket,
          key: directPutKey,
        );
        expect(headRes, R2ObjectMatcher(), reason: headRes.error?.toString());
        expect(headRes.body?.size, await pdfFile.length());

        r2basic.dispose();
      },
      timeout: Timeout(Duration(minutes: 5)),
    );

    // ── directMultipartUpload ───────────────────────────────────────────────

    test(
      'directMultipartUpload uploads a large file via presigned part URLs without credentials',
      () async {
        // R2/S3 requires every part except the last to be >= 5 MB, so we
        // need a file that is at least 5 MB + 1 byte to exercise two parts.
        // We reuse the PDF file if it is large enough, otherwise synthesise
        // a byte array.
        const minSize = 5 * 1024 * 1024 + 1; // 5 MB + 1 byte

        final XFile testFile;
        if (pdfFile.existsSync() && await pdfFile.length() >= minSize) {
          testFile = pdfFile;
        } else {
          // Synthesise an in-memory file large enough for two parts.
          testFile = XFile.fromData(
            Uint8List(minSize + 1024),
            mimeType: 'application/octet-stream',
            name: 'synthetic-large-file.bin',
          );
        }

        final fileSize = await testFile.length();
        const chunkSize = 5 * 1024 * 1024; // 5 MB
        print(
          'directMultipartUpload: fileSize=$fileSize, chunkSize=$chunkSize',
        );

        // 1. Backend (authenticated): create the multipart draft.
        final draftRes = await r2.createDirectMultipartUpload(
          bucket: testBucket,
          key: directMpKey,
          fileSize: fileSize,
          chunkSize: chunkSize,
          contentType: testFile.mimeType ?? 'application/octet-stream',
          expiresIn: Duration(minutes: 30),
        );
        expect(draftRes, ResponseMatcher(), reason: draftRes.error?.toString());
        final draft = draftRes.body!;
        expect(draft.uploadId, isNotEmpty);
        expect(draft.partUrls, isNotEmpty);
        print(
          'createDirectMultipartUpload: uploadId=${draft.uploadId}, '
          'parts=${draft.partUrls.length}',
        );

        // 2. Client (no credentials): upload via R2CloudflareAPI.basic().
        final r2basic = R2CloudflareAPI.basic();
        int lastCount = 0;

        final res = await r2basic.directMultipartUpload(
          draft: draft,
          content: DataTransmit<XFile>(
            data: testFile,
            progressCallback: (count, total) {
              lastCount = count;
              print('directMultipartUpload progress: $count / $total');
            },
          ),
        );

        expect(res, R2ObjectMatcher(), reason: res.error?.toString());
        expect(res.body?.key, directMpKey);
        expect(res.body?.etag, isNotEmpty);
        expect(
          lastCount,
          greaterThan(0),
          reason: 'Progress callback must fire',
        );
        print('directMultipartUpload done – etag=${res.body?.etag}');

        // 3. Verify via authenticated API.
        final headRes = await r2.headObject(
          bucket: testBucket,
          key: directMpKey,
        );
        expect(headRes, R2ObjectMatcher(), reason: headRes.error?.toString());
        expect(
          headRes.body?.size,
          fileSize,
          reason: 'Assembled object size must match original file',
        );

        r2basic.dispose();
      },
      timeout: Timeout(Duration(minutes: 10)),
    );
  });
}
