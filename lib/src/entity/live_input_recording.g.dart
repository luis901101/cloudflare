// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_input_recording.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LiveInputRecordingCWProxy {
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// LiveInputRecording(...).copyWith(id: 12, name: "My name")
  /// ```
  LiveInputRecording call({
    LiveInputRecordingMode? mode,
    bool? requireSignedURLs,
    List<String>? allowedOrigins,
    int? timeoutSeconds,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfLiveInputRecording.copyWith(...)`.
class _$LiveInputRecordingCWProxyImpl implements _$LiveInputRecordingCWProxy {
  const _$LiveInputRecordingCWProxyImpl(this._value);

  final LiveInputRecording _value;

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// LiveInputRecording(...).copyWith(id: 12, name: "My name")
  /// ```
  LiveInputRecording call({
    Object? mode = const $CopyWithPlaceholder(),
    Object? requireSignedURLs = const $CopyWithPlaceholder(),
    Object? allowedOrigins = const $CopyWithPlaceholder(),
    Object? timeoutSeconds = const $CopyWithPlaceholder(),
  }) {
    return LiveInputRecording(
      mode: mode == const $CopyWithPlaceholder()
          ? _value.mode
          // ignore: cast_nullable_to_non_nullable
          : mode as LiveInputRecordingMode?,
      requireSignedURLs: requireSignedURLs == const $CopyWithPlaceholder()
          ? _value.requireSignedURLs
          // ignore: cast_nullable_to_non_nullable
          : requireSignedURLs as bool?,
      allowedOrigins: allowedOrigins == const $CopyWithPlaceholder()
          ? _value.allowedOrigins
          // ignore: cast_nullable_to_non_nullable
          : allowedOrigins as List<String>?,
      timeoutSeconds: timeoutSeconds == const $CopyWithPlaceholder()
          ? _value.timeoutSeconds
          // ignore: cast_nullable_to_non_nullable
          : timeoutSeconds as int?,
    );
  }
}

extension $LiveInputRecordingCopyWith on LiveInputRecording {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfLiveInputRecording.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$LiveInputRecordingCWProxy get copyWith =>
      _$LiveInputRecordingCWProxyImpl(this);
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
