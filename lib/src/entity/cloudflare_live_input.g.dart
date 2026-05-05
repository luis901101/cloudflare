// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloudflare_live_input.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

/// This Extension on [CloudflareLiveInput] is to generate the code for a copyWith(...) function.
extension $CloudflareLiveInputCopyWithExtension on CloudflareLiveInput {
  CloudflareLiveInput copyWith({
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
  }) {
    return CloudflareLiveInput(
      id: id ?? this.id,
      meta: ((meta?.isNotEmpty ?? false) ? meta : null) ?? this.meta,
      created: created ?? this.created,
      modified: modified ?? this.modified,
      rtmps: rtmps ?? this.rtmps,
      rtmpsPlayback: rtmpsPlayback ?? this.rtmpsPlayback,
      srt: srt ?? this.srt,
      srtPlayback: srtPlayback ?? this.srtPlayback,
      recording: recording ?? this.recording,
      status: status ?? this.status,
    );
  }
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
              json['recording'] as Map<String, dynamic>,
            ),
      status: json['status'] == null
          ? null
          : LiveInputStatus.fromJson(json['status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CloudflareLiveInputToJson(
  CloudflareLiveInput instance,
) => <String, dynamic>{
  'uid': instance.id,
  'meta': ?instance.meta,
  'created': instance.created.toIso8601String(),
  'modified': instance.modified.toIso8601String(),
  'rtmps': instance.rtmps,
  'rtmpsPlayback': instance.rtmpsPlayback,
  'srt': instance.srt,
  'srtPlayback': instance.srtPlayback,
  'recording': instance.recording,
  'status': ?instance.status,
};
