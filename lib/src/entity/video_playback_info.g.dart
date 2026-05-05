// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_playback_info.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

/// This Extension on [VideoPlaybackInfo] is to generate the code for a copyWith(...) function.
extension $VideoPlaybackInfoCopyWithExtension on VideoPlaybackInfo {
  VideoPlaybackInfo copyWith({String? hls, String? dash}) {
    return VideoPlaybackInfo(hls: hls ?? this.hls, dash: dash ?? this.dash);
  }
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
    <String, dynamic>{'hls': ?instance.hls, 'dash': ?instance.dash};
