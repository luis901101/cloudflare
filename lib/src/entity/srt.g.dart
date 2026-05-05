// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'srt.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

/// This Extension on [SRT] is to generate the code for a copyWith(...) function.
extension $SRTCopyWithExtension on SRT {
  SRT copyWith({String? url, String? streamId, String? passphrase}) {
    return SRT(
      url: url ?? this.url,
      streamId: streamId ?? this.streamId,
      passphrase: passphrase ?? this.passphrase,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SRT _$SRTFromJson(Map<String, dynamic> json) => SRT(
  url: json['url'] as String?,
  streamId: json['streamId'] as String?,
  passphrase: json['passphrase'] as String?,
);

Map<String, dynamic> _$SRTToJson(SRT instance) => <String, dynamic>{
  'url': instance.url,
  'streamId': instance.streamId,
  'passphrase': instance.passphrase,
};
