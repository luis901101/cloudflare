// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_playback_info.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VideoPlaybackInfoCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// VideoPlaybackInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  VideoPlaybackInfo call({
    String? hls,
    String? dash,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVideoPlaybackInfo.copyWith(...)`.
class _$VideoPlaybackInfoCWProxyImpl implements _$VideoPlaybackInfoCWProxy {
  const _$VideoPlaybackInfoCWProxyImpl(this._value);

  final VideoPlaybackInfo _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// VideoPlaybackInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  VideoPlaybackInfo call({
    Object? hls = const $CopyWithPlaceholder(),
    Object? dash = const $CopyWithPlaceholder(),
  }) {
    return VideoPlaybackInfo(
      hls: hls == const $CopyWithPlaceholder()
          ? _value.hls
          // ignore: cast_nullable_to_non_nullable
          : hls as String?,
      dash: dash == const $CopyWithPlaceholder()
          ? _value.dash
          // ignore: cast_nullable_to_non_nullable
          : dash as String?,
    );
  }
}

extension $VideoPlaybackInfoCopyWith on VideoPlaybackInfo {
  /// Returns a callable class that can be used as follows: `instanceOfVideoPlaybackInfo.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$VideoPlaybackInfoCWProxy get copyWith =>
      _$VideoPlaybackInfoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoPlaybackInfo _$VideoPlaybackInfoFromJson(Map<String, dynamic> json) =>
    VideoPlaybackInfo(
      hls: json['hls'] as String?,
      dash: json['dash'] as String?,
    );

Map<String, dynamic> _$VideoPlaybackInfoToJson(VideoPlaybackInfo instance) =>
    <String, dynamic>{
      if (instance.hls case final value?) 'hls': value,
      if (instance.dash case final value?) 'dash': value,
    };
