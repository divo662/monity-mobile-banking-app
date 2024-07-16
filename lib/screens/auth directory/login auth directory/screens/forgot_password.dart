import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../main.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/navigator/page_navigator.dart';
import '../../../../widgets/default_button.dart';
import '../../../../widgets/form_text.dart';
import '../../../../widgets/small_text.dart';
import 'login_screen.dart';
import 'otp_Screen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (kDebugMode) {
        print("Attempting to reset password for: ${emailController.text.trim()}");
      }
      await supabase.auth.resetPasswordForEmail(emailController.text.trim());
      if (!mounted) return;
      NavigationHelper.navigateToPage(context,  OtpScreen(email: emailController.text.trim()));
    } on AuthException catch (e) {
      if (kDebugMode) {
        print("AuthException: ${e.message}");
      }
      _handleAuthError(e);
    } on SocketException catch (_) {
      _showSnackBar("No internet connection. Please check your network.");
    } catch (e) {
      if (kDebugMode) {
        print("Unexpected error: $e");
      }
      _showSnackBar("An unexpected error occurred. Please try again later.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleAuthError(AuthException e) {
    String errorMessage = "An error occurred. Please try again later.";
    if (e.message.contains('400')) {
      errorMessage = "No user found with that email.";
    } else if (e.message.contains('AuthRetryableFetchError')) {
      errorMessage = "Temporary network issue. Please try again later.";
    }
    _showSnackBar(errorMessage);
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        )),
                    SmallText(
                      text: 'Forgot Password',
                      color: AppColor.secondTextColor,
                      fontWeight: FontWeight.w600,
                      size: 24.sp,
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                SmallText(
                  text:
                      'Input your email address to get an OTP to reset your password.',
                  color: AppColor.greyColor5,
                  size: 14.sp,
                ),
                SizedBox(height: 27.h),
                SmallText(
                  text: 'Email',
                  color: AppColor.greyColor5,
                  fontWeight: FontWeight.w600,
                  size: 14.sp,
                ),
                SizedBox(height: 8.h),
                 FormText(
                  borderRadius: 19,
                  textColor: AppColor.textColor,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  hintText: 'xyz@example.com',
                  // controller: _emailController,
                ),
                SizedBox(height: 50.h),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    DefaultButton(
                      onpressed: () {
                        resetPassword();
                      },
                      title: 'Proceed',
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
                SizedBox(height: 17.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SmallText(
                      text: "Remember password?",
                      color: AppColor.subColor,
                      size: 16.sp,
                    ),
                    TextButton(
                      onPressed: () {
                        NavigationHelper.navigateToPage(
                          context,
                          const LoginScreen(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent),
                      child: SmallText(
                        text: 'Log In',
                        color: AppColor.primaryColor,
                        size: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
