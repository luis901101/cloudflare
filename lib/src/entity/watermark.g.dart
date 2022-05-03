// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watermark.dart';

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
