// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_size.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

/// This Extension on [VideoSize] is to generate the code for a copyWith(...) function.
extension $VideoSizeCopyWithExtension on VideoSize {
  VideoSize copyWith({int? width, int? height}) {
    return VideoSize(width: width ?? this.width, height: height ?? this.height);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoSize _$VideoSizeFromJson(Map<String, dynamic> json) => VideoSize(
  width: (json['width'] as num?)?.toInt(),
  height: (json['height'] as num?)?.toInt(),
);

Map<String, dynamic> _$VideoSizeToJson(VideoSize instance) => <String, dynamic>{
  'width': instance.width,
  'height': instance.height,
};
