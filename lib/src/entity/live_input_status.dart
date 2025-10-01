import 'package:cloudflare/src/entity/live_input_status_log.dart';
import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'live_input_status.g.dart';

/// LiveInputStatus represents the current and historical status of a
/// Live Input after a streaming was started.
@CopyWith()
@JsonSerializable()
class LiveInputStatus extends Jsonable<LiveInputStatus> {
  /// The current status for the Live Input
  final LiveInputStatusLog? current;

  /// The history log for the Live Input statuses
  final List<LiveInputStatusLog>? history;

  const LiveInputStatus({this.current, this.history});

  @override
  Map<String, dynamic> toJson() => _$LiveInputStatusToJson(this);

  @override
  LiveInputStatus? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? LiveInputStatus.fromJson(json) : null;

  factory LiveInputStatus.fromJson(Map<String, dynamic> json) =>
      _$LiveInputStatusFromJson(json);
}
