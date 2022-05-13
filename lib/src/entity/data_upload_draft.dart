import 'package:cloudflare/cloudflare.dart';
import 'package:cloudflare/src/utils/json_utils.dart';
import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'data_upload_draft.g.dart';

/// DataUploadDraft is the response object when requesting `direct_upload`
/// For instance: https://api.cloudflare.com/#cloudflare-images-create-authenticated-direct-upload-url-v2
@JsonSerializable()
class DataUploadDraft extends Jsonable<DataUploadDraft> {

  /// Resource id.
  @JsonKey(readValue: JsonUtils.idReadValue) final String id;

  /// Url to upload resource without API key or token
  final String uploadURL;

  /// Only on video direct upload responses
  final Watermark? watermark;

  const DataUploadDraft({
    String? id,
    @CopyWithField(immutable: true) String? uid,
    String? uploadURL,
    this.watermark,
  }) :
    id = id ?? uid ?? '',
    uploadURL = uploadURL ?? ''
  ;

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

  @override
  Map<String, dynamic> toJson() => _$DataUploadDraftToJson(this);

  @override
  DataUploadDraft? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? DataUploadDraft.fromJson(json) : null;

  factory DataUploadDraft.fromJson(Map<String, dynamic> json) =>
      _$DataUploadDraftFromJson(json);
}
