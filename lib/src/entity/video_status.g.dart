// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_status.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VideoStatusCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// VideoStatus(...).copyWith(id: 12, name: "My name")
  /// ````
  VideoStatus call({
    String? errorReasonCode,
    String? errorReasonText,
    int? pctComplete,
    MediaProcessingState? state,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVideoStatus.copyWith(...)`.
class _$VideoStatusCWProxyImpl implements _$VideoStatusCWProxy {
  final VideoStatus _value;

  const _$VideoStatusCWProxyImpl(this._value);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// VideoStatus(...).copyWith(id: 12, name: "My name")
  /// ````
  VideoStatus call({
    Object? errorReasonCode = const $CopyWithPlaceholder(),
    Object? errorReasonText = const $CopyWithPlaceholder(),
    Object? pctComplete = const $CopyWithPlaceholder(),
    Object? state = const $CopyWithPlaceholder(),
  }) {
    return VideoStatus(
      errorReasonCode: errorReasonCode == const $CopyWithPlaceholder()
          ? _value.errorReasonCode
          // ignore: cast_nullable_to_non_nullable
          : errorReasonCode as String?,
      errorReasonText: errorReasonText == const $CopyWithPlaceholder()
          ? _value.errorReasonText
          // ignore: cast_nullable_to_non_nullable
          : errorReasonText as String?,
      pctComplete: pctComplete == const $CopyWithPlaceholder()
          ? _value.pctComplete
          // ignore: cast_nullable_to_non_nullable
          : pctComplete as int?,
      state: state == const $CopyWithPlaceholder()
          ? _value.state
          // ignore: cast_nullable_to_non_nullable
          : state as MediaProcessingState?,
    );
  }
}

extension $VideoStatusCopyWith on VideoStatus {
  /// Returns a callable class that can be used as follows: `instanceOfclass VideoStatus extends Jsonable<VideoStatus>.name.copyWith(...)`.
  _$VideoStatusCWProxy get copyWith => _$VideoStatusCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoStatus _$VideoStatusFromJson(Map<String, dynamic> json) => VideoStatus(
      state: $enumDecodeNullable(_$MediaProcessingStateEnumMap, json['state'],
          unknownValue: MediaProcessingState.unknown),
      pctComplete: JsonUtils.intReadValue(json, 'pctComplete') as int?,
      errorReasonCode: json['errorReasonCode'] as String?,
      errorReasonText: json['errorReasonText'] as String?,
    );

Map<String, dynamic> _$VideoStatusToJson(VideoStatus instance) =>
    <String, dynamic>{
      'state': _$MediaProcessingStateEnumMap[instance.state],
      'pctComplete': instance.pctComplete,
      'errorReasonCode': instance.errorReasonCode,
      'errorReasonText': instance.errorReasonText,
    };

const _$MediaProcessingStateEnumMap = {
  MediaProcessingState.pendingupload: 'pendingupload',
  MediaProcessingState.downloading: 'downloading',
  MediaProcessingState.queued: 'queued',
  MediaProcessingState.inprogress: 'inprogress',
  MediaProcessingState.ready: 'ready',
  MediaProcessingState.error: 'error',
  MediaProcessingState.unknown: 'unknown',
};
