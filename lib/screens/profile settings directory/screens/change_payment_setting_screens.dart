import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../res/app_strings.dart';
import '../../../utils/app_color.dart';
import '../../../utils/navigator/page_navigator.dart';
import '../../../widgets/default_button.dart';
import '../../../widgets/small_text.dart';

class PasscodeChangeScreen extends StatefulWidget {
  const PasscodeChangeScreen({super.key});

  @override
  State<PasscodeChangeScreen> createState() => _PasscodeChangeScreenState();
}

class _PasscodeChangeScreenState extends State<PasscodeChangeScreen> {
  final TextEditingController _otpController1 = TextEditingController();
  final TextEditingController _otpController2 = TextEditingController();
  final TextEditingController _otpController3 = TextEditingController();
  final TextEditingController _otpController4 = TextEditingController();
  String _passcode = '';
  bool _isLoading = false;

  void _updatePasscode() async {
    setState(() {
      _isLoading = true;
    });

    String newPasscode = _passcode;
    final user = Supabase.instance.client.auth.currentUser;

    try {
      final response = await Supabase.instance.client
          .from('user_passcodes')
          .update({'passcode': newPasscode})
          .eq('user_id', user!.id);

      if(mounted) {
        NavigationHelper.navigateBack(context);
      }

      if (response != null) {
        throw Exception('Error updating passcode: $response');
      }

      _showSnackBar('Passcode updated successfully');
    } catch (e) {
      _showSnackBar('Failed to update passcode: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onOtpChange(String value, int index) {
    if (value.length == 1) {
      _passcode += value;
      if (index < 3) {
        FocusScope.of(context).nextFocus();
      }
    } else if (value.isEmpty && index > 0) {
      _passcode = _passcode.substring(0, _passcode.length - 1);
      FocusScope.of(context).previousFocus();
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
              onTap: () {
                NavigationHelper.navigateBack(context);
              },
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.transparent,
                    border:
                    Border.all(color: AppColor.primaryColor, width: 1.5)),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_outlined,
                    color: AppColor.primaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              width:5.w,
            ),
            SmallText(
              text: "Change Passcode",
              fontWeight: FontWeight.w400,
              color: AppColor.blueTitleColor,
              size: 20.sp,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter New Passcode',
              style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                fontFamily: AppStrings.rubik,
                color: AppColor.secondTextColor
              )
            ),
            SizedBox(height: 40.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOtpTextField(_otpController1, 0),
                _buildOtpTextField(_otpController2, 1),
                _buildOtpTextField(_otpController3, 2),
                _buildOtpTextField(_otpController4, 3),
              ],
            ),
            SizedBox(height: 40.h),
            Stack(
              alignment: Alignment.center,
              children: [
                DefaultButton(
                  onpressed: _isLoading ? null : _updatePasscode,
                  title: 'Save Passcode',
                  buttonWidth: double.infinity,
                ),
                // Loading indicator
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
    );
  }

  Widget _buildOtpTextField(TextEditingController controller, int index) {
    return SizedBox(
      height: 56.h,
      width: 56.w,
      child: TextFormField(
        controller: controller,
        onChanged: (value) {
          _onOtpChange(value, index);
        },
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
            color: AppColor.primaryColor,
            fontWeight: FontWeight.w400,
            fontSize: 32.sp,
            fontFamily: AppStrings.rubik),
        decoration: InputDecoration(
            counterText: "",
            hoverColor: AppColor.textColor,
            fillColor:
            Colors.blueGrey.shade100.withOpacity(0.1),
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
                    style: BorderStyle.solid)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    width: 1.5.w,
                    color: AppColor.errorColor,
                    style: BorderStyle.solid)),
            contentPadding: EdgeInsets.zero),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }
}
