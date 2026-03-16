import 'package:cloudflare/src/entity/r2_signed_url.dart';
import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'r2_multipart_draft.g.dart';

/// A server-generated multipart upload session handed to an unauthenticated
/// client so it can perform a chunked, resumable upload to R2 without
/// possessing any Cloudflare credentials.
///
/// ### Server-side (authenticated)
/// ```dart
/// final res = await r2.createDirectMultipartUpload(
///   'my-bucket', 'uploads/video.mp4',
///   fileSize: await videoFile.length(),
/// );
/// final draft = res.body!;
/// // Serialise draft and send to the client (e.g. via your REST API).
/// ```
///
/// ### Client-side (credential-free)
/// ```dart
/// final r2basic = R2CloudflareAPI.basic();
/// final res = await r2basic.directMultipartUpload(
///   draft,
///   DataTransmit<XFile>(
///     data: videoFile,
///     progressCallback: (count, total) => print('$count / $total'),
///   ),
/// );
/// if (res.isSuccessful) print('Uploaded: ${res.body?.key}');
/// ```
///
/// ### Fields
/// | Field | Description |
/// |---|---|
/// | [uploadId] | S3 multipart upload session ID. |
/// | [bucket] | The R2 bucket the object will be stored in. |
/// | [key] | The object key within [bucket]. |
/// | [partUrls] | Presigned PUT URLs — one per chunk, in upload order. Index 0 → `partNumber=1`. |
/// | [completeUrl] | Presigned POST URL to finalise the upload; the client POSTs the completion XML body here — no credentials required. |
@CopyWith()
@JsonSerializable()
class R2MultipartDraft extends Jsonable<R2MultipartDraft> {
  /// S3 multipart upload session ID returned by `CreateMultipartUpload`.
  final String uploadId;

  /// The R2 bucket the object will be stored in.
  final String bucket;

  /// The object key within [bucket] (analogous to a file path).
  final String key;

  /// Presigned PUT URLs for each chunk, **in upload order**.
  ///
  /// `partUrls[0]` corresponds to `partNumber=1`, `partUrls[1]` to
  /// `partNumber=2`, and so on.  The number of URLs determines how the file
  /// will be split — [R2CloudflareAPI.directMultipartUpload] divides the file
  /// into exactly `partUrls.length` equal-sized chunks (the last may be
  /// smaller).
  final List<R2SignedUrl> partUrls;

  /// Presigned POST URL to complete the multipart upload.
  ///
  /// The client POSTs the `<CompleteMultipartUpload>` XML body (built from the
  /// ETags returned by each part response) to this URL after all parts are
  /// uploaded — no Cloudflare credentials are needed.
  final R2SignedUrl completeUrl;

  /// Byte size of each chunk used when the presigned part URLs were generated.
  ///
  /// [R2CloudflareAPI.directMultipartUpload] uses this value to split the file
  /// into the exact same byte ranges the server signed.  The last chunk may be
  /// smaller than [chunkSize].
  final int chunkSize;

  const R2MultipartDraft({
    required this.uploadId,
    required this.bucket,
    required this.key,
    required this.partUrls,
    required this.completeUrl,
    required this.chunkSize,
  });

  factory R2MultipartDraft.fromJson(Map<String, dynamic> json) =>
      _$R2MultipartDraftFromJson(json);

  @override
  R2MultipartDraft? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? R2MultipartDraft.fromJson(json) : null;

  @override
  Map<String, dynamic> toJson() => _$R2MultipartDraftToJson(this);
}
