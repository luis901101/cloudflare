import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'video_playback_info.g.dart';

@CopyWith(skipFields: true)
@JsonSerializable()
class VideoPlaybackInfo extends Jsonable<VideoPlaybackInfo> {

  /// HLS manifest for the video
  ///
  /// read only
  final String? hls;

  /// DASH Media Presentation Description for the video
  ///
  /// read only
  final String? dash;


  VideoPlaybackInfo({
    this.hls,
    this.dash,
  });

  @override
  Map<String, dynamic> toJson() => _$VideoPlaybackInfoToJson(this);

  @override
  VideoPlaybackInfo? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? VideoPlaybackInfo.fromJson(json) : null;

  factory VideoPlaybackInfo.fromJson(Map<String, dynamic> json) =>
      _$VideoPlaybackInfoFromJson(json);
}
