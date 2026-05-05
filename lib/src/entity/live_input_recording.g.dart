// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_input_recording.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

/// This Extension on [LiveInputRecording] is to generate the code for a copyWith(...) function.
extension $LiveInputRecordingCopyWithExtension on LiveInputRecording {
  LiveInputRecording copyWith({
    LiveInputRecordingMode? mode,
    bool? requireSignedURLs,
    List<String>? allowedOrigins,
    int? timeoutSeconds,
  }) {
    return LiveInputRecording(
      mode: mode ?? this.mode,
      requireSignedURLs: requireSignedURLs ?? this.requireSignedURLs,
      allowedOrigins:
          ((allowedOrigins?.isNotEmpty ?? false) ? allowedOrigins : null) ??
          this.allowedOrigins,
      timeoutSeconds: timeoutSeconds ?? this.timeoutSeconds,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveInputRecording _$LiveInputRecordingFromJson(Map<String, dynamic> json) =>
    LiveInputRecording(
      mode: $enumDecodeNullable(_$LiveInputRecordingModeEnumMap, json['mode']),
      requireSignedURLs: json['requireSignedURLs'] as bool?,
      allowedOrigins: (json['allowedOrigins'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      timeoutSeconds: (json['timeoutSeconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LiveInputRecordingToJson(LiveInputRecording instance) =>
    <String, dynamic>{
      'mode': _$LiveInputRecordingModeEnumMap[instance.mode]!,
      'requireSignedURLs': instance.requireSignedURLs,
      'allowedOrigins': instance.allowedOrigins,
      'timeoutSeconds': instance.timeoutSeconds,
    };

const _$LiveInputRecordingModeEnumMap = {
  LiveInputRecordingMode.off: 'off',
  LiveInputRecordingMode.automatic: 'automatic',
};
