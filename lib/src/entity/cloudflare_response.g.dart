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
    List<ErrorInfo>? errors,
    List<String>? messages,
    Pagination? paginationInfo,
    dynamic? result,
    bool? success,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCloudflareResponse.copyWith(...)`.
class _$CloudflareResponseCWProxyImpl implements _$CloudflareResponseCWProxy {
  final CloudflareResponse _value;

  const _$CloudflareResponseCWProxyImpl(this._value);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// CloudflareResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  CloudflareResponse call({
    Object? errors = const $CopyWithPlaceholder(),
    Object? messages = const $CopyWithPlaceholder(),
    Object? paginationInfo = const $CopyWithPlaceholder(),
    Object? result = const $CopyWithPlaceholder(),
    Object? success = const $CopyWithPlaceholder(),
  }) {
    return CloudflareResponse(
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
      result: result == const $CopyWithPlaceholder() || result == null
          ? _value.result
          // ignore: cast_nullable_to_non_nullable
          : result as dynamic,
      success: success == const $CopyWithPlaceholder()
          ? _value.success
          // ignore: cast_nullable_to_non_nullable
          : success as bool?,
    );
  }
}

extension $CloudflareResponseCopyWith on CloudflareResponse {
  /// Returns a callable class that can be used as follows: `instanceOfCloudflareResponse.copyWith(...)`.
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

Map<String, dynamic> _$CloudflareResponseToJson(CloudflareResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('result', instance.result);
  val['success'] = instance.success;
  val['errors'] = instance.errors;
  val['messages'] = instance.messages;
  writeNotNull('result_info', instance.paginationInfo);
  return val;
}
