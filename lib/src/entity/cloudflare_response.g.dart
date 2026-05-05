// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloudflare_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

/// This Extension on [CloudflareResponse] is to generate the code for a copyWith(...) function.
extension $CloudflareResponseCopyWithExtension on CloudflareResponse {
  CloudflareResponse copyWith({
    Object? result,
    bool? success,
    List<ErrorInfo>? errors,
    List<String>? messages,
    Pagination? paginationInfo,
  }) {
    return CloudflareResponse(
      result: result ?? this.result,
      success: success ?? this.success,
      errors: ((errors?.isNotEmpty ?? false) ? errors : null) ?? this.errors,
      messages:
          ((messages?.isNotEmpty ?? false) ? messages : null) ?? this.messages,
      paginationInfo: paginationInfo ?? this.paginationInfo,
    );
  }
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
