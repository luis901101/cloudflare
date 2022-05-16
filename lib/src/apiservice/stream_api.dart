import 'dart:io' hide HttpResponse;
import 'dart:typed_data';

import 'package:cloudflare/cloudflare.dart';
import 'package:tusc/tusc.dart' as tus;
import 'package:cloudflare/src/base_api/rest_api.dart';
import 'package:cloudflare/src/base_api/rest_api_service.dart';
import 'package:cloudflare/src/entity/data_upload_draft.dart';
import 'package:cloudflare/src/service/stream_service.dart';
import 'package:cloudflare/src/utils/date_time_utils.dart';
import 'package:cloudflare/src/utils/params.dart';
import 'package:cloudflare/src/utils/platform_utils.dart';
import 'package:cross_file/cross_file.dart' show XFile;
import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';

class StreamAPI extends RestAPIService<StreamService, CloudflareStreamVideo,
    CloudflareErrorResponse> {
  final String tusUploadUrl;
  StreamAPI({required RestAPI restAPI, required String accountId}) :
      tusUploadUrl = 'https://api.cloudflare.com/client/v4/accounts/$accountId/stream',
      super(
            restAPI: restAPI,
            service: StreamService(dio: restAPI.dio, accountId: accountId),
            accountId: accountId,
            dataType: CloudflareStreamVideo());

  /// A video up to 200 MegaBytes can be uploaded using a single
  /// HTTP POST (multipart/form-data) request.
  /// For larger file sizes, please upload using the TUS protocol.
  ///
  /// Official documentation:
  /// https://api.cloudflare.com/#stream-videos-upload-a-video-using-a-single-http-request
  /// https://api.cloudflare.com/#stream-videos-upload-a-video-from-a-url
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
    DataTransmit<String>? contentFromUrl,

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
    /// A Watermark object with the id of an existing watermark profile
    /// e.g: Watermark(id: "ea95132c15732412d22c1476fa83f27a")
    Watermark? watermark,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    assert(
        contentFromFile != null ||
            contentFromPath != null ||
            contentFromBytes != null ||
            contentFromUrl != null,
        'One of the content must be specified.');

    final CloudflareHTTPResponse<CloudflareStreamVideo?> response;

    if (contentFromPath != null) {
      contentFromFile ??= DataTransmit<File>(
        data: File(contentFromPath.data),
        progressCallback: contentFromPath.progressCallback);
    }

    /// Web support
    if(contentFromFile != null && PlatformUtils.isWeb) {
      contentFromBytes ??= DataTransmit<List<int>>(
        data: contentFromFile.data.readAsBytesSync(),
        progressCallback: contentFromFile.progressCallback);
      contentFromFile = null;
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
          Params.url: contentFromUrl!.data,
          Params.thumbnailTimestampPct: thumbnailTimestampPct,
          Params.allowedOrigins: allowedOrigins,
          Params.requireSignedURLs: requireSignedURLs,
          Params.watermark: watermark?.toJson(),
        }..removeWhere((key, value) => value == null || (value is List && value.isEmpty)),
        onUploadProgress: contentFromUrl.progressCallback,
      ));
    }
    return response;
  }

  /// For videos larger than 200 MegaBytes tus(https://tus.io) protocol is used
  ///
  /// Official documentation:
  /// https://developers.cloudflare.com/stream/uploading-videos/upload-video-file/#resumable-uploads-with-tus-for-large-files
  Future<TusAPI> tusStream({
    /// Video file to stream
    File? file,

    /// Path to the video file to stream
    String? path,

    /// Video byte array representation to stream
    Uint8List? bytes,

    /// The name of the video in the dashboard.
    String? name,

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
    /// A Watermark object with the id of an existing watermark profile
    /// e.g: Watermark(id: "ea95132c15732412d22c1476fa83f27a")
    Watermark? watermark,

    /// The size in bytes of the portions of the file that will be uploaded in
    /// chunks.
    ///
    /// Min value: 5242880 bytes which is 5 MB
    /// Max value: 209715200 bytes which is 200 MB
    /// e.g: For reliable connections you can use 52428800 bytes which is 50 MB
    int? chunkSize,

    /// Sets the storage to be used to allow resuming uploads
    /// See [TusMemoryStore] or [TusPersistentStore]
    ///
    /// Default value: [TusMemoryStore]
    tus.TusCache? cache,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    assert(
        file != null ||
            path != null ||
            bytes != null,
        'One of the content must be specified.');

    if (path != null) file ??= File(path);

    /// Web support
    if(file != null && PlatformUtils.isWeb) {
      bytes ??= file.readAsBytesSync();
      file = null;
    }

    final XFile xFile;
    if (file != null) {
      xFile = XFile(file.path);
    } else {
      xFile = XFile.fromData(bytes!);
    }
    final tusAPI = TusAPI(
      dataUploadDraft: DataUploadDraft(uploadURL: tusUploadUrl),
      file: xFile,
      cache: cache,
      chunkSize: chunkSize,
      headers: restAPI.headers,
      metadata: {
        Params.name: name,
        Params.thumbnailTimestampPct: thumbnailTimestampPct,
        Params.allowedOrigins: allowedOrigins,
        Params.requireSignedURLs: requireSignedURLs,
        Params.watermark: watermark?.id,
      },
      timeout: restAPI.timeout
    );
    return tusAPI;
  }

  /// For video direct stream upload without API key or token.
  /// This function is to be used specifically after a video
  /// createDirectStreamUpload has been requested.
  ///
  /// Official documentation: https://developers.cloudflare.com/stream/uploading-videos/direct-creator-uploads/
  Future<CloudflareHTTPResponse<CloudflareStreamVideo?>> directStreamUpload({
    /// Information on where to stream upload the video without an API key or token
    required DataUploadDraft dataUploadDraft,

    /// Video file to upload
    DataTransmit<File>? contentFromFile,

    /// Path to the video file to upload
    DataTransmit<String>? contentFromPath,

    /// Image byte array representation to upload
    DataTransmit<Uint8List>? contentFromBytes,
  }) async {
    assert(
    contentFromFile != null ||
        contentFromPath != null ||
        contentFromBytes != null,
    'One of the content must be specified.');

    if (contentFromPath != null) {
      contentFromFile ??= DataTransmit<File>(
          data: File(contentFromPath.data),
          progressCallback: contentFromPath.progressCallback);
    }

    /// Web support
    if(contentFromFile != null && PlatformUtils.isWeb) {
      contentFromBytes ??= DataTransmit<Uint8List>(
          data: contentFromFile.data.readAsBytesSync(),
          progressCallback: contentFromFile.progressCallback);
      contentFromFile = null;
    }

    final dio = restAPI.dio;
    final formData = FormData();
    ProgressCallback? progressCallback;
    if (contentFromFile != null) {
      final file = contentFromFile.data;
      progressCallback = contentFromFile.progressCallback;
      formData.files.add(MapEntry(
          Params.file,
          MultipartFile.fromFileSync(file.path, filename: file.path.split(Platform.pathSeparator).last)));
    } else {
      final bytes = contentFromBytes!.data;
      progressCallback = contentFromBytes.progressCallback;
      formData.files.add(MapEntry(
          Params.file,
          MultipartFile.fromBytes(
            bytes,
            filename: null,
          )));
    }

    final rawResponse = await dio.fetch(Options(
      method: 'POST',
      // headers: _headers,
      // responseType: ResponseType.plain,
      contentType: 'multipart/form-data',
    ).compose(
        BaseOptions(
          baseUrl: dataUploadDraft.uploadURL,
          connectTimeout: restAPI.timeout?.inMilliseconds),
        '',
        data: formData,
        onSendProgress: progressCallback));
    final rawHttpResponse = HttpResponse(rawResponse.data, rawResponse);
    final rawCloudflareResponse = await getSaveResponse(
        Future.value(rawHttpResponse),
        parseCloudflareResponse: false);

    return CloudflareHTTPResponse<CloudflareStreamVideo?>(
      rawCloudflareResponse.base,
        CloudflareStreamVideo(
          id: dataUploadDraft.id,
          readyToStream: true,
          watermark: dataUploadDraft.watermark
        ),
        error: rawCloudflareResponse.error,
      extraData: rawCloudflareResponse.extraData
    );
  }

  /// For larger than 200 MegaBytes video direct stream upload using
  /// tus(https://tus.io) protocol without API key or token.
  /// This function is to be used specifically after a video
  /// [createTusDirectStreamUpload] has been requested.
  Future<TusAPI> tusDirectStreamUpload({
    /// Information on where to stream upload the video without an API key or token
    required DataUploadDraft dataUploadDraft,

    /// Video file to stream
    File? file,

    /// Path to the video file to stream
    String? path,

    /// Video byte array representation to stream
    Uint8List? bytes,

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
    /// A Watermark object with the id of an existing watermark profile
    /// e.g: Watermark(id: "ea95132c15732412d22c1476fa83f27a")
    Watermark? watermark,

    /// The size in bytes of the portions of the file that will be uploaded in
    /// chunks.
    ///
    /// Min value: 5242880 bytes which is 5 MB
    /// Max value: 209715200 bytes which is 200 MB
    /// e.g: For reliable connections you can use 52428800 bytes which is 50 MB
    int? chunkSize,

    /// Sets the storage to be used to allow resuming uploads
    /// See [TusMemoryStore] or [TusPersistentStore]
    ///
    /// Default value: [TusMemoryStore]
    tus.TusCache? cache,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    assert(
    file != null ||
        path != null ||
        bytes != null,
    'One of the content must be specified.');

    if (path != null) file ??= File(path);

    /// Web support
    if(file != null && PlatformUtils.isWeb) {
      bytes ??= file.readAsBytesSync();
      file = null;
    }

    final XFile xFile;
    if (file != null) {
      xFile = XFile(file.path);
    } else {
      xFile = XFile.fromData(bytes!);
    }
    final tusAPI = TusAPI(
      dataUploadDraft: dataUploadDraft,
      file: xFile,
      cache: cache,
      chunkSize: chunkSize,
      metadata: {
        Params.thumbnailTimestampPct: thumbnailTimestampPct,
        Params.allowedOrigins: allowedOrigins,
        Params.requireSignedURLs: requireSignedURLs,
        Params.watermark: watermark?.id,
      },
      timeout: restAPI.timeout,
    );
    return tusAPI;
  }

  /// Stream multiple videos by repeatedly calling stream
  Future<List<CloudflareHTTPResponse<CloudflareStreamVideo?>>> streamMultiple({
    /// Video files to stream
    List<DataTransmit<File>>? contentFromFiles,

    /// Paths to the video files to stream
    List<DataTransmit<String>>? contentFromPaths,

    /// List of video byte array representations to stream
    List<DataTransmit<Uint8List>>? contentFromBytes,

    /// URL list to the videos. Server must be publicly routable and support
    /// HTTP HEAD requests and HTTP GET range requests. Server should respond
    /// to HTTP HEAD requests with a content-range header with the size
    /// of the file.
    ///
    /// e.g: "https://example.com/myvideo.mp4"
    List<DataTransmit<String>>? contentFromUrls,

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
    /// A Watermark object with the id of an existing watermark profile
    /// e.g: Watermark(id: "ea95132c15732412d22c1476fa83f27a")
    Watermark? watermark,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    assert(
        (contentFromFiles?.isNotEmpty ?? false) ||
            (contentFromPaths?.isNotEmpty ?? false) ||
            (contentFromBytes?.isNotEmpty ?? false) ||
            (contentFromUrls?.isNotEmpty ?? false),
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
      for (final contentFromUrl in contentFromUrls!) {
        final response = await stream(
          contentFromUrl: contentFromUrl,
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

  /// Direct uploads allow users to upload videos without API keys. A common
  /// place to use direct uploads is on web apps, client side applications,
  /// or on mobile devices where users upload content directly to Stream.
  ///
  /// Official documentation: https://api.cloudflare.com/#stream-videos-create-a-video-and-get-authenticated-direct-upload-url
  Future<CloudflareHTTPResponse<DataUploadDraft?>> createDirectStreamUpload({
    /// Direct uploads occupy minutes of videos on your Stream account until
    /// they are expired. This value will be used to calculate the duration the
    /// video will occupy before the video is uploaded. After upload, the
    /// duration of the uploaded will be used instead. If a video longer than
    /// this value is uploaded, the video will result in an error.
    ///
    /// Min value: 1 second
    /// Max value: 21600 seconds which is 360 mins, 6 hours
    /// e.g: 300 seconds which is 5 mins
    required int maxDurationSeconds,

    /// User-defined identifier of the media creator
    ///
    /// Max length: 64
    /// e.g: "creator-id_abcde12345"
    String? creator,

    /// Timestamp location of thumbnail image calculated as a percentage value
    /// of the video's duration. To convert from a second-wise timestamp to a
    /// percentage, divide the desired timestamp by the total duration of the
    /// video. If this value is not set, the default thumbnail image will be
    /// from 0s of the video.
    ///
    /// Default value: 0
    /// Min value:0
    /// Max value:1
    /// e.g: 0.529241
    num? thumbnailTimestampPct,

    /// List which origins should be allowed to display the video. Enter
    /// allowed origin domains in an array and use * for wildcard subdomains.
    /// Empty array will allow the video to be viewed on any origin.
    ///
    /// e.g:
    /// [
    ///   "example.com"
    /// ]
    List<String>? allowedOrigins,

    /// Indicates whether the video can be a accessed only using it's UID. If
    /// set to true, a signed token needs to be generated with a signing key to
    /// view the video.
    ///
    /// Default value: false
    /// e.g: true
    bool? requireSignedURLs,

    /// A Watermark object with the id of an existing watermark profile
    /// e.g: Watermark(id: "ea95132c15732412d22c1476fa83f27a")
    Watermark? watermark,

    /// The date after upload will not be accepted.
    ///
    /// Min value: Now + 2 minutes.
    /// Max value: Now + 6 hours.
    /// Default value: Now + 30 minutes.
    /// e.g: "2021-01-02T02:20:00Z"
    DateTime? expiry,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    final response = await genericParseResponse(
      service.createDirectUpload(
        data: {
          Params.maxDurationSeconds: maxDurationSeconds,
          Params.creator: creator,
          Params.thumbnailTimestampPct: thumbnailTimestampPct,
          Params.allowedOrigins: allowedOrigins,
          Params.requireSignedURLs: requireSignedURLs,
          Params.watermark: watermark?.toJson(),
          Params.expiry: expiry?.toJson(),
        }..removeWhere((key, value) => value == null || (value is List && value.isEmpty)),
      ),
      dataType: DataUploadDraft(),
    );
    return response;
  }

  /// Direct upload using tus(https://tus.io) protocol
  /// Direct uploads allow users to upload videos without API keys. A common
  /// place to use direct uploads is on web apps, client side applications,
  /// or on mobile devices where users upload content directly to Stream.
  ///
  /// IMPORTANT: when using tus protocol for direct stream upload it's not
  /// required to set a [maxDurationSeconds] because Cloudflare will reserve a
  /// loose amount o minutes for the video to be uploaded, for instance 240
  /// minutes will be reserved from you available storage.
  ///
  /// Official documentation: https://developers.cloudflare.com/stream/uploading-videos/direct-creator-uploads/#using-tus-recommended-for-videos-over-200mb
  Future<CloudflareHTTPResponse<DataUploadDraft?>> createTusDirectStreamUpload({
    /// The size of the file to upload in bytes
    required int size,

    /// The name of the video in the dashboard.
    String? name,

    /// Direct uploads occupy minutes of videos on your Stream account until
    /// they are expired. This value will be used to calculate the duration the
    /// video will occupy before the video is uploaded. After upload, the
    /// duration of the uploaded will be used instead. If a video longer than
    /// this value is uploaded, the video will result in an error.
    ///
    /// Min value: 1 second
    /// Max value: 21600 seconds which is 360 mins, 6 hours
    /// e.g: 300 seconds which is 5 mins
    int? maxDurationSeconds,

    /// User-defined identifier of the media creator
    ///
    /// Max length: 64
    /// e.g: "creator-id_abcde12345"
    String? creator,

    /// Timestamp location of thumbnail image calculated as a percentage value
    /// of the video's duration. To convert from a second-wise timestamp to a
    /// percentage, divide the desired timestamp by the total duration of the
    /// video. If this value is not set, the default thumbnail image will be
    /// from 0s of the video.
    ///
    /// Default value: 0
    /// Min value:0
    /// Max value:1
    /// e.g: 0.529241
    num? thumbnailTimestampPct,

    /// List which origins should be allowed to display the video. Enter
    /// allowed origin domains in an array and use * for wildcard subdomains.
    /// Empty array will allow the video to be viewed on any origin.
    ///
    /// e.g:
    /// [
    ///   "example.com"
    /// ]
    List<String>? allowedOrigins,

    /// Indicates whether the video can be a accessed only using it's UID. If
    /// set to true, a signed token needs to be generated with a signing key to
    /// view the video.
    ///
    /// Default value: false
    /// e.g: true
    bool? requireSignedURLs,

    /// A Watermark object with the id of an existing watermark profile
    /// e.g: Watermark(id: "ea95132c15732412d22c1476fa83f27a")
    Watermark? watermark,

    /// The date after upload will not be accepted.
    ///
    /// Min value: Now + 2 minutes.
    /// Max value: Now + 6 hours.
    /// Default value: Now + 30 minutes.
    /// e.g: "2021-01-02T02:20:00Z"
    DateTime? expiry,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
      final metadataMap = {
        Params.name: name,
        Params.maxDurationSeconds: maxDurationSeconds,
        Params.creator: creator,
        Params.thumbnailTimestampPct: thumbnailTimestampPct,
        Params.allowedOrigins: allowedOrigins,
        Params.requireSignedURLs: requireSignedURLs,
        Params.watermark: watermark?.id,
        Params.expiry: expiry?.toJson(),
      };
    final metadata = TusAPI.generateMetadata(metadataMap);
    final rawResponse = await getSaveResponse(
      service.createTusDirectUpload(
        size: size,
        metadata: metadata,
      ),
      parseCloudflareResponse: false
    );
    final id = rawResponse.headers[Params.streamMediaIdKC];
    final uploadURL = rawResponse.headers[Params.location];
    return CloudflareHTTPResponse<DataUploadDraft>(
      rawResponse.base,
      DataUploadDraft(
        id: id,
        uploadURL: uploadURL,
      ),
      error: rawResponse.error,
      extraData: rawResponse.extraData,
    );
  }

  /// Up to 1000 videos can be listed with one request, use optional parameters
  /// to get a specific range of videos.
  /// Please note that Cloudflare Stream does not use pagination, instead it
  /// uses a cursor pattern to list more than 1000 videos. In order to list all
  /// videos, make multiple requests to the API using the created date-time of
  /// the last item in the previous request as the before or after parameter.
  ///
  /// Official documentation: https://api.cloudflare.com/#stream-videos-list-videos
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

    /// Filter by user-defined identifier of the media creator
    ///
    /// Max length: 64
    /// e.g: "creator-id_abcde12345"
    String? creator,

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
        creator: creator,
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
  /// Official documentation: https://api.cloudflare.com/#stream-videos-video-details
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
  /// Official documentation: https://api.cloudflare.com/#stream-videos-delete-video
  Future<CloudflareHTTPResponse> delete({
    String? id,
    CloudflareStreamVideo? video,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    assert(
        id != null || video != null, 'One of id or video must not be null.');
    id ??= video?.id;
    final response = await getSaveResponse(
      service.delete(id: id!,),
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
        'One of ids or live inputs must not be empty.');

    ids ??= videos?.map((video) => video.id).toList();

    List<CloudflareHTTPResponse> responses = [];
    for (final id in ids!) {
      final response = await delete(id: id,);
      responses.add(response);
    }
    return responses;
  }
}
