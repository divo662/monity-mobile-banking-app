import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../res/app_strings.dart';
import '../utils/app_color.dart';

class FormText extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final Color? fillColor;
  final GestureTapCallback? onTap;
  final String? labelText;
  final String? textViewTitle;
  final String? hintText;
  final bool readOnly;
  final bool autofocus;
  final bool autocorrect;
  final bool obscureText;
  final double borderRadius;
  final double borderWidth;
  final bool isDense;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? borderColor;
  final int? maxLines;
  final int? maxLength;
  final bool filled;
  final String? prefixText;
  final String? helperText;
  final Color? iconColor;
  final Color? textColor;
  final Iterable<String>? autofillHints;
  final FocusNode? focusNode;
  final TextStyle? hintStyle;

  final EdgeInsetsGeometry? contentPadding;

  const FormText(
      {super.key,
      this.onChanged,
      this.controller,
      this.fillColor,
      this.onTap,
      this.keyboardType,
      this.textInputAction,
      this.validator,
      this.readOnly = false,
      this.autofocus = false,
      this.autocorrect = false,
      this.obscureText = false,
      this.isDense = true,
      this.labelText,
      this.hintText,
      this.onFieldSubmitted,
      this.borderRadius = 6.0,
      this.borderWidth = 0.5,
      this.suffixIcon,
      this.iconColor,
      this.textColor = Colors.black,
      this.prefixIcon,
      this.borderColor,
      this.filled = true,
      this.prefixText,
      this.autofillHints,
      this.focusNode,
      this.helperText,
      this.maxLength,
      this.maxLines = 1,
      this.contentPadding,
      this.hintStyle,
      this.textViewTitle = '',
        this.textCapitalization});

  OutlineInputBorder _border(BuildContext context) => OutlineInputBorder(
      borderSide: BorderSide(
          width: 1.5.w, color: AppColor.primaryColor, style: BorderStyle.solid),
      borderRadius: const BorderRadius.all(Radius.circular(15)));

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      autocorrect: autocorrect,
      readOnly: readOnly,
      autofocus: autofocus,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      autofillHints: autofillHints,
      onFieldSubmitted: onFieldSubmitted,
      focusNode: focusNode,
      style: TextStyle(
          color: AppColor.textColor,
          fontWeight: FontWeight.w500,
          fontSize: 17.sp,
          fontFamily: AppStrings.rubik),
      decoration: InputDecoration(
          border: _border(context),
          enabledBorder: _border(context),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide(
                  width: 1.5.w,
                  color: AppColor.primaryColor,
                  style: BorderStyle.solid)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide:  BorderSide(
                  width: 1.5.w,
                  color: AppColor.errorColor,
                  style: BorderStyle.solid)),
          errorBorder: _border(context),
          disabledBorder: _border(context),
          hintText: hintText,
          hintStyle: TextStyle(
              color: AppColor.greyColor5,
              fontWeight: FontWeight.w400,
              fontSize: 15.sp,
              fontFamily: AppStrings.rubik),
          labelText: labelText,
          contentPadding: contentPadding,
          labelStyle: const TextStyle(
            color: Colors.grey,
          ),
          filled: filled,
          isDense: isDense,
          fillColor: AppColor.bg,
          helperText: helperText,
          helperMaxLines: 2,
          helperStyle: const TextStyle(fontSize: 10),
          prefixText: prefixText,
          prefixIcon: prefixIcon,
          iconColor: AppColor.greyColor5,
          prefixIconColor: AppColor.greyColor5,
          suffixIcon: suffixIcon,
          suffixIconColor: AppColor.greyColor5),
    );
  }
}
