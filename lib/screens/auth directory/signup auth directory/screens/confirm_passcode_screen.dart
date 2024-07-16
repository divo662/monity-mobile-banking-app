import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../res/app_icons.dart';
import '../../../../res/app_strings.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/navigator/page_navigator.dart';
import '../../../home directory/screens/bottom_nav_bar.dart';

class ConfirmPasscodeSetupScreen extends StatefulWidget {
  final String passcode;

  const ConfirmPasscodeSetupScreen({super.key, required this.passcode});

  @override
  State<ConfirmPasscodeSetupScreen> createState() =>
      _ConfirmPasscodeSetupScreenState();
}

class _ConfirmPasscodeSetupScreenState
    extends State<ConfirmPasscodeSetupScreen> {
  String confirmedPasscode = '';
  int inputCount = 0;

  void _onNumberPressed(String number) {
    if (inputCount < 4) {
      setState(() {
        confirmedPasscode += number;
        inputCount++;
        if (inputCount == 4) {
          if (confirmedPasscode == widget.passcode) {
            _savePasscode(widget.passcode);
          } else {
            _showSnackBar("Passcodes do not match. Please try again.");
            setState(() {
              confirmedPasscode = '';
              inputCount = 0;
            });
          }
        }
      });
    }
  }

  void _onDeletePressed() {
    if (inputCount > 0) {
      setState(() {
        confirmedPasscode =
            confirmedPasscode.substring(0, confirmedPasscode.length - 1);
        inputCount--;
      });
    }
  }

  Future<void> _savePasscode(String passcode) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception("User not authenticated");
    }

    try {
      _showSnackBar("Passcode set successfully.");
      NavigationHelper.navigateToReplacement(context, BottomNavbarScreen());
    } catch (e) {
      if (kDebugMode) {
        print('Error saving passcode: $e');
      }
      _showSnackBar("An error occurred while saving the passcode.");
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
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          'Confirm Passcode',
          style: TextStyle(
              fontFamily: AppStrings.rubik,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.secondTextColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              AppIcons.passcodeIcon,
              height: 150.h,
              width: double.infinity,
            ),
            Text(
              "Confirm Pin",
              style: TextStyle(
                  fontFamily: AppStrings.rubik,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade900),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 20.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: index < inputCount
                              ? Colors.transparent
                              : AppColor.greyColor5,
                          width: 1.5),
                      color: index < inputCount
                          ? AppColor.primaryColor
                          : Colors.transparent,
                    ),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18, bottom: 10),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                children: List.generate(10, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: InkWell(
                      onTap: () => _onNumberPressed('$index'),
                      borderRadius: BorderRadius.circular(50.0),
                      child: Center(
                        child: Text(
                          '$index',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontFamily: AppStrings.rubik,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                })
                  ..add(
                    IconButton(
                      icon: const Icon(Icons.backspace),
                      onPressed: _onDeletePressed,
                    ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
