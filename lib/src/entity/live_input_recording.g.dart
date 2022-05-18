// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_input_recording.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LiveInputRecordingCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// LiveInputRecording(...).copyWith(id: 12, name: "My name")
  /// ````
  LiveInputRecording call({
    List<String>? allowedOrigins,
    RecordingMode? mode,
    bool? requireSignedURLs,
    int? timeoutSeconds,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLiveInputRecording.copyWith(...)`.
class _$LiveInputRecordingCWProxyImpl implements _$LiveInputRecordingCWProxy {
  final LiveInputRecording _value;

  const _$LiveInputRecordingCWProxyImpl(this._value);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// LiveInputRecording(...).copyWith(id: 12, name: "My name")
  /// ````
  LiveInputRecording call({
    Object? allowedOrigins = const $CopyWithPlaceholder(),
    Object? mode = const $CopyWithPlaceholder(),
    Object? requireSignedURLs = const $CopyWithPlaceholder(),
    Object? timeoutSeconds = const $CopyWithPlaceholder(),
  }) {
    return LiveInputRecording(
      allowedOrigins: allowedOrigins == const $CopyWithPlaceholder()
          ? _value.allowedOrigins
          // ignore: cast_nullable_to_non_nullable
          : allowedOrigins as List<String>?,
      mode: mode == const $CopyWithPlaceholder()
          ? _value.mode
          // ignore: cast_nullable_to_non_nullable
          : mode as RecordingMode?,
      requireSignedURLs: requireSignedURLs == const $CopyWithPlaceholder()
          ? _value.requireSignedURLs
          // ignore: cast_nullable_to_non_nullable
          : requireSignedURLs as bool?,
      timeoutSeconds: timeoutSeconds == const $CopyWithPlaceholder()
          ? _value.timeoutSeconds
          // ignore: cast_nullable_to_non_nullable
          : timeoutSeconds as int?,
    );
  }
}

extension $LiveInputRecordingCopyWith on LiveInputRecording {
  /// Returns a callable class that can be used as follows: `instanceOfclass LiveInputRecording extends Jsonable<LiveInputRecording>.name.copyWith(...)`.
  _$LiveInputRecordingCWProxy get copyWith =>
      _$LiveInputRecordingCWProxyImpl(this);
}

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
