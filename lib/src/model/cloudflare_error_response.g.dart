// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloudflare_error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CloudflareErrorResponse _$CloudflareErrorResponseFromJson(
  Map<String, dynamic> json,
) => CloudflareErrorResponse(
  errors: (json['errors'] as List<dynamic>?)
      ?.map((e) => ErrorInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
  messages: (json['messages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$CloudflareErrorResponseToJson(
  CloudflareErrorResponse instance,
) => <String, dynamic>{
  'errors': instance.errors,
  'messages': instance.messages,
};
