import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  static LinearGradient bottomSheetGradient = LinearGradient(
    colors: [
      AppColors.gradientOneColor.withOpacity(0.95),
      AppColors.darkblack.withOpacity(0.95),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static Color bottomSheetGradientOneColor = const Color(0xff003152);
  static Color bottomSheetGradientTwoColor = const Color(0xff003356);
  static Color trailBoxColor = const Color(0xff32A0AE);
  static const Color fullMapBackgroundColor = Color(0xff001C38);
  static Color selectTimeColor = const Color(0xff153850);
  static Color guideBottomSheetColor = const Color(0xff133350);
  static const Color timerBackground = Color(0xff1A3D55);
  static const Color menuButtonColor = Color(0xff279FAD);
  static const Color menuTimeColor = Color(0xff53E5F6);
  static const Color homeAppbarColor = Color(0xff5EB2DF);
  static Color chartCartColor = const Color(0xff000000);
  static Color gameAllBackgroundColor = const Color(0xff234D6A);
  static Color watchColor = const Color(0xff4D6779);
  static Color linearDotColor = const Color(0xff5589AA);
  static Color linearIndicatorColor = const Color(0xff53E5F6);
  static Color appColor = const Color(0xff133152);
  static Color textColor = const Color(0xff53E5F6);
  static Color deepWhite = const Color(0xffD9D9D9);
  static Color buttonColor = const Color(0xff32A0AE);
  static Color brownBorderColor = const Color(0xffDC9794);
  static Color bottomSheetColor = const Color(0xff012239);
  static Color greenButtonColor = const Color(0xff2B6D75);
  static Color gradientOneColor = const Color(0xff003356);
  static Color homeGradientOneColor = const Color(0xff003152);
  static Color homeGradientTwoColor = const Color(0xff0F002E);
  static Color appLightColor = const Color(0xff22435B);
  static Color appLightScaFoldBgColor = const Color(0xff264D68);
  static Color bottomSheetBorderColor = const Color(0xff1A3D55);
  static Color appbarColor = const Color(0xff4CA7D8);
  static Color lightBlueColor = const Color(0xff5FD9EC);
  static Color linearProgressBlueColor = const Color(0xff64E5F6);
  static Color lightAppBarColor = const Color(0xff2F6C9A);
  static Color lightBrownColor = const Color(0xffE6B99B);
  static Color appBarHomeColor = const Color(0xff2E6B96);
  static Color cardBrownBorderBrownColor = const Color(0xffF2B78F);
  static Color iconBrownColor = const Color(0xffE7AD87);
  static Color bottomNavigationColor = const Color(0xff0A2138);
  static Color navyBlue = const Color(0xFF222F3F);
  static Color blue = const Color(0xFF03152A);
  static Color darkGrey = const Color(0xff292e2f);
  static Color red = const Color(0xFFFE4545);
  static const Color white = Color(0xffFFFFFF);
  static const Color lightGrey = Color.fromARGB(255, 232, 232, 232);
  static const Color grey = Color(0xff9E9E9E);
  static const Color appBarElationColor = Color.fromARGB(137, 222, 222, 222);
  static const Color black = Color(0xff000000);
  static const Color darkblack = Color(0xff001828);
  static const Color black87 = Color(0xdd000000);
  static const Color black54 = Color(0x8a000000);
  static const Color black26 = Color(0x42000000);
  static const Color black12 = Color(0x0000001F);
  static const Color shimmerDarkGrey = Color(0xFFAFAFAF);
  static const Color darkGray = Color(0xff282828);
  static const Color teal = Color(0xFF009688);
  static const Color yellow = Color.fromARGB(255, 252, 219, 3);
  static const Color transparent = Colors.transparent;
  static InputBorder formDecoration() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColors.black, width: 0.5));
  }

  static InputBorder errorDecoration() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: AppColors.red, width: 1));
  }

  static LinearGradient backgroundGradientColor = const LinearGradient(
    colors: [Color(0xff3356F2), AppColors.darkblack],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
