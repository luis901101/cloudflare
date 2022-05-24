import 'package:cloudflare/src/enumerators/thumbnail_fit.dart';
import 'package:cloudflare/src/entity/media_nft.dart';
import 'package:cloudflare/src/entity/video_playback_info.dart';
import 'package:cloudflare/src/entity/video_size.dart';
import 'package:cloudflare/src/entity/video_status.dart';
import 'package:cloudflare/src/entity/watermark.dart';
import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:cloudflare/src/utils/params.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cloudflare_stream_video.g.dart';

/// Documentation here:
/// API docs: https://api.cloudflare.com/#stream-videos-properties
/// Developer Cloudflare docs: https://developers.cloudflare.com/stream
@CopyWith(skipFields: true)
@JsonSerializable(includeIfNull: false)
class CloudflareStreamVideo extends Jsonable<CloudflareStreamVideo> {

  static const uploadVideoDeliveryUrl = 'https://upload.videodelivery.net';
  static const watchVideoDeliveryUrl = 'https://watch.videodelivery.net';
  static const videoDeliveryHost = 'videodelivery.net';
  static const videoDeliveryUrl = 'https://$videoDeliveryHost';
  static const videoCloudflareUrl = 'https://cloudflarestream.com';

  /// Media item unique identifier
  /// max length: 32
  ///
  /// read only
  ///
  /// e.g: "ea95132c15732412d22c1476fa83f27a"
  @JsonKey(name: Params.uid) final String id;

  /// When the media item was uploaded.
  /// Using  ISO 8601 ZonedDateTime
  ///
  /// read only
  ///
  /// e.g: "2014-01-02T02:20:00Z"
  final DateTime uploaded;

  /// Size of the media item in bytes.
  ///
  /// read only
  ///
  /// e.g: 4190963
  final int size;

  /// You can create watermark profile for different videos.
  ///
  /// e.g:
  /// {
  ///   "uid": "ea95132c15732412d22c1476fa83f27a",
  ///   "size": 29472,
  ///   "height": 600,
  ///   "width": 400,
  ///   "created": "2014-01-02T02:20:00Z",
  ///   "downloadedFrom": "https://company.com/logo.png",
  ///   "name": "Marketing Videos",
  ///   "opacity": 0.75,
  ///   "padding": 0.1,
  ///   "scale": 0.1,
  ///   "position": "center"
  /// }
  Watermark? watermark;

  /// Indicates whether the video can be a accessed only using it's UID.
  /// If set to true, a signed token needs to be generated with a signing key
  /// to view the video.
  ///
  /// read only
  ///
  /// default value: false
  final bool requireSignedURLs;

  /// User modifiable key-value store. Can be used for keeping references
  /// to another system of record for managing videos.
  Map? meta;

  /// List which origins should be allowed to display the video.
  /// Enter allowed origin domains in an array and use * for wildcard
  /// subdomains. Empty array will allow the video to be viewed on any origin.
  ///
  /// e.g: ["example.com"]
  List<String> allowedOrigins;

  /// Maximum duration for a video upload. Can be set for a video that is not
  /// yet uploaded to limit its duration. Uploaded that exceed this duration
  /// will fail during processing. A value of -1 means the value is unknown.
  ///
  /// e.g: 300
  /// default value: -1
  int? maxDurationSeconds;

  /// When the media item was created.
  /// Using  ISO 8601 ZonedDateTime
  ///
  /// read only
  ///
  /// e.g: "2014-01-02T02:20:00Z"
  final DateTime created;

  /// URI of preview page for video. Omitted until encoding is complete.
  ///
  /// read only
  ///
  /// e.g: "https://watch.cloudflarestream.com/ea95132c15732412d22c1476fa83f27a"
  final String preview;

  /// When the media item was last modified.
  /// Using  ISO 8601 ZonedDateTime
  ///
  /// read only
  ///
  /// e.g: "2014-01-02T02:20:00Z"
  final DateTime modified;

  /// Size of the video after upload is completed and before video is ready.
  /// e.g:
  /// {
  ///   "height": 1080,
  ///   "width": 1920
  /// }
  final VideoSize input;

  /// URI to JPG thumbnail for a media item. Omitted until encoding is complete.
  ///
  /// read only
  ///
  /// e.g: "https://videodelivery.net/ea95132c15732412d22c1476fa83f27a/thumbnails/thumbnail.jpg"
  final String thumbnail;

