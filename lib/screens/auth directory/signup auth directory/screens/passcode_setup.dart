
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../res/app_icons.dart';
import '../../../../res/app_strings.dart';
import '../../../../utils/app_color.dart';
import 'confirm_passcode_screen.dart';


class PasscodeScreen extends StatefulWidget {
  const PasscodeScreen({super.key});

  @override
  State<PasscodeScreen> createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  String passcode = '';
  int inputCount = 0;

  void _onNumberPressed(String number) {
    if (inputCount < 4) {
      setState(() {
        passcode += number;
        inputCount++;
        if (inputCount == 4) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  ConfirmPasscodeSetupScreen(passcode: passcode),
            ),
          );
        }
      });
    }
  }

  void _onDeletePressed() {
    if (inputCount > 0) {
      setState(() {
        passcode = passcode.substring(0, passcode.length - 1);
        inputCount--;
      });
    }
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
          'Create Passcode',
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
              "Create Pin",
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
            })..add(
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
