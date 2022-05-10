// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_upload_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataUploadDraft _$DataUploadDraftFromJson(Map<String, dynamic> json) =>
    DataUploadDraft(
      id: JsonUtils.idReadValue(json, 'id') as String?,
      uploadURL: json['uploadURL'] as String?,
      watermark: json['watermark'] == null
          ? null
          : Watermark.fromJson(json['watermark'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataUploadDraftToJson(DataUploadDraft instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uploadURL': instance.uploadURL,
      'watermark': instance.watermark,
    };
