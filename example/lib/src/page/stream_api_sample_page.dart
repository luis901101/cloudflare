import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:cloudflare/cloudflare.dart';
import 'package:cloudflare_example/main.dart';
import 'package:cloudflare_example/src/utils/alert_utils.dart';
import 'package:cloudflare_example/src/utils/picker_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tusc/tusc.dart';
import 'package:video_player/video_player.dart';

class StreamAPIDemoPage extends StatefulWidget {
  const StreamAPIDemoPage({super.key});

  @override
  State createState() => _StreamAPIDemoPageState();
}

enum FileSource {
  path,
  bytes,
}

enum UploadType {
  singleHttp,
  tus,
}

class _StreamAPIDemoPageState extends State<StreamAPIDemoPage> {
  static const int loadVideo = 1;
  static const int doAuthenticatedUpload = 2;
  static const int doDirectUpload = 3;
  static const int deleteUploadedData = 4;
  DataTransmitNotifier? dataVideo;
  CloudflareStreamVideo? cloudflareStreamVideo;
  bool awaitingToBeReadyToStream = false;
  ChewieController? chewieControllerFromPath;
  ChewieController? chewieControllerFromUrl;
  Timer? awaitingToBeReadyToStreamTimer;
  TusAPI? tusAPI;

  bool loading = false;
  String? errorMessage;
  FileSource fileSource = FileSource.path;
  UploadType uploadType = UploadType.singleHttp;

  @override
  void initState() {
    super.initState();
  }

  void onUploadSourceChanged(FileSource? value) =>
      setState(() => fileSource = value!);

