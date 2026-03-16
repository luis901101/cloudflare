// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloudflare_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CloudflareResponseCWProxy {
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// CloudflareResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  CloudflareResponse call({
    Object? result,
    bool? success,
    List<ErrorInfo>? errors,
    List<String>? messages,
    Pagination? paginationInfo,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfCloudflareResponse.copyWith(...)`.
class _$CloudflareResponseCWProxyImpl implements _$CloudflareResponseCWProxy {
  const _$CloudflareResponseCWProxyImpl(this._value);

  final CloudflareResponse _value;

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// CloudflareResponse(...).copyWith(id: 12, name: "My name")
  /// ```
  CloudflareResponse call({
    Object? result = const $CopyWithPlaceholder(),
    Object? success = const $CopyWithPlaceholder(),
    Object? errors = const $CopyWithPlaceholder(),
    Object? messages = const $CopyWithPlaceholder(),
    Object? paginationInfo = const $CopyWithPlaceholder(),
  }) {
    return CloudflareResponse(
      result: result == const $CopyWithPlaceholder()
          ? _value.result
          // ignore: cast_nullable_to_non_nullable
          : result as Object?,
      success: success == const $CopyWithPlaceholder()
          ? _value.success
          // ignore: cast_nullable_to_non_nullable
          : success as bool?,
      errors: errors == const $CopyWithPlaceholder()
          ? _value.errors
          // ignore: cast_nullable_to_non_nullable
          : errors as List<ErrorInfo>?,
      messages: messages == const $CopyWithPlaceholder()
          ? _value.messages
          // ignore: cast_nullable_to_non_nullable
          : messages as List<String>?,
      paginationInfo: paginationInfo == const $CopyWithPlaceholder()
          ? _value.paginationInfo
          // ignore: cast_nullable_to_non_nullable
          : paginationInfo as Pagination?,
    );
  }
}

extension $CloudflareResponseCopyWith on CloudflareResponse {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfCloudflareResponse.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$CloudflareResponseCWProxy get copyWith =>
      _$CloudflareResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CloudflareResponse _$CloudflareResponseFromJson(Map<String, dynamic> json) =>
    CloudflareResponse(
      result: json['result'],
      success: json['success'] as bool?,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => ErrorInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      paginationInfo: json['result_info'] == null
          ? null
          : Pagination.fromJson(json['result_info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CloudflareResponseToJson(CloudflareResponse instance) =>
    <String, dynamic>{
      'result': ?instance.result,
      'success': instance.success,
      'errors': instance.errors,
      'messages': instance.messages,
      'result_info': ?instance.paginationInfo,
    };
