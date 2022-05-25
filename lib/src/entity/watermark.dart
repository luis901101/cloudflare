import 'package:cloudflare/src/enumerators/watermark_position.dart';
import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:cloudflare/src/utils/params.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'watermark.g.dart';

/// Watermark profile
@CopyWith(skipFields: true)
@JsonSerializable()
class Watermark extends Jsonable<Watermark> {
  /// Watermark profile unique identifier.
  @JsonKey(name: Params.uid)
  final String id;

  /// The size of the image in bytes.
  final int size;

  /// Width of the image in pixels.
  final int width;

  /// Height of the image in pixels.
  final int height;

  /// When the watermark profile was created.
  final DateTime created;

  /// Location of the image. Valid positions are: "upperRight", "upperLeft",
  /// "lowerLeft", "lowerRight", and "center".
  /// Note that "center" will ignore the "padding" parameter.
  ///
  /// default value: upperRight
  @JsonKey(unknownEnumValue: WatermarkPosition.upperRight)
  final WatermarkPosition position;

  /// The size of the image relative to the overall size of the video.
  /// This parameter will adapt to horizontal and vertical videos automatically.
  /// 0.0 means no scaling (use the size of the image as-is), and 1.0
  /// fills the entire video.
  ///
  /// default value: 0.15
  /// min value: 0.0
  /// max value: 1.0
  final double scale;

  /// Translucency of the image. 0.0 means completely transparent, and 1.0 means
  /// completely opaque. Note that if the image is already semi-transparent,
  /// setting this to 1.0 will not make it completely opaque.
  ///
  /// default value: 1.0
  /// min value: 0.0
  /// max value: 1.0
  final double opacity;

  /// Whitespace between the adjacent edges (determined by position) of the
  /// video and the image. 0.0 means no padding, and 1.0 means padded full
  /// video width or length, determined by the algorithm.
  ///
  /// default value: 0.05
  /// min value: 0.0
  /// max value: 1.0
  final double padding;

  /// A short description for the profile.
  final String? name;

  /// The source URL to the image where it was downloaded from.
  /// If the watermark profile was created via direct upload,
  /// this field will be null.
  final String? downloadedFrom;

  Watermark({
    String? id,
    int? size,
    int? width,
    int? height,
    DateTime? created,
    WatermarkPosition? position,
    double? scale,
    double? opacity,
    double? padding,
    this.name,
    this.downloadedFrom,
  })  : id = id ?? '',
        size = size ?? 0,
        width = width ?? 0,
        height = height ?? 0,
        created = created ?? DateTime.now(),
        position = position ?? WatermarkPosition.upperRight,
        scale = scale ?? 0.0,
        opacity = opacity ?? 0.0,
        padding = padding ?? 0.0;

  @override
  Map<String, dynamic> toJson() => _$WatermarkToJson(this);

  @override
  Watermark? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? Watermark.fromJson(json) : null;

  factory Watermark.fromJson(Map<String, dynamic> json) =>
      _$WatermarkFromJson(json);
}
