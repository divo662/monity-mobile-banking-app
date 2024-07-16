import 'package:flutter/material.dart';
import '../res/app_strings.dart';

class SmallText extends StatelessWidget {
  final String text;
  final double size;
  final Color? color;
  final FontWeight fontWeight;
  final TextAlign align;
  final TextDecoration decoration;

  const SmallText({
    super.key,
    required this.text,
    this.size = 13,
    this.color,
    this.fontWeight = FontWeight.w500,
    this.align = TextAlign.left,
    this.decoration = TextDecoration.none,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontFamily: AppStrings.rubik,
        fontWeight: fontWeight,
        decoration: decoration,
      ),
    );
  }
}
