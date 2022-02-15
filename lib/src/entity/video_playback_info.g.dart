// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_playback_info.dart';

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
      'hls': instance.hls,
      'dash': instance.dash,
    };
