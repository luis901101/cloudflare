// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloudflare_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CloudflareImage _$CloudflareImageFromJson(Map<String, dynamic> json) =>
    CloudflareImage(
      id: json['id'] as String?,
      filename: json['filename'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      requireSignedURLs: json['requireSignedURLs'] as bool?,
      variants: (json['variants'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      uploaded: json['uploaded'] == null
          ? null
          : DateTime.parse(json['uploaded'] as String),
    );

Map<String, dynamic> _$CloudflareImageToJson(CloudflareImage instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'filename': instance.filename,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('metadata', instance.metadata);
  val['requireSignedURLs'] = instance.requireSignedURLs;
  val['variants'] = instance.variants;
  val['uploaded'] = instance.uploaded.toIso8601String();
  return val;
}
