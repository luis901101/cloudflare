import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cloudflare_image.g.dart';

/// Official documentation here:
/// API docs: https://api.cloudflare.com/#cloudflare-images-properties
/// Developer Cloudflare docs: https://developers.cloudflare.com/images/cloudflare-images
@JsonSerializable(includeIfNull: false)
class CloudflareImage extends Jsonable<CloudflareImage>{

  static const imageDeliveryUrl = 'https://imagedelivery.net';

  /// Image unique identifier
  ///
  /// e.g: "ZxR0pLaXRldlBtaFhhO2FiZGVnaA"
  ///
  /// max length: 32
  /// read only
  String id;

  /// Image file name
  ///
  /// e.g: "avatar.png"
  ///
  /// max length: 32
  /// read only
  String? filename;


  /// User modifiable key-value store.
  /// Can be used for keeping references to another system of record for
  /// managing images. Metadata must not exceed 1024 bytes
  ///
  /// {
  ///   "meta": "metaID"
  /// }
  Map<String, dynamic>?  meta;

  /// Indicates whether the image can be a accessed only using it's UID.
  /// If set to true, a signed token needs to be generated with a signing key
  /// to view the image.
  ///
  /// e.g: false
  ///
  /// default value: false
  /// valid values: (true,false)
  bool requireSignedURLs;

  /// List specifying available variants for an image.
  ///
  /// e.g:
  /// [
  ///   "https://imagedelivery.net/MTt4OTd0b0w5aj/ZxR0pLaXRldlBtaFhhO2FiZGVnaA/thumbnail",
  ///   "https://imagedelivery.net/MTt4OTd0b0w5aj/ZxR0pLaXRldlBtaFhhO2FiZGVnaA/hero",
  ///   "https://imagedelivery.net/MTt4OTd0b0w5aj/ZxR0pLaXRldlBtaFhhO2FiZGVnaA/original"
  /// ]
  ///
  /// read only
  List<String> variants;

  /// When the media item was uploaded.
  ///
  /// e.g: "2014-01-02T02:20:00Z"
  ///
  /// read only
  DateTime uploaded;

  String? _baseUrl;

  CloudflareImage({
    String? id,
    this.filename,
    this.meta,
    bool? requireSignedURLs,
    List<String>? variants,
    DateTime? uploaded,
  }) :
    id = id ?? '',
    requireSignedURLs = requireSignedURLs ?? false,
    variants = variants ?? [],
    uploaded = uploaded ?? DateTime.now()
  ;

  factory CloudflareImage.fromUrl(String url) {
    final split = url.replaceAll('$imageDeliveryUrl/', '').split('/');
    String? imageDeliveryId = split.isNotEmpty ? split[0] : null,
        imageId = split.length > 1 ? split[1] : null;
    if(!url.startsWith(imageDeliveryUrl) || imageDeliveryId == null || imageId == null) {
      throw Exception('Invalid CloudflareImage from url');
    }
    return CloudflareImage(
      id: imageDeliveryId,
      variants: [url],
    );
  }

  String get baseUrl => _baseUrl ?? (_baseUrl = variants.isNotEmpty ? variants[0] : '');

  @override
  bool operator ==(Object other) {
    if(other is! CloudflareImage) return false;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  Map<String, dynamic> toJson() => _$CloudflareImageToJson(this);
  @override
  CloudflareImage? fromJsonMap(Map<String, dynamic>? json) => json != null ? CloudflareImage.fromJson(json) : null;
  factory CloudflareImage.fromJson(Map<String, dynamic> json) =>
      _$CloudflareImageFromJson(json);


}