  /// URI to GIF thumbnail for a media item. Omitted until encoding is complete.
  ///
  /// read only
  ///
  /// e.g: "https://videodelivery.net/ea95132c15732412d22c1476fa83f27a/thumbnails/thumbnail.gif"
  final String animatedThumbnail;

  /// Object specifying more fine-grained status for this video item.
  /// If "state" is "inprogress" or "error", "step" will be one of "encoding"
  /// or "manifest". When "state" is "inprogress", "pctComplete" will be a
  /// number between 0 and 100 indicating the approximate percent of that step
  /// that has been completed. If the "state" is "error", "errorReasonCode" and
  /// "errorReasonText" will contain additional details.
  ///
  /// read only
  ///
  /// e.g:
  /// {
  ///   "state": "inprogress",
  ///   "pctComplete": 51,
  ///   "errorReasonCode": "ERR_NON_VIDEO",
  ///   "errorReasonText": "The file was not recognized as a valid video file."
  /// }
  final VideoStatus status;

  /// Duration of the video in seconds. A value of -1 means the duration is
  /// unknown. The duration becomes available after the upload,
  /// before the video is ready.
  ///
  /// read only
  ///
  /// e.g: 300
  final double duration;

  /// Date at which the video upload URL is no longer valid for direct user uploads.
  ///
  /// e.g: "2014-01-02T02:20:00Z"
  DateTime? uploadExpiry;

  /// Timestamp location of thumbnail image calculated as a percentage value of
  /// the video's duration. To convert from a second-wise timestamp to a
  /// percentage, divide the desired timestamp by the total duration of the
  /// video. If this value is not set, the default thumbnail image will be
  /// from 0s of the video.
  ///
  /// default value: 0
  /// min value: 0
  /// max value: 1
  ///
  /// e.g: 0.529241
  double thumbnailTimestampPct;

  ///
  /// read only
  ///
  /// e.g:
  /// {
  ///   "hls": "https://videodelivery.net/ea95132c15732412d22c1476fa83f27a/manifest/video.m3u8",
  ///   "dash": "https://videodelivery.net/ea95132c15732412d22c1476fa83f27a/manifest/video.mpd"
  /// }
  final VideoPlaybackInfo? playback;

  ///
  /// read only
  ///
  /// e.g:
  /// {
  ///   "contract": "0x57f1887a8bf19b14fc0d912b9b2acc9af147ea85",
  ///   "token": 5
  /// }
  final MediaNFT? nft;

  /// Indicates whether the video is ready for viewing.
  ///
  /// read only
  ///
  /// e.g: true
  final bool readyToStream;

  /// Live input ID that was used to upload this video with Stream Live.
  ///
  /// read only
  ///
  /// max length: 32
  ///
  /// e.g: "fc0a8dc887b16759bfd9ad922230a014"
  final String? liveInput;

  CloudflareStreamVideo({
    String? id,
    DateTime? uploaded,
    int? size,
    this.watermark,
    bool? requireSignedURLs,
    this.meta,
    List<String>? allowedOrigins,
    this.maxDurationSeconds,
    DateTime? created,
    String? preview,
    DateTime? modified,
    VideoSize? input,
    String? thumbnail,
    String? animatedThumbnail,
    VideoStatus? status,
    double? duration,
    this.uploadExpiry,
    double? thumbnailTimestampPct,
    VideoPlaybackInfo? playback,
    this.nft,
    bool? readyToStream,
    this.liveInput,
  }) :
    id = id ??= '',
    uploaded = uploaded ?? DateTime.now(),
    size = size ?? 0,
    requireSignedURLs = requireSignedURLs ?? false,
    allowedOrigins = allowedOrigins ?? [],
    created = created ?? DateTime.now(),
    preview = preview ?? (id.isNotEmpty ? '$watchVideoDeliveryUrl/$id' : ''),
    modified = modified ?? DateTime.now(),
    input = input ?? VideoSize(),
    thumbnail = thumbnail ?? (id.isNotEmpty ? '$videoDeliveryUrl/$id/thumbnails/thumbnail.jpg' : ''),
    animatedThumbnail = thumbnail ?? (id.isNotEmpty ? '$videoDeliveryUrl/$id/thumbnails/thumbnail.gif' : ''),
    status = status ?? VideoStatus(),
    duration = duration ?? -1,
    thumbnailTimestampPct = thumbnailTimestampPct ?? 0,
    playback = playback ?? (id.isNotEmpty ? VideoPlaybackInfo(
      hls: '$videoDeliveryUrl/$id/manifest/video.m3u8',
      dash: '$videoDeliveryUrl/$id/manifest/video.mpd',
    ) : null),
    readyToStream = readyToStream ?? false
  ;

