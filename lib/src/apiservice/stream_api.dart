import 'dart:io';

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
            dataType: CloudflareStreamVideo());

  /// A video up to 200 MegaBytes can be uploaded using a single
  /// HTTP POST (multipart/form-data) request.
  /// For larger file sizes, please upload using the TUS protocol.
  Future<CloudflareHTTPResponse<CloudflareStreamVideo?>> stream({
    /// Video file to stream
    DataTransmit<File>? contentFromFile,
    DataTransmit<String>? contentFromPath,
    DataTransmit<List<int>>? contentFromBytes,
  }) async {
    assert(
        contentFromFile != null ||
            contentFromPath != null ||
            contentFromBytes != null,
        'One of the content must be specified.');

    final CloudflareHTTPResponse<CloudflareStreamVideo?> response;
    if (contentFromPath != null) {
      contentFromFile = DataTransmit<File>(
          data: File(contentFromPath.data),
          progressCallback: contentFromPath.progressCallback);
    }
    if (contentFromFile != null) {
      response = await parseResponse(service.streamFromFile(
        file: contentFromFile.data,
        onUploadProgress: contentFromFile.progressCallback,
      ));
    } else {
      response = await parseResponse(service.streamFromBytes(
        bytes: contentFromBytes!.data,
        onUploadProgress: contentFromBytes.progressCallback,
      ));
    }

    return response;
  }

  /// Stream multiple videos by repeatedly calling stream
  Future<List<CloudflareHTTPResponse<CloudflareStreamVideo?>>> streamMultiple({
    /// Video files to upload
    List<DataTransmit<File>>? contentFromFiles,
    List<DataTransmit<String>>? contentFromPaths,
    List<DataTransmit<List<int>>>? contentFromBytes,
  }) async {
    assert(
        (contentFromFiles?.isNotEmpty ?? false) ||
            (contentFromPaths?.isNotEmpty ?? false) ||
            (contentFromBytes?.isNotEmpty ?? false),
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
    } else {
      for (final content in contentFromBytes!) {
        final response = await stream(
          contentFromBytes: content,
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
    final response = await parseResponseAsList(
      service.getAll(
        after: after,
        before: before,
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
    assert(
        id != null || video != null, 'One of id or video must not be empty.');
    id ??= video?.id;
    final response = await parseResponse(service.get(
      id: id!,
    ));
    return response;
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
  //
  //
  //
  // /// Fetch base video. For most images this will be the originally uploaded
  // /// file. For larger images it can be a near-lossless version of the original.
  // /// Note: the response is <video blob data>
  // Future<CloudflareHTTPResponse<List<int>?>> getBase({
  //   String? id,
  //   CloudflareStreamVideo? video,
  // }) async {
  //   assert(
  //       id != null || video != null, 'One of id or video must not be empty.');
  //   id ??= video?.id;
  //   final response = await genericParseResponse<List<int>>(
  //       service.getBase(
  //         id: id!,
  //       ),
  //       parseCloudflareResponse: false);
  //
  //   return response;
  // }
  //
  // /// Delete an video on Cloudflare Images. On success, all copies of the video
  // /// are deleted and purged from Cache.
  // Future<CloudflareHTTPResponse> delete({
  //   String? id,
  //   CloudflareStreamVideo? video,
  // }) async {
  //   assert(
  //       id != null || video != null, 'One of id or video must not be empty.');
  //   id ??= video?.id;
  //   final response = await getSaveResponse(
  //       service.delete(
  //         id: id!,
  //       ),
  //       parseCloudflareResponse: false);
  //   return response;
  // }
  //
  // /// Delete a list of images on Cloudflare Images. On success, all copies of the images
  // /// are deleted and purged from Cache.
  // Future<List<CloudflareHTTPResponse>> deleteMultiple({
  //   List<String>? ids,
  //   List<CloudflareStreamVideo>? images,
  // }) async {
  //   assert((ids?.isNotEmpty ?? false) || (images?.isNotEmpty ?? false),
  //       'One of ids or images must not be empty.');
  //
  //   ids ??= images?.map((video) => video.id).toList();
  //
  //   List<CloudflareHTTPResponse> responses = [];
  //   for (final id in ids!) {
  //     final response = await getSaveResponse(
  //         service.delete(
  //           id: id,
  //         ),
  //         parseCloudflareResponse: false);
  //     responses.add(response);
  //   }
  //   return responses;
  // }
}
