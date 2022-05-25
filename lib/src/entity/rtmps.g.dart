// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rtmps.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RTMPSCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// RTMPS(...).copyWith(id: 12, name: "My name")
  /// ````
  RTMPS call({
    String? streamKey,
    String? url,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRTMPS.copyWith(...)`.
class _$RTMPSCWProxyImpl implements _$RTMPSCWProxy {
  final RTMPS _value;

  const _$RTMPSCWProxyImpl(this._value);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// RTMPS(...).copyWith(id: 12, name: "My name")
  /// ````
  RTMPS call({
    Object? streamKey = const $CopyWithPlaceholder(),
    Object? url = const $CopyWithPlaceholder(),
  }) {
    return RTMPS(
      streamKey: streamKey == const $CopyWithPlaceholder()
          ? _value.streamKey
          // ignore: cast_nullable_to_non_nullable
          : streamKey as String?,
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String?,
    );
  }
}

extension $RTMPSCopyWith on RTMPS {
  /// Returns a callable class that can be used as follows: `instanceOfRTMPS.copyWith(...)`.
  _$RTMPSCWProxy get copyWith => _$RTMPSCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RTMPS _$RTMPSFromJson(Map<String, dynamic> json) => RTMPS(
      url: json['url'] as String?,
      streamKey: json['streamKey'] as String?,
    );

Map<String, dynamic> _$RTMPSToJson(RTMPS instance) => <String, dynamic>{
      'url': instance.url,
      'streamKey': instance.streamKey,
    };
