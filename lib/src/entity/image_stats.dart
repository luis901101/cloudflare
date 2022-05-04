import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:cloudflare/src/utils/params.dart';
import 'package:json_annotation/json_annotation.dart';

part 'image_stats.g.dart';

/// ImageStats is the response object when requesting `direct_upload`
/// For instance: https://api.cloudflare.com/#cloudflare-images-images-usage-statistics
@JsonSerializable()
class ImageStats extends Jsonable<ImageStats> {

  /// Current usage
  final int current;

  /// Allowed usage
  final int allowed;

  const ImageStats({
    int? current,
    int? allowed,
  }) :
    current = current ?? 0,
    allowed = allowed ??0
  ;

  @override
  Map<String, dynamic> toJson() => _$ImageStatsToJson(this);

  @override
  ImageStats? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? ImageStats.fromJson(json) : null;

  factory ImageStats.fromJson(Map<String, dynamic> json) =>
    _$ImageStatsFromJson(json[Params.count] ?? json);
}
