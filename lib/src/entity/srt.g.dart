// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'srt.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SRTCWProxy {
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// SRT(...).copyWith(id: 12, name: "My name")
  /// ```
  SRT call({String? url, String? streamId, String? passphrase});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfSRT.copyWith(...)`.
class _$SRTCWProxyImpl implements _$SRTCWProxy {
  const _$SRTCWProxyImpl(this._value);

  final SRT _value;

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// SRT(...).copyWith(id: 12, name: "My name")
  /// ```
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
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfSRT.copyWith(...)`.
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
