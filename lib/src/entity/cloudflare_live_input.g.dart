// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloudflare_live_input.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CloudflareLiveInputCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// CloudflareLiveInput(...).copyWith(id: 12, name: "My name")
  /// ````
  CloudflareLiveInput call({
    DateTime? created,
    String? id,
    Map<dynamic, dynamic>? meta,
    DateTime? modified,
    LiveInputRecording? recording,
    RTMPS? rtmps,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCloudflareLiveInput.copyWith(...)`.
class _$CloudflareLiveInputCWProxyImpl implements _$CloudflareLiveInputCWProxy {
  final CloudflareLiveInput _value;

  const _$CloudflareLiveInputCWProxyImpl(this._value);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// CloudflareLiveInput(...).copyWith(id: 12, name: "My name")
  /// ````
  CloudflareLiveInput call({
    Object? created = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? meta = const $CopyWithPlaceholder(),
    Object? modified = const $CopyWithPlaceholder(),
    Object? recording = const $CopyWithPlaceholder(),
    Object? rtmps = const $CopyWithPlaceholder(),
  }) {
    return CloudflareLiveInput(
      created: created == const $CopyWithPlaceholder()
          ? _value.created
          // ignore: cast_nullable_to_non_nullable
          : created as DateTime?,
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      meta: meta == const $CopyWithPlaceholder()
          ? _value.meta
          // ignore: cast_nullable_to_non_nullable
          : meta as Map<dynamic, dynamic>?,
      modified: modified == const $CopyWithPlaceholder()
          ? _value.modified
          // ignore: cast_nullable_to_non_nullable
          : modified as DateTime?,
      recording: recording == const $CopyWithPlaceholder()
          ? _value.recording
          // ignore: cast_nullable_to_non_nullable
          : recording as LiveInputRecording?,
      rtmps: rtmps == const $CopyWithPlaceholder()
          ? _value.rtmps
          // ignore: cast_nullable_to_non_nullable
          : rtmps as RTMPS?,
    );
  }
}

extension $CloudflareLiveInputCopyWith on CloudflareLiveInput {
  /// Returns a callable class that can be used as follows: `instanceOfclass CloudflareLiveInput extends Jsonable<CloudflareLiveInput>.name.copyWith(...)`.
  _$CloudflareLiveInputCWProxy get copyWith =>
      _$CloudflareLiveInputCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CloudflareLiveInput _$CloudflareLiveInputFromJson(Map<String, dynamic> json) =>
    CloudflareLiveInput(
      id: json['uid'] as String?,
      meta: json['meta'] as Map<String, dynamic>?,
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      modified: json['modified'] == null
          ? null
          : DateTime.parse(json['modified'] as String),
      rtmps: json['rtmps'] == null
          ? null
          : RTMPS.fromJson(json['rtmps'] as Map<String, dynamic>),
      recording: json['recording'] == null
          ? null
          : LiveInputRecording.fromJson(
              json['recording'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CloudflareLiveInputToJson(CloudflareLiveInput instance) {
  final val = <String, dynamic>{
    'uid': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('meta', instance.meta);
  val['created'] = instance.created.toIso8601String();
  val['modified'] = instance.modified.toIso8601String();
  val['rtmps'] = instance.rtmps;
  val['recording'] = instance.recording;
  return val;
}
