import 'package:cloudflare/src/utils/params.dart';
import 'package:dio/dio.dart' as dio;
import 'package:cloudflare/cloudflare.dart';
import 'package:tusc/tusc.dart';
import 'package:cross_file/cross_file.dart' show XFile;

/// Callback to notify the upload URI of a tus upload is known.
///
/// [uploadUrl] is the durable handle of the upload on the tus server, the one
/// to persist to be able to resume this very upload later, possibly from
/// another process. See [TusAPI.uploadURI].
typedef UploadCreatedCallback = void Function(String uploadUrl);

class TusAPI {
  static const tusVersion = '1.0.0';

  static String? generateMetadata(Map<String, dynamic>? map) {
    map?.removeWhere(
      (key, value) => value == null || (value is List && value.isEmpty),
    );
    if (map?.isEmpty ?? true) return null;
    return map?.parseToMetadata;
  }

  DataUploadDraft _dataUploadDraft;
  late final _CloudflareTusClient _tusClient;

  /// Notified with the upload URI when it becomes known, set by the running
  /// [startUpload].
  UploadCreatedCallback? _onUploadCreated;

  /// Fallback for the `onTimeout` of [startUpload], given when this [TusAPI]
  /// was created.
  final Function()? _onTimeoutCallback;

  /// The last upload URI [_onUploadCreated] was notified with, so that the same
  /// one, the one the caller supplied included, is not reported over and over.
  String _notifiedUploadUrl;

  /// Uploads a file to Cloudflare Stream using the
  /// [tus](https://tus.io) protocol.
  ///
  /// Either [dataUploadDraft], with the `uploadURL` of a direct upload or of
  /// the account wide stream endpoint, or [uploadUrl], with an upload URI
  /// resolved by a previous upload, must be provided.
  TusAPI({
    required XFile file,

    /// Where the upload is created, as returned by
    /// `StreamAPI.createTusDirectStreamUpload`.
    ///
    /// Optional when [uploadUrl] is given, since an upload that is being
    /// resumed has already been created and the draft that created it may well
    /// be gone by then. Its `id` is still worth passing, when known, as it
    /// identifies the video the upload produces.
    DataUploadDraft? dataUploadDraft,

    /// The upload URI of an upload already created on the tus server, as
    /// reported by [uploadURI] or by the `onUploadCreated` callback of
    /// [startUpload] during a previous run.
    ///
    /// Given one, the upload creation request is skipped and the upload
    /// continues from the offset the server reports, so an upload interrupted
    /// by the process being killed picks up where it left off instead of
    /// starting over.
    ///
    /// Note an upload URI is not forever: Cloudflare releases the reservation
    /// of a direct upload that is not completed before its `expiry`, 30 minutes
    /// after creation by default and 6 hours at most. Once that happens
    /// resuming fails with a [ProtocolException], and, when there is no
    /// [dataUploadDraft] to create a new upload from, it is thrown rather than
    /// recovered from, since uploading to a different video than the one asked
    /// for is not something to do silently.
    String? uploadUrl,
    TusCache? cache,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? metadata,
    int? chunkSize,
    int? progressSliceSize,
    Duration? timeout,
    List<Duration>? retryDelays,
    String Function()? fingerprintGenerator,

    /// Notified when a request times out, unless [startUpload] is given an
    /// `onTimeout` of its own.
    Function()? onTimeoutCallback,
  }) : assert(
         (dataUploadDraft?.uploadURL.isNotEmpty ?? false) ||
             (uploadUrl?.isNotEmpty ?? false),
         'Either dataUploadDraft.uploadURL or uploadUrl must be provided',
       ),
       _dataUploadDraft = dataUploadDraft ?? const DataUploadDraft(),
       _onTimeoutCallback = onTimeoutCallback,
       _notifiedUploadUrl = uploadUrl ?? '' {
    _tusClient = _CloudflareTusClient(
      url: _dataUploadDraft.uploadURL,
      uploadUrl: uploadUrl,
      file: file,
      cache: cache ?? TusMemoryCache(),
      headers: headers,
      metadata: metadata,
      chunkSize: chunkSize ?? 5.MB,
      progressSliceSize: progressSliceSize,
      timeout: timeout,
      retryDelays: retryDelays,
      fingerprintGenerator: fingerprintGenerator,
      onUploadUrlResolved: _notifyUploadCreated,
    );
  }

  TusClient get tusClient => _tusClient;

