// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'r2_bucket.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$R2BucketCWProxy {
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// R2Bucket(...).copyWith(id: 12, name: "My name")
  /// ```
  R2Bucket call({String name, DateTime? creationDate});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfR2Bucket.copyWith(...)`.
class _$R2BucketCWProxyImpl implements _$R2BucketCWProxy {
  const _$R2BucketCWProxyImpl(this._value);

  final R2Bucket _value;

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// R2Bucket(...).copyWith(id: 12, name: "My name")
  /// ```
  R2Bucket call({
    Object? name = const $CopyWithPlaceholder(),
    Object? creationDate = const $CopyWithPlaceholder(),
  }) {
    return R2Bucket(
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      creationDate: creationDate == const $CopyWithPlaceholder()
          ? _value.creationDate
          // ignore: cast_nullable_to_non_nullable
          : creationDate as DateTime?,
    );
  }
}

extension $R2BucketCopyWith on R2Bucket {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfR2Bucket.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$R2BucketCWProxy get copyWith => _$R2BucketCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

R2Bucket _$R2BucketFromJson(Map<String, dynamic> json) => R2Bucket(
  name: json['name'] as String,
  creationDate: json['creationDate'] == null
      ? null
      : DateTime.parse(json['creationDate'] as String),
);

Map<String, dynamic> _$R2BucketToJson(R2Bucket instance) => <String, dynamic>{
  'name': instance.name,
  'creationDate': ?instance.creationDate?.toIso8601String(),
};
