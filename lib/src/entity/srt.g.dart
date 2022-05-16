// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'srt.dart';

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