  /// The draft this upload was created from, with the id of the video the
  /// upload produces once Cloudflare has reported it.
  DataUploadDraft get dataUploadDraft => _dataUploadDraft;

  /// Whether the client supports resuming
  bool get resumingEnabled => _tusClient.resumingEnabled;

  /// The URI on the server for the file.
  ///
  /// This is the durable handle of the upload, empty until the upload has been
  /// created. Persist it, along with [dataUploadDraft]`.id`, to be able to
  /// resume this upload later through the `uploadUrl` parameter, even from
  /// another process.
  String get uploadURI => _tusClient.uploadUrl;

  /// The fingerprint of the file being uploaded
  String get fingerprint => _tusClient.fingerprint;

  /// The 'Upload-Metadata' header sent to server
  String get uploadMetadata => _tusClient.uploadMetadata;

  /// The amount of bytes the server has confirmed for this upload
  int get offset => _tusClient.offset;

  /// Check if possible to resume an already started upload
  Future<bool> canResume() => _tusClient.canResume();

  /// Start or resume an upload in chunks
  /// It throws [ProtocolException] on server error, unless [onError] is
  /// specified, in which case errors are notified through the callback.
  ///
  /// An upload backed by a cache, which is the default, resumes the upload
  /// previously started for the same [fingerprint] instead of creating a new
  /// one, so an interrupted upload continues where it left off. See the
  /// `cache` and `fingerprintGenerator` parameters of
  /// `StreamAPI.tusStream` and `StreamAPI.tusDirectStreamUpload`.
  ///
  /// Calling this while an upload is already running does not start a second
  /// one, it adopts the callbacks given here and returns the future of the
  /// upload in progress.
  ///
  /// The returned future completes when the upload stops, whether that is
  /// because it finished, or because it was paused or cancelled.
  Future<void> startUpload({
    /// Callback to notify about the upload progress. It provides [count] which
    /// is the amount of bytes sent so far and [total] the amount of bytes to be
    /// uploaded.
    ///
    /// It is called while a chunk is still being sent, so it reports bytes
    /// sent rather than bytes the server has acknowledged. A chunk that fails
    /// on the way is reported as sent and then reported again at the offset the
    /// server confirms, so [count] can go backwards after a failure.
    dio.ProgressCallback? onProgress,

    /// Callback to notify the upload URI is known, either because the upload
    /// has just been created on the tus server or because it was restored from
    /// the cache.
    ///
    /// This is the moment to persist that URI, since it is what a later run
    /// needs, through the `uploadUrl` parameter of [TusAPI], to resume this
    /// upload instead of starting over. It is not notified for a URI the caller
    /// already provided.
    UploadCreatedCallback? onUploadCreated,

    /// Callback to notify the upload has completed.
    ///
    /// The video is `null` when nothing identifies it, which is why an upload
    /// resumed through `uploadUrl` is worth giving the id of the draft it was
    /// created from.
    Function(CloudflareStreamVideo? cloudflareStreamVideo)? onComplete,

    /// Callback to notify the upload has failed. When specified, errors are
    /// notified through it instead of being thrown.
    Function(ProtocolException error)? onError,

    /// Callback to notify a request timed out according to the `timeout`
    /// specified when this [TusAPI] was created.
    Function()? onTimeout,
  }) {
    _onUploadCreated = onUploadCreated;
    return _tusClient.startUpload(
      onProgress: (count, total, response) {
        onProgress?.call(count, total);
      },
      onComplete: (response) {
        if (onComplete == null) return;
        final streamMediaId = response.headers[Params.streamMediaIdKC] ?? '';
        if (streamMediaId.isNotEmpty) {
          _dataUploadDraft = _dataUploadDraft.copyWith(id: streamMediaId);
        }
        onComplete(_uploadedStreamVideo);
      },
      onError: onError,
      onTimeout: onTimeout ?? _onTimeoutCallback,
    );
  }

  /// Get the upload state
  TusUploadState get state => _tusClient.state;

  /// Get the error message in case of any error
  String? get errorMessage => _tusClient.errorMessage;

  /// Pause the current upload.
  ///
  /// The upload is flagged as paused right away, so the chunk loop stops even
  /// when no request happens to be in flight. The returned future completes as
  /// soon as the request in flight is given up on, without waiting for its
  /// chunk to land, and is `null` when there is nothing to pause.
  ///
  /// Awaiting the future of [startUpload] is what tells the upload has really
  /// stopped.
  Future? pauseUpload() => _tusClient.pauseUpload();

