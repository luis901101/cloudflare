// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloudflare_response.dart';

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
