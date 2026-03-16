// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'r2_signed_url.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$R2SignedUrlCWProxy {
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// R2SignedUrl(...).copyWith(id: 12, name: "My name")
  /// ```
  R2SignedUrl call({
    String url,
    String bucket,
    String key,
    String type,
    DateTime expiresAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfR2SignedUrl.copyWith(...)`.
class _$R2SignedUrlCWProxyImpl implements _$R2SignedUrlCWProxy {
  const _$R2SignedUrlCWProxyImpl(this._value);

  final R2SignedUrl _value;

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// R2SignedUrl(...).copyWith(id: 12, name: "My name")
  /// ```
  R2SignedUrl call({
    Object? url = const $CopyWithPlaceholder(),
    Object? bucket = const $CopyWithPlaceholder(),
    Object? key = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? expiresAt = const $CopyWithPlaceholder(),
  }) {
    return R2SignedUrl(
      url: url == const $CopyWithPlaceholder() || url == null
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String,
      bucket: bucket == const $CopyWithPlaceholder() || bucket == null
          ? _value.bucket
          // ignore: cast_nullable_to_non_nullable
          : bucket as String,
      key: key == const $CopyWithPlaceholder() || key == null
          ? _value.key
          // ignore: cast_nullable_to_non_nullable
          : key as String,
      type: type == const $CopyWithPlaceholder() || type == null
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String,
      expiresAt: expiresAt == const $CopyWithPlaceholder() || expiresAt == null
          ? _value.expiresAt
          // ignore: cast_nullable_to_non_nullable
          : expiresAt as DateTime,
    );
  }
}

extension $R2SignedUrlCopyWith on R2SignedUrl {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfR2SignedUrl.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$R2SignedUrlCWProxy get copyWith => _$R2SignedUrlCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

R2SignedUrl _$R2SignedUrlFromJson(Map<String, dynamic> json) => R2SignedUrl(
  url: json['url'] as String,
  bucket: json['bucket'] as String,
  key: json['key'] as String,
  type: json['type'] as String,
  expiresAt: DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$R2SignedUrlToJson(R2SignedUrl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'bucket': instance.bucket,
      'key': instance.key,
      'type': instance.type,
      'expiresAt': instance.expiresAt.toIso8601String(),
    };
