import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'live_input_output.g.dart';

/// LiveInputOutput is the response object of associated outputs to a live input
@CopyWith()
@JsonSerializable()
class LiveInputOutput extends Jsonable<LiveInputOutput> {
  /// Output id.
  @JsonKey(readValue: Jsonable.idReadValue)
  final String id;

  /// The URL an output will re-stream to
  ///
  /// e.g: "rtmp://a.rtmp.youtube.com/live2"
  final String url;

  /// The streamKey used to authenticate against an output's target
  ///
  /// e.g: "uzya-f19y-g2g9-a2ee-51j2"
  final String streamKey;

  const LiveInputOutput({
    String? id,
    String? url,
    String? streamKey,
  })  : id = id ?? '',
        url = url ?? '',
        streamKey = streamKey ?? '';

  @override
  Map<String, dynamic> toJson() => _$LiveInputOutputToJson(this);

  @override
  LiveInputOutput? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? LiveInputOutput.fromJson(json) : null;

  factory LiveInputOutput.fromJson(Map<String, dynamic> json) =>
      _$LiveInputOutputFromJson(json);
}
