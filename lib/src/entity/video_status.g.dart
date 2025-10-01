// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_status.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VideoStatusCWProxy {
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// VideoStatus(...).copyWith(id: 12, name: "My name")
  /// ```
  VideoStatus call({
    MediaProcessingState? state,
    int? pctComplete,
    String? errorReasonCode,
    String? errorReasonText,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfVideoStatus.copyWith(...)`.
class _$VideoStatusCWProxyImpl implements _$VideoStatusCWProxy {
  const _$VideoStatusCWProxyImpl(this._value);

  final VideoStatus _value;

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// VideoStatus(...).copyWith(id: 12, name: "My name")
  /// ```
  VideoStatus call({
    Object? state = const $CopyWithPlaceholder(),
    Object? pctComplete = const $CopyWithPlaceholder(),
    Object? errorReasonCode = const $CopyWithPlaceholder(),
    Object? errorReasonText = const $CopyWithPlaceholder(),
  }) {
    return VideoStatus(
      state: state == const $CopyWithPlaceholder()
          ? _value.state
          // ignore: cast_nullable_to_non_nullable
          : state as MediaProcessingState?,
      pctComplete: pctComplete == const $CopyWithPlaceholder()
          ? _value.pctComplete
          // ignore: cast_nullable_to_non_nullable
          : pctComplete as int?,
      errorReasonCode: errorReasonCode == const $CopyWithPlaceholder()
          ? _value.errorReasonCode
          // ignore: cast_nullable_to_non_nullable
          : errorReasonCode as String?,
      errorReasonText: errorReasonText == const $CopyWithPlaceholder()
          ? _value.errorReasonText
          // ignore: cast_nullable_to_non_nullable
          : errorReasonText as String?,
    );
  }
}

extension $VideoStatusCopyWith on VideoStatus {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfVideoStatus.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$VideoStatusCWProxy get copyWith => _$VideoStatusCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoStatus _$VideoStatusFromJson(Map<String, dynamic> json) => VideoStatus(
  state: $enumDecodeNullable(
    _$MediaProcessingStateEnumMap,
    json['state'],
    unknownValue: MediaProcessingState.unknown,
  ),
  pctComplete: (Jsonable.intReadValue(json, 'pctComplete') as num?)?.toInt(),
  errorReasonCode: json['errorReasonCode'] as String?,
  errorReasonText: json['errorReasonText'] as String?,
);

Map<String, dynamic> _$VideoStatusToJson(VideoStatus instance) =>
    <String, dynamic>{
      'state': _$MediaProcessingStateEnumMap[instance.state]!,
      'pctComplete': instance.pctComplete,
      'errorReasonCode': ?instance.errorReasonCode,
      'errorReasonText': ?instance.errorReasonText,
    };

const _$MediaProcessingStateEnumMap = {
  MediaProcessingState.pendingUpload: 'pendingupload',
  MediaProcessingState.downloading: 'downloading',
  MediaProcessingState.queued: 'queued',
  MediaProcessingState.inProgress: 'inprogress',
  MediaProcessingState.liveInProgress: 'live-inprogress',
  MediaProcessingState.ready: 'ready',
  MediaProcessingState.error: 'error',
  MediaProcessingState.unknown: 'unknown',
};
