// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageStats _$ImageStatsFromJson(Map<String, dynamic> json) => ImageStats(
  current: (json['current'] as num?)?.toInt(),
  allowed: (json['allowed'] as num?)?.toInt(),
);

Map<String, dynamic> _$ImageStatsToJson(ImageStats instance) =>
    <String, dynamic>{'current': instance.current, 'allowed': instance.allowed};
