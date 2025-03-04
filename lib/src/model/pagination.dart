import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloudflare/src/utils/params.dart';

part 'pagination.g.dart';

/// Documentation here:
/// API docs: https://api.cloudflare.com/#getting-started-responses
@JsonSerializable()
class Pagination extends Jsonable<Pagination> {
  static const String countHeader = 'X-Count';
  static const String totalCountHeader = 'X-Total-Count';

  /// The requested page.
  /// default value: 1
  int page;
  @JsonKey(name: Params.perPage)

  /// The size of the requested page
  /// default value: 50
  int size;

  /// The amount of results in the requested page
  int count;

  /// The total amount
  @JsonKey(name: Params.totalCount)
  int totalCount;

  Pagination({
    int? page,
    int? size,
    int? count,
    int? totalCount,
  })  : page = page ?? 1,
        size = size ?? 50,
        count = count ?? 0,
        totalCount = totalCount ?? 0;

  @override
  Map<String, dynamic> toJson() => _$PaginationToJson(this);
  @override
  Pagination? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? Pagination.fromJson(json) : null;
  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);
}
