import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'live_input_status_log.g.dart';

/// LiveInputStatusLog represents the status of a Live Input in a specific time
@CopyWith(skipFields: true)
@JsonSerializable()
class LiveInputStatusLog extends Jsonable<LiveInputStatusLog> {

  /// Specifies the state of the Live Input.
  ///
  /// read only
  ///
  /// e.g: "disconnected"
  final String? state;

  /// Specifies the reason of the state of the Live Input.
  ///
  /// read only
  ///
  /// e.g: "client_disconnect"
  final String? reason;

  /// Indicates when the Live Input entered this status
  /// Using  ISO 8601 ZonedDateTime
  ///
  /// read only
  ///
  /// e.g: "2014-01-02T02:20:00Z"
  final DateTime? statusEnteredAt;

  /// Indicates when was the last time the Live Input entered this status
  /// Using  ISO 8601 ZonedDateTime
  ///
  /// read only
  ///
  /// e.g: "2014-01-02T02:20:00Z"
  final DateTime? statusLastSeen;

  const LiveInputStatusLog({
    this.state,
    this.reason,
    this.statusEnteredAt,
    this.statusLastSeen,
  });

  bool get isConnected => state == 'connected';

  @override
  Map<String, dynamic> toJson() => _$LiveInputStatusLogToJson(this);

  @override
  LiveInputStatusLog? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? LiveInputStatusLog.fromJson(json) : null;

  factory LiveInputStatusLog.fromJson(Map<String, dynamic> json) =>
      _$LiveInputStatusLogFromJson(json);
}
