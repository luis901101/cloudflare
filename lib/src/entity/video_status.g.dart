// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_status.dart';

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
