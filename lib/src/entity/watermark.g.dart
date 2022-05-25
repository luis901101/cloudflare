// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watermark.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WatermarkCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// Watermark(...).copyWith(id: 12, name: "My name")
  /// ````
  Watermark call({
    DateTime? created,
    String? downloadedFrom,
    int? height,
    String? id,
    String? name,
    double? opacity,
    double? padding,
    WatermarkPosition? position,
    double? scale,
    int? size,
    int? width,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWatermark.copyWith(...)`.
class _$WatermarkCWProxyImpl implements _$WatermarkCWProxy {
  final Watermark _value;

  const _$WatermarkCWProxyImpl(this._value);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// Watermark(...).copyWith(id: 12, name: "My name")
  /// ````
  Watermark call({
    Object? created = const $CopyWithPlaceholder(),
    Object? downloadedFrom = const $CopyWithPlaceholder(),
    Object? height = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? opacity = const $CopyWithPlaceholder(),
    Object? padding = const $CopyWithPlaceholder(),
    Object? position = const $CopyWithPlaceholder(),
    Object? scale = const $CopyWithPlaceholder(),
    Object? size = const $CopyWithPlaceholder(),
    Object? width = const $CopyWithPlaceholder(),
  }) {
    return Watermark(
      created: created == const $CopyWithPlaceholder()
          ? _value.created
          // ignore: cast_nullable_to_non_nullable
          : created as DateTime?,
      downloadedFrom: downloadedFrom == const $CopyWithPlaceholder()
          ? _value.downloadedFrom
          // ignore: cast_nullable_to_non_nullable
          : downloadedFrom as String?,
      height: height == const $CopyWithPlaceholder()
          ? _value.height
          // ignore: cast_nullable_to_non_nullable
          : height as int?,
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      opacity: opacity == const $CopyWithPlaceholder()
          ? _value.opacity
          // ignore: cast_nullable_to_non_nullable
          : opacity as double?,
      padding: padding == const $CopyWithPlaceholder()
          ? _value.padding
          // ignore: cast_nullable_to_non_nullable
          : padding as double?,
      position: position == const $CopyWithPlaceholder()
          ? _value.position
          // ignore: cast_nullable_to_non_nullable
          : position as WatermarkPosition?,
      scale: scale == const $CopyWithPlaceholder()
          ? _value.scale
          // ignore: cast_nullable_to_non_nullable
          : scale as double?,
      size: size == const $CopyWithPlaceholder()
          ? _value.size
          // ignore: cast_nullable_to_non_nullable
          : size as int?,
      width: width == const $CopyWithPlaceholder()
          ? _value.width
          // ignore: cast_nullable_to_non_nullable
          : width as int?,
    );
  }
}

extension $WatermarkCopyWith on Watermark {
  /// Returns a callable class that can be used as follows: `instanceOfWatermark.copyWith(...)`.
  _$WatermarkCWProxy get copyWith => _$WatermarkCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Watermark _$WatermarkFromJson(Map<String, dynamic> json) => Watermark(
      id: json['uid'] as String?,
      size: json['size'] as int?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      position: $enumDecodeNullable(
          _$WatermarkPositionEnumMap, json['position'],
          unknownValue: WatermarkPosition.upperRight),
      scale: (json['scale'] as num?)?.toDouble(),
      opacity: (json['opacity'] as num?)?.toDouble(),
      padding: (json['padding'] as num?)?.toDouble(),
      name: json['name'] as String?,
      downloadedFrom: json['downloadedFrom'] as String?,
    );

Map<String, dynamic> _$WatermarkToJson(Watermark instance) => <String, dynamic>{
      'uid': instance.id,
      'size': instance.size,
      'width': instance.width,
      'height': instance.height,
      'created': instance.created.toIso8601String(),
      'position': _$WatermarkPositionEnumMap[instance.position],
      'scale': instance.scale,
      'opacity': instance.opacity,
      'padding': instance.padding,
      'name': instance.name,
      'downloadedFrom': instance.downloadedFrom,
    };

const _$WatermarkPositionEnumMap = {
  WatermarkPosition.upperRight: 'upperRight',
  WatermarkPosition.upperLeft: 'upperLeft',
  WatermarkPosition.lowerLeft: 'lowerLeft',
  WatermarkPosition.lowerRight: 'lowerRight',
  WatermarkPosition.center: 'center',
};
