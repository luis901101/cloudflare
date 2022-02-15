// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoStatus _$VideoStatusFromJson(Map<String, dynamic> json) => VideoStatus(
      state: $enumDecodeNullable(_$VideoProcessingStateEnumMap, json['state']),
      pctComplete: json['pctComplete'] as int?,
      errorReasonCode: json['errorReasonCode'] as String?,
      errorReasonText: json['errorReasonText'] as String?,
    );

Map<String, dynamic> _$VideoStatusToJson(VideoStatus instance) =>
    <String, dynamic>{
      'state': _$VideoProcessingStateEnumMap[instance.state],
      'pctComplete': instance.pctComplete,
      'errorReasonCode': instance.errorReasonCode,
      'errorReasonText': instance.errorReasonText,
    };

const _$VideoProcessingStateEnumMap = {
  VideoProcessingState.pendingupload: 'pendingupload',
  VideoProcessingState.downloading: 'downloading',
  VideoProcessingState.queued: 'queued',
  VideoProcessingState.inprogress: 'inprogress',
  VideoProcessingState.ready: 'ready',
  VideoProcessingState.error: 'error',
};
