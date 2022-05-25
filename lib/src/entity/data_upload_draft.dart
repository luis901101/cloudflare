import 'package:cloudflare/cloudflare.dart';
import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'data_upload_draft.g.dart';

/// DataUploadDraft is the response object when requesting `direct_upload`
/// For instance: https://api.cloudflare.com/#cloudflare-images-create-authenticated-direct-upload-url-v2
@CopyWith(skipFields: true)
@JsonSerializable()
class DataUploadDraft extends Jsonable<DataUploadDraft> {
  /// Resource id.
  @JsonKey(readValue: Jsonable.idReadValue)
  final String id;

  /// Url to upload resource without API key or token
  final String uploadURL;

  /// Only on video direct upload responses
  final Watermark? watermark;

  const DataUploadDraft({
    String? id,
    String? uploadURL,
    this.watermark,
  })  : id = id ?? '',
        uploadURL = uploadURL ?? '';

  @override
  Map<String, dynamic> toJson() => _$DataUploadDraftToJson(this);

  @override
  DataUploadDraft? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? DataUploadDraft.fromJson(json) : null;

  factory DataUploadDraft.fromJson(Map<String, dynamic> json) =>
      _$DataUploadDraftFromJson(json);
}
