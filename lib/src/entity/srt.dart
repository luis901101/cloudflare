import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'srt.g.dart';

/// Support for SRT(Secure Reliable Transfer)
///
/// Check here: https://blog.cloudflare.com/stream-now-supports-srt-as-a-drop-in-replacement-for-rtmp/
@CopyWith()
@JsonSerializable()
class SRT extends Jsonable<SRT> {
  /// The URL the live input can be sent SRT data
  ///
  /// e.g: "srt://live.cloudflare.com:778/live/"
  final String url;
  final String streamId;
  final String passphrase;

  SRT({String? url, String? streamId, String? passphrase})
    : url = url ?? '',
      streamId = streamId ?? '',
      passphrase = passphrase ?? '';

  @override
  Map<String, dynamic> toJson() => _$SRTToJson(this);

  @override
  SRT? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? SRT.fromJson(json) : null;

  factory SRT.fromJson(Map<String, dynamic> json) => _$SRTFromJson(json);
}
