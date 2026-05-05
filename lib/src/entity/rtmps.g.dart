// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rtmps.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

/// This Extension on [RTMPS] is to generate the code for a copyWith(...) function.
extension $RTMPSCopyWithExtension on RTMPS {
  RTMPS copyWith({String? url, String? streamKey}) {
    return RTMPS(url: url ?? this.url, streamKey: streamKey ?? this.streamKey);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RTMPS _$RTMPSFromJson(Map<String, dynamic> json) =>
    RTMPS(url: json['url'] as String?, streamKey: json['streamKey'] as String?);

Map<String, dynamic> _$RTMPSToJson(RTMPS instance) => <String, dynamic>{
  'url': instance.url,
  'streamKey': instance.streamKey,
};
