import 'dart:async';
import 'dart:io';
import 'package:cloudflare/cloudflare.dart';
import 'package:cloudflare_example/alert_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloudflare_example/image_utils.dart';
import 'package:image_picker/image_picker.dart';

/// Make sure to put environment variables in your
/// flutter run command or in your Additional run args in your selected
/// configuration.
/// Take into account not all envs are necessary, it depends on what kind of
/// authentication you want to use.
///
/// For example:
///
/// flutter run
/// --dart-define=CLOUDFLARE_API_URL=https://api.cloudflare.com/client/v4
/// --dart-define=CLOUDFLARE_ACCOUNT_ID=xxxxxxxxxxxxxxxxxxxxxxxxxxx
/// --dart-define=CLOUDFLARE_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxx
/// --dart-define=CLOUDFLARE_API_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxx
/// --dart-define=CLOUDFLARE_ACCOUNT_EMAIL=xxxxxxxxxxxxxxxxxxxxxxxxxxx
/// --dart-define=CLOUDFLARE_USER_SERVICE_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxx
///
const String apiUrl = String.fromEnvironment('CLOUDFLARE_API_URL', defaultValue: 'https://api.cloudflare.com/client/v4');
const String accountId = String.fromEnvironment('CLOUDFLARE_ACCOUNT_ID', defaultValue: '');
const String token = String.fromEnvironment('CLOUDFLARE_TOKEN', defaultValue: '');
const String apiKey = String.fromEnvironment('CLOUDFLARE_API_KEY', defaultValue: '');
const String accountEmail = String.fromEnvironment('CLOUDFLARE_ACCOUNT_EMAIL', defaultValue: '');
const String userServiceKey = String.fromEnvironment('CLOUDFLARE_USER_SERVICE_KEY', defaultValue: '');

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cloudflare Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Cloudflare Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum UploadMode {
  single,
  multiple,
}

enum FileSource {
  path,
  bytes,
}

enum DeleteMode {
  batch,
  iterative,
}

class _MyHomePageState extends State<MyHomePage> {
  //Change this values with your own
  static const int loadPhoto = 1;
  static const int uploadPhotos = 2;
  static const int deleteUploadedPhotos = 3;
  List<String> pathPhotos = [];
  List<String> urlPhotos = [];
  bool loading = false;
  late Cloudflare cloudflare;
  String? errorMessage;
  UploadMode uploadMode = UploadMode.single;
  FileSource fileSource = FileSource.path;
  DeleteMode deleteMode = DeleteMode.batch;

  @override
  void initState() {
    super.initState();
    (cloudflare = Cloudflare(
      apiUrl: apiUrl,
      accountId: accountId,
      token: token,
      apiKey: apiKey,
      accountEmail: accountEmail,
      userServiceKey: userServiceKey,
    )).init();
  }

  void onUploadModeChanged(UploadMode? value) => setState(() => uploadMode = value!);

  void onUploadSourceChanged(FileSource? value) => setState(() => fileSource = value!);

  void onDeleteModeChanged(DeleteMode? value) => setState(() => deleteMode = value!);

