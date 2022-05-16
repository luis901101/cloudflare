// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_input_recording.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveInputRecording _$LiveInputRecordingFromJson(Map<String, dynamic> json) =>
    LiveInputRecording(
      mode: $enumDecodeNullable(_$RecordingModeEnumMap, json['mode']),
      requireSignedURLs: json['requireSignedURLs'] as bool?,
      allowedOrigins: (json['allowedOrigins'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      timeoutSeconds: json['timeoutSeconds'] as int?,
    );

Map<String, dynamic> _$LiveInputRecordingToJson(LiveInputRecording instance) =>
    <String, dynamic>{
      'mode': _$RecordingModeEnumMap[instance.mode],
      'requireSignedURLs': instance.requireSignedURLs,
      'allowedOrigins': instance.allowedOrigins,
      'timeoutSeconds': instance.timeoutSeconds,
    };

const _$RecordingModeEnumMap = {
  RecordingMode.off: 'off',
  RecordingMode.automatic: 'automatic',
};
