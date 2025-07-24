import 'dart:async';
import 'dart:io';

import 'package:cloudflare/cloudflare.dart';
import 'package:cloudflare_example/main.dart';
import 'package:cloudflare_example/src/utils/alert_utils.dart';
import 'package:cloudflare_example/src/utils/picker_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageAPIDemoPage extends StatefulWidget {
  const ImageAPIDemoPage({super.key});

  @override
  State createState() => _ImageAPIDemoPageState();
}

enum FileSource {
  path,
  bytes,
}

class _ImageAPIDemoPageState extends State<ImageAPIDemoPage> {
  static const int loadImage = 1;
  static const int doAuthenticatedUpload = 2;
  static const int doDirectUpload = 3;
  static const int deleteUploadedData = 4;
  List<DataTransmitNotifier> dataImages = [];
  List<CloudflareImage> cloudflareImages = [];
  bool loading = false;
  String? errorMessage;
  FileSource fileSource = FileSource.path;

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

  Widget imageFromPathView(DataTransmitNotifier data) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.file(
            File(data.dataTransmit.data),
            key: ValueKey('image-file-${data.dataTransmit.data}'),
            width: 100,
            height: 100,
          ),
          ValueListenableBuilder<double>(
            key: ValueKey('image-file-progress-${data.dataTransmit.data}'),
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
      ),
    );
  }

  Widget imageFromUrlView(CloudflareImage image) {
    Widget imageView(String url) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              url,
              width: 100,
              height: 100,
            ),
            Text(CloudflareImage.variantNameFromUrl(url)),
          ],
        );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Variants',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ...image.variants.map((url) => imageView(url))
      ],
    );
  }

  Widget imageGalleryView({
    bool fromPath = true,
  }) {
    List imagesSource = fromPath ? dataImages : cloudflareImages;

    final imageViews = List.generate(imagesSource.length, (index) {
      final source = imagesSource[index];
      return fromPath ? imageFromPathView(source) : imageFromUrlView(source);
    });

    if (loading && !fromPath) {
      imageViews.add(const Center(
        child: CircularProgressIndicator(),
      ));
    }
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      runAlignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: imageViews,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image API Demo'),
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
                  'Images from file',
                ),
                const SizedBox(
                  height: 16,
                ),
                imageGalleryView(fromPath: true),
                ElevatedButton(
                  onPressed: loading || dataImages.isEmpty
                      ? null
                      : () {
                          dataImages = [];
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
                  'Images from cloudflare',
                ),
                const SizedBox(
                  height: 16,
                ),
                imageGalleryView(fromPath: false),
                const SizedBox(
                  height: 32,
                ),
                Visibility(
                    visible: errorMessage?.isNotEmpty ?? false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$errorMessage',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, color: Colors.red.shade900),
                        ),
                        const SizedBox(
                          height: 128,
                        ),
                      ],
                    )),
                ElevatedButton(
                  onPressed: loading || cloudflareImages.isEmpty
                      ? null
                      : () {
                          cloudflareImages = [];
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading ||
                              (dataImages.isEmpty && cloudflareImages.isEmpty)
                          ? null
                          : () {
                              dataImages = [];
                              cloudflareImages = [];
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
                      onPressed: loading || dataImages.isEmpty
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
                            'Authenticated uploads are recommended only for server side, because it requires a token or api key to be able to upload image to Cloudflare. For uploading images from client side like mobile or web app consider "Direct upload"',
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
                      onPressed: loading || dataImages.isEmpty
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
                            'Direct uploads are recommended from client side like mobile or web app. This upload consist on client apps first requests the server for an upload url to upload to without token or api key authorization and then uploads the image to the upload url returned by server.',
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
                          onPressed: loading || cloudflareImages.isEmpty
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
                            'Delete uploaded images',
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
        onPressed: () => onClick(loadImage),
        tooltip: 'Choose image',
        child: const Icon(Icons.photo),
      ),
    );
  }

  void onNewImages(List<String> filePaths) {
    if (filePaths.isNotEmpty) {
      for (final path in filePaths) {
        if (path.isNotEmpty) {
          dataImages.add(DataTransmitNotifier(
              dataTransmit: DataTransmit<String>(data: path)));
        }
      }
      setState(() {});
    }
  }

  Future<Uint8List> getFileBytes(String path) async {
    return await File(path).readAsBytes();
  }

  Future<void> doMultipleAuthenticatedUpload() async {
    try {
      List<DataTransmit<String>>? contentFromPaths;
      List<DataTransmit<Uint8List>>? contentFromBytes;

      switch (fileSource) {
        case FileSource.path:
          contentFromPaths =
              dataImages.map((data) => data.dataTransmit).toList();
          break;
        case FileSource.bytes:
          contentFromBytes = await Future.wait(dataImages.map((data) async =>
              DataTransmit<Uint8List>(
                  data: await getFileBytes(data.dataTransmit.data),
                  progressCallback: data.dataTransmit.progressCallback)));
          break;
      }

      List<CloudflareHTTPResponse<CloudflareImage?>> responses =
          await cloudflare.imageAPI.uploadMultiple(
        contentFromPaths: contentFromPaths,
        contentFromBytes: contentFromBytes,
      );

      for (var response in responses) {
        if (response.isSuccessful && response.body != null) {
          cloudflareImages.add(response.body!);
        } else {
          if (response.error is CloudflareErrorResponse &&
              (response.error as CloudflareErrorResponse).messages.isNotEmpty) {
            errorMessage =
                (response.error as CloudflareErrorResponse).messages.first;
          } else {
            errorMessage = response.error?.toString();
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

  Future<void> doMultipleDirectUpload() async {
    try {
      List<DataTransmit> contents = [];

      switch (fileSource) {
        case FileSource.path:
          contents = dataImages.map((data) => data.dataTransmit).toList();
          break;
        case FileSource.bytes:
          contents = await Future.wait(dataImages.map((data) async =>
              DataTransmit<Uint8List>(
                  data: await getFileBytes(data.dataTransmit.data),
                  progressCallback: data.dataTransmit.progressCallback)));
          break;
      }

      for (final content in contents) {
        DataTransmit<String>? contentFromPath;
        DataTransmit<Uint8List>? contentFromBytes;
        if (content.data is String) {
          contentFromPath = content as DataTransmit<String>;
        } else if (content.data is Uint8List) {
          contentFromBytes = content as DataTransmit<Uint8List>;
        }
        final responseCreateDirectUpload =
            await cloudflare.imageAPI.createDirectUpload();
        if (responseCreateDirectUpload.isSuccessful &&
            responseCreateDirectUpload.body != null) {
          final responseUpload = await cloudflare.imageAPI.directUpload(
            dataUploadDraft: responseCreateDirectUpload.body!,
            contentFromPath: contentFromPath,
            contentFromBytes: contentFromBytes,
          );
          setState(() {});
          if (responseUpload.isSuccessful && responseUpload.body != null) {
            cloudflareImages.add(responseUpload.body!);
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
      }
    } catch (e) {
      errorMessage = e.toString();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> authenticatedUpload() async {
    showLoading();
    return doMultipleAuthenticatedUpload();
  }

  Future<void> directUpload() async {
    showLoading();
    return doMultipleDirectUpload();
  }

  Future<void> doMultipleDelete() async {
    List<CloudflareHTTPResponse> responses =
        await cloudflare.imageAPI.deleteMultiple(
      images: cloudflareImages,
    );

    errorMessage = null;
    List<CloudflareImage> imagesCouldNotDelete = [];
    for (int i = 0; i < responses.length; ++i) {
      final response = responses[i];
      if (!response.isSuccessful) {
        imagesCouldNotDelete.add(cloudflareImages[i]);
        if (response.error is CloudflareErrorResponse &&
            (response.error as CloudflareErrorResponse).messages.isNotEmpty) {
          errorMessage =
              (response.error as CloudflareErrorResponse).messages.first;
        } else {
          errorMessage = response.error?.toString();
        }
      }
    }

    if (imagesCouldNotDelete.isNotEmpty) {
      errorMessage = 'Not all images could be deleted: $errorMessage';
    }
    cloudflareImages
        .removeWhere((image) => !imagesCouldNotDelete.contains(image));
    setState(() {});
  }

  Future<void> delete() async {
    showLoading();
    await doMultipleDelete();
  }

  void onClick(int id) async {
    errorMessage = null;
    try {
      switch (id) {
        case loadImage:
          AlertUtils.showPickerModal(
            context: context,
            onFromCamera: () async {
              onNewImages(await handleImagePickerResponse(
                  PickerUtils.takeFromCamera(cameraDevice: CameraDevice.rear)));
            },
            onFromGallery: () async {
              onNewImages(await handleImagePickerResponse(
                  PickerUtils.pickFromGallery()));
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

  Future<List<String>> handleImagePickerResponse(Future getImageCall) async {
    Map<String, dynamic> resource =
        await (getImageCall as FutureOr<Map<String, dynamic>>);
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
}
