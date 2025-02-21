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
    String? id,
    int? size,
    int? width,
    int? height,
    DateTime? created,
    WatermarkPosition? position,
    double? scale,
    double? opacity,
    double? padding,
    String? name,
    String? downloadedFrom,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWatermark.copyWith(...)`.
class _$WatermarkCWProxyImpl implements _$WatermarkCWProxy {
  const _$WatermarkCWProxyImpl(this._value);

  final Watermark _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// Watermark(...).copyWith(id: 12, name: "My name")
  /// ````
  Watermark call({
    Object? id = const $CopyWithPlaceholder(),
    Object? size = const $CopyWithPlaceholder(),
    Object? width = const $CopyWithPlaceholder(),
    Object? height = const $CopyWithPlaceholder(),
    Object? created = const $CopyWithPlaceholder(),
    Object? position = const $CopyWithPlaceholder(),
    Object? scale = const $CopyWithPlaceholder(),
    Object? opacity = const $CopyWithPlaceholder(),
    Object? padding = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? downloadedFrom = const $CopyWithPlaceholder(),
  }) {
    return Watermark(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      size: size == const $CopyWithPlaceholder()
          ? _value.size
          // ignore: cast_nullable_to_non_nullable
          : size as int?,
      width: width == const $CopyWithPlaceholder()
          ? _value.width
          // ignore: cast_nullable_to_non_nullable
          : width as int?,
      height: height == const $CopyWithPlaceholder()
          ? _value.height
          // ignore: cast_nullable_to_non_nullable
          : height as int?,
      created: created == const $CopyWithPlaceholder()
          ? _value.created
          // ignore: cast_nullable_to_non_nullable
          : created as DateTime?,
      position: position == const $CopyWithPlaceholder()
          ? _value.position
          // ignore: cast_nullable_to_non_nullable
          : position as WatermarkPosition?,
      scale: scale == const $CopyWithPlaceholder()
          ? _value.scale
          // ignore: cast_nullable_to_non_nullable
          : scale as double?,
      opacity: opacity == const $CopyWithPlaceholder()
          ? _value.opacity
          // ignore: cast_nullable_to_non_nullable
          : opacity as double?,
      padding: padding == const $CopyWithPlaceholder()
          ? _value.padding
          // ignore: cast_nullable_to_non_nullable
          : padding as double?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      downloadedFrom: downloadedFrom == const $CopyWithPlaceholder()
          ? _value.downloadedFrom
          // ignore: cast_nullable_to_non_nullable
          : downloadedFrom as String?,
    );
  }
}

extension $WatermarkCopyWith on Watermark {
  /// Returns a callable class that can be used as follows: `instanceOfWatermark.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$WatermarkCWProxy get copyWith => _$WatermarkCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Watermark _$WatermarkFromJson(Map<String, dynamic> json) => Watermark(
      id: json['uid'] as String?,
      size: (json['size'] as num?)?.toInt(),
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
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
      'position': _$WatermarkPositionEnumMap[instance.position]!,
      'scale': instance.scale,
      'opacity': instance.opacity,
      'padding': instance.padding,
      if (instance.name case final value?) 'name': value,
      if (instance.downloadedFrom case final value?) 'downloadedFrom': value,
    };

const _$WatermarkPositionEnumMap = {
  WatermarkPosition.upperRight: 'upperRight',
  WatermarkPosition.upperLeft: 'upperLeft',
  WatermarkPosition.lowerLeft: 'lowerLeft',
  WatermarkPosition.lowerRight: 'lowerRight',
  WatermarkPosition.center: 'center',
};
