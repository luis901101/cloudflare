import 'package:cloudflare/src/enumerators/recording_mode.dart';
import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'live_input_recording.g.dart';

/// Control recording the input to a Stream video. Behavior depends on the mode.
/// In most cases, the video will initially be viewable as a live video and
/// transition to on-demand after a condition is satisfied.
@JsonSerializable()
class LiveInputRecording extends Jsonable<LiveInputRecording> {

  /// Specifies the recording behavior of the live input. 'off' indicates no
  /// recording will be made. 'automatic' indicates a recording should be made,
  /// and that the recording should transition to on-demand after Stream Live
  /// stops receiving input.
  ///
  /// Default value: off
  /// Valid values: off, automatic
  ///
  /// e.g: "automatic"
  final RecordingMode mode;

  /// Indicates whether videos created using this Live Input has the
  /// requireSignedURLs property set. This enforces access controls on any
  /// video created with the live input.
  ///
  /// Default value: false
  final bool requireSignedURLs;

  /// List of which origins should be allowed to display videos created with
  /// this input. Enter allowed origin domains in an array and use * for
  /// wildcard subdomains. Empty array will allow the video to be viewed on any
  /// origin.
  ///
  /// e.g: ["example.com"]
  List<String> allowedOrigins;

  /// Duration a live input configured in 'automatic' mode waits before
  /// determining a recording should transition from live to on-demand. A value
  /// of 0 indicates the platform default should be used. 0 is recommended for
  /// most use cases.
  ///
  /// Default value: 0
  int timeoutSeconds;


  LiveInputRecording({
    RecordingMode? mode,
    bool? requireSignedURLs,
    List<String>? allowedOrigins,
    int? timeoutSeconds,
  }) :
    mode = mode ?? RecordingMode.automatic,
    requireSignedURLs = requireSignedURLs ?? false,
    allowedOrigins = allowedOrigins ?? [],
    timeoutSeconds = timeoutSeconds ?? 0
  ;

  @override
  Map<String, dynamic> toJson() => _$LiveInputRecordingToJson(this);

  @override
  LiveInputRecording? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? LiveInputRecording.fromJson(json) : null;

  factory LiveInputRecording.fromJson(Map<String, dynamic> json) =>
      _$LiveInputRecordingFromJson(json);
}
