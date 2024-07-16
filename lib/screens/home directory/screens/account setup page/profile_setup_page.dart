import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../res/app_strings.dart';
import '../../../../utils/app_color.dart';
import '../../../../utils/navigator/page_navigator.dart';
import '../../../../widgets/default_button.dart';
import '../../../../widgets/form_text.dart';
import '../../../../widgets/small_text.dart';
import '../../../auth directory/signup auth directory/screens/passcode_setup.dart';
import '../../supabase/profile_info_db.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  bool confirmObscureText = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController homeAddressController = TextEditingController();
  TextEditingController stateOfOriginController = TextEditingController();
  TextEditingController lgaController = TextEditingController();
  TextEditingController bvnController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();

  bool get isValidEmail => _isValidEmail;

  bool get isValidPassword => _isValidPassword;
  late bool _isValidEmail;
  late bool _isValidPassword;
  late bool _isLoading;
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _isValidEmail = false;
    _isValidPassword = false;
    _isLoading = false;
    _userFuture = _getCurrentUser();
  }

  Future<User?> _getCurrentUser() async {
    return Supabase.instance.client.auth.currentUser;
  }

  Future<void> _saveProfileData() async {
    if (homeAddressController.text.isEmpty ||
        genderController.text.isEmpty ||
        dobController.text.isEmpty ||
        nationalityController.text.isEmpty ||
        stateOfOriginController.text.isEmpty ||
        lgaController.text.isEmpty ||
        bvnController.text.isEmpty ||
        phoneNumberController.text.isEmpty) {
      _showSnackBar("Please enter all required fields");
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final profileInfoDb = ProfileInfoDb();
      await profileInfoDb.addDataToProfileInfo(
        homeAddress: homeAddressController.text.trim(),
        dateOfBirth: dobController.text.trim(),
        gender: genderController.text.trim(),
        nationality: nationalityController.text.trim(),
        stateOfOrigin: stateOfOriginController.text.trim(),
        lga: lgaController.text.trim(),
        bvn: bvnController.text.trim(),
        phoneNumber: phoneNumberController.text.trim(),
      );
      _showSnackBar("Profile Updated.");
      NavigationHelper.navigateToReplacement(context, const PasscodeScreen());
      setState(() {
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar("An unexpected error occurred. Please try again later.");
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
    return FutureBuilder<User?>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 4.0,
              color: AppColor.primaryColor,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
              child: Text(
            'Error: ${snapshot.error}',
            style: TextStyle(
                color: AppColor.secondTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 24.sp,
                fontFamily: AppStrings.rubik),
          ));
        } else {
          final user = snapshot.data!;
          if (kDebugMode) {
            print(
                '${user.userMetadata!['first_name']} ${user.userMetadata!['last_name']}');
          }

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              title: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      NavigationHelper.navigateBack(
                        context,
                      );
                    },
                    child: Container(
                      height: 48.h,
                      width: 48.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          color: Colors.transparent,
                          border: Border.all(
                              color: AppColor.primaryColor, width: 1.5.w)),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_outlined,
                          color: AppColor.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  SmallText(
                    text: 'Complete Profile',
                    color: AppColor.secondTextColor,
                    fontWeight: FontWeight.bold,
                    size: 24.sp,
                  ),
                ],
              ),
            ),
            backgroundColor: AppColor.bg,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15.h),
                        Text(
                          "Let's get you started now!",
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontFamily: AppStrings.rubik,
                              color: AppColor.subColor,
                              fontWeight: FontWeight.w500),
                        ),
                        SmallText(
                          text: 'Email',
                          color: AppColor.subColor,
                          fontWeight: FontWeight.w500,
                          size: 14.sp,
                        ),
                        SizedBox(height: 8.h),
                        FormText(
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          controller: emailController,
                          readOnly: true,
                          hintText: user.email,
                          hintStyle: TextStyle(
                              color: AppColor.greyColor5,
                              fontWeight: FontWeight.w500,
                              fontSize: 17.sp,
                              fontFamily: AppStrings.rubik),
                          // controller: _emailController,
                        ),
                        SizedBox(height: 8.h),
                        SmallText(
                          text: 'Full legal name',
                          color: AppColor.subColor,
                          fontWeight: FontWeight.w500,
                          size: 14.sp,
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 163.w,
                              child: FormText(
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                textCapitalization: TextCapitalization.words,
                                controller: firstNameController,
                                readOnly: true,
                                hintText: user.userMetadata!['first_name'],
                                hintStyle: TextStyle(
                                    color: AppColor.greyColor5,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17.sp,
                                    fontFamily: AppStrings.rubik),
                                // controller: _emailController,
                              ),
                            ),
                            SizedBox(
                              width: 163.w,
                              child: FormText(
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                controller: lastNameController,
                                textCapitalization: TextCapitalization.words,
                                readOnly: true,
                                hintText: user.userMetadata!['last_name'],
                                hintStyle: TextStyle(
                                    color: AppColor.greyColor5,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17.sp,
                                    fontFamily: AppStrings.rubik),
                                // controller: _emailController,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        SmallText(
                          text: 'Phone number',
                          color: AppColor.subColor,
                          fontWeight: FontWeight.w500,
                          size: 14.sp,
                        ),
                        SizedBox(height: 8.h),
                        FormText(
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          maxLength: 11,
                          textCapitalization: TextCapitalization.words,
                          controller: phoneNumberController,
                          hintText: "Phone number",
                          hintStyle: TextStyle(
                              color: AppColor.greyColor5,
                              fontWeight: FontWeight.w500,
                              fontSize: 17.sp,
                              fontFamily: AppStrings.rubik),
                          // controller: _emailController,
                        ),
                        SizedBox(height: 20.h),
                        SmallText(
                          text: 'Gender',
                          color: AppColor.subColor,
                          fontWeight: FontWeight.w500,
                          size: 14.sp,
                        ),
                        SizedBox(height: 8.h),
                        FormText(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          controller: genderController,
                          hintText: "Male",
                          hintStyle: TextStyle(
                              color: AppColor.greyColor5,
                              fontWeight: FontWeight.w500,
                              fontSize: 17.sp,
                              fontFamily: AppStrings.rubik),
                          // controller: _emailController,
                        ),
                        SizedBox(height: 20.h),
                        SmallText(
                          text: 'Date of Birth',
                          color: AppColor.subColor,
                          fontWeight: FontWeight.w500,
                          size: 14.sp,
                        ),
                        SizedBox(height: 8.h),
                        FormText(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          controller: dobController,
                          hintText: "dd/mm/yyyy",
                          hintStyle: TextStyle(
                              color: AppColor.greyColor5,
                              fontWeight: FontWeight.w500,
                              fontSize: 17.sp,
                              fontFamily: AppStrings.rubik),
                          // controller: _emailController,
                        ),
                        SizedBox(height: 20.h),
                        SmallText(
                          text: 'Home Address',
                          color: AppColor.subColor,
                          fontWeight: FontWeight.w500,
                          size: 14.sp,
                        ),
                        SizedBox(height: 8.h),
                        FormText(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          controller: homeAddressController,
                          hintText:
                              "123 Main Street, Apartment 4B, City, State,",
                          hintStyle: TextStyle(
                              color: AppColor.greyColor5,
                              fontWeight: FontWeight.w500,
                              fontSize: 17.sp,
                              fontFamily: AppStrings.rubik),
                          // controller: _emailController,
                        ),
                        SizedBox(height: 20.h),
                        SmallText(
                          text: 'State of Origin',
                          color: AppColor.subColor,
                          fontWeight: FontWeight.w500,
                          size: 14.sp,
                        ),
                        SizedBox(height: 8.h),
                        FormText(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          controller: stateOfOriginController,
                          hintText: "Lagos State",
                          hintStyle: TextStyle(
                              color: AppColor.greyColor5,
                              fontWeight: FontWeight.w500,
                              fontSize: 17.sp,
                              fontFamily: AppStrings.rubik),
                          // controller: _emailController,
                        ),
                        SizedBox(height: 20.h),
                        SmallText(
                          text: 'Local Government Area',
                          color: AppColor.subColor,
                          fontWeight: FontWeight.w500,
                          size: 14.sp,
                        ),
                        SizedBox(height: 8.h),
                        FormText(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          controller: lgaController,
                          hintText: "Ikorodu",
                          hintStyle: TextStyle(
                              color: AppColor.greyColor5,
                              fontWeight: FontWeight.w500,
                              fontSize: 17.sp,
                              fontFamily: AppStrings.rubik),
                          // controller: _emailController,
                        ),
                        SizedBox(height: 20.h),
                        SmallText(
                          text: 'Nationality',
                          color: AppColor.subColor,
                          fontWeight: FontWeight.w500,
                          size: 14.sp,
                        ),
                        SizedBox(height: 8.h),
                        FormText(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          controller: nationalityController,
                          hintText: "Nigeria",
                          hintStyle: TextStyle(
                              color: AppColor.greyColor5,
                              fontWeight: FontWeight.w500,
                              fontSize: 17.sp,
                              fontFamily: AppStrings.rubik),
                          // controller: _emailController,
                        ),
                        SizedBox(height: 20.h),
                        SmallText(
                          text: 'bvn',
                          color: AppColor.subColor,
                          fontWeight: FontWeight.w500,
                          size: 14.sp,
                        ),
                        SizedBox(height: 8.h),
                        FormText(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          textCapitalization: TextCapitalization.words,
                          controller: bvnController,
                          hintText: "Bvn number must be 14 digits",
                          maxLength: 14,
                          hintStyle: TextStyle(
                              color: AppColor.greyColor5,
                              fontWeight: FontWeight.w500,
                              fontSize: 17.sp,
                              fontFamily: AppStrings.rubik),
                          // controller: _emailController,
                        ),
                        SizedBox(height: 30.h),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Your main content
                            DefaultButton(
                              onpressed: () {
                                _saveProfileData();
                              },
                              title: 'Save profile',
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
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
