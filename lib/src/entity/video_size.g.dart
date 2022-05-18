// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_size.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VideoSizeCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// VideoSize(...).copyWith(id: 12, name: "My name")
  /// ````
  VideoSize call({
    int? height,
    int? width,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVideoSize.copyWith(...)`.
class _$VideoSizeCWProxyImpl implements _$VideoSizeCWProxy {
  final VideoSize _value;

  const _$VideoSizeCWProxyImpl(this._value);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// VideoSize(...).copyWith(id: 12, name: "My name")
  /// ````
  VideoSize call({
    Object? height = const $CopyWithPlaceholder(),
    Object? width = const $CopyWithPlaceholder(),
  }) {
    return VideoSize(
      height: height == const $CopyWithPlaceholder()
          ? _value.height
          // ignore: cast_nullable_to_non_nullable
          : height as int?,
      width: width == const $CopyWithPlaceholder()
          ? _value.width
          // ignore: cast_nullable_to_non_nullable
          : width as int?,
    );
  }
}

extension $VideoSizeCopyWith on VideoSize {
  /// Returns a callable class that can be used as follows: `instanceOfclass VideoSize extends Jsonable<VideoSize>.name.copyWith(...)`.
  _$VideoSizeCWProxy get copyWith => _$VideoSizeCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoSize _$VideoSizeFromJson(Map<String, dynamic> json) => VideoSize(
      width: json['width'] as int?,
      height: json['height'] as int?,
    );

Map<String, dynamic> _$VideoSizeToJson(VideoSize instance) => <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
    };
