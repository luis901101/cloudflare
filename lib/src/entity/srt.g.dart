// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'srt.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SRTCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// SRT(...).copyWith(id: 12, name: "My name")
  /// ````
  SRT call({
    String? url,
    String? streamId,
    String? passphrase,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSRT.copyWith(...)`.
class _$SRTCWProxyImpl implements _$SRTCWProxy {
  const _$SRTCWProxyImpl(this._value);

  final SRT _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// SRT(...).copyWith(id: 12, name: "My name")
  /// ````
  SRT call({
    Object? url = const $CopyWithPlaceholder(),
    Object? streamId = const $CopyWithPlaceholder(),
    Object? passphrase = const $CopyWithPlaceholder(),
  }) {
    return SRT(
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String?,
      streamId: streamId == const $CopyWithPlaceholder()
          ? _value.streamId
          // ignore: cast_nullable_to_non_nullable
          : streamId as String?,
      passphrase: passphrase == const $CopyWithPlaceholder()
          ? _value.passphrase
          // ignore: cast_nullable_to_non_nullable
          : passphrase as String?,
    );
  }
}

extension $SRTCopyWith on SRT {
  /// Returns a callable class that can be used as follows: `instanceOfSRT.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$SRTCWProxy get copyWith => _$SRTCWProxyImpl(this);
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
