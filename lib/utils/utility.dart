import 'package:file_picker/file_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../widgets/confirm_box.dart';
import 'env.dart';
import 'export.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:uuid/uuid.dart';

class Utility {
  static void showSnackbar(String msg) {
    var context = Get.context!;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.white,
        behavior: SnackBarBehavior.floating));
  }

  static Widget imageLoader() {
    return const Center(
        child: SpinKitPulsingGrid(
      color: AppColors.white,
      size: 35,
    ));
  }

  static noInternetDialog() {
    Get.isDialogOpen.obs.listen((isOpen) {
      if (isOpen != null && isOpen) {
        Get.back();
      }
    });

    Future.delayed(
      Duration.zero,
      () {
        return Get.dialog(
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                height: 50.h,
                width: 80.w,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "No Internet Connection",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15.sp,
                        color: Colors.black,
                      ),
                    ),
                    10.verticalSpace,
                    Text(
                      textAlign: TextAlign.center,
                      "Please check your internet connection and try again.",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15.sp,
                        color: Colors.grey,
                      ),
                    ),
                    10.verticalSpace,
                    CommonButton(
                      text: 'Ok',
                      height: 35,
                      width: 80,
                      ontap: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget loader() {
    return Center(
      child: SpinKitPulsingGrid(
        color: AppColors.navyBlue,
        size: 50,
      ),
    );
  }

  static Future<void> startLoading(BuildContext context) async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          children: [loader()],
        );
      },
    );
  }

  static Future<void> stopLoading(BuildContext context) async {
    Navigator.of(context).pop();
  }

  static Widget animationLoader() {
    return Lottie.asset(
      loadingLottieAnimation,
      height: 50.h,
      width: 50.w,
    );
  }
}

void showSnackBarWarning({required String message, Color? backgroundColor}) {
  return showErrorSnackBar(
    message: message,
    backgroundColor: Colors.indigo[900],
    icon: Icons.warning,
    iconColor: Colors.yellow,
  );
}

void showErrorSnackBar(
    {required String message,
    Color? backgroundColor,
    IconData? icon,
    Color? iconColor}) {
  final radius = Radius.circular(15);

  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    backgroundColor: backgroundColor ?? AppColors.appColor,
    duration: const Duration(seconds: 4),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: radius, topRight: radius)),
    content: Row(
      children: [
        Icon(
          icon ?? Icons.info,
          size: 24,
          color: iconColor ?? Colors.white,
        ),
        const SizedBox(
          width: 6,
        ),
        Flexible(
            child: Text(
          message,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
        ))
      ],
    ),
  ));
}

void showSnackBar(String title, String message) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: const Color(0xff252526),
    colorText: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
    snackStyle: SnackStyle.GROUNDED,
    margin: const EdgeInsets.all(0.0),
  );
}

// * Confirm box
void confirmBox(String title, String text, VoidCallback callback) {
  Get.dialog(
    ConfirmBox(
      title: title,
      text: text,
      callback: () {
        callback();
      },
    ),
  );
}

Future<File?> pickImageFromGallary() async {
  const uuid = Uuid();
  final ImagePicker picker = ImagePicker();
  final XFile? file = await picker.pickImage(source: ImageSource.gallery);
  if (file == null) return null;
  final dir = Directory.systemTemp;
  final targetPath = "${dir.absolute.path}/${uuid.v6()}.jpg";
  File image = await compressImage(File(file.path), targetPath);
  return image;
}

Future<File?> pickImageFromCamera() async {
  const uuid = Uuid();
  final ImagePicker picker = ImagePicker();
  final XFile? file = await picker.pickImage(source: ImageSource.camera);
  if (file == null) return null;
  final dir = Directory.systemTemp;
  final targetPath = "${dir.absolute.path}/${uuid.v6()}.jpg";
  File image = await compressImage(File(file.path), targetPath);
  return image;
}

Future<File?> pickVideoFromGallery() async {
  final ImagePicker picker = ImagePicker();
  final XFile? videoFile = await picker.pickVideo(source: ImageSource.gallery);
  if (videoFile == null) return null;
  return File(videoFile.path);
}

Future<File?> pickPdfFromFile() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );
  if (result != null && result.files.isNotEmpty) {
    return File(result.files.single.path!);
  } else {
    return null;
  }
}

Future<dynamic> pickFileData() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );
  if (result != null && result.files.isNotEmpty) {
    String? filePath = result.files.first.path;
    if (filePath != null) {
      return filePath;
    }
  }
}

void showImgSEndDialog() {
  var context = Get.context!;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          children: <Widget>[
            const CircularProgressIndicator(
              strokeWidth: 3,
            ),
            SizedBox(width: 20.w),
            const Expanded(
                child: Text(
              'Uploading image...',
              style: TextStyle(color: AppColors.white),
            )),
          ],
        ),
      );
    },
  );
}

void showProgressDialog(String msg) {
  var context = Get.context!;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          children: <Widget>[
            const CircularProgressIndicator(
              strokeWidth: 3,
            ),
            SizedBox(width: 20.w),
            Expanded(child: Text(msg)),
          ],
        ),
      );
    },
  );
}

Future<File> compressImage(File file, String targetPath) async {
  var result = await FlutterImageCompress.compressAndGetFile(
    file.path,
    targetPath,
    quality: 70,
  );
  return File(result!.path);
}

// * Get Supabase s3 bucket url
String getS3Url(String path) {
  return "${Env.supabaseUrl}/storage/v1/object/public/$path";
}

// * formate date
String formateDateFromNow(String date) {
  // Parse UTC timestamp string to DateTime
  DateTime utcDateTime = DateTime.parse(date.split('+')[0].trim());

  // Convert UTC to IST (UTC+5:30 for Indian Standard Time)
  DateTime istDateTime = utcDateTime.add(const Duration(hours: 5, minutes: 30));

  // Format the DateTime using Jiffy
  return Jiffy.parseFromDateTime(istDateTime).fromNow();
}
