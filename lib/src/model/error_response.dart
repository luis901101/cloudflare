import 'package:cloudflare_sdk/src/model/error_info.dart';
import 'package:cloudflare_sdk/src/utils/jsonable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'error_response.g.dart';

@JsonSerializable()
class ErrorResponse extends Jsonable<ErrorResponse> {

  List<ErrorInfo> errors;
  List<String> messages;

  ErrorResponse({
    List<ErrorInfo>? errors,
    List<String>? messages,
  }) : errors = errors ?? [],
      messages = messages ?? []
  ;

  @override
  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);

  @override
  ErrorResponse? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? ErrorResponse.fromJson(json) : null;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);
}