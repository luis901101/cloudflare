
import 'package:cloudflare_sdk/src/utils/jsonable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'error_info.g.dart';

@JsonSerializable(includeIfNull: false)
class ErrorInfo extends Jsonable<ErrorInfo> {
  int? code;
  String? message;

  ErrorInfo({
    this.code,
    this.message,
  });

  @override
  Map<String, dynamic> toJson() => _$ErrorInfoToJson(this);
  @override
  ErrorInfo? fromJsonMap(Map<String, dynamic>? json) => json != null ? ErrorInfo.fromJson(json) : null;
  factory ErrorInfo.fromJson(Map<String, dynamic> json) =>
      _$ErrorInfoFromJson(json);
}