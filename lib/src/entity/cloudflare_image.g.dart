// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloudflare_image.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CloudflareImageCWProxy {
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// CloudflareImage(...).copyWith(id: 12, name: "My name")
  /// ```
  CloudflareImage call({
    String? id,
    String? imageDeliveryId,
    String? filename,
    Map<dynamic, dynamic>? meta,
    bool? requireSignedURLs,
    List<String>? variants,
    DateTime? uploaded,
    bool? draft,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfCloudflareImage.copyWith(...)`.
class _$CloudflareImageCWProxyImpl implements _$CloudflareImageCWProxy {
  const _$CloudflareImageCWProxyImpl(this._value);

  final CloudflareImage _value;

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// CloudflareImage(...).copyWith(id: 12, name: "My name")
  /// ```
  CloudflareImage call({
    Object? id = const $CopyWithPlaceholder(),
    Object? imageDeliveryId = const $CopyWithPlaceholder(),
    Object? filename = const $CopyWithPlaceholder(),
    Object? meta = const $CopyWithPlaceholder(),
    Object? requireSignedURLs = const $CopyWithPlaceholder(),
    Object? variants = const $CopyWithPlaceholder(),
    Object? uploaded = const $CopyWithPlaceholder(),
    Object? draft = const $CopyWithPlaceholder(),
  }) {
    return CloudflareImage(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      imageDeliveryId: imageDeliveryId == const $CopyWithPlaceholder()
          ? _value.imageDeliveryId
          // ignore: cast_nullable_to_non_nullable
          : imageDeliveryId as String?,
      filename: filename == const $CopyWithPlaceholder()
          ? _value.filename
          // ignore: cast_nullable_to_non_nullable
          : filename as String?,
      meta: meta == const $CopyWithPlaceholder()
          ? _value.meta
          // ignore: cast_nullable_to_non_nullable
          : meta as Map<dynamic, dynamic>?,
      requireSignedURLs: requireSignedURLs == const $CopyWithPlaceholder()
          ? _value.requireSignedURLs
          // ignore: cast_nullable_to_non_nullable
          : requireSignedURLs as bool?,
      variants: variants == const $CopyWithPlaceholder()
          ? _value.variants
          // ignore: cast_nullable_to_non_nullable
          : variants as List<String>?,
      uploaded: uploaded == const $CopyWithPlaceholder()
          ? _value.uploaded
          // ignore: cast_nullable_to_non_nullable
          : uploaded as DateTime?,
      draft: draft == const $CopyWithPlaceholder()
          ? _value.draft
          // ignore: cast_nullable_to_non_nullable
          : draft as bool?,
    );
  }
}

extension $CloudflareImageCopyWith on CloudflareImage {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfCloudflareImage.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$CloudflareImageCWProxy get copyWith => _$CloudflareImageCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CloudflareImage _$CloudflareImageFromJson(Map<String, dynamic> json) =>
    CloudflareImage(
      id: json['id'] as String?,
      imageDeliveryId: json['imageDeliveryId'] as String?,
      filename: json['filename'] as String?,
      meta:
          Jsonable.stringToMapReadValue(json, 'meta') as Map<String, dynamic>?,
      requireSignedURLs: json['requireSignedURLs'] as bool?,
      variants: (json['variants'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      uploaded: json['uploaded'] == null
          ? null
          : DateTime.parse(json['uploaded'] as String),
      draft: json['draft'] as bool?,
    );

Map<String, dynamic> _$CloudflareImageToJson(CloudflareImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageDeliveryId': ?instance.imageDeliveryId,
      'filename': ?instance.filename,
      'meta': ?instance.meta,
      'requireSignedURLs': instance.requireSignedURLs,
      'variants': instance.variants,
      'uploaded': instance.uploaded.toIso8601String(),
      'draft': instance.draft,
    };
