// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_input_status_log.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LiveInputStatusLogCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// LiveInputStatusLog(...).copyWith(id: 12, name: "My name")
  /// ````
  LiveInputStatusLog call({
    String? reason,
    String? state,
    DateTime? statusEnteredAt,
    DateTime? statusLastSeen,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLiveInputStatusLog.copyWith(...)`.
class _$LiveInputStatusLogCWProxyImpl implements _$LiveInputStatusLogCWProxy {
  final LiveInputStatusLog _value;

  const _$LiveInputStatusLogCWProxyImpl(this._value);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// LiveInputStatusLog(...).copyWith(id: 12, name: "My name")
  /// ````
  LiveInputStatusLog call({
    Object? reason = const $CopyWithPlaceholder(),
    Object? state = const $CopyWithPlaceholder(),
    Object? statusEnteredAt = const $CopyWithPlaceholder(),
    Object? statusLastSeen = const $CopyWithPlaceholder(),
  }) {
    return LiveInputStatusLog(
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String?,
      state: state == const $CopyWithPlaceholder()
          ? _value.state
          // ignore: cast_nullable_to_non_nullable
          : state as String?,
      statusEnteredAt: statusEnteredAt == const $CopyWithPlaceholder()
          ? _value.statusEnteredAt
          // ignore: cast_nullable_to_non_nullable
          : statusEnteredAt as DateTime?,
      statusLastSeen: statusLastSeen == const $CopyWithPlaceholder()
          ? _value.statusLastSeen
          // ignore: cast_nullable_to_non_nullable
          : statusLastSeen as DateTime?,
    );
  }
}

extension $LiveInputStatusLogCopyWith on LiveInputStatusLog {
  /// Returns a callable class that can be used as follows: `instanceOfclass LiveInputStatusLog extends Jsonable<LiveInputStatusLog>.name.copyWith(...)`.
  _$LiveInputStatusLogCWProxy get copyWith =>
      _$LiveInputStatusLogCWProxyImpl(this);
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
      'state': instance.state,
      'reason': instance.reason,
      'statusEnteredAt': instance.statusEnteredAt?.toIso8601String(),
      'statusLastSeen': instance.statusLastSeen?.toIso8601String(),
    };
