import 'package:cloudflare/src/entity/live_input_recording.dart';
import 'package:cloudflare/src/entity/rtmps.dart';
import 'package:cloudflare/src/entity/srt.dart';
import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:cloudflare/src/utils/params.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cloudflare_live_input.g.dart';

/// Official documentation here:
/// API docs: https://api.cloudflare.com/#stream-live-inputs-properties
/// Developer Cloudflare docs: https://developers.cloudflare.com/stream/stream-live/
@CopyWith(skipFields: true)
@JsonSerializable(includeIfNull: false)
class CloudflareLiveInput extends Jsonable<CloudflareLiveInput> {

  /// Live input unique identifier
  /// max length: 32
  ///
  /// read only
  ///
  /// e.g: "66be4bf738797e01e1fca35a7bdecdcd"
  @JsonKey(name: Params.uid) final String id;

  /// User modifiable key-value store. Can be used for keeping references
  /// to another system of record for managing videos.
  Map? meta;

  /// When the live input was created.
  /// Using  ISO 8601 ZonedDateTime
  ///
  /// read only
  ///
  /// e.g: "2014-01-02T02:20:00Z"
  final DateTime created;

  /// When the live input was last modified.
  /// Using  ISO 8601 ZonedDateTime
  ///
  /// read only
  ///
  /// e.g: "2014-01-02T02:20:00Z"
  final DateTime modified;

  /// An object that contains RTMPS url and key
  final RTMPS rtmps;
  final RTMPS rtmpsPlayback;

  /// An object that contains SRT url, streamID and passphrase
  final SRT srt;
  final SRT srtPlayback;

  /// Control recording the input to a Stream video. Behavior depends on the
  /// mode. In most cases, the video will initially be viewable as a live video
  /// and transition to on-demand after a condition is satisfied.
  final LiveInputRecording recording;

  CloudflareLiveInput({
    String? id,
    this.meta,
    DateTime? created,
    DateTime? modified,
    RTMPS? rtmps,
    RTMPS? rtmpsPlayback,
    SRT? srt,
    SRT? srtPlayback,
    LiveInputRecording? recording,
  }) :
    id = id ?? '',
    created = created ?? DateTime.now(),
    modified = modified ?? DateTime.now(),
    rtmps = rtmps ?? RTMPS(),
    rtmpsPlayback = rtmpsPlayback ?? RTMPS(),
    srt = srt ?? SRT(),
    srtPlayback = srtPlayback ?? SRT(),
    recording = recording ?? LiveInputRecording()
  ;

  @override
  bool operator ==(Object other) {
    if (other is! CloudflareLiveInput) return false;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  Map<String, dynamic> toJson() => _$CloudflareLiveInputToJson(this);
  @override
  CloudflareLiveInput? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? CloudflareLiveInput.fromJson(json) : null;
  factory CloudflareLiveInput.fromJson(Map<String, dynamic> json) =>
      _$CloudflareLiveInputFromJson(json);
}
