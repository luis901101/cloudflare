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
    String? id,
    Map<dynamic, dynamic>? meta,
    DateTime? created,
    DateTime? modified,
    RTMPS? rtmps,
    RTMPS? rtmpsPlayback,
    SRT? srt,
    SRT? srtPlayback,
    LiveInputRecording? recording,
    LiveInputStatus? status,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCloudflareLiveInput.copyWith(...)`.
class _$CloudflareLiveInputCWProxyImpl implements _$CloudflareLiveInputCWProxy {
  const _$CloudflareLiveInputCWProxyImpl(this._value);

  final CloudflareLiveInput _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// CloudflareLiveInput(...).copyWith(id: 12, name: "My name")
  /// ````
  CloudflareLiveInput call({
    Object? id = const $CopyWithPlaceholder(),
    Object? meta = const $CopyWithPlaceholder(),
    Object? created = const $CopyWithPlaceholder(),
    Object? modified = const $CopyWithPlaceholder(),
    Object? rtmps = const $CopyWithPlaceholder(),
    Object? rtmpsPlayback = const $CopyWithPlaceholder(),
    Object? srt = const $CopyWithPlaceholder(),
    Object? srtPlayback = const $CopyWithPlaceholder(),
    Object? recording = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return CloudflareLiveInput(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      meta: meta == const $CopyWithPlaceholder()
          ? _value.meta
          // ignore: cast_nullable_to_non_nullable
          : meta as Map<dynamic, dynamic>?,
      created: created == const $CopyWithPlaceholder()
          ? _value.created
          // ignore: cast_nullable_to_non_nullable
          : created as DateTime?,
      modified: modified == const $CopyWithPlaceholder()
          ? _value.modified
          // ignore: cast_nullable_to_non_nullable
          : modified as DateTime?,
      rtmps: rtmps == const $CopyWithPlaceholder()
          ? _value.rtmps
          // ignore: cast_nullable_to_non_nullable
          : rtmps as RTMPS?,
      rtmpsPlayback: rtmpsPlayback == const $CopyWithPlaceholder()
          ? _value.rtmpsPlayback
          // ignore: cast_nullable_to_non_nullable
          : rtmpsPlayback as RTMPS?,
      srt: srt == const $CopyWithPlaceholder()
          ? _value.srt
          // ignore: cast_nullable_to_non_nullable
          : srt as SRT?,
      srtPlayback: srtPlayback == const $CopyWithPlaceholder()
          ? _value.srtPlayback
          // ignore: cast_nullable_to_non_nullable
          : srtPlayback as SRT?,
      recording: recording == const $CopyWithPlaceholder()
          ? _value.recording
          // ignore: cast_nullable_to_non_nullable
          : recording as LiveInputRecording?,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as LiveInputStatus?,
    );
  }
}

extension $CloudflareLiveInputCopyWith on CloudflareLiveInput {
  /// Returns a callable class that can be used as follows: `instanceOfCloudflareLiveInput.copyWith(...)`.
  // ignore: library_private_types_in_public_api
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
      rtmpsPlayback: json['rtmpsPlayback'] == null
          ? null
          : RTMPS.fromJson(json['rtmpsPlayback'] as Map<String, dynamic>),
      srt: json['srt'] == null
          ? null
          : SRT.fromJson(json['srt'] as Map<String, dynamic>),
      srtPlayback: json['srtPlayback'] == null
          ? null
          : SRT.fromJson(json['srtPlayback'] as Map<String, dynamic>),
      recording: json['recording'] == null
          ? null
          : LiveInputRecording.fromJson(
              json['recording'] as Map<String, dynamic>),
      status: json['status'] == null
          ? null
          : LiveInputStatus.fromJson(json['status'] as Map<String, dynamic>),
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
  val['rtmpsPlayback'] = instance.rtmpsPlayback;
  val['srt'] = instance.srt;
  val['srtPlayback'] = instance.srtPlayback;
  val['recording'] = instance.recording;
  writeNotNull('status', instance.status);
  return val;
}
