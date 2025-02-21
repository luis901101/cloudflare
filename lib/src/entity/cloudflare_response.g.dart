// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloudflare_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CloudflareResponseCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// CloudflareResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  CloudflareResponse call({
    Object? result,
    bool? success,
    List<ErrorInfo>? errors,
    List<String>? messages,
    Pagination? paginationInfo,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCloudflareResponse.copyWith(...)`.
class _$CloudflareResponseCWProxyImpl implements _$CloudflareResponseCWProxy {
  const _$CloudflareResponseCWProxyImpl(this._value);

  final CloudflareResponse _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// CloudflareResponse(...).copyWith(id: 12, name: "My name")
  /// ````
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
  /// Returns a callable class that can be used as follows: `instanceOfCloudflareResponse.copyWith(...)`.
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
      if (instance.result case final value?) 'result': value,
      'success': instance.success,
      'errors': instance.errors,
      'messages': instance.messages,
      if (instance.paginationInfo case final value?) 'result_info': value,
    };
