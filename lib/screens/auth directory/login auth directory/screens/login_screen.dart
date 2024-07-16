import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../main.dart';
import '../../../../res/app_strings.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/navigator/page_navigator.dart';
import '../../../../widgets/default_button.dart';
import '../../../../widgets/form_text.dart';
import '../../../../widgets/small_text.dart';
import '../../../home directory/screens/bottom_nav_bar.dart';
import '../../signup auth directory/screens/user_reg_screen.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> logIn() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showSnackBar("Please enter your email and password");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      NavigationHelper.navigateToReplacement(context, BottomNavbarScreen());
    } on AuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      String errorMessage = e.statusCode == '400'
          ? "Invalid Credentials"
          : "An error occurred. Please try again later.";
      _showSnackBar(errorMessage);
    }
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
                  fontSize: 17.sp),
            ),
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h),
              SmallText(
                  text: 'Welcome Back',
                  color: AppColor.secondTextColor,
                  fontWeight: FontWeight.bold,
                  size: 24.sp),
              SizedBox(height: 15.h),
              Text(
                "Welcome back!\nReady to bank today?",
                style: TextStyle(
                    fontSize: 15.sp,
                    fontFamily: AppStrings.rubik,
                    color: AppColor.subColor,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 27.h),
              SmallText(
                  text: 'Email',
                  color: AppColor.subColor,
                  fontWeight: FontWeight.w500,
                  size: 14.sp),
              SizedBox(height: 8.h),
              FormText(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                controller: emailController,
                hintText: 'xyz@gmail.com',
                hintStyle: TextStyle(
                    color: AppColor.greyColor5,
                    fontWeight: FontWeight.w500,
                    fontSize: 17.sp,
                    fontFamily: AppStrings.rubik),
              ),
              SizedBox(height: 20.h),
              SmallText(
                  text: 'Password',
                  color: AppColor.subColor,
                  fontWeight: FontWeight.w500,
                  size: 14.sp),
              SizedBox(height: 8.h),
              FormText(
                textColor: AppColor.textColor,
                keyboardType: TextInputType.text,
                controller: passwordController,
                textInputAction: TextInputAction.done,
                suffixIcon: IconButton(
                  icon: Icon(_obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                hintText: '• • • • • •',
                hintStyle: TextStyle(
                    color: AppColor.greyColor5,
                    fontWeight: FontWeight.w500,
                    fontSize: 17.sp,
                    fontFamily: AppStrings.rubik),
                obscureText: _obscureText,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    NavigationHelper.navigateToPage(
                        context, const ForgotPassword());
                  },
                  child: SmallText(
                      text: 'Forgot Password?',
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.w600,
                      size: 15.sp),
                ),
              ),
              SizedBox(height: 27.h),
              Stack(
                alignment: Alignment.center,
                children: [
                  DefaultButton(
                      onpressed: logIn,
                      title: 'Login',
                      buttonWidth: double.infinity),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                          color: Colors.blue, strokeWidth: 2.0),
                    ),
                ],
              ),
              SizedBox(height: 27.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmallText(
                      text: "Don't have an account?",
                      color: AppColor.subColor,
                      size: 16.sp),
                  TextButton(
                    onPressed: () {
                      NavigationHelper.navigateToPage(
                          context, const UserRegScreen());
                    },
                    child: SmallText(
                        text: 'Get Started',
                        size: 16.sp,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
