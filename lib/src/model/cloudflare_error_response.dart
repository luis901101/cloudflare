import 'package:cloudflare/src/model/error_info.dart';
import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cloudflare_error_response.g.dart';

/// It is a wrapper for error responses from network calls
@JsonSerializable()
class CloudflareErrorResponse extends Jsonable<CloudflareErrorResponse> {
  List<ErrorInfo> errors;
  List<String> messages;

  CloudflareErrorResponse({
    List<ErrorInfo>? errors,
    List<String>? messages,
  })  : errors = errors ?? [],
        messages = messages ?? [];

  @override
  Map<String, dynamic> toJson() => _$CloudflareErrorResponseToJson(this);

  @override
  CloudflareErrorResponse? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? CloudflareErrorResponse.fromJson(json) : null;

  factory CloudflareErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$CloudflareErrorResponseFromJson(json);
}
