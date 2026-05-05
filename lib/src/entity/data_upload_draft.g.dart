// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_upload_draft.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

/// This Extension on [DataUploadDraft] is to generate the code for a copyWith(...) function.
extension $DataUploadDraftCopyWithExtension on DataUploadDraft {
  DataUploadDraft copyWith({
    String? id,
    String? uploadURL,
    Watermark? watermark,
  }) {
    return DataUploadDraft(
      id: id ?? this.id,
      uploadURL: uploadURL ?? this.uploadURL,
      watermark: watermark ?? this.watermark,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataUploadDraft _$DataUploadDraftFromJson(Map<String, dynamic> json) =>
    DataUploadDraft(
      id: Jsonable.idReadValue(json, 'id') as String?,
      uploadURL: json['uploadURL'] as String?,
      watermark: json['watermark'] == null
          ? null
          : Watermark.fromJson(json['watermark'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataUploadDraftToJson(DataUploadDraft instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uploadURL': instance.uploadURL,
      'watermark': ?instance.watermark,
    };
