import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../res/app_strings.dart';
import '../utils/app_color.dart';

class CustomPhoneNumberTextFormField extends StatelessWidget {
  final Color inputColor;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color fillColor;
  final bool willContainPrefix;
  final Color borderSideColor;

  const CustomPhoneNumberTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.name,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor = Colors.white,
    this.willContainPrefix = true,
    required this.inputColor,
    required this.borderSideColor,
    required TextInputAction textInputAction, required bool readOnly,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: double.infinity,
      padding: EdgeInsets.only(left: 8.sp,right: 8.sp),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
              width: 1.5.w,
              color: AppColor.primaryColor,
              style: BorderStyle.solid)
      ),
      child: InternationalPhoneNumberInput(
        textStyle:  TextStyle(
          color: AppColor.textColor,
          fontFamily: AppStrings.rubik,
          fontSize: 17.sp,
          fontWeight: FontWeight.w400,
        ),
        initialValue: PhoneNumber(isoCode: 'NG'),
        onSaved: (PhoneNumber? number) {
          // Save phone number if needed
        },
        spaceBetweenSelectorAndTextField: 5,
        onInputChanged: (PhoneNumber number) {
          // Handle phone number changes here if needed
        },
        selectorConfig: const SelectorConfig(
          selectorType: PhoneInputSelectorType.DIALOG,
        ),
        inputDecoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
              color: AppColor.greyColor5,
              fontWeight: FontWeight.w400,
              fontSize: 15.sp,
              fontFamily: AppStrings.rubik),
          filled: true,
          fillColor: AppColor.bg,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(10),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
