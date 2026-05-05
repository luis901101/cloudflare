// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'r2_multipart_draft.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

/// This Extension on [R2MultipartDraft] is to generate the code for a copyWith(...) function.
extension $R2MultipartDraftCopyWithExtension on R2MultipartDraft {
  R2MultipartDraft copyWith({
    String? uploadId,
    String? bucket,
    String? key,
    List<R2SignedUrl>? partUrls,
    R2SignedUrl? completeUrl,
    int? chunkSize,
  }) {
    return R2MultipartDraft(
      uploadId: uploadId ?? this.uploadId,
      bucket: bucket ?? this.bucket,
      key: key ?? this.key,
      partUrls:
          ((partUrls?.isNotEmpty ?? false) ? partUrls : null) ?? this.partUrls,
      completeUrl: completeUrl ?? this.completeUrl,
      chunkSize: chunkSize ?? this.chunkSize,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

R2MultipartDraft _$R2MultipartDraftFromJson(Map<String, dynamic> json) =>
    R2MultipartDraft(
      uploadId: json['uploadId'] as String,
      bucket: json['bucket'] as String,
      key: json['key'] as String,
      partUrls: (json['partUrls'] as List<dynamic>)
          .map((e) => R2SignedUrl.fromJson(e as Map<String, dynamic>))
          .toList(),
      completeUrl: R2SignedUrl.fromJson(
        json['completeUrl'] as Map<String, dynamic>,
      ),
      chunkSize: (json['chunkSize'] as num).toInt(),
    );

Map<String, dynamic> _$R2MultipartDraftToJson(R2MultipartDraft instance) =>
    <String, dynamic>{
      'uploadId': instance.uploadId,
      'bucket': instance.bucket,
      'key': instance.key,
      'partUrls': instance.partUrls,
      'completeUrl': instance.completeUrl,
      'chunkSize': instance.chunkSize,
    };
