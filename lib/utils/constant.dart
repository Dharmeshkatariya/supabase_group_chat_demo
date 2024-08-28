import 'dart:io';
import 'dart:ui';

import 'export.dart';

class ApiConstant {
  static String baseUrl = "";
}

class Common {
  static String mobileNumber = "";
  static String fcmToken = "";
  static String androidSound = "jetsons_doorbell";
  static String iosSound = "jetsons_doorbell.mp3";

  static Widget cacheCarouselSlider(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.cover,
        height: 30.h,
        width: double.infinity,
        maxWidthDiskCache: 5000,
        maxHeightDiskCache: 5000,
        progressIndicatorBuilder: (_, __, progress) =>
            Center(child: Utility.animationLoader()),
      ),
    );
  }

  static Widget dividerRow() {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: 1,
              color: AppColors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              "  OR  ",
              style: TextStyle(
                color: AppColors.black,
                // fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 1,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  static Widget cmnPositionWidget({
    required void Function() ontap,
    required Widget createWidget,
  }) {
    return Positioned(
      bottom: 10.h,
      right: 20.w,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          onTap: ontap,
          child: CircleAvatar(
              // backgroundColor: AppColors.navyBlue.withOpacity(0.1),
              backgroundColor: AppColors.white,
              radius: 15.r,
              child: createWidget),
        ),
      ),
    );
  }

  static Widget circleAvatarFilePath(String img) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.grey,
          width: 0.6,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: AppColors.white,
        radius: 60.r,
        backgroundImage: FileImage(File(img)),
      ),
    );
  }

  static Widget circleAvatarUser(String img) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.grey,
          width: 0.6,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: AppColors.white,
        radius: 60.r,
        backgroundImage: AssetImage(img),
      ),
    );
  }

  static Widget commonNetworkImage(String userImage, double radius) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.grey,
          width: 1,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: AppColors.white,
        radius: radius,
        backgroundImage: NetworkImage(getS3Url(userImage)),
      ),
    );
  }

  static Widget commonAssetImage(String userImage, double radius) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.grey,
          width: 1,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: AppColors.white,
        radius: radius,
        backgroundImage: AssetImage(userImage),
      ),
    );
  }

  static Widget circleNetworkImage(String userImage) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.grey,
          width: 1,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: AppColors.white,
        radius: 60.r,
        backgroundImage: NetworkImage(userImage),
      ),
    );
  }

  static Widget googleNetworkImage(String userImage) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.grey,
          width: 1,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: AppColors.white,
        radius: 8.r,
        backgroundImage: NetworkImage(userImage),
      ),
    );
  }

  // static Widget cmnUserProfile(String imgPath) {
  //   return Container(
  //     decoration: BoxDecoration(
  //         color: AppColors.white,
  //         borderRadius: BorderRadius.circular(Responsive.width * 25),
  //         border: Border.all(color: AppColors.appColor, width: 3)),
  //     height: Responsive.height * 14,
  //     width: Responsive.width * 28,
  //     child: Image.asset(
  //       imgPath,
  //       fit: BoxFit.fill,
  //     ),
  //   );
  // }

  static Widget cmnCacheNetworkImg(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2.h),
      child: CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.cover,
        height: 25.h,
        width: 25.w,
        maxWidthDiskCache: 5000,
        maxHeightDiskCache: 5000,
        progressIndicatorBuilder: (_, __, progress) =>
            Center(child: Utility.animationLoader()),
      ),
    );
  }

  static Widget bookEmptyTxt({String? text}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text!,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
