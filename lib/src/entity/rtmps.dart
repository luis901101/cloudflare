import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rtmps.g.dart';

@JsonSerializable()
class RTMPS extends Jsonable<RTMPS> {

  /// The URL the live input can be sent RTMPS data
  ///
  /// e.g: "rtmps://live.cloudflare.com:443/live/"
  final String url;

  /// The stream key used to authenticate received RTMPS data
  ///
  /// e.g: "MjE2OTAxNzQyMjQxNDkyNDYyNTAxNjc3MzE3NzY4MjAwMTYx
  final String streamKey;


  RTMPS({
    String? url,
    String? streamKey,
  }) :
      url = url ?? '',
      streamKey = streamKey ?? ''
  ;

  @override
  Map<String, dynamic> toJson() => _$RTMPSToJson(this);

  @override
  RTMPS? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? RTMPS.fromJson(json) : null;

  factory RTMPS.fromJson(Map<String, dynamic> json) =>
      _$RTMPSFromJson(json);
}
