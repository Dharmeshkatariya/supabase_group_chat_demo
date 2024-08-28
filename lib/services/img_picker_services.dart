import 'dart:io';

import 'package:get/get.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../utils/export.dart';

class ImgPickerServices {
  Future<List<XFile>?> pickMultiImage() async {
    bool galleryGranted = await Permissions().isPermissionGranted();
    if (galleryGranted) {
      final List<XFile> images =
          await ImagePicker().pickMultiImage(imageQuality: 70);
      return images;
    } else {
      return null;
    }
  }

  Future<XFile?> pickImageFromCamera() async {
    bool galleryGranted = await Permissions().isPermissionGranted();
    if (galleryGranted) {
      final XFile? image = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 80);
      return image;
    } else {
      return null;
    }
  }

  Future<XFile?> pickImageFromGallery() async {
    bool galleryGranted = await Permissions().isPermissionGranted();
    if (galleryGranted) {
      final XFile? image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 80);
      return image;
    } else {
      return null;
    }
  }

  Future<String> assetToFilePath(String assetPath) async {
    ByteData data = await rootBundle.load(assetPath);
    String tempDir = (await getTemporaryDirectory()).path;
    String filePath = '$tempDir/${assetPath.split('/').last}';
    File file = File(filePath);
    await file.writeAsBytes(data.buffer.asUint8List());
    return filePath;
  }
  // Future<String?> pickImageFromGallery(BuildContext context) async {
  //   XFile? value;
  //   if (await _cameraPermission()) {
  //     value = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (value != null) {
  //       return value.path;
  //     }
  //   }else{
  //     showAlertDialog(context) ;
  //   }
  //   return null;
  // }

  // Future<String?> pickImageFromCamera(BuildContext context) async {
  //   XFile? value;
  //   if (await _cameraPermission()) {
  //     value = await ImagePicker().pickImage(source: ImageSource.camera);
  //     if (value != null) {
  //       return value.path;
  //     }
  //   }else{
  //     showAlertDialog(context) ;
  //
  //   }
  //   return null;
  // }
  // Future<String?> pickImageFromCamera(BuildContext context) async {
  //   XFile? value;
  //   final XFile? image =
  //   await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
  //   // bool cameraGranted = await _cameraPermission(Permission.camera);
  //   bool cameraGranted = await Permissions().isPermissionGranted();
  //
  //   if (cameraGranted) {
  //     value = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 70);
  //     if (value != null) {
  //       return value.path;
  //     }
  //   } else {
  //     showAlertDialog(
  //       context,
  //       'Permission Denied',
  //       'Allow access to camera',
  //     );
  //   }
  //   return null;
  // }

  Future<bool> _cameraPermission(Permission permission) async {
    PermissionStatus status = await permission.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      PermissionStatus newStatus = await permission.request();
      // return newStatus.isGranted;
      return true;
    } else {
      return false;
    }
  }

  // Future<bool> _cameraPermission(Permission permission) async {
  //   PermissionStatus status = await permission.status;
  //   if (status.isGranted) {
  //     return true;
  //   } else if (status.isDenied) {
  //     PermissionStatus newStatus = await permission.request();
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  showAlertDialog(BuildContext context, String title, String content) {
    return showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              await openAppSettings().whenComplete(() {
                Navigator.of(context).pop();
              });
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  Future<String?> convertNetworkImgToPath(String imageUrl) async {
    try {
      Dio dio = Dio();
      Directory directory = await getTemporaryDirectory();
      String imagePath =
          '${directory.path}/image_${DateTime.now().millisecondsSinceEpoch}.png';
      var response = await dio.get(imageUrl,
          options: Options(responseType: ResponseType.bytes));
      File file = File(imagePath);
      await file.writeAsBytes(response.data as List<int>);
      return imagePath;
    } catch (e) {
      return null;
    }
  }
}

class Permissions {
  static PermissionHandlerPlatform get _handler =>
      PermissionHandlerPlatform.instance;

  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  Future<bool> isAndroid14() async {
    if (GetPlatform.isAndroid) {
      var androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.version.sdkInt == 34;
    } else {
      return false;
    }
  }

  Future<bool> isAndroid13() async {
    if (GetPlatform.isAndroid) {
      await deviceInfoPlugin.androidInfo.then((value) {
        if (value.version.sdkInt == 33) {
          return true;
        } else {
          return false;
        }
      });
      return false;
    } else {
      return true;
    }
  }

  Future<bool> isAndroid12() async {
    if (GetPlatform.isAndroid) {
      await deviceInfoPlugin.androidInfo.then((value) {
        if (value.version.sdkInt == 32) {
          return true;
        } else {
          return false;
        }
      });
      return false;
    } else {
      return true;
    }
  }

  Future<bool> isPermissionGranted() async {
    Map<Permission, PermissionStatus> permissions =
        await _handler.requestPermissions(
      [
        if (GetPlatform.isAndroid)
          if (await isAndroid13()) Permission.photos,
        if (GetPlatform.isAndroid)
          if (await isAndroid12()) Permission.storage,
        if (GetPlatform.isAndroid) Permission.notification,
      ],
    );
    bool checkedTrue = true;
    for (var element in permissions.values) {
      if (element == PermissionStatus.granted) {
        checkedTrue = true;
      } else if (element == PermissionStatus.permanentlyDenied) {
        openAppSettings();
        checkedTrue = false;
      } else {
        checkedTrue = false;
      }
    }
    return checkedTrue;
  }
}
