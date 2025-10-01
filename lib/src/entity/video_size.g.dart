// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_size.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VideoSizeCWProxy {
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// VideoSize(...).copyWith(id: 12, name: "My name")
  /// ```
  VideoSize call({int? width, int? height});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfVideoSize.copyWith(...)`.
class _$VideoSizeCWProxyImpl implements _$VideoSizeCWProxy {
  const _$VideoSizeCWProxyImpl(this._value);

  final VideoSize _value;

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// VideoSize(...).copyWith(id: 12, name: "My name")
  /// ```
  VideoSize call({
    Object? width = const $CopyWithPlaceholder(),
    Object? height = const $CopyWithPlaceholder(),
  }) {
    return VideoSize(
      width: width == const $CopyWithPlaceholder()
          ? _value.width
          // ignore: cast_nullable_to_non_nullable
          : width as int?,
      height: height == const $CopyWithPlaceholder()
          ? _value.height
          // ignore: cast_nullable_to_non_nullable
          : height as int?,
    );
  }
}

extension $VideoSizeCopyWith on VideoSize {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfVideoSize.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$VideoSizeCWProxy get copyWith => _$VideoSizeCWProxyImpl(this);
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
