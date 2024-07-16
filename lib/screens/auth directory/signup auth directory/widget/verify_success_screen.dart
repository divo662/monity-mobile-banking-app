import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../res/app_icons.dart';
import '../../../../res/app_strings.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/navigator/page_navigator.dart';
import '../../../../widgets/default_button.dart';
import '../../../../widgets/small_text.dart';

class VerifySuccessScreen extends StatelessWidget {
  final GestureTapCallback navScreen;
  const VerifySuccessScreen({super.key, required this.navScreen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100.h,),
            Image.asset(AppIcons.congrats,
              height: 350.h,
              width: double.infinity,
            ),
            Text(
              "Verification Success",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24.sp,
                  fontFamily: AppStrings.rubik,
                  fontWeight: FontWeight.w500,
                  color: AppColor.secondTextColor
              ),
            ),
            SizedBox(height: 8.h),
            SmallText(
              text:
              'Congratulations your account is ready to use,\n'
                  'now you can start banking.',
              fontWeight: FontWeight.w400,
              color: AppColor.subColor,
              align: TextAlign.center,
              size: 15.sp,
            ),
            SizedBox(height: 60.h),
            DefaultButton(
              onpressed: navScreen,
              title: 'Continue',
              buttonWidth: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
