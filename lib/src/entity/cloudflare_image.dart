import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cloudflare_image.g.dart';

/// Official documentation here:
/// API docs: https://api.cloudflare.com/#cloudflare-images-properties
/// Developer Cloudflare docs: https://developers.cloudflare.com/images/cloudflare-images
@JsonSerializable(includeIfNull: false)
class CloudflareImage extends Jsonable<CloudflareImage> {
  static const imageDeliveryUrl = 'https://imagedelivery.net';

  /// Image unique identifier
  ///
  /// max length: 32
  /// read only
  ///
  /// e.g: "ZxR0pLaXRldlBtaFhhO2FiZGVnaA"
  final String id;

  /// Image file name
  ///
  /// max length: 32
  /// read only
  ///
  /// e.g: "avatar.png"
  final String? filename;

  /// User modifiable key-value store.
  /// Can be used for keeping references to another system of record for
  /// managing images. Metadata must not exceed 1024 bytes
  ///
  /// {
  ///   "meta": "metaID"
  /// }
  Map? meta;

  /// Indicates whether the image can be a accessed only using it's UID.
  /// If set to true, a signed token needs to be generated with a signing key
  /// to view the image.
  ///
  /// default value: false
  /// valid values: (true,false)
  ///
  /// e.g: false
  bool requireSignedURLs;

  /// List specifying available variants for an image.
  ///
  /// read only
  ///
  /// e.g:
  /// [
  ///   "https://imagedelivery.net/MTt4OTd0b0w5aj/ZxR0pLaXRldlBtaFhhO2FiZGVnaA/thumbnail",
  ///   "https://imagedelivery.net/MTt4OTd0b0w5aj/ZxR0pLaXRldlBtaFhhO2FiZGVnaA/hero",
  ///   "https://imagedelivery.net/MTt4OTd0b0w5aj/ZxR0pLaXRldlBtaFhhO2FiZGVnaA/original"
  /// ]
  final List<String> variants;

  /// When the media item was uploaded.
  /// Using  ISO 8601 ZonedDateTime
  ///
  /// read only
  ///
  /// e.g: "2014-01-02T02:20:00Z"
  final DateTime uploaded;

  /// Whether this is a pending direct upload image or not
  ///
  /// Default value: false
  /// e.g: false
  final bool draft;

  @JsonKey(ignore: true) String? _firstVariant;

  CloudflareImage({
    String? id,
    this.filename,
    this.meta,
    bool? requireSignedURLs,
    List<String>? variants,
    DateTime? uploaded,
    bool? draft,
  })  : id = id ?? '',
        requireSignedURLs = requireSignedURLs ?? false,
        variants = variants ?? [],
        uploaded = uploaded ?? DateTime.now(),
        draft = draft ?? false;

  static Map<String, String> _dataFromUrl(String url) {
    final split = url.replaceAll('$imageDeliveryUrl/', '').split('/');
    String? imageDeliveryId = split.isNotEmpty ? split[0] : null,
        imageId = split.length > 1 ? split[1] : null,
        variantName = split.length > 2 ? split[2] : null;
    if (!url.startsWith(imageDeliveryUrl) ||
        imageDeliveryId == null ||
        imageId == null ||
        variantName == null) {
      throw Exception('Invalid CloudflareImage from url');
    }
    return {
      'imageDeliveryId': imageDeliveryId,
      'imageId': imageId,
      'variantName': variantName,
    };
  }

  factory CloudflareImage.fromUrl(String url) {
    final data = _dataFromUrl(url);
    return CloudflareImage(
      id: data['imageId'],
      variants: [url],
    );
  }

  static String variantNameFromUrl(String url) {
    final data = _dataFromUrl(url);
    return data['variantName']!;
  }

  String get firstVariant =>
      _firstVariant ?? (_firstVariant = variants.isNotEmpty ? variants[0] : '');

  @override
  bool operator ==(Object other) {
    if (other is! CloudflareImage) return false;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  Map<String, dynamic> toJson() => _$CloudflareImageToJson(this);
  @override
  CloudflareImage? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? CloudflareImage.fromJson(json) : null;
  factory CloudflareImage.fromJson(Map<String, dynamic> json) =>
      _$CloudflareImageFromJson(json);
}
