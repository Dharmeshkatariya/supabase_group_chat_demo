import 'export.dart';

class GetTextTheme {
  static TextStyle getBodyLarge(BuildContext context,
      {double? fontSize,
      double? height,
      FontWeight? fontWeight,
      Color? color,
      String? fontFamily}) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
          height: height,
          color: color,
          fontFamily: fontFamily,
        );
  }

  static TextStyle getBodyMedium(BuildContext context,
      {double? fontSize,
      FontWeight? fontWeight,
      Color? color,
      String? fontFamily}) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontFamily: fontFamily,
        );
  }

  static TextStyle getBodySmall(BuildContext context,
      {double? fontSize,
      FontWeight? fontWeight,
      Color? color,
      String? fontFamily}) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontFamily: fontFamily,
        );
  }

  static TextStyle getDisplayLarge(BuildContext context,
      {double? fontSize,
      FontWeight? fontWeight,
      Color? color,
      String? fontFamily}) {
    return Theme.of(context).textTheme.displayLarge!.copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontFamily: fontFamily,
        );
  }

  static TextStyle getDisplayMedium(BuildContext context,
      {double? fontSize,
      FontWeight? fontWeight,
      Color? color,
      String? fontFamily}) {
    return Theme.of(context).textTheme.displayMedium!.copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontFamily: fontFamily,
        );
  }

  static TextStyle getDisplaySmall(BuildContext context,
      {double? fontSize,
      FontWeight? fontWeight,
      Color? color,
      String? fontFamily}) {
    return Theme.of(context).textTheme.displaySmall!.copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontFamily: fontFamily,
        );
  }

  static TextStyle getTitleLarge(BuildContext context,
      {double? fontSize,
      FontWeight? fontWeight,
      Color? color,
      String? fontFamily}) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontFamily: fontFamily,
        );
  }

  static TextStyle getTitleMedium(BuildContext context,
      {double? fontSize,
      FontWeight? fontWeight,
      Color? color,
      String? fontFamily}) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontFamily: fontFamily,
        );
  }

  static TextStyle getTitleSmall(BuildContext context,
      {double? fontSize,
      FontWeight? fontWeight,
      Color? color,
      String? fontFamily}) {
    return Theme.of(context).textTheme.titleSmall!.copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontFamily: fontFamily,
        );
  }

  static TextStyle getLabelSmall(BuildContext context,
      {double? fontSize,
      FontWeight? fontWeight,
      Color? color,
      String? fontFamily}) {
    return Theme.of(context).textTheme.labelSmall!.copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontFamily: fontFamily,
        );
  }

  static TextStyle getLabelMedium(BuildContext context,
      {double? fontSize,
      FontWeight? fontWeight,
      Color? color,
      String? fontFamily}) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontFamily: fontFamily,
        );
  }

  static TextStyle getLabelLarge(BuildContext context,
      {double? fontSize,
      FontWeight? fontWeight,
      Color? color,
      String? fontFamily}) {
    return Theme.of(context).textTheme.labelLarge!.copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontFamily: fontFamily,
        );
  }

  static TextStyle getHeadlineLarge(BuildContext context,
      {double? fontSize,
      FontWeight? fontWeight,
      Color? color,
      String? fontFamily}) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontFamily: fontFamily,
        );
  }

  static TextStyle getHeadlineMedium(BuildContext context,
      {double? fontSize,
      FontWeight? fontWeight,
      Color? color,
      String? fontFamily}) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontFamily: fontFamily,
        );
  }

  static TextStyle getHeadlineSmall(BuildContext context,
      {double? fontSize,
      FontWeight? fontWeight,
      Color? color,
      String? fontFamily}) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontFamily: fontFamily,
        );
  }
}
