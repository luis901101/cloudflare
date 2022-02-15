import 'package:cloudflare/src/enumerators/video_processing_state.dart';
import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'video_status.g.dart';

/// Object specifying more fine-grained status for this video item.
/// If "state" is "inprogress" or "error", "step" will be one of "encoding" or
/// "manifest". When "state" is "inprogress", "pctComplete" will be a number
/// between 0 and 100 indicating the approximate percent of that step that has
/// been completed. If the "state" is "error", "errorReasonCode" and
/// "errorReasonText" will contain additional details.
@JsonSerializable()
class VideoStatus extends Jsonable<VideoStatus> {
  /// Specifies the processing status of the video.
  VideoProcessingState state;

  /// Indicates the percent upload completed of the entire upload in bytes.
  /// The value must be a non-negative integer.
  ///
  /// min value:0
  /// max value:100
  int pctComplete;

  /// Provides an error code on why this video failed to encode.
  /// Empty if the state is not in "error". This field should be preferred
  /// for programmatic use.
  ///
  /// e.g: "ERR_NON_VIDEO"
  String? errorReasonCode;

  /// Provides a reason in English on why this video failed to encode.
  /// Empty if the state is not in "error".
  ///
  /// e.g: "The file was not recognized as a valid video file."
  String? errorReasonText;

  VideoStatus({
    VideoProcessingState? state,
    int? pctComplete,
    this.errorReasonCode,
    this.errorReasonText,
  })  : state = state ?? VideoProcessingState.inprogress,
        pctComplete = pctComplete ?? 0;

  @override
  Map<String, dynamic> toJson() => _$VideoStatusToJson(this);

  @override
  VideoStatus? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? VideoStatus.fromJson(json) : null;

  factory VideoStatus.fromJson(Map<String, dynamic> json) =>
      _$VideoStatusFromJson(json);
}
