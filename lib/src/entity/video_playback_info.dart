import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'video_playback_info.g.dart';

@JsonSerializable()
class VideoPlaybackInfo extends Jsonable<VideoPlaybackInfo> {

  /// HLS manifest for the video
  String hls;

  /// DASH Media Presentation Description for the video
  String dash;


  VideoPlaybackInfo({
    String? hls,
    String? dash,
  })  : hls = hls ?? '',
        dash = dash ?? '';

  @override
  Map<String, dynamic> toJson() => _$VideoPlaybackInfoToJson(this);

  @override
  VideoPlaybackInfo? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? VideoPlaybackInfo.fromJson(json) : null;

  factory VideoPlaybackInfo.fromJson(Map<String, dynamic> json) =>
      _$VideoPlaybackInfoFromJson(json);
}
