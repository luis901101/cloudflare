import 'dart:io';
import 'package:cloudflare/src/utils/date_time_utils.dart';
import 'package:cloudflare/src/utils/params.dart';

import 'package:cloudflare/cloudflare.dart';
import 'package:cloudflare/src/base_api/rest_api.dart';
import 'package:cloudflare/src/base_api/rest_api_service.dart';
import 'package:cloudflare/src/service/stream_service.dart';

class StreamAPI extends RestAPIService<StreamService, CloudflareStreamVideo,
    CloudflareErrorResponse> {
  StreamAPI({required RestAPI restAPI, required String accountId})
      : super(
            restAPI: restAPI,
            service: StreamService(dio: restAPI.dio, accountId: accountId),
            accountId: accountId,
            dataType: CloudflareStreamVideo());

  /// A video up to 200 MegaBytes can be uploaded using a single
  /// HTTP POST (multipart/form-data) request.
  /// For larger file sizes, please upload using the TUS protocol.
  Future<CloudflareHTTPResponse<CloudflareStreamVideo?>> stream({
    /// Video file to stream
    DataTransmit<File>? contentFromFile,

    /// Path to the video file to stream
    DataTransmit<String>? contentFromPath,

    /// Video byte array representation to stream
    DataTransmit<List<int>>? contentFromBytes,

    /// URL to the video. Server must be publicly routable and support
    /// HTTP HEAD requests and HTTP GET range requests. Server should respond
    /// to HTTP HEAD requests with a content-range header with the size
    /// of the file.
    ///
    /// e.g: "https://example.com/myvideo.mp4"
    String? url,

    /// ONLY AVAILABLE FOR STREAMING CONTENT FROM URL
    /// Timestamp location of thumbnail image calculated as a percentage value
    /// of the video's duration. To convert from a second-wise timestamp to a
    /// percentage, divide the desired timestamp by the total duration of the
    /// video. If this value is not set, the default thumbnail image will be
    /// from 0s of the video.
    ///
    /// default value: 0
    /// min value:0
    /// max value:1
    ///
    /// e.g: 0.529241
    double? thumbnailTimestampPct,

    /// ONLY AVAILABLE FOR STREAMING CONTENT FROM URL
    /// List which origins should be allowed to display the video. Enter
    /// allowed origin domains in an array and use * for wildcard subdomains.
    /// Empty array will allow the video to be viewed on any origin.
    ///
    /// e.g:
    /// [
    ///   "example.com"
    /// ]
    List<String>? allowedOrigins,

    /// ONLY AVAILABLE FOR STREAMING CONTENT FROM URL
    /// Indicates whether the video can be a accessed only using it's UID.
    /// If set to true, a signed token needs to be generated with a signing key
    /// to view the video.
    ///
    /// default value: false
    ///
    /// e.g: true
    bool? requireSignedURLs,

    /// ONLY AVAILABLE FOR STREAMING CONTENT FROM URL
    /// A Watermark pointing to an existing watermark profile
    /// e.g: Watermark(id: "ea95132c15732412d22c1476fa83f27a")
    Watermark? watermark,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    assert(
        contentFromFile != null ||
            contentFromPath != null ||
            contentFromBytes != null ||
            url != null,
        'One of the content must be specified.');

    final CloudflareHTTPResponse<CloudflareStreamVideo?> response;
    if (contentFromPath != null) {
      contentFromFile ??= DataTransmit<File>(
          data: File(contentFromPath.data),
          progressCallback: contentFromPath.progressCallback);
    }
    if (contentFromFile != null) {
      response = await parseResponse(service.streamFromFile(
        file: contentFromFile.data,
        onUploadProgress: contentFromFile.progressCallback,
      ));
    } else if(contentFromBytes != null) {
      response = await parseResponse(service.streamFromBytes(
        bytes: contentFromBytes.data,
        onUploadProgress: contentFromBytes.progressCallback,
      ));
    } else {
      response = await parseResponse(service.streamFromUrl(
        data: {
          Params.url: url,
          if(thumbnailTimestampPct != null) Params.thumbnailTimestampPct: thumbnailTimestampPct,
          if(allowedOrigins?.isNotEmpty ?? false) Params.allowedOrigins: allowedOrigins,
          if(requireSignedURLs != null) Params.requireSignedURLs: requireSignedURLs,
          if(watermark != null) Params.watermark: watermark.toJson(),
        },
      ));
    }
    return response;
  }

  /// Stream multiple videos by repeatedly calling stream
  Future<List<CloudflareHTTPResponse<CloudflareStreamVideo?>>> streamMultiple({
    /// Video files to stream
    List<DataTransmit<File>>? contentFromFiles,

    /// Paths to the video files to stream
    List<DataTransmit<String>>? contentFromPaths,

    /// List of video byte array representations to stream
    List<DataTransmit<List<int>>>? contentFromBytes,

    /// URL list to the videos. Server must be publicly routable and support
    /// HTTP HEAD requests and HTTP GET range requests. Server should respond
    /// to HTTP HEAD requests with a content-range header with the size
    /// of the file.
    ///
    /// e.g: "https://example.com/myvideo.mp4"
    List<String>? urls,

    /// ONLY AVAILABLE FOR STREAMING CONTENT FROM URL
    /// Timestamp location of thumbnail image calculated as a percentage value
    /// of the video's duration. To convert from a second-wise timestamp to a
    /// percentage, divide the desired timestamp by the total duration of the
    /// video. If this value is not set, the default thumbnail image will be
    /// from 0s of the video.
    ///
    /// default value: 0
    /// min value:0
    /// max value:1
    ///
    /// e.g: 0.529241
    double? thumbnailTimestampPct,

    /// ONLY AVAILABLE FOR STREAMING CONTENT FROM URL
    /// List which origins should be allowed to display the video. Enter
    /// allowed origin domains in an array and use * for wildcard subdomains.
    /// Empty array will allow the video to be viewed on any origin.
    ///
    /// e.g:
    /// [
    ///   "example.com"
    /// ]
    List<String>? allowedOrigins,

    /// ONLY AVAILABLE FOR STREAMING CONTENT FROM URL
    /// Indicates whether the video can be a accessed only using it's UID.
    /// If set to true, a signed token needs to be generated with a signing key
    /// to view the video.
    ///
    /// default value: false
    ///
    /// e.g: true
    bool? requireSignedURLs,

    /// ONLY AVAILABLE FOR STREAMING CONTENT FROM URL
    /// A Watermark pointing to an existing watermark profile
    /// e.g: Watermark(id: "ea95132c15732412d22c1476fa83f27a")
    Watermark? watermark,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    assert(
        (contentFromFiles?.isNotEmpty ?? false) ||
            (contentFromPaths?.isNotEmpty ?? false) ||
            (contentFromBytes?.isNotEmpty ?? false) ||
            (urls?.isNotEmpty ?? false),
        'One of the contents must be specified.');

    List<CloudflareHTTPResponse<CloudflareStreamVideo?>> responses = [];

    if (contentFromPaths?.isNotEmpty ?? false) {
      contentFromFiles = [];
      for (final content in contentFromPaths!) {
        contentFromFiles.add(DataTransmit<File>(
            data: File(content.data),
            progressCallback: content.progressCallback));
      }
    }
    if (contentFromFiles?.isNotEmpty ?? false) {
      for (final content in contentFromFiles!) {
        final response = await stream(
          contentFromFile: content,
        );
        responses.add(response);
      }
    } else if (contentFromBytes?.isNotEmpty ?? false){
      for (final content in contentFromBytes!) {
        final response = await stream(
          contentFromBytes: content,
        );
        responses.add(response);
      }
    } else {
      for (final url in urls!) {
        final response = await stream(
          url: url,
          thumbnailTimestampPct: thumbnailTimestampPct,
          allowedOrigins: allowedOrigins,
          requireSignedURLs: requireSignedURLs,
          watermark: watermark,
        );
        responses.add(response);
      }
    }
    return responses;
  }

  /// Up to 1000 videos can be listed with one request, use optional parameters
  /// to get a specific range of videos.
  /// Please note that Cloudflare Stream does not use pagination, instead it
  /// uses a cursor pattern to list more than 1000 videos. In order to list all
  /// videos, make multiple requests to the API using the created date-time of
  /// the last item in the previous request as the before or after parameter.
  Future<CloudflareHTTPResponse<List<CloudflareStreamVideo>?>> getAll({
    /// Show videos created after this date-time
    /// Using  ISO 8601 ZonedDateTime
    ///
    /// e.g: "2014-01-02T02:20:00Z"
    DateTime? after,

    /// Show videos created before this date-time
    /// Using  ISO 8601 ZonedDateTime
    ///
    /// e.g: "2014-01-02T02:20:00Z"
    DateTime? before,

    /// Include stats in the response about the number of videos in response
    /// range and total number of videos available
    ///
    /// default value: false
    bool? includeCounts,

    /// A string provided in this field will be used to search over the 'name'
    /// key in meta field, which can be set with the upload request of after.
    ///
    /// e.g: "puppy.mp4"
    String? search,

    /// Number of videos to include in the response
    ///
    /// min value:0
    /// max value:1000
    int? limit,

    /// List videos in ascending order of creation
    ///
    /// default value: false
    bool? asc,
    
    /// Filter by statuses
    /// 
    /// e.g: 
    /// [
    ///   MediaProcessingState.downloading,
    ///   MediaProcessingState.queued, 
    ///   MediaProcessingState.inprogress,
    ///   MediaProcessingState.ready,
    ///   MediaProcessingState.error
    /// ]
    List<MediaProcessingState>? status,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    final response = await parseResponseAsList(
      service.getAll(
        after: after?.toJson(),
        before: before?.toJson(),
        includeCounts: includeCounts,
        search: search,
        limit: limit,
        asc: asc,
        status: status?.map((e) => e.name).join(','),
      )
    );

    return response;
  }

  /// Fetch details of a single video.
  Future<CloudflareHTTPResponse<CloudflareStreamVideo?>> get({
    String? id,
    CloudflareStreamVideo? video,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    assert(
        id != null || video != null, 'One of id or video must not be empty.');
    id ??= video?.id;
    final response = await parseResponse(service.get(
      id: id!,
    ));
    return response;
  }

  /// Delete a video on Cloudflare Stream. On success, all copies of the video
  /// are deleted.
  Future<CloudflareHTTPResponse> delete({
    String? id,
    CloudflareStreamVideo? video,
  }) async {
    assert(
        id != null || video != null, 'One of id or video must not be null.');
    id ??= video?.id;
    final response = await getSaveResponse(
        service.delete(
          id: id!,
        ),
        parseCloudflareResponse: false);
    return response;
  }

  /// Delete a list of videos on Cloudflare Stream. On success, all copies of
  /// the videos are deleted.
  Future<List<CloudflareHTTPResponse>> deleteMultiple({
    List<String>? ids,
    List<CloudflareStreamVideo>? videos,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    assert((ids?.isNotEmpty ?? false) || (videos?.isNotEmpty ?? false),
        'One of ids or images must not be empty.');

    ids ??= videos?.map((video) => video.id).toList();

    List<CloudflareHTTPResponse> responses = [];
    for (final id in ids!) {
      final response = await getSaveResponse(
          service.delete(
            id: id,
          ),
          parseCloudflareResponse: false);
      responses.add(response);
    }
    return responses;
  }

  // /// Update video access control. On access control change,
  // /// all copies of the video are purged from Cache.
  // Future<CloudflareHTTPResponse<CloudflareStreamVideo?>> update({
  //   String? id,
  //   CloudflareStreamVideo? video,
  //
  //   /// Indicates whether the video can be accessed only using it's UID.
  //   /// If set to true, a signed token needs to be generated with a signing key
  //   /// to view the video. Returns a new UID on a change. No-op if not specified
  //   bool? requireSignedURLs,
  //
  //   /// User modifiable key-value store. Can use used for keeping references to
  //   /// another system of record for managing images. No-op if not specified.
  //   /// "{\"meta\": \"metaID\"}"
  //   Map<String, dynamic>? metadata,
  // }) async {
  //   assert(
  //       id != null || video != null, 'One of id or video must not be empty.');
  //   id ??= video?.id;
  //   final response = await parseResponse(service.update(
  //     id: id!,
  //     requireSignedURLs: requireSignedURLs,
  //     metadata: metadata,
  //   ));
  //
  //   return response;
  // }
}
