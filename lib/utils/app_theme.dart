import 'export.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    // brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0.0,
      surfaceTintColor: Colors.black,
    ),
    navigationBarTheme: const NavigationBarThemeData(
      height: 55,
      indicatorColor: Colors.transparent,
      elevation: 5.0,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      backgroundColor: Colors.black,
      iconTheme: MaterialStatePropertyAll<IconThemeData>(
        IconThemeData(
          color: Colors.white,
          size: 30,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        foregroundColor: MaterialStateProperty.all(Colors.black),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: Colors.transparent),
        ),
      ),
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0xff242424)),
      minimumSize: MaterialStateProperty.all(Size.zero),
      padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      ),
    )),
    colorScheme: const ColorScheme.dark(
      brightness: Brightness.dark,
      background: Colors.black,
      onBackground: Colors.white,
      surfaceTint: Colors.black12,
      primary: Colors.white,
      onPrimary: Colors.black,
    ),
    // buttonTheme: _buildButtonTheme(),
    // fontFamily: cabinRegular,
    // inputDecorationTheme: _buildInputDecorationTheme(),
    // textTheme: _buildTextTheme(),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.appColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0.0,
      surfaceTintColor: Colors.black,
    ),
    switchTheme: SwitchThemeData(
      thumbColor:
          MaterialStateProperty.resolveWith<Color>((states) => AppColors.white),
    ),
    canvasColor: AppColors.white,
    scaffoldBackgroundColor: AppColors.white,
    fontFamily: cabinRegular,
    secondaryHeaderColor: AppColors.darkGrey,
    textTheme: _buildTextTheme(),
  );

  static TextTheme _buildTextTheme() {
    return TextTheme(
      bodyLarge: getNormalStyle(color: AppColors.white),
      bodyMedium: getNormalStyle(color: AppColors.darkGray),
      bodySmall: getNormalStyle(color: AppColors.lightGrey),
      displayLarge: getNormalStyle(color: AppColors.grey, fontSize: 15.h),
      displayMedium: getBoldStyle(color: AppColors.white, fontSize: 15.h),
      displaySmall: getMediumStyle(color: AppColors.white, fontSize: 15.h),
      headlineSmall: getNormalStyle(color: Colors.grey[500]!),
      titleLarge: getNormalStyle(color: AppColors.shimmerDarkGrey),
      titleMedium: getNormalStyle(color: AppColors.darkGray),
      titleSmall: getNormalStyle(color: AppColors.darkGray),
    );
  }

  static TextStyle getNormalStyle({
    required Color color,
    double fontSize = 14,
    double? height,
  }) {
    return TextStyle(color: color, height: height, fontSize: fontSize);
  }

  static TextStyle getBoldStyle({required Color color, double fontSize = 14}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle getMediumStyle(
      {required Color color, double fontSize = 14}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle setMediumStyle({
    Color? color,
    double? fontSize,
  }) {
    return TextStyle(
      color: color ?? AppColors.darkGrey,
      fontSize: fontSize ?? 14,
      fontWeight: FontWeight.w500,
    );
  }

  static ButtonThemeData _buildButtonTheme() {
    return ButtonThemeData(
      buttonColor: AppColors.yellow,
      colorScheme: const ColorScheme.light().copyWith(
        primary: AppColors.yellow,
      ),
    );
  }

  static AppBarTheme _buildAppBarTheme() {
    return AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 0,
      iconTheme: _buildIconTheme(),
    );
  }

  static IconThemeData _buildIconTheme() {
    return const IconThemeData(
      color: AppColors.white,
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme() {
    return InputDecorationTheme(
      fillColor: AppColors.appColor.withOpacity(0.3),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      errorStyle: getNormalStyle(color: AppColors.red),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.red,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.red,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5.r),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.red,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(5.r),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.red,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(5.r),
      ),
      contentPadding: EdgeInsets.all(13.0.sp),
      alignLabelWithHint: false,
    );
  }
}
