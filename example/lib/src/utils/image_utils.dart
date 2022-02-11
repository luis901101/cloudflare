import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImageUtils {
  static Future<String?> _retrieveLostData() async {
    if (!Platform.isAndroid) return null;
    final LostDataResponse response = await ImagePicker().retrieveLostData();
    return response.file?.path != null ? response.file!.path : null;
  }

  static const String cameraAccessDenied = "camera_access_denied";
  static const String galleryAccessDenied = "photo_access_denied";

  static Future<Map<String, dynamic>> _pickImageFrom({
    ImageSource source = ImageSource.camera,
    CameraDevice cameraDevice = CameraDevice.rear,
    bool multiple = true,
  }) async {
    Map<String, dynamic> resource = {};

    XFile? pickedImage;
    List<XFile>? pickedImages;
    try {
      Future<void> pickMultipleFromGallery() async {
        pickedImages = await ImagePicker().pickMultiImage(
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 100,
        );
      }

      Future<void> pickSingleFromGallery() async {
        pickedImage = await ImagePicker().pickImage(
          source: source,
          preferredCameraDevice: cameraDevice,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 100,
        );
        if (pickedImage != null) pickedImages = [pickedImage!];
      }

      Future<void> pickFromCamera() async {
        pickedImage = await ImagePicker().pickImage(
          source: source,
          preferredCameraDevice: cameraDevice,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 100,
        );
        if (pickedImage != null) pickedImages = [pickedImage!];
      }

      switch (source) {
        case ImageSource.gallery:
          if (multiple) {
            await pickMultipleFromGallery();
          } else {
            await pickSingleFromGallery();
          }
          break;
        case ImageSource.camera:
          await pickFromCamera();
          break;
      }

      List<String> filePaths = [];
      String? path;
      pickedImages?.forEach((item) => filePaths.add(item.path));
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

  static Future<Map<String, dynamic>> pickImageFromGallery(
          {bool multiple = true}) async =>
      await _pickImageFrom(source: ImageSource.gallery, multiple: multiple);

  static Future<Map<String, dynamic>> takePhoto(
          {CameraDevice cameraDevice = CameraDevice.rear}) async =>
      await _pickImageFrom(
          source: ImageSource.camera, cameraDevice: cameraDevice);

  static showPermissionExplanation(
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
