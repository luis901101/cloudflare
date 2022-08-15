// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloudflare_stream_video.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CloudflareStreamVideoCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// CloudflareStreamVideo(...).copyWith(id: 12, name: "My name")
  /// ````
  CloudflareStreamVideo call({
    List<String>? allowedOrigins,
    String? animatedThumbnail,
    DateTime? created,
    String? customAccountSubdomainUrl,
    double? duration,
    String? id,
    VideoSize? input,
    String? liveInput,
    int? maxDurationSeconds,
    Map<dynamic, dynamic>? meta,
    DateTime? modified,
    MediaNFT? nft,
    VideoPlaybackInfo? playback,
    String? preview,
    bool? readyToStream,
    bool? requireSignedURLs,
    int? size,
    VideoStatus? status,
    String? thumbnail,
    double? thumbnailTimestampPct,
    DateTime? uploadExpiry,
    DateTime? uploaded,
    Watermark? watermark,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCloudflareStreamVideo.copyWith(...)`.
class _$CloudflareStreamVideoCWProxyImpl
    implements _$CloudflareStreamVideoCWProxy {
  final CloudflareStreamVideo _value;

  const _$CloudflareStreamVideoCWProxyImpl(this._value);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// CloudflareStreamVideo(...).copyWith(id: 12, name: "My name")
  /// ````
  CloudflareStreamVideo call({
    Object? allowedOrigins = const $CopyWithPlaceholder(),
    Object? animatedThumbnail = const $CopyWithPlaceholder(),
    Object? created = const $CopyWithPlaceholder(),
    Object? customAccountSubdomainUrl = const $CopyWithPlaceholder(),
    Object? duration = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? input = const $CopyWithPlaceholder(),
    Object? liveInput = const $CopyWithPlaceholder(),
    Object? maxDurationSeconds = const $CopyWithPlaceholder(),
    Object? meta = const $CopyWithPlaceholder(),
    Object? modified = const $CopyWithPlaceholder(),
    Object? nft = const $CopyWithPlaceholder(),
    Object? playback = const $CopyWithPlaceholder(),
    Object? preview = const $CopyWithPlaceholder(),
    Object? readyToStream = const $CopyWithPlaceholder(),
    Object? requireSignedURLs = const $CopyWithPlaceholder(),
    Object? size = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? thumbnail = const $CopyWithPlaceholder(),
    Object? thumbnailTimestampPct = const $CopyWithPlaceholder(),
    Object? uploadExpiry = const $CopyWithPlaceholder(),
    Object? uploaded = const $CopyWithPlaceholder(),
    Object? watermark = const $CopyWithPlaceholder(),
  }) {
    return CloudflareStreamVideo(
      allowedOrigins: allowedOrigins == const $CopyWithPlaceholder()
          ? _value.allowedOrigins
          // ignore: cast_nullable_to_non_nullable
          : allowedOrigins as List<String>?,
      animatedThumbnail: animatedThumbnail == const $CopyWithPlaceholder()
          ? _value.animatedThumbnail
          // ignore: cast_nullable_to_non_nullable
          : animatedThumbnail as String?,
      created: created == const $CopyWithPlaceholder()
          ? _value.created
          // ignore: cast_nullable_to_non_nullable
          : created as DateTime?,
      duration: duration == const $CopyWithPlaceholder()
          ? _value.duration
          // ignore: cast_nullable_to_non_nullable
          : duration as double?,
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      input: input == const $CopyWithPlaceholder()
          ? _value.input
          // ignore: cast_nullable_to_non_nullable
          : input as VideoSize?,
      liveInput: liveInput == const $CopyWithPlaceholder()
          ? _value.liveInput
          // ignore: cast_nullable_to_non_nullable
          : liveInput as String?,
      maxDurationSeconds: maxDurationSeconds == const $CopyWithPlaceholder()
          ? _value.maxDurationSeconds
          // ignore: cast_nullable_to_non_nullable
          : maxDurationSeconds as int?,
      meta: meta == const $CopyWithPlaceholder()
          ? _value.meta
          // ignore: cast_nullable_to_non_nullable
          : meta as Map<dynamic, dynamic>?,
      modified: modified == const $CopyWithPlaceholder()
          ? _value.modified
          // ignore: cast_nullable_to_non_nullable
          : modified as DateTime?,
      nft: nft == const $CopyWithPlaceholder()
          ? _value.nft
          // ignore: cast_nullable_to_non_nullable
          : nft as MediaNFT?,
      playback: playback == const $CopyWithPlaceholder()
          ? _value.playback
          // ignore: cast_nullable_to_non_nullable
          : playback as VideoPlaybackInfo?,
      preview: preview == const $CopyWithPlaceholder()
          ? _value.preview
          // ignore: cast_nullable_to_non_nullable
          : preview as String?,
      readyToStream: readyToStream == const $CopyWithPlaceholder()
          ? _value.readyToStream
          // ignore: cast_nullable_to_non_nullable
          : readyToStream as bool?,
      requireSignedURLs: requireSignedURLs == const $CopyWithPlaceholder()
          ? _value.requireSignedURLs
          // ignore: cast_nullable_to_non_nullable
          : requireSignedURLs as bool?,
      size: size == const $CopyWithPlaceholder()
          ? _value.size
          // ignore: cast_nullable_to_non_nullable
          : size as int?,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as VideoStatus?,
      thumbnail: thumbnail == const $CopyWithPlaceholder()
          ? _value.thumbnail
          // ignore: cast_nullable_to_non_nullable
          : thumbnail as String?,
      thumbnailTimestampPct:
          thumbnailTimestampPct == const $CopyWithPlaceholder()
              ? _value.thumbnailTimestampPct
              // ignore: cast_nullable_to_non_nullable
              : thumbnailTimestampPct as double?,
      uploadExpiry: uploadExpiry == const $CopyWithPlaceholder()
          ? _value.uploadExpiry
          // ignore: cast_nullable_to_non_nullable
          : uploadExpiry as DateTime?,
      uploaded: uploaded == const $CopyWithPlaceholder()
          ? _value.uploaded
          // ignore: cast_nullable_to_non_nullable
          : uploaded as DateTime?,
      watermark: watermark == const $CopyWithPlaceholder()
          ? _value.watermark
          // ignore: cast_nullable_to_non_nullable
          : watermark as Watermark?,
    );
  }
}

extension $CloudflareStreamVideoCopyWith on CloudflareStreamVideo {
  /// Returns a callable class that can be used as follows: `instanceOfCloudflareStreamVideo.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$CloudflareStreamVideoCWProxy get copyWith =>
      _$CloudflareStreamVideoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CloudflareStreamVideo _$CloudflareStreamVideoFromJson(
        Map<String, dynamic> json) =>
    CloudflareStreamVideo(
      id: json['uid'] as String?,
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
      animatedThumbnail: json['animatedThumbnail'] as String?,
      status: json['status'] == null
          ? null
          : VideoStatus.fromJson(json['status'] as Map<String, dynamic>),
      duration: (json['duration'] as num?)?.toDouble(),
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
    'uid': instance.id,
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
  writeNotNull('maxDurationSeconds', instance.maxDurationSeconds);
  val['created'] = instance.created.toIso8601String();
  val['preview'] = instance.preview;
  val['modified'] = instance.modified.toIso8601String();
  val['input'] = instance.input;
  val['thumbnail'] = instance.thumbnail;
  val['animatedThumbnail'] = instance.animatedThumbnail;
  val['status'] = instance.status;
  val['duration'] = instance.duration;
  writeNotNull('uploadExpiry', instance.uploadExpiry?.toIso8601String());
  val['thumbnailTimestampPct'] = instance.thumbnailTimestampPct;
  writeNotNull('playback', instance.playback);
  writeNotNull('nft', instance.nft);
  val['readyToStream'] = instance.readyToStream;
  writeNotNull('liveInput', instance.liveInput);
  return val;
}
