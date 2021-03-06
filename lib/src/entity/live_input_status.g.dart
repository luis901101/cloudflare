// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_input_status.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LiveInputStatusCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// LiveInputStatus(...).copyWith(id: 12, name: "My name")
  /// ````
  LiveInputStatus call({
    LiveInputStatusLog? current,
    List<LiveInputStatusLog>? history,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLiveInputStatus.copyWith(...)`.
class _$LiveInputStatusCWProxyImpl implements _$LiveInputStatusCWProxy {
  final LiveInputStatus _value;

  const _$LiveInputStatusCWProxyImpl(this._value);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// LiveInputStatus(...).copyWith(id: 12, name: "My name")
  /// ````
  LiveInputStatus call({
    Object? current = const $CopyWithPlaceholder(),
    Object? history = const $CopyWithPlaceholder(),
  }) {
    return LiveInputStatus(
      current: current == const $CopyWithPlaceholder()
          ? _value.current
          // ignore: cast_nullable_to_non_nullable
          : current as LiveInputStatusLog?,
      history: history == const $CopyWithPlaceholder()
          ? _value.history
          // ignore: cast_nullable_to_non_nullable
          : history as List<LiveInputStatusLog>?,
    );
  }
}

extension $LiveInputStatusCopyWith on LiveInputStatus {
  /// Returns a callable class that can be used as follows: `instanceOfLiveInputStatus.copyWith(...)`.
  _$LiveInputStatusCWProxy get copyWith => _$LiveInputStatusCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveInputStatus _$LiveInputStatusFromJson(Map<String, dynamic> json) =>
    LiveInputStatus(
      current: json['current'] == null
          ? null
          : LiveInputStatusLog.fromJson(
              json['current'] as Map<String, dynamic>),
      history: (json['history'] as List<dynamic>?)
          ?.map((e) => LiveInputStatusLog.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LiveInputStatusToJson(LiveInputStatus instance) =>
    <String, dynamic>{
      'current': instance.current,
      'history': instance.history,
    };
