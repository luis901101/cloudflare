// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_input_output.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LiveInputOutputCWProxy {
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// LiveInputOutput(...).copyWith(id: 12, name: "My name")
  /// ```
  LiveInputOutput call({String? id, String? url, String? streamKey});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfLiveInputOutput.copyWith(...)`.
class _$LiveInputOutputCWProxyImpl implements _$LiveInputOutputCWProxy {
  const _$LiveInputOutputCWProxyImpl(this._value);

  final LiveInputOutput _value;

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// LiveInputOutput(...).copyWith(id: 12, name: "My name")
  /// ```
  LiveInputOutput call({
    Object? id = const $CopyWithPlaceholder(),
    Object? url = const $CopyWithPlaceholder(),
    Object? streamKey = const $CopyWithPlaceholder(),
  }) {
    return LiveInputOutput(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String?,
      streamKey: streamKey == const $CopyWithPlaceholder()
          ? _value.streamKey
          // ignore: cast_nullable_to_non_nullable
          : streamKey as String?,
    );
  }
}

extension $LiveInputOutputCopyWith on LiveInputOutput {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfLiveInputOutput.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$LiveInputOutputCWProxy get copyWith => _$LiveInputOutputCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveInputOutput _$LiveInputOutputFromJson(Map<String, dynamic> json) =>
    LiveInputOutput(
      id: Jsonable.idReadValue(json, 'id') as String?,
      url: json['url'] as String?,
      streamKey: json['streamKey'] as String?,
    );

Map<String, dynamic> _$LiveInputOutputToJson(LiveInputOutput instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'streamKey': instance.streamKey,
    };
