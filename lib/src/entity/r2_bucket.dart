import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'r2_bucket.g.dart';

/// Represents a Cloudflare R2 storage bucket.
///
/// R2 buckets are top-level containers for objects (files). Each bucket
/// must have a name that is unique within the Cloudflare account.
///
/// API docs: https://developers.cloudflare.com/r2/api/s3/api/
@CopyWith()
@JsonSerializable()
class R2Bucket extends Jsonable<R2Bucket> {
  /// The bucket name (3–63 characters, lowercase alphanumeric and hyphens).
  final String name;

  /// When the bucket was created (UTC).
  final DateTime? creationDate;

  const R2Bucket({required this.name, this.creationDate});

  factory R2Bucket.fromJson(Map<String, dynamic> json) =>
      _$R2BucketFromJson(json);

  @override
  R2Bucket? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? R2Bucket.fromJson(json) : null;

  @override
  Map<String, dynamic> toJson() => _$R2BucketToJson(this);
}
