import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'media_nft.g.dart';

@JsonSerializable()
class MediaNFT extends Jsonable<MediaNFT> {

  /// ERC-721 compatible contract address
  ///
  /// read only
  ///
  /// min length: 42
  /// max length: 42
  ///
  /// e.g: "0x57f1887a8bf19b14fc0d912b9b2acc9af147ea85"
  final String? contract;

  /// Token ID for the NFT
  ///
  /// read only
  ///
  /// e.g: 5
  final int? token;

  MediaNFT({
    this.contract,
    this.token,
  });

  @override
  Map<String, dynamic> toJson() => _$MediaNFTToJson(this);

  @override
  MediaNFT? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? MediaNFT.fromJson(json) : null;

  factory MediaNFT.fromJson(Map<String, dynamic> json) =>
      _$MediaNFTFromJson(json);
}
