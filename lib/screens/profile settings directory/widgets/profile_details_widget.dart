import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../res/app_strings.dart';
import '../../../utils/app_color.dart';
import '../../../utils/navigator/page_navigator.dart';
import '../../../widgets/small_text.dart';
import '../../home directory/supabase/profile_info_db.dart';


class ProfileDetailsWidget extends StatefulWidget {
  const ProfileDetailsWidget({super.key});

  @override
  State<ProfileDetailsWidget> createState() => _ProfileDetailsWidgetState();
}

class _ProfileDetailsWidgetState extends State<ProfileDetailsWidget> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.primaryColor,
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
                    border: Border.all(color: Colors.white, width: 1.5)),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 5.w),
            SmallText(
              text: "My Profile",
              fontWeight: FontWeight.w400,
              color: Colors.white,
              size: 20.sp,
            ),
          ],
        ),
      ),
      backgroundColor: AppColor.bg,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _profileInfo == null
          ? const Center(child: Text('Error loading profile info'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            SizedBox(height: 8.h),
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
            SizedBox(height: 20.h),
            _buildProfileDetailRow('Email', _profileInfo!['email']),
            _buildProfileDetailRow(
                'Mobile Number', _profileInfo!['phone_number']),
            _buildProfileDetailRow(
                'Date of Birth', _profileInfo!['date_of_birth']),
            _buildProfileDetailRow('Gender', _profileInfo!['gender']),
            _buildProfileDetailRow(
                'Nationality', _profileInfo!['nationality']),
            _buildProfileDetailRow(
                'State of Origin', _profileInfo!['state_of_origin']),
            _buildProfileDetailRow('LGA', _profileInfo!['lga']),
            _buildProfileDetailRow('Home Address',
                _profileInfo!['home_address'], isAddress: true),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetailRow(String label, String? value,
      {bool isAddress = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: AppStrings.rubik,
              color: AppColor.subColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          isAddress
              ? Expanded(
            child: Text(
              value ?? 'N/A',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColor.secondTextColor,
                fontFamily: AppStrings.rubik,
              ),
            ),
          )
              : Text(
            value ?? 'N/A',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColor.secondTextColor,
              fontFamily: AppStrings.rubik,
            ),
          ),
        ],
      ),
    );
  }
}
