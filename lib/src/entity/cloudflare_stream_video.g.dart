// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloudflare_stream_video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CloudflareStreamVideo _$CloudflareStreamVideoFromJson(
        Map<String, dynamic> json) =>
    CloudflareStreamVideo(
      uploaded: json['uploaded'] == null
          ? null
          : DateTime.parse(json['uploaded'] as String),
      size: json['size'] as int?,
      watermark: json['watermark'] == null
          ? null
          : Watermark.fromJson(json['watermark'] as Map<String, dynamic>),
      requireSignedURLs: json['requireSignedURLs'] as bool?,
      meta: json['meta'] as Map<String, dynamic>?,
      allowedOrigins: (json['allowedOrigins'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      maxDurationSeconds: json['maxDurationSeconds'] as int?,
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
      id: json['uid'] as String?,
      status: json['status'] == null
          ? null
          : VideoStatus.fromJson(json['status'] as Map<String, dynamic>),
      duration: json['duration'] as int?,
      uploadExpiry: json['uploadExpiry'] == null
          ? null
          : DateTime.parse(json['uploadExpiry'] as String),
      thumbnailTimestampPct:
          (json['thumbnailTimestampPct'] as num?)?.toDouble(),
      playback: json['playback'] == null
          ? null
          : VideoPlaybackInfo.fromJson(
              json['playback'] as Map<String, dynamic>),
      nft: json['nft'] == null
          ? null
          : MediaNFT.fromJson(json['nft'] as Map<String, dynamic>),
      readyToStream: json['readyToStream'] as bool?,
      liveInput: json['liveInput'] as String?,
    );

Map<String, dynamic> _$CloudflareStreamVideoToJson(
    CloudflareStreamVideo instance) {
  final val = <String, dynamic>{
    'uploaded': instance.uploaded.toIso8601String(),
    'size': instance.size,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('watermark', instance.watermark);
  val['requireSignedURLs'] = instance.requireSignedURLs;
  writeNotNull('meta', instance.meta);
  val['allowedOrigins'] = instance.allowedOrigins;
  val['maxDurationSeconds'] = instance.maxDurationSeconds;
  val['created'] = instance.created.toIso8601String();
  val['preview'] = instance.preview;
  val['modified'] = instance.modified.toIso8601String();
  val['input'] = instance.input;
  val['thumbnail'] = instance.thumbnail;
  val['uid'] = instance.id;
  val['status'] = instance.status;
  val['duration'] = instance.duration;
  val['uploadExpiry'] = instance.uploadExpiry.toIso8601String();
  val['thumbnailTimestampPct'] = instance.thumbnailTimestampPct;
  writeNotNull('playback', instance.playback);
  writeNotNull('nft', instance.nft);
  val['readyToStream'] = instance.readyToStream;
  writeNotNull('liveInput', instance.liveInput);
  return val;
}
