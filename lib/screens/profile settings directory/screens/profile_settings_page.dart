
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../main.dart';
import '../../../res/app_strings.dart';
import '../../../utils/app_color.dart';
import '../../../utils/navigator/page_navigator.dart';
import '../../../widgets/default_button.dart';
import '../../../widgets/small_text.dart';
import '../../auth directory/login auth directory/screens/login_screen.dart';
import '../../auth directory/signup auth directory/screens/terms_and_condition_screen.dart';
import '../../home directory/supabase/profile_info_db.dart';
import '../widgets/profile_details_widget.dart';
import 'change_password_setting_screen.dart';
import 'change_payment_setting_screens.dart';


class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  Map<String, dynamic>? _profileInfo;
  bool _isLoading = true;

  final profileInfoDb = ProfileInfoDb();

  @override
  void initState() {
    super.initState();
    _fetchProfileInfo();
  }

  Future<void> _fetchProfileInfo() async {
    try {
      final profileInfo = await profileInfoDb.getUserProfileInfo();
      setState(() {
        _profileInfo = profileInfo;
        _isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching profile info: $e');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await supabase.auth.signOut();
      NavigationHelper.navigateToReplacement(context, const LoginScreen());
    } on AuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      String errorMessage = "An error occurred. Please try again later.";
      if (e.statusCode == '400') {
        errorMessage = "Couldn't logout, please try again";
      }
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
                errorMessage,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 17.sp,
                ),
              ),
            ),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _fetchProfileInfo,
      color: AppColor.primaryColor,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      backgroundColor: AppColor.bg,
      child: Scaffold(
        backgroundColor: AppColor.bg,
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _profileInfo == null
            ? Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  'Error loading profile info, please check your network and reload page.',
                  style: TextStyle(
                    color: AppColor.subColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    fontFamily: AppStrings.rubik,
                  ),
                ),
                SizedBox(height: 10.h),
                DefaultButton(
                  onpressed: _fetchProfileInfo,
                  title: "Refresh",
                  buttonWidth: double.infinity,
                ),
              ],
            ),
          ),
        )
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 45.h),
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColor.greyColor3,
                  child: const Icon(
                    Icons.person,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
              ),
              Center(
                child: Text(
                  '${_profileInfo!['first_name'] ?? 'N/A'} ${_profileInfo!['last_name'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.secondTextColor,
                    fontFamily: AppStrings.rubik,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Center(
                child: Text(
                  'Account Number: ${_profileInfo!['account_number'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.subColor,
                    fontFamily: AppStrings.rubik,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Expanded(
                child: ListView(
                  children: [
                    _buildListTile(
                      icon: Icons.person,
                      text: "Profile Details",
                      onTap: () {
                        NavigationHelper.navigateToPage(
                            context, const ProfileDetailsWidget());
                      },
                    ),
                    _buildListTile(
                      icon: Icons.login,
                      text: "Change Password Settings",
                      onTap: () {
                        NavigationHelper.navigateToPage(
                            context, const ChangePasswordScreen());
                      },
                    ),
                    _buildListTile(
                      icon: Icons.payment,
                      text: "Payment Settings",
                      onTap: () {
                        NavigationHelper.navigateToPage(
                            context, const PasscodeChangeScreen());
                      },
                    ),
                    _buildListTile(
                      icon: Icons.notifications_active,
                      text: "Push Notification Settings",
                      onTap: () {},
                    ),
                    _buildListTile(
                      icon: Icons.info,
                      text: "About Monity",
                      onTap: () {
                        NavigationHelper.navigateToPage(
                            context, const TermsAndConditionsScreen());
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              DefaultButton(
                onpressed: _logout,
                title: "Logout",
                buttonWidth: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListTile _buildListTile(
      {required IconData icon,
        required String text,
        required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: AppColor.primaryColor.withOpacity(0.3),
        child: Icon(icon, color: Colors.black),
      ),
      title: SmallText(
        text: text,
        size: 16.sp,
        color: AppColor.secondTextColor,
        fontWeight: FontWeight.w500,
      ),
      trailing: const Icon(Icons.arrow_forward_ios_sharp),
    );
  }
}