  bool get isReady => readyToStream;

  /// Customizing static JPG thumbnails on the fly
  ///
  /// Documentation: https://developers.cloudflare.com/stream/viewing-videos/displaying-thumbnails/#use-case-1-generating-a-thumbnail-on-the-fly
  String customThumbnail({
    /// Start time from the video
    ///
    /// Default value: 0s
    ///
    /// e.g: 8m, 5m2s
    String? time,

    /// Width of the thumbnail
    ///
    /// Default value: 640
    int? width,

    /// Height of the thumbnail
    ///
    /// Default value: 640
    int? height,

    /// Clarifies what to do when requested width and height doesn't match the
    /// original upload, which should be one of [ThumbnailFit] enum values
    ///
    /// Default value: crop
    ///
    /// e.g: scale
    ThumbnailFit? fit,
  }) => Uri(
      scheme: 'https',
      host: videoDeliveryHost,
      path: '/$id/thumbnails/thumbnail.jpg',
      queryParameters: {
        if(time != null) Params.time: time.toString(),
        if(width != null) Params.width: width.toString(),
        if(height != null) Params.height: height.toString(),
        if(fit != null) Params.fit: fit.name,
      },
    ).toString();

  /// Customizing animated GIF thumbnails on the fly
  ///
  /// Documentation: https://developers.cloudflare.com/stream/viewing-videos/displaying-thumbnails/#use-case-3-generating-animated-thumbnails
  String customAnimatedThumbnail({
    /// Start time from the video
    ///
    /// Default value: 0s
    ///
    /// e.g: 8m, 5m2s
    String? time,

    /// Width of the thumbnail
    ///
    /// Default value: 640
    int? width,

    /// Height of the thumbnail
    ///
    /// Default value: 640
    int? height,

    /// Clarifies what to do when requested width and height doesn't match the
    /// original upload, which should be one of [ThumbnailFit] enum values
    ///
    /// Default value: crop
    ///
    /// e.g: scale
    ThumbnailFit? fit,

    /// Start time from the video
    ///
    /// Default value: 5s
    ///
    /// e.g: 1m, 5s
    String? duration,

    /// Frames per second for the GIF
    ///
    /// Min value: 1
    /// Max value: 15
    /// Default value: 8
    int? fps,
  }) => Uri(
    scheme: 'https',
    host: videoDeliveryHost,
    path: '/$id/thumbnails/thumbnail.gif',
    queryParameters: {
      if(time != null) Params.time: time.toString(),
      if(width != null) Params.width: width.toString(),
      if(height != null) Params.height: height.toString(),
      if(fit != null) Params.fit: fit.name,
      if(duration != null) Params.duration: duration.toString(),
      if(fps != null) Params.fps: fps.toString(),
    },
  ).toString();

  static Map<String, dynamic> _dataFromVideoDeliveryUrl(String url) {
    final split = url.replaceAll('$uploadVideoDeliveryUrl/', '')
        .replaceAll('$watchVideoDeliveryUrl/', '')
        .replaceAll('$videoDeliveryUrl/', '')
        .replaceAll('$videoCloudflareUrl/', '')
        .split('/');
    String? videoId = split.isNotEmpty ? split[0] : null;

    if (!(url.startsWith(uploadVideoDeliveryUrl) ||
        url.startsWith(watchVideoDeliveryUrl) ||
        url.startsWith(videoDeliveryUrl) ||
        url.startsWith(videoCloudflareUrl)) ||
        videoId == null) {
      // throw Exception('Invalid Cloudflare video from url');
      return {};
    }
    return {
      Params.id: videoId,
    };
  }

  /// Builds a CloudflareStreamVideo from an url if url is properly created
  static CloudflareStreamVideo? fromUrl(String url) {
    final data = _dataFromVideoDeliveryUrl(url);
    return data.isEmpty ? null : CloudflareStreamVideo(
      id: data[Params.id],
      readyToStream: !url.startsWith(uploadVideoDeliveryUrl)
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! CloudflareStreamVideo) return false;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  Map<String, dynamic> toJson() => _$CloudflareStreamVideoToJson(this);
  @override
  CloudflareStreamVideo? fromJsonMap(Map<String, dynamic>? json) =>
      json != null ? CloudflareStreamVideo.fromJson(json) : null;
  factory CloudflareStreamVideo.fromJson(Map<String, dynamic> json) =>
      _$CloudflareStreamVideoFromJson(json);
}
