// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_input_status.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

/// This Extension on [LiveInputStatus] is to generate the code for a copyWith(...) function.
extension $LiveInputStatusCopyWithExtension on LiveInputStatus {
  LiveInputStatus copyWith({
    LiveInputStatusLog? current,
    List<LiveInputStatusLog>? history,
  }) {
    return LiveInputStatus(
      current: current ?? this.current,
      history:
          ((history?.isNotEmpty ?? false) ? history : null) ?? this.history,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveInputStatus _$LiveInputStatusFromJson(Map<String, dynamic> json) =>
    LiveInputStatus(
      current: json['current'] == null
          ? null
          : LiveInputStatusLog.fromJson(
              json['current'] as Map<String, dynamic>,
            ),
      history: (json['history'] as List<dynamic>?)
          ?.map((e) => LiveInputStatusLog.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LiveInputStatusToJson(LiveInputStatus instance) =>
    <String, dynamic>{
      'current': ?instance.current,
      'history': ?instance.history,
    };