  Widget get uploadSourceView => Column(
        children: [
          const Text('File source'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                child: RadioListTile<FileSource>(
                    title: const Text('Path'),
                    value: FileSource.path,
                    groupValue: fileSource,
                    onChanged: onUploadSourceChanged),
              ),
              SizedBox(
                width: 150,
                child: RadioListTile<FileSource>(
                    title: const Text('Bytes'),
                    value: FileSource.bytes,
                    groupValue: fileSource,
                    onChanged: onUploadSourceChanged),
              ),
            ],
          )
        ],
      );

  void onUploadTypeChanged(UploadType? value) =>
      setState(() => uploadType = value!);

  bool get tusCanPlay => tusAPI?.state != TusUploadState.uploading;
  bool get tusCanPause => tusAPI?.state == TusUploadState.uploading;

  Widget get uploadTypeView => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Upload type'),
          const SizedBox(height: 8),
          SizedBox(
            width: 300,
            child: RadioListTile<UploadType>(
                title:
                    const Text('Single http request, for videos under 200 MB'),
                value: UploadType.singleHttp,
                groupValue: uploadType,
                onChanged: onUploadTypeChanged),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 300,
            child: RadioListTile<UploadType>(
                title: const Text('Tus protocol, for videos over 200 MB'),
                value: UploadType.tus,
                groupValue: uploadType,
                onChanged: onUploadTypeChanged),
          ),
          if (tusAPI != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    if (tusCanPlay) {
                      await tusAPI?.resumeUpload();
                    } else {
                      await tusAPI?.pauseUpload();
                    }
                    setState(() {});
                  },
                  iconSize: 32,
                  icon: Icon(
                    tusCanPlay
                        ? Icons.play_circle_fill
                        : Icons.pause_circle_filled,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () async {
                    await tusAPI?.cancelUpload();
                    setState(() {});
                  },
                  iconSize: 32,
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                )
              ],
            ),
        ],
      );

  Widget videoFromPathView(DataTransmitNotifier data) {
    String path = data.dataTransmit.data;
    if (chewieControllerFromPath?.videoPlayerController.dataSource !=
        'file://${data.dataTransmit.data}') {
      clearVideoPathControllers();
      chewieControllerFromPath = ChewieController(
        videoPlayerController: VideoPlayerController.file(
          File(path),
        )..initialize()
              .then((_) => errorMessage = null)
              .onError((error, stackTrace) {
            errorMessage = error?.toString();
          }).whenComplete(() => setState(() {})),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: chewieControllerFromPath!
                  .videoPlayerController.value.isInitialized
              ? AspectRatio(
                  key: ValueKey('video-from-file-$path'),
                  aspectRatio: MediaQuery.of(context).size.shortestSide > 600
                      ? 3
                      : chewieControllerFromPath!
                          .videoPlayerController.value.aspectRatio,
                  // aspectRatio: 3,
                  child: Chewie(
                    controller: chewieControllerFromPath!,
                  ),
                )
              : const CircularProgressIndicator(),
        ),
        ValueListenableBuilder<double>(
          key: ValueKey('video-from-file-progress-$path'),
          valueListenable: data.notifier,
          builder: (context, value, child) {
            if (value == 0 && !loading) return const SizedBox();
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(
                  value: value,
                ),
                Text('${(value * 100).toInt()} %'),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget videoFromUrlView(CloudflareStreamVideo video) {
    // String url = video.preview; // Cloudflare video previews doesn't allow Range header which is required in iOS with https://pub.dev/packages/video_player
    String url = video.playback?.hls ?? '';
    if (chewieControllerFromUrl?.videoPlayerController.dataSource != url) {
      clearVideoUrlControllers();
      chewieControllerFromUrl = ChewieController(
        videoPlayerController: VideoPlayerController.networkUrl(
          Uri.parse(url),
        )..initialize()
              .then((_) => errorMessage = null)
              .onError((error, stackTrace) {
            errorMessage = error?.toString();
            clearVideoUrlControllers();
          }).whenComplete(() => setState(() {})),
      );
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: chewieControllerFromUrl!.videoPlayerController.value.isInitialized
          ? AspectRatio(
              key: ValueKey('video-from-url-$url'),
              aspectRatio: MediaQuery.of(context).size.shortestSide > 600
                  ? 3
                  : chewieControllerFromUrl!
                      .videoPlayerController.value.aspectRatio,
              child: Chewie(
                controller: chewieControllerFromUrl!,
              ),
            )
          : const CircularProgressIndicator(),
    );
  }

  Widget videoGalleryView({
    bool fromPath = true,
  }) {
    dynamic videoSource = fromPath ? dataVideo : cloudflareStreamVideo;

    final views = [
      if (fromPath && videoSource != null) videoFromPathView(videoSource),
      if (!fromPath && videoSource != null) videoFromUrlView(videoSource),
    ];

    if (loading && !fromPath) {
      views.add(const Center(
        child: CircularProgressIndicator(),
      ));
    }
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      runAlignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: views,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video API Demo'),
      ),
      body: Center(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 16),
                const Text(
                  'Videos from file',
                ),
                const SizedBox(
                  height: 16,
                ),
                videoGalleryView(fromPath: true),
                ElevatedButton(
                  onPressed: loading || dataVideo == null
                      ? null
                      : () {
                          dataVideo = null;
                          clearVideoPathControllers();
                          setState(() {});
                        },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                      return states.contains(WidgetState.disabled)
                          ? null
                          : Colors.deepPurple;
                    }),
                  ),
                  child: const Text(
                    'Clear list',
                    textAlign: TextAlign.center,
                  ),
                ),
                const Divider(
                  height: 48,
                ),
                const Text(
                  'Videos from cloudflare',
                ),
                const SizedBox(
                  height: 16,
                ),
                videoGalleryView(fromPath: false),
                const SizedBox(
                  height: 32,
                ),
                if (awaitingToBeReadyToStream)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Awaiting video to be ready to stream',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, color: Colors.green.shade900),
                      ),
                      const SizedBox(height: 8),
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 128,
                      ),
                    ],
                  ),
                if (errorMessage?.isNotEmpty ?? false)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$errorMessage',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 18, color: Colors.red.shade900),
                      ),
                      const SizedBox(
                        height: 128,
                      ),
                    ],
                  ),
                ElevatedButton(
                  onPressed: loading || cloudflareStreamVideo == null
                      ? null
                      : () {
                          cloudflareStreamVideo = null;
                          clearVideoUrlControllers();
                          setState(() {});
                        },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                      return states.contains(WidgetState.disabled)
                          ? null
                          : Colors.purple;
                    }),
                  ),
                  child: const Text(
                    'Clear list',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                uploadSourceView,
                const SizedBox(
                  height: 32,
                ),
                uploadTypeView,
                const SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading ||
                              (dataVideo == null &&
                                  cloudflareStreamVideo == null)
                          ? null
                          : () {
                              dataVideo = null;
                              cloudflareStreamVideo = null;
                              clearAllVideoControllers();
                              setState(() {});
                            },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                          return states.contains(WidgetState.disabled)
                              ? null
                              : Colors.blue;
                        }),
                      ),
                      child: const Text(
                        'Clear all',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading || dataVideo == null
                          ? null
                          : () => onClick(doAuthenticatedUpload),
                      style: ButtonStyle(
                          padding:
                              WidgetStateProperty.all(const EdgeInsets.all(8))),
                      child: const Column(
                        children: [
                          Text(
                            'Authenticated upload',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Authenticated uploads are recommended only for server side, because it requires a token or api key to be able to upload video to Cloudflare. For uploading videos from client side like mobile or web app consider "Direct upload".',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading || dataVideo == null
                          ? null
                          : () => onClick(doDirectUpload),
                      style: ButtonStyle(
                        padding:
                            WidgetStateProperty.all(const EdgeInsets.all(8)),
                        backgroundColor:
                            WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                          return states.contains(WidgetState.disabled)
                              ? null
                              : Colors.deepOrange;
                        }),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            'Direct upload',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Direct uploads are recommended from client side like mobile or web app. This upload consist on client apps first requests the server for an upload url to upload to without token or api key authorization and then uploads the video to the upload url returned by server.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: loading || cloudflareStreamVideo == null
                              ? null
                              : () => onClick(deleteUploadedData),
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color?>(
                                    (Set<WidgetState> states) {
                              return states.contains(WidgetState.disabled)
                                  ? null
                                  : Colors.red.shade600;
                            }),
                          ),
                          child: const Text(
                            'Delete uploaded videos',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onClick(loadVideo),
        tooltip: 'Choose video',
        child: const Icon(Icons.photo),
      ),
    );
  }

  void onNewVideos(List<String> filePaths) {
    if (filePaths.isNotEmpty) {
      dataVideo = DataTransmitNotifier(
          dataTransmit: DataTransmit(data: filePaths.first));
      setState(() {});
    }
  }

  Future<Uint8List> getFileBytes(String path) async {
    return await File(path).readAsBytes();
  }

  Future<void> awaitForVideoToBeReadyToStream(
      CloudflareStreamVideo video) async {
    /// Code below is a hack to verify the readiness of the video to stream.
    /// This hack is only for test purposes
    /// The proper way to do this is described in the documentation here: https://developers.cloudflare.com/stream/uploading-videos/using-webhooks/
    setState(() => awaitingToBeReadyToStream = true);
    awaitingToBeReadyToStreamTimer?.cancel();
    awaitingToBeReadyToStreamTimer =
        Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (awaitingToBeReadyToStreamTimer?.isActive ?? false) {
        final checkResponse = await cloudflare.streamAPI.get(video: video);
        if (checkResponse.isSuccessful &&
            (checkResponse.body?.isReady ?? false)) {
          awaitingToBeReadyToStreamTimer?.cancel();
          setState(() {
            awaitingToBeReadyToStream = false;
            cloudflareStreamVideo = checkResponse.body!;
          });
        }
      }
    });
  }

  Future<void> singleHttpRequestAuthenticatedUpload() async {
    try {
      DataTransmit<String>? contentFromPath;
      DataTransmit<Uint8List>? contentFromBytes;

      switch (fileSource) {
        case FileSource.path:
          contentFromPath = dataVideo?.dataTransmit;
          break;
        case FileSource.bytes:
          contentFromBytes = DataTransmit<Uint8List>(
              data: await getFileBytes(dataVideo!.dataTransmit.data),
              progressCallback: dataVideo?.dataTransmit.progressCallback);
          break;
      }

      CloudflareHTTPResponse<CloudflareStreamVideo?> response =
          await cloudflare.streamAPI.stream(
        contentFromPath: contentFromPath,
        contentFromBytes: contentFromBytes,
      );

      if (response.isSuccessful && response.body != null) {
        awaitForVideoToBeReadyToStream(response.body!);
      } else {
        if (response.error is CloudflareErrorResponse &&
            (response.error as CloudflareErrorResponse).messages.isNotEmpty) {
          errorMessage =
              (response.error as CloudflareErrorResponse).messages.first;
        } else {
          errorMessage = response.error?.toString();
        }
      }
    } catch (e) {
      errorMessage = e.toString();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> tusAuthenticatedUpload() async {
    try {
      String? path;
      Uint8List? bytes;

      switch (fileSource) {
        case FileSource.path:
          path = dataVideo?.dataTransmit.data;
          break;
        case FileSource.bytes:
          bytes = await getFileBytes(dataVideo!.dataTransmit.data);
          break;
      }

      tusAPI = await cloudflare.streamAPI.tusStream(
        path: path,
        bytes: bytes,
        timeout: const Duration(minutes: 2),
      );
      setState(() {});
      await tusAPI?.startUpload(
        onProgress: (count, total) {
          dataVideo?.dataTransmit.progressCallback?.call(count, total);
        },
        onComplete: (cloudflareStreamVideo) {
          tusAPI = null;
          if (cloudflareStreamVideo != null) {
            awaitForVideoToBeReadyToStream(cloudflareStreamVideo);
          } else {
            setState(() {
              errorMessage = 'Tus upload completed with null video';
            });
          }
        },
      );
    } catch (e) {
      errorMessage = e.toString();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> authenticatedUpload() async {
    showLoading();
    return uploadType == UploadType.singleHttp
        ? singleHttpRequestAuthenticatedUpload()
        : tusAuthenticatedUpload();
  }

  Future<void> singleHttpRequestDirectUpload() async {
    try {
      DataTransmit? content;

      switch (fileSource) {
        case FileSource.path:
          content = dataVideo?.dataTransmit;
          break;
        case FileSource.bytes:
          content = DataTransmit<Uint8List>(
              data: await getFileBytes(dataVideo!.dataTransmit.data),
              progressCallback: dataVideo!.dataTransmit.progressCallback);
          break;
      }

      DataTransmit<String>? contentFromPath;
      DataTransmit<Uint8List>? contentFromBytes;
      if (content?.data is String) {
        contentFromPath = content as DataTransmit<String>;
      } else if (content?.data is Uint8List) {
        contentFromBytes = content as DataTransmit<Uint8List>;
      }
      final responseCreateDirectUpload = await cloudflare.streamAPI
          .createDirectStreamUpload(
              maxDurationSeconds: chewieControllerFromPath!
                  .videoPlayerController.value.duration.inSeconds);
      if (responseCreateDirectUpload.isSuccessful &&
          responseCreateDirectUpload.body != null) {
        final responseUpload = await cloudflare.streamAPI.directStreamUpload(
          dataUploadDraft: responseCreateDirectUpload.body!,
          contentFromPath: contentFromPath,
          contentFromBytes: contentFromBytes,
        );
        if (responseUpload.isSuccessful && responseUpload.body != null) {
          awaitForVideoToBeReadyToStream(responseUpload.body!);
        } else {
          if (responseUpload.error is CloudflareErrorResponse &&
              (responseUpload.error as CloudflareErrorResponse)
                  .messages
                  .isNotEmpty) {
            errorMessage = (responseUpload.error as CloudflareErrorResponse)
                .messages
                .first;
          } else {
            errorMessage = responseUpload.error?.toString();
          }
        }
      }
    } catch (e) {
      errorMessage = e.toString();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> tusDirectUpload() async {
    try {
      String? path;
      Uint8List? bytes;

      switch (fileSource) {
        case FileSource.path:
          path = dataVideo?.dataTransmit.data;
          break;
        case FileSource.bytes:
          bytes = await getFileBytes(dataVideo!.dataTransmit.data);
          break;
      }

      final responseCreateDirectUpload = await cloudflare.streamAPI
          .createTusDirectStreamUpload(
              size: File(dataVideo!.dataTransmit.data).lengthSync(),
              maxDurationSeconds: chewieControllerFromPath!
                  .videoPlayerController.value.duration.inSeconds);
      if (responseCreateDirectUpload.isSuccessful &&
          responseCreateDirectUpload.body != null) {
        tusAPI = await cloudflare.streamAPI.tusDirectStreamUpload(
          dataUploadDraft: responseCreateDirectUpload.body!,
          path: path,
          bytes: bytes,
          timeout: const Duration(minutes: 2),
        );
        setState(() {});
        await tusAPI?.startUpload(
          onProgress: (count, total) {
            dataVideo?.dataTransmit.progressCallback?.call(count, total);
          },
          onComplete: (cloudflareStreamVideo) {
            tusAPI = null;
            if (cloudflareStreamVideo != null) {
              awaitForVideoToBeReadyToStream(cloudflareStreamVideo);
            } else {
              setState(() {
                errorMessage = 'Tus upload completed with null video';
              });
            }
          },
        );
      }
    } catch (e) {
      errorMessage = e.toString();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> directUpload() async {
    showLoading();
    return uploadType == UploadType.singleHttp
        ? singleHttpRequestDirectUpload()
        : tusDirectUpload();
  }

  Future<void> delete() async {
    showLoading();
    CloudflareHTTPResponse response = await cloudflare.streamAPI.delete(
      video: cloudflareStreamVideo,
    );

    errorMessage = null;
    CloudflareStreamVideo? videoCouldNotDelete;

    if (!response.isSuccessful) {
      videoCouldNotDelete = cloudflareStreamVideo;
      if (response.error is CloudflareErrorResponse &&
          (response.error as CloudflareErrorResponse).messages.isNotEmpty) {
        errorMessage =
            (response.error as CloudflareErrorResponse).messages.first;
      } else {
        errorMessage = response.error?.toString();
      }
    }

    cloudflareStreamVideo = null;

    if (videoCouldNotDelete != null) {
      errorMessage = 'There was an error deleting the video: $errorMessage';
    }
  }

  void onClick(int id) async {
    errorMessage = null;
    try {
      switch (id) {
        case loadVideo:
          AlertUtils.showPickerModal(
            context: context,
            onFromCamera: () async {
              onNewVideos(await handlePickerResponse(PickerUtils.takeFromCamera(
                  cameraDevice: CameraDevice.rear, pickImage: false)));
            },
            onFromGallery: () async {
              onNewVideos(await handlePickerResponse(
                  PickerUtils.pickFromGallery(pickImage: false)));
            },
          );
          break;
        case doAuthenticatedUpload:
          await authenticatedUpload();
          break;
        case doDirectUpload:
          await directUpload();
          break;
        case deleteUploadedData:
          await delete();
          break;
      }
    } catch (e) {
      print(e);
      loading = false;
      setState(() => errorMessage = e.toString());
    } finally {
      if (loading) hideLoading();
    }
  }

  void showLoading() => setState(() => loading = true);

  void hideLoading() => setState(() => loading = false);

  Future<List<String>> handlePickerResponse(Future getCall) async {
    Map<String, dynamic> resource =
        await (getCall as FutureOr<Map<String, dynamic>>);
    if (resource.isEmpty) return [];
    switch (resource['status']) {
      case 'SUCCESS':
        if (mounted) Navigator.pop(context);
        return resource['data'];
      default:
        PickerUtils.showPermissionExplanation(
            context: context, message: resource['message']);
        break;
    }
    return [];
  }

  void clearAllVideoControllers() {
    clearVideoPathControllers();
    clearVideoUrlControllers();
  }

  void clearVideoPathControllers() {
    chewieControllerFromPath?.videoPlayerController.dispose();
    chewieControllerFromPath?.dispose();
    chewieControllerFromPath = null;
  }

  void clearVideoUrlControllers() {
    chewieControllerFromUrl?.videoPlayerController.dispose();
    chewieControllerFromUrl?.dispose();
    chewieControllerFromUrl = null;
  }

  @override
  void dispose() {
    clearAllVideoControllers();
    super.dispose();
  }
}
