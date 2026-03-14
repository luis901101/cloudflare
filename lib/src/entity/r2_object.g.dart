// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'r2_object.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$R2ObjectCWProxy {
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// R2Object(...).copyWith(id: 12, name: "My name")
  /// ```
  R2Object call({
    String key,
    String? bucket,
    int? size,
    String? etag,
    DateTime? lastModified,
    String? storageClass,
    String? contentType,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfR2Object.copyWith(...)`.
class _$R2ObjectCWProxyImpl implements _$R2ObjectCWProxy {
  const _$R2ObjectCWProxyImpl(this._value);

  final R2Object _value;

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// R2Object(...).copyWith(id: 12, name: "My name")
  /// ```
  R2Object call({
    Object? key = const $CopyWithPlaceholder(),
    Object? bucket = const $CopyWithPlaceholder(),
    Object? size = const $CopyWithPlaceholder(),
    Object? etag = const $CopyWithPlaceholder(),
    Object? lastModified = const $CopyWithPlaceholder(),
    Object? storageClass = const $CopyWithPlaceholder(),
    Object? contentType = const $CopyWithPlaceholder(),
  }) {
    return R2Object(
      key: key == const $CopyWithPlaceholder() || key == null
          ? _value.key
          // ignore: cast_nullable_to_non_nullable
          : key as String,
      bucket: bucket == const $CopyWithPlaceholder()
          ? _value.bucket
          // ignore: cast_nullable_to_non_nullable
          : bucket as String?,
      size: size == const $CopyWithPlaceholder()
          ? _value.size
          // ignore: cast_nullable_to_non_nullable
          : size as int?,
      etag: etag == const $CopyWithPlaceholder()
          ? _value.etag
          // ignore: cast_nullable_to_non_nullable
          : etag as String?,
      lastModified: lastModified == const $CopyWithPlaceholder()
          ? _value.lastModified
          // ignore: cast_nullable_to_non_nullable
          : lastModified as DateTime?,
      storageClass: storageClass == const $CopyWithPlaceholder()
          ? _value.storageClass
          // ignore: cast_nullable_to_non_nullable
          : storageClass as String?,
      contentType: contentType == const $CopyWithPlaceholder()
          ? _value.contentType
          // ignore: cast_nullable_to_non_nullable
          : contentType as String?,
    );
  }
}

extension $R2ObjectCopyWith on R2Object {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfR2Object.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$R2ObjectCWProxy get copyWith => _$R2ObjectCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

R2Object _$R2ObjectFromJson(Map<String, dynamic> json) => R2Object(
  key: json['key'] as String,
  bucket: json['bucket'] as String?,
  size: (json['size'] as num?)?.toInt(),
  etag: json['etag'] as String?,
  lastModified: json['lastModified'] == null
      ? null
      : DateTime.parse(json['lastModified'] as String),
  storageClass: json['storageClass'] as String?,
  contentType: json['contentType'] as String?,
);

Map<String, dynamic> _$R2ObjectToJson(R2Object instance) => <String, dynamic>{
  'key': instance.key,
  'bucket': ?instance.bucket,
  'size': ?instance.size,
  'etag': ?instance.etag,
  'lastModified': ?instance.lastModified?.toIso8601String(),
  'storageClass': ?instance.storageClass,
  'contentType': ?instance.contentType,
};
