import 'export.dart';

class CommonButton extends StatefulWidget {
  const CommonButton(
      {super.key,
      this.ontap,
      required this.text,
      this.height,
      this.width,
      this.latterSpacing,
      this.border,
      this.color,
      this.textColor,
      this.padding,
      this.fontSize});

  final void Function()? ontap;
  final String text;
  final double? height;
  final double? width;
  final int? latterSpacing;
  final double? fontSize;
  final Color? color;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final BoxBorder? border;

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: Container(
        padding: widget.padding ?? EdgeInsets.zero,
        alignment: Alignment.center,
        height: widget.height ?? 40.h,
        width: widget.width ?? 340.w,
        decoration: BoxDecoration(
          color: widget.color ?? AppColors.white,
          border: widget.border ??
              Border.all(color: AppColors.darkblack, width: 1.w),
          borderRadius: BorderRadius.circular(40.r),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
              color: widget.textColor ?? AppColors.black,
              fontWeight: FontWeight.w400,
              fontSize: widget.fontSize ?? 16.sp,
              height: 1.sp,
              letterSpacing: 0.sp),
        ),
      ),
    );
  }
}
