import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:monity/widgets/small_text.dart';
import '../utils/app_color.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    super.key,
    this.onpressed,
    required this.title,
    required this.buttonWidth,
    this.buttonHeight = 55,
    this.buttonTextFontSize = 16,
    this.buttonColor = AppColor.primaryColor,
    this.buttonTextColor = AppColor.whiteTextColor,
  });
  final String title;
  final VoidCallback? onpressed;
  final double buttonWidth;
  final double buttonHeight;
  final double buttonTextFontSize;
  final Color buttonColor;
  final Color buttonTextColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        height: buttonHeight,
        width: buttonWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: buttonColor,
        ),
        child: Align(
          alignment: Alignment.center,
          child: SmallText(
            text: title,
            color: buttonTextColor,
            fontWeight: FontWeight.w500,
            size: 15.sp,
          ),
        ),
      ),
    );
  }
}
