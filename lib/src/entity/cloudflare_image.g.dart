// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloudflare_image.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

/// This Extension on [CloudflareImage] is to generate the code for a copyWith(...) function.
extension $CloudflareImageCopyWithExtension on CloudflareImage {
  CloudflareImage copyWith({
    String? id,
    String? imageDeliveryId,
    String? filename,
    Map<dynamic, dynamic>? meta,
    bool? requireSignedURLs,
    List<String>? variants,
    DateTime? uploaded,
    bool? draft,
  }) {
    return CloudflareImage(
      id: id ?? this.id,
      imageDeliveryId: imageDeliveryId ?? this.imageDeliveryId,
      filename: filename ?? this.filename,
      meta: ((meta?.isNotEmpty ?? false) ? meta : null) ?? this.meta,
      requireSignedURLs: requireSignedURLs ?? this.requireSignedURLs,
      variants:
          ((variants?.isNotEmpty ?? false) ? variants : null) ?? this.variants,
      uploaded: uploaded ?? this.uploaded,
      draft: draft ?? this.draft,
    );
  }
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
