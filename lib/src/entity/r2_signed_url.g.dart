// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'r2_signed_url.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

/// This Extension on [R2SignedUrl] is to generate the code for a copyWith(...) function.
extension $R2SignedUrlCopyWithExtension on R2SignedUrl {
  R2SignedUrl copyWith({
    String? url,
    String? bucket,
    String? key,
    String? type,
    DateTime? expiresAt,
  }) {
    return R2SignedUrl(
      url: url ?? this.url,
      bucket: bucket ?? this.bucket,
      key: key ?? this.key,
      type: type ?? this.type,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
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
