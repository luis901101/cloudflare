import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PickerUtils {
  static Future<String?> _retrieveLostData() async {
    if (!Platform.isAndroid) return null;
    final LostDataResponse response = await ImagePicker().retrieveLostData();
    return response.file?.path != null ? response.file!.path : null;
  }

  static const String cameraAccessDenied = 'camera_access_denied';
  static const String galleryAccessDenied = 'photo_access_denied';

  static Future<Map<String, dynamic>> _pickFrom({
    ImageSource source = ImageSource.camera,
    CameraDevice cameraDevice = CameraDevice.rear,
    bool multiple = true,
    bool pickImage = true,
  }) async {
    Map<String, dynamic> resource = {};

    XFile? pickedFile;
    List<XFile>? pickedFiles;
    try {
      Future<void> pickMultiple() async {
        pickedFiles = await ImagePicker().pickMultiImage(
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 100,
        );
      }

      Future<void> pickSingle() async {
        pickedFile = pickImage
            ? await ImagePicker().pickImage(
                source: source,
                preferredCameraDevice: cameraDevice,
                maxWidth: 1920,
                maxHeight: 1080,
                imageQuality: 100,
              )
            : await ImagePicker().pickVideo(
                source: source,
                preferredCameraDevice: cameraDevice,
              );
        if (pickedFile != null) pickedFiles = [pickedFile!];
      }

      if (pickImage && multiple) {
        await pickMultiple();
      } else {
        await pickSingle();
      }

      List<String> filePaths = [];
      String? path;
      pickedFiles?.forEach((item) => filePaths.add(item.path));
      if (filePaths.isEmpty) {
        path = await _retrieveLostData();
        if (path != null) filePaths.add(path);
      }
      resource = {'status': 'SUCCESS', 'data': filePaths};
    } on PlatformException catch (e) {
      resource = {
        'status': 'ERROR',
        'data': [],
        'message': e.message,
        'exception': e,
        'extras': e.details
      };
      switch (e.code) {
        case cameraAccessDenied:
          resource['message'] =
              'Camera permission denied. You have to grant permission from system settings';
          break;
        case galleryAccessDenied:
          resource['message'] =
              'Gellery permission denied. You have to grant permission from system settings';
          break;
      }
    } catch (e) {
      resource = {
        'status': 'ERROR',
        'data': [],
        'message': e.toString(),
        'exception': e,
      };
    }
    return resource;
  }

  static Future<Map<String, dynamic>> pickFromGallery(
          {bool multiple = true, bool pickImage = true}) async =>
      await _pickFrom(
          source: ImageSource.gallery,
          multiple: multiple,
          pickImage: pickImage);

  static Future<Map<String, dynamic>> takeFromCamera(
          {CameraDevice cameraDevice = CameraDevice.rear,
          bool pickImage = true}) async =>
      await _pickFrom(
          source: ImageSource.camera,
          cameraDevice: cameraDevice,
          multiple: false,
          pickImage: pickImage);

  static void showPermissionExplanation(
      {required BuildContext context, String? message}) {
    showDialog(
        context: context,
        builder: (innerContext) => AlertDialog(
              title: const Text('Warning'),
              content: Text(message!),
              actions: [
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'))
              ],
            ));
  }
}
