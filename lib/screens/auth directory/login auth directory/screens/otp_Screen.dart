import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:monity/screens/auth%20directory/login%20auth%20directory/screens/reset_password.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../main.dart';
import '../../../../res/app_strings.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/navigator/page_navigator.dart';
import '../../../../widgets/default_button.dart';
import '../../../../widgets/small_text.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  int _remainingTime = 59;
  Timer? _timer;
  bool _isLoading = false;

  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> confirmOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = _concatenateOtp();
      await supabase.auth.verifyOTP(
        type: OtpType.recovery,
        token: token,
        email: widget.email,
      );

      if (mounted) {
        NavigationHelper.navigateToReplacement(
          context,
          ResetPassword(email: widget.email),
        );
      }
    } catch (error) {
      _showSnackBar("Failed to verify OTP. Please try again.");
      if (kDebugMode) {
        print('Error verifying OTP: $error');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _concatenateOtp() {
    return otpControllers.map((controller) => controller.text).join();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        dismissDirection: DismissDirection.startToEnd,
        content: Container(
          width: 190.w,
          height: 56.h,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(45),
            color: Colors.redAccent,
          ),
          child: Center(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => NavigationHelper.navigateBack(context),
              child: Container(
                height: 48.h,
                width: 48.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColor.primaryColor, width: 1.5),
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_outlined,
                    color: AppColor.primaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(width: 0.3 * MediaQuery.of(context).size.width),
            SmallText(
              text: "OTP",
              fontWeight: FontWeight.w400,
              color: AppColor.blueTitleColor,
              size: 20.sp,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SmallText(
                text: 'Enter OTP Code',
                fontWeight: FontWeight.w400,
                color: AppColor.secondTextColor,
                size: 20.sp,
              ),
              SizedBox(height: 5.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: AppStrings.rubik,
                  ),
                  children: [
                    TextSpan(
                      text: "We have just sent a code to ",
                      style: TextStyle(
                        color: AppColor.subColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: AppStrings.rubik,
                      ),
                    ),
                    TextSpan(
                      text: widget.email,
                      style: TextStyle(
                        color: AppColor.primaryColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: AppStrings.rubik,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50.h),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      height: 56,
                      width: 56,
                      child: TextFormField(
                        autofocus: false,
                        controller: otpControllers[index],
                        style: TextStyle(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 32.sp,
                          fontFamily: AppStrings.rubik,
                        ),
                        onChanged: (value) {
                          if (value.length == 1 && index < 5) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: "",
                          fillColor: Colors.blueGrey.shade100.withOpacity(0.1),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColor.primaryColor,
                              width: 1.5.w,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              width: 1.5.w,
                              color: AppColor.primaryColor,
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 50.h),
              Stack(
                alignment: Alignment.center,
                children: [
                  DefaultButton(
                    onpressed: confirmOtp,
                    title: 'Reset Password',
                    buttonWidth: double.infinity,
                  ),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 6.0,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20.h),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppStrings.rubik,
                    ),
                    children: [
                      TextSpan(
                        text: "Didn't get a code? ",
                        style: TextStyle(
                          color: AppColor.subColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: AppStrings.rubik,
                        ),
                      ),
                      TextSpan(
                        text: 'Resend in ($_remainingTime)s',
                        style: TextStyle(
                          color: AppColor.primaryColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: AppStrings.rubik,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
