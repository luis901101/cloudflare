// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_input_status_log.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

/// This Extension on [LiveInputStatusLog] is to generate the code for a copyWith(...) function.
extension $LiveInputStatusLogCopyWithExtension on LiveInputStatusLog {
  LiveInputStatusLog copyWith({
    String? state,
    String? reason,
    DateTime? statusEnteredAt,
    DateTime? statusLastSeen,
  }) {
    return LiveInputStatusLog(
      state: state ?? this.state,
      reason: reason ?? this.reason,
      statusEnteredAt: statusEnteredAt ?? this.statusEnteredAt,
      statusLastSeen: statusLastSeen ?? this.statusLastSeen,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveInputStatusLog _$LiveInputStatusLogFromJson(Map<String, dynamic> json) =>
    LiveInputStatusLog(
      state: json['state'] as String?,
      reason: json['reason'] as String?,
      statusEnteredAt: json['statusEnteredAt'] == null
          ? null
          : DateTime.parse(json['statusEnteredAt'] as String),
      statusLastSeen: json['statusLastSeen'] == null
          ? null
          : DateTime.parse(json['statusLastSeen'] as String),
    );

Map<String, dynamic> _$LiveInputStatusLogToJson(LiveInputStatusLog instance) =>
    <String, dynamic>{
      'state': ?instance.state,
      'reason': ?instance.reason,
      'statusEnteredAt': ?instance.statusEnteredAt?.toIso8601String(),
      'statusLastSeen': ?instance.statusLastSeen?.toIso8601String(),
    };
