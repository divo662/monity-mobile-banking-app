import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../res/app_strings.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/navigator/page_navigator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../widgets/default_button.dart';
import '../../../../widgets/form_text.dart';
import '../../../../widgets/small_text.dart';
import 'login_screen.dart';

class ResetPassword extends StatefulWidget {
  final String email;

  const ResetPassword({super.key, required this.email});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          password: _passwordController.text,
        ),
      );

      if (response.user != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password reset successful')),
          );
          NavigationHelper.navigateToReplacement(
            context,
            const LoginScreen(),
          );
        }
      }
    } on AuthException catch (error) {
      _showSnackBar("$error");
    } catch (error) {
      _showSnackBar("Unexpected error occurred");
    }

    setState(() => _isLoading = false);
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
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Reset Password",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.sp,
            fontFamily: AppStrings.rubik,
            fontWeight: FontWeight.w400,
            color: AppColor.secondTextColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                'Enter your new password',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.secondTextColor,
                  fontFamily: AppStrings.rubik
                ),
              ),
              SizedBox(height: 20.h),
              SmallText(
                text: 'New Password',
                color: AppColor.subColor,
                fontWeight: FontWeight.w500,
                size: 14.sp,
              ),
              SizedBox(height: 8.h),
              FormText(
                textColor: AppColor.textColor,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                controller: _passwordController,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                hintText: 'Must be up to 6 characters',
                hintStyle: TextStyle(
                    color: AppColor.greyColor5,
                    fontWeight: FontWeight.w500,
                    fontSize: 17.sp,
                    fontFamily: AppStrings.rubik),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
                obscureText: _obscurePassword,
              ),
              SizedBox(height: 20.h),
              SmallText(
                text: 'Confirm Password',
                color: AppColor.subColor,
                fontWeight: FontWeight.w500,
                size: 14.sp,
              ),
              SizedBox(height: 8.h),
              FormText(
                textColor: AppColor.textColor,
                keyboardType: TextInputType.text,
                controller: _confirmPasswordController,
                textInputAction: TextInputAction.done,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                hintText: 'Re-enter password',
                hintStyle: TextStyle(
                    color: AppColor.greyColor5,
                    fontWeight: FontWeight.w500,
                    fontSize: 17.sp,
                    fontFamily: AppStrings.rubik),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                obscureText: _obscureConfirmPassword,
              ),
              SizedBox(height: 50.h),
              Stack(
                alignment: Alignment.center,
                children: [
                  // Your main content
                  DefaultButton(
                    onpressed: () {
                      _resetPassword();
                    },
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
            ],
          ),
        ),
      ),
    );
  }
}

