// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_input_output.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

/// This Extension on [LiveInputOutput] is to generate the code for a copyWith(...) function.
extension $LiveInputOutputCopyWithExtension on LiveInputOutput {
  LiveInputOutput copyWith({String? id, String? url, String? streamKey}) {
    return LiveInputOutput(
      id: id ?? this.id,
      url: url ?? this.url,
      streamKey: streamKey ?? this.streamKey,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveInputOutput _$LiveInputOutputFromJson(Map<String, dynamic> json) =>
    LiveInputOutput(
      id: Jsonable.idReadValue(json, 'id') as String?,
      url: json['url'] as String?,
      streamKey: json['streamKey'] as String?,
    );

Map<String, dynamic> _$LiveInputOutputToJson(LiveInputOutput instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'streamKey': instance.streamKey,
    };
