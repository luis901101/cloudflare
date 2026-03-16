// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'r2_multipart_draft.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$R2MultipartDraftCWProxy {
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// R2MultipartDraft(...).copyWith(id: 12, name: "My name")
  /// ```
  R2MultipartDraft call({
    String uploadId,
    String bucket,
    String key,
    List<R2SignedUrl> partUrls,
    R2SignedUrl completeUrl,
    int chunkSize,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfR2MultipartDraft.copyWith(...)`.
class _$R2MultipartDraftCWProxyImpl implements _$R2MultipartDraftCWProxy {
  const _$R2MultipartDraftCWProxyImpl(this._value);

  final R2MultipartDraft _value;

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// R2MultipartDraft(...).copyWith(id: 12, name: "My name")
  /// ```
  R2MultipartDraft call({
    Object? uploadId = const $CopyWithPlaceholder(),
    Object? bucket = const $CopyWithPlaceholder(),
    Object? key = const $CopyWithPlaceholder(),
    Object? partUrls = const $CopyWithPlaceholder(),
    Object? completeUrl = const $CopyWithPlaceholder(),
    Object? chunkSize = const $CopyWithPlaceholder(),
  }) {
    return R2MultipartDraft(
      uploadId: uploadId == const $CopyWithPlaceholder() || uploadId == null
          ? _value.uploadId
          // ignore: cast_nullable_to_non_nullable
          : uploadId as String,
      bucket: bucket == const $CopyWithPlaceholder() || bucket == null
          ? _value.bucket
          // ignore: cast_nullable_to_non_nullable
          : bucket as String,
      key: key == const $CopyWithPlaceholder() || key == null
          ? _value.key
          // ignore: cast_nullable_to_non_nullable
          : key as String,
      partUrls: partUrls == const $CopyWithPlaceholder() || partUrls == null
          ? _value.partUrls
          // ignore: cast_nullable_to_non_nullable
          : partUrls as List<R2SignedUrl>,
      completeUrl:
          completeUrl == const $CopyWithPlaceholder() || completeUrl == null
          ? _value.completeUrl
          // ignore: cast_nullable_to_non_nullable
          : completeUrl as R2SignedUrl,
      chunkSize: chunkSize == const $CopyWithPlaceholder() || chunkSize == null
          ? _value.chunkSize
          // ignore: cast_nullable_to_non_nullable
          : chunkSize as int,
    );
  }
}

extension $R2MultipartDraftCopyWith on R2MultipartDraft {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfR2MultipartDraft.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$R2MultipartDraftCWProxy get copyWith => _$R2MultipartDraftCWProxyImpl(this);
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
