// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloudflare_stream_video.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

/// This Extension on [CloudflareStreamVideo] is to generate the code for a copyWith(...) function.
extension $CloudflareStreamVideoCopyWithExtension on CloudflareStreamVideo {
  CloudflareStreamVideo copyWith({
    String? id,
    DateTime? uploaded,
    int? size,
    Watermark? watermark,
    bool? requireSignedURLs,
    Map<dynamic, dynamic>? meta,
    List<String>? allowedOrigins,
    int? maxDurationSeconds,
    DateTime? created,
    String? preview,
    DateTime? modified,
    VideoSize? input,
    String? thumbnail,
    String? animatedThumbnail,
    VideoStatus? status,
    double? duration,
    DateTime? uploadExpiry,
    double? thumbnailTimestampPct,
    VideoPlaybackInfo? playback,
    MediaNFT? nft,
    bool? readyToStream,
    String? liveInput,
    String? customAccountSubdomainUrl,
  }) {
    return CloudflareStreamVideo(
      id: id ?? this.id,
      uploaded: uploaded ?? this.uploaded,
      size: size ?? this.size,
      watermark: watermark ?? this.watermark,
      requireSignedURLs: requireSignedURLs ?? this.requireSignedURLs,
      meta: ((meta?.isNotEmpty ?? false) ? meta : null) ?? this.meta,
      allowedOrigins:
          ((allowedOrigins?.isNotEmpty ?? false) ? allowedOrigins : null) ??
          this.allowedOrigins,
      maxDurationSeconds: maxDurationSeconds ?? this.maxDurationSeconds,
      created: created ?? this.created,
      preview: preview ?? this.preview,
      modified: modified ?? this.modified,
      input: input ?? this.input,
      thumbnail: thumbnail ?? this.thumbnail,
      animatedThumbnail: animatedThumbnail ?? this.animatedThumbnail,
      status: status ?? this.status,
      duration: duration ?? this.duration,
      uploadExpiry: uploadExpiry ?? this.uploadExpiry,
      thumbnailTimestampPct:
          thumbnailTimestampPct ?? this.thumbnailTimestampPct,
      playback: playback ?? this.playback,
      nft: nft ?? this.nft,
      readyToStream: readyToStream ?? this.readyToStream,
      liveInput: liveInput ?? this.liveInput,
      customAccountSubdomainUrl:
          customAccountSubdomainUrl ?? this.customAccountSubdomainUrl,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CloudflareStreamVideo _$CloudflareStreamVideoFromJson(
  Map<String, dynamic> json,
) => CloudflareStreamVideo(
  id: json['uid'] as String?,
  uploaded: json['uploaded'] == null
      ? null
      : DateTime.parse(json['uploaded'] as String),
  size: (json['size'] as num?)?.toInt(),
  watermark: json['watermark'] == null
      ? null
      : Watermark.fromJson(json['watermark'] as Map<String, dynamic>),
  requireSignedURLs: json['requireSignedURLs'] as bool?,
  meta: json['meta'] as Map<String, dynamic>?,
  allowedOrigins: (json['allowedOrigins'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  maxDurationSeconds: (json['maxDurationSeconds'] as num?)?.toInt(),
  created: json['created'] == null
      ? null
      : DateTime.parse(json['created'] as String),
  preview: json['preview'] as String?,
  modified: json['modified'] == null
      ? null
      : DateTime.parse(json['modified'] as String),
  input: json['input'] == null
      ? null
      : VideoSize.fromJson(json['input'] as Map<String, dynamic>),
  thumbnail: json['thumbnail'] as String?,
  animatedThumbnail: json['animatedThumbnail'] as String?,
  status: json['status'] == null
      ? null
      : VideoStatus.fromJson(json['status'] as Map<String, dynamic>),
  duration: (json['duration'] as num?)?.toDouble(),
  uploadExpiry: json['uploadExpiry'] == null
      ? null
      : DateTime.parse(json['uploadExpiry'] as String),
  thumbnailTimestampPct: (json['thumbnailTimestampPct'] as num?)?.toDouble(),
  playback: json['playback'] == null
      ? null
      : VideoPlaybackInfo.fromJson(json['playback'] as Map<String, dynamic>),
  nft: json['nft'] == null
      ? null
      : MediaNFT.fromJson(json['nft'] as Map<String, dynamic>),
  readyToStream: json['readyToStream'] as bool?,
  liveInput: json['liveInput'] as String?,
  customAccountSubdomainUrl: json['customAccountSubdomainUrl'] as String?,
);

Map<String, dynamic> _$CloudflareStreamVideoToJson(
  CloudflareStreamVideo instance,
) => <String, dynamic>{
  'uid': instance.id,
  'uploaded': instance.uploaded.toIso8601String(),
  'size': instance.size,
  'watermark': ?instance.watermark,
  'requireSignedURLs': instance.requireSignedURLs,
  'meta': ?instance.meta,
  'allowedOrigins': instance.allowedOrigins,
  'maxDurationSeconds': ?instance.maxDurationSeconds,
  'created': instance.created.toIso8601String(),
  'preview': instance.preview,
  'modified': instance.modified.toIso8601String(),
  'input': instance.input,
  'thumbnail': instance.thumbnail,
  'animatedThumbnail': instance.animatedThumbnail,
  'status': instance.status,
  'duration': instance.duration,
  'uploadExpiry': ?instance.uploadExpiry?.toIso8601String(),
  'thumbnailTimestampPct': instance.thumbnailTimestampPct,
  'playback': ?instance.playback,
  'nft': ?instance.nft,
  'readyToStream': instance.readyToStream,
  'liveInput': ?instance.liveInput,
  'customAccountSubdomainUrl': ?instance.customAccountSubdomainUrl,
};
