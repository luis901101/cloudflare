// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_nft.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

/// This Extension on [MediaNFT] is to generate the code for a copyWith(...) function.
extension $MediaNFTCopyWithExtension on MediaNFT {
  MediaNFT copyWith({String? contract, int? token}) {
    return MediaNFT(
      contract: contract ?? this.contract,
      token: token ?? this.token,
    );
  }
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
