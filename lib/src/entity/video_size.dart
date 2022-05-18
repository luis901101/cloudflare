import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'video_size.g.dart';

@CopyWith(skipFields: true)
@JsonSerializable()
class VideoSize extends Jsonable<VideoSize> {
  /// Width of the video in pixels. A value of -1 means the width is unknown.
  /// Value becomes available after the upload, before the video is ready.
  ///
  /// read only
  ///
  /// e.g: 1920
  final int width;

  /// Height of the video in pixels. A value of -1 means the height is unknown.
  /// Value becomes available after the upload, before the video is ready.
  ///
  /// read only
  ///
  /// e.g: 1080
  final int height;

  VideoSize({
    int? width,
    int? height,
  })  : width = width ?? -1,
        height = height ?? -1;

  @override
  Map<String, dynamic> toJson() => _$VideoSizeToJson(this);

  @override
  VideoSize? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? VideoSize.fromJson(json) : null;

  factory VideoSize.fromJson(Map<String, dynamic> json) =>
      _$VideoSizeFromJson(json);
}