  /// Cancels the current upload.
  ///
  /// Cancelling abandons the upload rather than just stopping it: its cache
  /// entry is dropped, so a following [startUpload] or [resumeUpload] creates a
  /// new upload and starts over from the beginning. An upload built from an
  /// `uploadUrl` alone has no draft to create a new upload from, so cancelling
  /// it only stops it.
  ///
  /// The returned future completes once the cancellation has been recorded,
  /// cache removal included, and is `null` when the upload has already
  /// completed, in which case there is nothing to cancel.
  Future? cancelUpload() => _tusClient.cancelUpload();

  /// Resume the current upload
  Future<void> resumeUpload() => _tusClient.resumeUpload();

  /// Releases the resources held by this upload, the http client used to talk
  /// to the tus server included.
  ///
  /// This does not stop a running upload, so pause or cancel it, and await the
  /// future of the running [startUpload] or [resumeUpload], before closing.
  void close() => _tusClient.close();

  void _notifyUploadCreated(String uploadUrl) {
    if (uploadUrl.isEmpty || uploadUrl == _notifiedUploadUrl) return;
    _notifiedUploadUrl = uploadUrl;
    _onUploadCreated?.call(uploadUrl);
  }

  /// The video the upload produced, or `null` when nothing identifies it.
  ///
  /// Cloudflare reports its id on the response to the last chunk, which is what
  /// [startUpload] stores in [dataUploadDraft], and the id of the draft the
  /// upload was created from is the next best thing. The url is only a fallback
  /// for a server that reported neither, and a best effort one at that, since
  /// Cloudflare does not guarantee its urls carry the video id.
  CloudflareStreamVideo? get _uploadedStreamVideo {
    final streamVideo = _dataUploadDraft.id.isNotEmpty
        ? CloudflareStreamVideo(id: _dataUploadDraft.id)
        : _streamVideoFromUrl(_dataUploadDraft.uploadURL);
    return streamVideo?.copyWith(readyToStream: true);
  }

  static const _videoDeliveryUrls = [
    CloudflareStreamVideo.uploadVideoDeliveryUrl,
    CloudflareStreamVideo.watchVideoDeliveryUrl,
    CloudflareStreamVideo.videoDeliveryUrl,
    CloudflareStreamVideo.videoCloudflareUrl,
  ];

  static CloudflareStreamVideo? _streamVideoFromUrl(String url) {
    // The id is read off the path, which means any url at all yields something,
    // so only the urls whose path is known to start with the video id are asked.
    if (url.isEmpty ||
        (!_videoDeliveryUrls.any(url.startsWith) &&
            CloudflareStreamVideo.customAccountSubdomainFromUrl(url) == null)) {
      return null;
    }
    final streamVideo = CloudflareStreamVideo.fromUrl(url);
    return (streamVideo?.id.isEmpty ?? true) ? null : streamVideo;
  }
}

/// A [TusClient] that lets the caller decide the fingerprint an upload is
/// cached under, and reports the upload URI as soon as it is known.
///
/// The default fingerprint is derived from the creation url, the file name and
/// the file size, which is stable for the account wide stream endpoint used by
/// authenticated uploads, and stable for a direct upload as long as the same
/// `DataUploadDraft` is reused. Anything else, such as keying the upload by the
/// id of a video in your own database, needs this hook.
class _CloudflareTusClient extends TusClient {
  _CloudflareTusClient({
    required super.file,
    required super.url,
    super.uploadUrl,
    this.fingerprintGenerator,
    this.onUploadUrlResolved,
    super.cache,
    super.headers,
    super.metadata,
    super.chunkSize,
    super.progressSliceSize,
    super.timeout,
    super.retryDelays,
  });

  final String Function()? fingerprintGenerator;

  /// Notified with the upload URI once it is known, which is either when the
  /// upload has just been created on the server or when it was restored from
  /// the cache.
  final UploadCreatedCallback? onUploadUrlResolved;

  @override
  String generateFingerprint() =>
      fingerprintGenerator?.call() ?? super.generateFingerprint();

  @override
  Future<void> createUpload() async {
    await super.createUpload();
    onUploadUrlResolved?.call(uploadUrl);
  }

  @override
  Future<bool> canResume() async {
    final canResume = await super.canResume();
    // Only on a hit, since a miss leaves the upload URI empty and the upload
    // about to be created, which reports itself.
    if (canResume) onUploadUrlResolved?.call(uploadUrl);
    return canResume;
  }
}
