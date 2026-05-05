// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_status.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

/// This Extension on [VideoStatus] is to generate the code for a copyWith(...) function.
extension $VideoStatusCopyWithExtension on VideoStatus {
  VideoStatus copyWith({
    MediaProcessingState? state,
    int? pctComplete,
    String? errorReasonCode,
    String? errorReasonText,
  }) {
    return VideoStatus(
      state: state ?? this.state,
      pctComplete: pctComplete ?? this.pctComplete,
      errorReasonCode: errorReasonCode ?? this.errorReasonCode,
      errorReasonText: errorReasonText ?? this.errorReasonText,
    );
  }
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
