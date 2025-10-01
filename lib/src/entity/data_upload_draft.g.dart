// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_upload_draft.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DataUploadDraftCWProxy {
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// DataUploadDraft(...).copyWith(id: 12, name: "My name")
  /// ```
  DataUploadDraft call({String? id, String? uploadURL, Watermark? watermark});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfDataUploadDraft.copyWith(...)`.
class _$DataUploadDraftCWProxyImpl implements _$DataUploadDraftCWProxy {
  const _$DataUploadDraftCWProxyImpl(this._value);

  final DataUploadDraft _value;

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// DataUploadDraft(...).copyWith(id: 12, name: "My name")
  /// ```
  DataUploadDraft call({
    Object? id = const $CopyWithPlaceholder(),
    Object? uploadURL = const $CopyWithPlaceholder(),
    Object? watermark = const $CopyWithPlaceholder(),
  }) {
    return DataUploadDraft(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      uploadURL: uploadURL == const $CopyWithPlaceholder()
          ? _value.uploadURL
          // ignore: cast_nullable_to_non_nullable
          : uploadURL as String?,
      watermark: watermark == const $CopyWithPlaceholder()
          ? _value.watermark
          // ignore: cast_nullable_to_non_nullable
          : watermark as Watermark?,
    );
  }
}

extension $DataUploadDraftCopyWith on DataUploadDraft {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfDataUploadDraft.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$DataUploadDraftCWProxy get copyWith => _$DataUploadDraftCWProxyImpl(this);
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