  Widget get uploadModeView => Column(
    children: [
      Text("Upload mode"),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: RadioListTile<UploadMode>(
                title: Text("Single"),
                value: UploadMode.single,
                groupValue: uploadMode,
                onChanged: onUploadModeChanged),
          ),
          Expanded(
            child: RadioListTile<UploadMode>(
                title: Text("Multiple"),
                value: UploadMode.multiple,
                groupValue: uploadMode,
                onChanged: onUploadModeChanged),
          ),
        ],
      )
    ],
  );

  Widget get uploadSourceView => Column(
    children: [
      Text("File source"),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: RadioListTile<FileSource>(
                title: Text("Path"),
                value: FileSource.path,
                groupValue: fileSource,
                onChanged: onUploadSourceChanged),
          ),
          Expanded(
            child: RadioListTile<FileSource>(
                title: Text("Bytes"),
                value: FileSource.bytes,
                groupValue: fileSource,
                onChanged: onUploadSourceChanged),
          ),
        ],
      )
    ],
  );

  Widget get deleteModeView => Column(
    children: [
      Text("Delete mode"),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: RadioListTile<DeleteMode>(
                title: Text("Batch"),
                value: DeleteMode.batch,
                groupValue: deleteMode,
                onChanged: onDeleteModeChanged),
          ),
          Expanded(
            child: RadioListTile<DeleteMode>(
                title: Text("Iterative"),
                value: DeleteMode.iterative,
                groupValue: deleteMode,
                onChanged: onDeleteModeChanged),
          ),
        ],
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 16),
                Text(
                  'Photos from file',
                ),
                SizedBox(
                  height: 16,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(pathPhotos.length, (index) {
                    return Image.file(
                      File(pathPhotos[index]),
                      width: 100,
                      height: 100,
                    );
                  }),
                ),
                ElevatedButton(
                  onPressed: loading || pathPhotos.isEmpty
                      ? null
                      : () {
                    pathPhotos = [];
                    setState(() {});
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                          return states.contains(MaterialState.disabled)
                              ? null
                              : Colors.deepPurple;
                        }),
                  ),
                  child: Text(
                    'Clear list',
                    textAlign: TextAlign.center,
                  ),
                ),
                Divider(
                  height: 48,
                ),
                Text(
                  'Photos from cloudflare',
                ),
                SizedBox(
                  height: 16,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(urlPhotos.length, (index) {
                    final cloudflareImage = CloudflareImage.fromUrl(urlPhotos[index]);
                    return Image.network(
                      cloudflareImage.baseUrl,
                      width: 100,
                      height: 100,
                    );
                  })
                    ..add(
                      Visibility(
                          visible: loading,
                          child: Center(
                            child: CircularProgressIndicator(),
                          )),
                    ),
                ),
                SizedBox(
                  height: 32,
                ),
                Visibility(
                    visible: errorMessage?.isNotEmpty ?? false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$errorMessage",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, color: Colors.red.shade900),
                        ),
                        SizedBox(
                          height: 128,
                        ),
                      ],
                    )),
                ElevatedButton(
                  onPressed: loading || urlPhotos.isEmpty
                      ? null
                      : () {
                    urlPhotos = [];
                    setState(() {});
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                          return states.contains(MaterialState.disabled)
                              ? null
                              : Colors.purple;
                        }),
                  ),
                  child: Text(
                    'Clear list',
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                uploadModeView,
                SizedBox(
                  height: 16,
                ),
                uploadSourceView,
                SizedBox(
                  height: 16,
                ),
                deleteModeView,
                SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: loading ||
                              (pathPhotos.isEmpty && urlPhotos.isEmpty)
                              ? null
                              : () {
                            pathPhotos = [];
                            urlPhotos = [];
                            setState(() {});
                          },
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                  return states.contains(MaterialState.disabled)
                                      ? null
                                      : Colors.deepOrange;
                                }),
                          ),
                          child: Text(
                            'Clear all',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: loading || pathPhotos.isEmpty
                              ? null
                              : () => onClick(uploadPhotos),
                          child: Text(
                            'Upload',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: loading || pathPhotos.isEmpty
                              ? null
                              : () => onClick(deleteUploadedPhotos),
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                  return states.contains(MaterialState.disabled)
                                      ? null
                                      : Colors.red.shade600;
                                }),
                          ),
                          child: Text(
                            'Delete uploaded photos',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onClick(loadPhoto),
        tooltip: 'Choose photo',
        child: Icon(Icons.photo),
      ),
    );
  }

  onNewPhotos(List<String> filePaths) {
    if(filePaths.isNotEmpty) {
      for (final path in filePaths) {
        if (path.isNotEmpty) {
          pathPhotos.add(path);
        }
      }
      setState(() {});
    }
  }

  Future<List<int>> getFileBytes(String path) async {
    return await File(path).readAsBytes();
  }

  Future<void> doSingleUpload() async {
    try {
      String? filePath;
      List<int>? fileBytes;

      switch (fileSource) {
        case FileSource.path:
          filePath = pathPhotos[0];
          break;
        case FileSource.bytes:
          fileBytes = await getFileBytes(pathPhotos[0]);
          break;
        default:
      }

      CResponse<CloudflareImage?> response = await cloudflare.imageAPI.upload(
        contentFromPath: filePath != null ? DataTransmit<String>(data: filePath) : null,
        contentFromBytes: fileBytes != null ? DataTransmit<List<int>>(data: fileBytes) : null,
      );

      if (response.isSuccessful && response.body?.baseUrl != null) {
        urlPhotos.add(response.body!.baseUrl);
      } else {
        if(response.error is ErrorResponse && (response.error as ErrorResponse).messages.isNotEmpty) {
          errorMessage = (response.error as ErrorResponse).messages.first;
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

  Future<void> doMultipleUpload() async {
    try {

      List<DataTransmit<String>>? contentFromPaths;
      List<DataTransmit<List<int>>>? contentFromBytes;

      switch (fileSource) {
        case FileSource.path:
          contentFromPaths = pathPhotos.map((path) => DataTransmit<String>(data: path)).toList();
          break;
        case FileSource.bytes:
          contentFromBytes = await Future.wait(pathPhotos.map((path) async => DataTransmit<List<int>>(data: await getFileBytes(path))));
          break;
        default:
      }

      List<CResponse<CloudflareImage?>> responses = await cloudflare.imageAPI.uploadMultiple(
        contentFromPaths: contentFromPaths,
        contentFromBytes: contentFromBytes,
      );

      for (var response in responses) {
        if (response.isSuccessful && response.body?.baseUrl != null) {
          urlPhotos.add(response.body!.baseUrl);
        } else {
          if(response.error is ErrorResponse && (response.error as ErrorResponse).messages.isNotEmpty) {
            errorMessage = (response.error as ErrorResponse).messages.first;
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

  Future<void> upload() async {
    showLoading();
    switch (uploadMode) {
      case UploadMode.multiple: return doMultipleUpload();
      case UploadMode.single: return doSingleUpload();
      default:
    }
  }

  Future<void> doBatchDelete() async {
    List<CloudflareImage> images = urlPhotos.map((url) => CloudflareImage.fromUrl(url)).toList();

    List<CResponse> responses = await cloudflare.imageAPI.deleteMultiple(images: images,);

    errorMessage = null;
    for (var response in responses) {
      if (!response.isSuccessful) {
        urlPhotos.add(response.body!.baseUrl);
        if(response.error is ErrorResponse && (response.error as ErrorResponse).messages.isNotEmpty) {
          errorMessage = (response.error as ErrorResponse).messages.first;
        } else {
          errorMessage = response.error?.toString();
        }
      }
    }

    if(errorMessage != null) {
      errorMessage = 'Not all images could be deleted: $errorMessage';
    }
  }

  Future<void> delete() async {
    showLoading();
    switch (deleteMode) {
      default:
        return doBatchDelete();
    }
  }

  void onClick(int id) async {
    errorMessage = null;
    try {
      switch (id) {
        case loadPhoto:
          AlertUtils.showImagePickerModal(
            context: context,
            onImageFromCamera: () async {
              onNewPhotos(await handleImagePickerResponse(
                  ImageUtils.takePhoto(cameraDevice: CameraDevice.rear)));
            },
            onImageFromGallery: () async {
              onNewPhotos(await handleImagePickerResponse(
                  ImageUtils.pickImageFromGallery()));
            },
          );
          break;
        case uploadPhotos:
          await upload();
          break;
        case deleteUploadedPhotos:
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

  showLoading() => setState(() => loading = true);

  hideLoading() => setState(() => loading = false);

  Future<List<String>> handleImagePickerResponse(Future getImageCall) async {
    Map<String, dynamic> resource =
    await (getImageCall as FutureOr<Map<String, dynamic>>);
    if (resource.isEmpty) return [];
    switch (resource['status']) {
      case 'SUCCESS':
        Navigator.pop(context);
        return resource['data'];
      default:
        ImageUtils.showPermissionExplanation(
            context: context, message: resource['message']);
        break;
    }
    return [];
  }
}
