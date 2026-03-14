import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'r2_object.g.dart';

/// Represents an object (file) stored in a Cloudflare R2 bucket.
///
/// An R2 object is identified by its [key] (analogous to a file path) within
/// a [bucket].
///
/// API docs: https://developers.cloudflare.com/r2/api/s3/api/
@CopyWith()
@JsonSerializable()
class R2Object extends Jsonable<R2Object> {
  /// The object key (analogous to a file path within the bucket).
  final String key;

  /// The bucket this object belongs to.
  final String? bucket;

  /// Object size in bytes.
  final int? size;

  /// HTTP ETag of the object (without surrounding quotes).
  final String? etag;

  /// Time the object was last modified (UTC).
  final DateTime? lastModified;

  /// S3 storage class (R2 always uses STANDARD).
  final String? storageClass;

  /// MIME content type of the object (e.g. `image/jpeg`).
  final String? contentType;

  const R2Object({
    required this.key,
    this.bucket,
    this.size,
    this.etag,
    this.lastModified,
    this.storageClass,
    this.contentType,
  });

  factory R2Object.fromJson(Map<String, dynamic> json) =>
      _$R2ObjectFromJson(json);

  @override
  R2Object? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? R2Object.fromJson(json) : null;

  @override
  Map<String, dynamic> toJson() => _$R2ObjectToJson(this);
}
