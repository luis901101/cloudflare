// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloudflare_image.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CloudflareImageCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// CloudflareImage(...).copyWith(id: 12, name: "My name")
  /// ````
  CloudflareImage call({
    bool? draft,
    String? filename,
    String? id,
    String? imageDeliveryId,
    Map<dynamic, dynamic>? meta,
    bool? requireSignedURLs,
    DateTime? uploaded,
    List<String>? variants,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCloudflareImage.copyWith(...)`.
class _$CloudflareImageCWProxyImpl implements _$CloudflareImageCWProxy {
  final CloudflareImage _value;

  const _$CloudflareImageCWProxyImpl(this._value);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// CloudflareImage(...).copyWith(id: 12, name: "My name")
  /// ````
  CloudflareImage call({
    Object? draft = const $CopyWithPlaceholder(),
    Object? filename = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? imageDeliveryId = const $CopyWithPlaceholder(),
    Object? meta = const $CopyWithPlaceholder(),
    Object? requireSignedURLs = const $CopyWithPlaceholder(),
    Object? uploaded = const $CopyWithPlaceholder(),
    Object? variants = const $CopyWithPlaceholder(),
  }) {
    return CloudflareImage(
      draft: draft == const $CopyWithPlaceholder()
          ? _value.draft
          // ignore: cast_nullable_to_non_nullable
          : draft as bool?,
      filename: filename == const $CopyWithPlaceholder()
          ? _value.filename
          // ignore: cast_nullable_to_non_nullable
          : filename as String?,
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      imageDeliveryId: imageDeliveryId == const $CopyWithPlaceholder()
          ? _value.imageDeliveryId
          // ignore: cast_nullable_to_non_nullable
          : imageDeliveryId as String?,
      meta: meta == const $CopyWithPlaceholder()
          ? _value.meta
          // ignore: cast_nullable_to_non_nullable
          : meta as Map<dynamic, dynamic>?,
      requireSignedURLs: requireSignedURLs == const $CopyWithPlaceholder()
          ? _value.requireSignedURLs
          // ignore: cast_nullable_to_non_nullable
          : requireSignedURLs as bool?,
      uploaded: uploaded == const $CopyWithPlaceholder()
          ? _value.uploaded
          // ignore: cast_nullable_to_non_nullable
          : uploaded as DateTime?,
      variants: variants == const $CopyWithPlaceholder()
          ? _value.variants
          // ignore: cast_nullable_to_non_nullable
          : variants as List<String>?,
    );
  }
}

extension $CloudflareImageCopyWith on CloudflareImage {
  /// Returns a callable class that can be used as follows: `instanceOfclass CloudflareImage extends Jsonable<CloudflareImage>.name.copyWith(...)`.
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
          JsonUtils.stringToMapReadValue(json, 'meta') as Map<String, dynamic>?,
      requireSignedURLs: json['requireSignedURLs'] as bool?,
      variants: (json['variants'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      uploaded: json['uploaded'] == null
          ? null
          : DateTime.parse(json['uploaded'] as String),
      draft: json['draft'] as bool?,
    );

Map<String, dynamic> _$CloudflareImageToJson(CloudflareImage instance) {
  final val = <String, dynamic>{
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('imageDeliveryId', instance.imageDeliveryId);
  writeNotNull('filename', instance.filename);
  writeNotNull('meta', instance.meta);
  val['requireSignedURLs'] = instance.requireSignedURLs;
  val['variants'] = instance.variants;
  val['uploaded'] = instance.uploaded.toIso8601String();
  val['draft'] = instance.draft;
  return val;
}
