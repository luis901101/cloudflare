// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloudflare_stream_video.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CloudflareStreamVideoCWProxy {
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// CloudflareStreamVideo(...).copyWith(id: 12, name: "My name")
  /// ```
  CloudflareStreamVideo call({
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
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfCloudflareStreamVideo.copyWith(...)`.
class _$CloudflareStreamVideoCWProxyImpl
    implements _$CloudflareStreamVideoCWProxy {
  const _$CloudflareStreamVideoCWProxyImpl(this._value);

  final CloudflareStreamVideo _value;

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// CloudflareStreamVideo(...).copyWith(id: 12, name: "My name")
  /// ```
  CloudflareStreamVideo call({
    Object? id = const $CopyWithPlaceholder(),
    Object? uploaded = const $CopyWithPlaceholder(),
    Object? size = const $CopyWithPlaceholder(),
    Object? watermark = const $CopyWithPlaceholder(),
    Object? requireSignedURLs = const $CopyWithPlaceholder(),
    Object? meta = const $CopyWithPlaceholder(),
    Object? allowedOrigins = const $CopyWithPlaceholder(),
    Object? maxDurationSeconds = const $CopyWithPlaceholder(),
    Object? created = const $CopyWithPlaceholder(),
    Object? preview = const $CopyWithPlaceholder(),
    Object? modified = const $CopyWithPlaceholder(),
    Object? input = const $CopyWithPlaceholder(),
    Object? thumbnail = const $CopyWithPlaceholder(),
    Object? animatedThumbnail = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? duration = const $CopyWithPlaceholder(),
    Object? uploadExpiry = const $CopyWithPlaceholder(),
    Object? thumbnailTimestampPct = const $CopyWithPlaceholder(),
    Object? playback = const $CopyWithPlaceholder(),
    Object? nft = const $CopyWithPlaceholder(),
    Object? readyToStream = const $CopyWithPlaceholder(),
    Object? liveInput = const $CopyWithPlaceholder(),
    Object? customAccountSubdomainUrl = const $CopyWithPlaceholder(),
  }) {
    return CloudflareStreamVideo(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      uploaded: uploaded == const $CopyWithPlaceholder()
          ? _value.uploaded
          // ignore: cast_nullable_to_non_nullable
          : uploaded as DateTime?,
      size: size == const $CopyWithPlaceholder()
          ? _value.size
          // ignore: cast_nullable_to_non_nullable
          : size as int?,
      watermark: watermark == const $CopyWithPlaceholder()
          ? _value.watermark
          // ignore: cast_nullable_to_non_nullable
          : watermark as Watermark?,
      requireSignedURLs: requireSignedURLs == const $CopyWithPlaceholder()
          ? _value.requireSignedURLs
          // ignore: cast_nullable_to_non_nullable
          : requireSignedURLs as bool?,
      meta: meta == const $CopyWithPlaceholder()
          ? _value.meta
          // ignore: cast_nullable_to_non_nullable
          : meta as Map<dynamic, dynamic>?,
      allowedOrigins: allowedOrigins == const $CopyWithPlaceholder()
          ? _value.allowedOrigins
          // ignore: cast_nullable_to_non_nullable
          : allowedOrigins as List<String>?,
      maxDurationSeconds: maxDurationSeconds == const $CopyWithPlaceholder()
          ? _value.maxDurationSeconds
          // ignore: cast_nullable_to_non_nullable
          : maxDurationSeconds as int?,
      created: created == const $CopyWithPlaceholder()
          ? _value.created
          // ignore: cast_nullable_to_non_nullable
          : created as DateTime?,
      preview: preview == const $CopyWithPlaceholder()
          ? _value.preview
          // ignore: cast_nullable_to_non_nullable
          : preview as String?,
      modified: modified == const $CopyWithPlaceholder()
          ? _value.modified
          // ignore: cast_nullable_to_non_nullable
          : modified as DateTime?,
      input: input == const $CopyWithPlaceholder()
          ? _value.input
          // ignore: cast_nullable_to_non_nullable
          : input as VideoSize?,
      thumbnail: thumbnail == const $CopyWithPlaceholder()
          ? _value.thumbnail
          // ignore: cast_nullable_to_non_nullable
          : thumbnail as String?,
      animatedThumbnail: animatedThumbnail == const $CopyWithPlaceholder()
          ? _value.animatedThumbnail
          // ignore: cast_nullable_to_non_nullable
          : animatedThumbnail as String?,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as VideoStatus?,
      duration: duration == const $CopyWithPlaceholder()
          ? _value.duration
          // ignore: cast_nullable_to_non_nullable
          : duration as double?,
      uploadExpiry: uploadExpiry == const $CopyWithPlaceholder()
          ? _value.uploadExpiry
          // ignore: cast_nullable_to_non_nullable
          : uploadExpiry as DateTime?,
      thumbnailTimestampPct:
          thumbnailTimestampPct == const $CopyWithPlaceholder()
          ? _value.thumbnailTimestampPct
          // ignore: cast_nullable_to_non_nullable
          : thumbnailTimestampPct as double?,
      playback: playback == const $CopyWithPlaceholder()
          ? _value.playback
          // ignore: cast_nullable_to_non_nullable
          : playback as VideoPlaybackInfo?,
      nft: nft == const $CopyWithPlaceholder()
          ? _value.nft
          // ignore: cast_nullable_to_non_nullable
          : nft as MediaNFT?,
      readyToStream: readyToStream == const $CopyWithPlaceholder()
          ? _value.readyToStream
          // ignore: cast_nullable_to_non_nullable
          : readyToStream as bool?,
      liveInput: liveInput == const $CopyWithPlaceholder()
          ? _value.liveInput
          // ignore: cast_nullable_to_non_nullable
          : liveInput as String?,
      customAccountSubdomainUrl:
          customAccountSubdomainUrl == const $CopyWithPlaceholder()
          ? _value.customAccountSubdomainUrl
          // ignore: cast_nullable_to_non_nullable
          : customAccountSubdomainUrl as String?,
    );
  }
}

extension $CloudflareStreamVideoCopyWith on CloudflareStreamVideo {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfCloudflareStreamVideo.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$CloudflareStreamVideoCWProxy get copyWith =>
      _$CloudflareStreamVideoCWProxyImpl(this);
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
