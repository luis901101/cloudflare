// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_input_status.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LiveInputStatusCWProxy {
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// LiveInputStatus(...).copyWith(id: 12, name: "My name")
  /// ```
  LiveInputStatus call({
    LiveInputStatusLog? current,
    List<LiveInputStatusLog>? history,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfLiveInputStatus.copyWith(...)`.
class _$LiveInputStatusCWProxyImpl implements _$LiveInputStatusCWProxy {
  const _$LiveInputStatusCWProxyImpl(this._value);

  final LiveInputStatus _value;

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// LiveInputStatus(...).copyWith(id: 12, name: "My name")
  /// ```
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
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfLiveInputStatus.copyWith(...)`.
  // ignore: library_private_types_in_public_api
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
