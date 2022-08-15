// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_nft.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MediaNFTCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// MediaNFT(...).copyWith(id: 12, name: "My name")
  /// ````
  MediaNFT call({
    String? contract,
    int? token,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMediaNFT.copyWith(...)`.
class _$MediaNFTCWProxyImpl implements _$MediaNFTCWProxy {
  final MediaNFT _value;

  const _$MediaNFTCWProxyImpl(this._value);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// MediaNFT(...).copyWith(id: 12, name: "My name")
  /// ````
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
  /// Returns a callable class that can be used as follows: `instanceOfMediaNFT.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$MediaNFTCWProxy get copyWith => _$MediaNFTCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaNFT _$MediaNFTFromJson(Map<String, dynamic> json) => MediaNFT(
      contract: json['contract'] as String?,
      token: json['token'] as int?,
    );

Map<String, dynamic> _$MediaNFTToJson(MediaNFT instance) => <String, dynamic>{
      'contract': instance.contract,
      'token': instance.token,
    };
