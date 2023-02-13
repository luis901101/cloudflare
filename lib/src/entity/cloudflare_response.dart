import 'package:cloudflare/src/model/error_info.dart';
import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloudflare/src/utils/params.dart';
import 'package:cloudflare/src/model/pagination.dart';

part 'cloudflare_response.g.dart';

/// Documentation here:
/// API docs: https://api.cloudflare.com/#getting-started-responses
@CopyWith(skipFields: true)
@JsonSerializable(includeIfNull: false)
class CloudflareResponse extends Jsonable<CloudflareResponse> {
  Object? result;
  bool success;
  List<ErrorInfo> errors;
  List<String> messages;
  @JsonKey(name: Params.resultInfo)
  Pagination? paginationInfo;

  CloudflareResponse({
    this.result,
    bool? success,
    List<ErrorInfo>? errors,
    List<String>? messages,
    this.paginationInfo,
  })  : success = success ?? false,
        errors = errors ?? [],
        messages = messages ?? [];

  @override
  Map<String, dynamic> toJson() => _$CloudflareResponseToJson(this);
  @override
  CloudflareResponse? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? CloudflareResponse.fromJson(json) : null;
  factory CloudflareResponse.fromJson(Map<String, dynamic> json) =>
      _$CloudflareResponseFromJson(json);
}
