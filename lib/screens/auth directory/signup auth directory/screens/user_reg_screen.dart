import 'dart:io';
import 'package:flutter/foundation.dart';
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
import '../../login auth directory/screens/login_screen.dart';
import '../widget/verify_success_screen.dart';

class UserRegScreen extends StatefulWidget {
  const UserRegScreen({super.key});

  @override
  State<UserRegScreen> createState() => _UserRegScreenState();
}

class _UserRegScreenState extends State<UserRegScreen> {
  bool _obscureText = true;
  bool confirmObscureText = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool get isValidEmail => _isValidEmail;
  bool get isValidPassword => _isValidPassword;
  late bool _isValidEmail;
  late bool _isValidPassword;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isValidEmail = false;
    _isValidPassword = false;
    _isLoading = false;

    emailController.addListener(_validateFields);
    passwordController.addListener(_validateFields);
    confirmPasswordController.addListener(_validateFields);
  }

  @override
  void dispose() {
    emailController.removeListener(_validateFields);
    passwordController.removeListener(_validateFields);
    confirmPasswordController.removeListener(_validateFields);
    super.dispose();
  }

  Future<void> signUp() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showSnackBar("Please enter your email and password");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showSnackBar("Password doesn't match");
      return;
    }

    if (!_validatePassword(passwordController.text)) {
      _showSnackBar("Password must be more than 6 characters");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        data: {
          'first_name': firstNameController.text.trim(),
          'last_name': lastNameController.text.trim(),
        },
      );

      if (response.session != null) {
        throw response.session!;
      }

      if (!mounted) return;

      NavigationHelper.navigateToPage(
        context,
        VerifySuccessScreen(navScreen: () {
          NavigationHelper.navigateToReplacement(context, const LoginScreen());
        }),
      );
    } on AuthException catch (e) {
      _handleAuthError(e);
      if (kDebugMode) {
        print("Unexpected error: $e");
      }
    } on SocketException catch (_) {
      if (kDebugMode) {
        print("Unexpected error: $_");
      }
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
    if (e.statusCode == '400') {
      errorMessage = "Email is already in use. Please use a different email.";
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

  void _validateFields() {
    bool isValidEmail = _validateEmail(emailController.text);

    bool isValidPassword = _validatePassword(passwordController.text);

    bool isValidConfirmPassword =
        passwordController.text == confirmPasswordController.text;

    setState(() {
      _isValidEmail = isValidEmail;
      _isValidPassword = isValidPassword && isValidConfirmPassword;
    });
  }

  bool _validateEmail(String email) {
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  bool _validatePassword(String password) {
    bool isPasswordValid = password.length >= 6;
    return isPasswordValid;
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
              SizedBox(height: 45.h),
              SmallText(
                text: 'Welcome to Monity',
                color: AppColor.secondTextColor,
                fontWeight: FontWeight.bold,
                size: 24.sp,
              ),
              SizedBox(height: 15.h),
              Text(
                "Let's get you started now!",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: AppStrings.rubik,
                  color: AppColor.subColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 15.h),
              _buildTextField('Email', emailController, TextInputType.emailAddress, 'xyz@gmail.com'),
              _buildNameFields(),
              SizedBox(height: 20.h),
              _buildPasswordField('Password', passwordController, _obscureText),
              SizedBox(height: 20.h),
              _buildPasswordField('Confirm Password', confirmPasswordController, confirmObscureText),
              SizedBox(height: 50.h),
              _buildContinueButton(),
              SizedBox(height: 15.h),
              _buildSignInLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, TextInputType keyboardType, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SmallText(
          text: label,
          color: AppColor.subColor,
          fontWeight: FontWeight.w500,
          size: 14.sp,
        ),
        SizedBox(height: 8.h),
        FormText(
          keyboardType: keyboardType,
          textInputAction: TextInputAction.next,
          controller: controller,
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColor.greyColor5,
            fontWeight: FontWeight.w500,
            fontSize: 17.sp,
            fontFamily: AppStrings.rubik,
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }

  Widget _buildNameFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildTextField('First Name', firstNameController, TextInputType.text, 'First Name'),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildTextField('Last Name', lastNameController, TextInputType.text, 'Last Name'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool obscureText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SmallText(
          text: label,
          color: AppColor.subColor,
          fontWeight: FontWeight.w500,
          size: 14.sp,
        ),
        SizedBox(height: 8.h),
        FormText(
          textColor: AppColor.textColor,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          controller: controller,
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off_outlined : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                if (label == 'Password') {
                  _obscureText = !_obscureText;
                } else {
                  confirmObscureText = !confirmObscureText;
                }
              });
            },
          ),
          hintText: label == 'Password' ? 'Must be at least 6 characters' : 'Re-enter password',
          hintStyle: TextStyle(
            color: AppColor.greyColor5,
            fontWeight: FontWeight.w500,
            fontSize: 17.sp,
            fontFamily: AppStrings.rubik,
          ),
          obscureText: obscureText,
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return Stack(
      alignment: Alignment.center,
      children: [
        DefaultButton(
          onpressed: signUp,
          title: 'Continue',
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
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SmallText(
          text: "Already have an account?",
          color: AppColor.subColor,
          size: 16,
        ),
        TextButton(
          onPressed: () {
            NavigationHelper.navigateToPage(
              context,
              const LoginScreen(),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
          ),
          child: const SmallText(
            text: 'Sign In',
            color: AppColor.secBlueColor,
            size: 16,
          ),
        ),
      ],
    );
  }
}


