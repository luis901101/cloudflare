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
    String? state,
    String? reason,
    DateTime? statusEnteredAt,
    DateTime? statusLastSeen,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLiveInputStatusLog.copyWith(...)`.
class _$LiveInputStatusLogCWProxyImpl implements _$LiveInputStatusLogCWProxy {
  const _$LiveInputStatusLogCWProxyImpl(this._value);

  final LiveInputStatusLog _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// LiveInputStatusLog(...).copyWith(id: 12, name: "My name")
  /// ````
  LiveInputStatusLog call({
    Object? state = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
    Object? statusEnteredAt = const $CopyWithPlaceholder(),
    Object? statusLastSeen = const $CopyWithPlaceholder(),
  }) {
    return LiveInputStatusLog(
      state: state == const $CopyWithPlaceholder()
          ? _value.state
          // ignore: cast_nullable_to_non_nullable
          : state as String?,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String?,
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
  /// Returns a callable class that can be used as follows: `instanceOfLiveInputStatusLog.copyWith(...)`.
  // ignore: library_private_types_in_public_api
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
      if (instance.state case final value?) 'state': value,
      if (instance.reason case final value?) 'reason': value,
      if (instance.statusEnteredAt?.toIso8601String() case final value?)
        'statusEnteredAt': value,
      if (instance.statusLastSeen?.toIso8601String() case final value?)
        'statusLastSeen': value,
    };
