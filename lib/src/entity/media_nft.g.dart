// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_nft.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MediaNFTCWProxy {
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// MediaNFT(...).copyWith(id: 12, name: "My name")
  /// ```
  MediaNFT call({String? contract, int? token});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfMediaNFT.copyWith(...)`.
class _$MediaNFTCWProxyImpl implements _$MediaNFTCWProxy {
  const _$MediaNFTCWProxyImpl(this._value);

  final MediaNFT _value;

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored.
  ///
  /// Example:
  /// ```dart
  /// MediaNFT(...).copyWith(id: 12, name: "My name")
  /// ```
  MediaNFT call({
    Object? contract = const $CopyWithPlaceholder(),
    Object? token = const $CopyWithPlaceholder(),
  }) {
    return MediaNFT(
      contract: contract == const $CopyWithPlaceholder()
          ? _value.contract
          // ignore: cast_nullable_to_non_nullable
          : contract as String?,
      token: token == const $CopyWithPlaceholder()
          ? _value.token
          // ignore: cast_nullable_to_non_nullable
          : token as int?,
    );
  }
}

extension $MediaNFTCopyWith on MediaNFT {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfMediaNFT.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$MediaNFTCWProxy get copyWith => _$MediaNFTCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaNFT _$MediaNFTFromJson(Map<String, dynamic> json) => MediaNFT(
  contract: json['contract'] as String?,
  token: (json['token'] as num?)?.toInt(),
);

Map<String, dynamic> _$MediaNFTToJson(MediaNFT instance) => <String, dynamic>{
  'contract': ?instance.contract,
  'token': ?instance.token,
};
