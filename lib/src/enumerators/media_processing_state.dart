import 'package:json_annotation/json_annotation.dart';

enum MediaProcessingState {
  @JsonValue('pendingupload')
  pendingUpload,
  downloading,
  queued,
  @JsonValue('inprogress')
  inProgress,
  @JsonValue('live-inprogress')
  liveInProgress,
  ready,
  error,
  unknown,
}
