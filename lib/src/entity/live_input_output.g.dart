// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_input_output.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LiveInputOutputCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// LiveInputOutput(...).copyWith(id: 12, name: "My name")
  /// ````
  LiveInputOutput call({
    String? id,
    String? streamKey,
    String? url,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLiveInputOutput.copyWith(...)`.
class _$LiveInputOutputCWProxyImpl implements _$LiveInputOutputCWProxy {
  final LiveInputOutput _value;

  const _$LiveInputOutputCWProxyImpl(this._value);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// LiveInputOutput(...).copyWith(id: 12, name: "My name")
  /// ````
  LiveInputOutput call({
    Object? id = const $CopyWithPlaceholder(),
    Object? streamKey = const $CopyWithPlaceholder(),
    Object? url = const $CopyWithPlaceholder(),
  }) {
    return LiveInputOutput(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      streamKey: streamKey == const $CopyWithPlaceholder()
          ? _value.streamKey
          // ignore: cast_nullable_to_non_nullable
          : streamKey as String?,
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String?,
    );
  }
}

extension $LiveInputOutputCopyWith on LiveInputOutput {
  /// Returns a callable class that can be used as follows: `instanceOfLiveInputOutput.copyWith(...)`.
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
