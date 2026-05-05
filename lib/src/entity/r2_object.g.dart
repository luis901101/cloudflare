// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'r2_object.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

/// This Extension on [R2Object] is to generate the code for a copyWith(...) function.
extension $R2ObjectCopyWithExtension on R2Object {
  R2Object copyWith({
    String? key,
    String? bucket,
    int? size,
    String? etag,
    DateTime? lastModified,
    String? storageClass,
    String? contentType,
  }) {
    return R2Object(
      key: key ?? this.key,
      bucket: bucket ?? this.bucket,
      size: size ?? this.size,
      etag: etag ?? this.etag,
      lastModified: lastModified ?? this.lastModified,
      storageClass: storageClass ?? this.storageClass,
      contentType: contentType ?? this.contentType,
    );
  }
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
