import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../res/app_images.dart';
import '../../../res/app_strings.dart';
import '../../../utils/app_color.dart';
import '../../../utils/navigator/page_navigator.dart';
import '../../auth directory/login auth directory/screens/login_screen.dart';
import '../../auth directory/signup auth directory/screens/user_reg_screen.dart';
import '../model/onboarding_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<OnboardingContent> _contentList = [
    OnboardingContent(
      imagePath: 'assets/images/boarding1.png',
      title: 'Fastest Payment in \n'
          'the World',
      description: 'Welcome to Monity, Integrate multiple\npayment methods'
          ' to help you up the\nprocess quickly.',
    ),
    OnboardingContent(
      imagePath: 'assets/images/card_group.png',
      title: 'The Most Secured\nPlatform for costumers',
      description: 'Built-in Fingerprint, face recognition\n'
          'and more, keeping you completely safe.',
    ),
    OnboardingContent(
      imagePath: 'assets/images/card_card.png',
      title: 'Paying for Everything is\nEasy and Convenient',
      description: 'Benefit from outstanding exchange rates\n'
          'across multiple currencies, making your transactions '
          'seamless and convenient.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }


  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboardingComplete', true);
    NavigationHelper.navigateToReplacement(context, const LoginScreen());
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 700.h,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _contentList.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    _buildPage(
                      _contentList[index],
                    ),
                    if (_currentPage == 0)
                      Positioned(
                        top: 55,
                        right: 15,
                        child: TextButton(
                          onPressed: () {
                            _pageController.jumpToPage(_contentList.length - 1);
                          },
                          child: Text(
                            "Skip>>",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontFamily: AppStrings.rubik,
                              color: AppColor.secBlueColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          if (_currentPage < _contentList.length - 1)
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(342.w, 55.h),
                  backgroundColor: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
                child: Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontFamily: AppStrings.rubik,
                    color: AppColor.whiteTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          if (_currentPage == _contentList.length - 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    NavigationHelper.navigateToReplacement(
                      context,
                      const LoginScreen(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(163.w, 55.h),
                    backgroundColor: AppColor.bg,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                        side: const BorderSide(
                            color: AppColor.primaryColor, width: 1.5)),
                  ),
                  child: Text(
                    "Log In",
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontFamily: AppStrings.rubik,
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _completeOnboarding();
                    NavigationHelper.navigateToReplacement(
                      context,
                      const UserRegScreen(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(163.w, 55.h),
                    backgroundColor: AppColor.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontFamily: AppStrings.rubik,
                      color: AppColor.whiteTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingContent content) {
    return SizedBox(
      height: 800.h,
      child: Column(
        children: [
          _currentPage == 0
              ? SizedBox(
                  width: 250,
                  height: 400.h,
                  child: Image.asset(
                    AppImages.onboardingFirst,
                    fit: BoxFit.contain,
                  ),
                )
              : _currentPage == 1
                  ? SizedBox(
                      width: 250,
                      height: 400.h,
                      child: Image.asset(
                        AppImages.onboardingSecond,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    )
                  : SizedBox(
                      width: 250,
                      height: 400.h,
                      child: Image.asset(
                        AppImages.onboardingThird,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
          Column(
            children: [
              SizedBox(
                height: 15.h,
              ),
              Text(
                content.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: AppStrings.rubik,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textColor),
              ),
              SizedBox(height: 15.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.sp),
                child: Text(
                  content.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: AppStrings.rubik,
                      color: AppColor.subColor,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(height: 35.h),
              _buildPageIndicator()
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    double totalWidth = 150.w;
    double segmentWidth = totalWidth / _contentList.length;

    return Center(
      child: SizedBox(
        width: totalWidth,
        child: Stack(
          children: [
            Container(
              height: 8.h,
              width: totalWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.r),
                color: Colors.grey.shade400,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(_contentList.length, (index) {
                return Container(
                  width: segmentWidth,
                  height: 8.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: index == 0 ? Radius.circular(50.r) : Radius.zero,
                      bottomLeft:
                          index == 0 ? Radius.circular(50.r) : Radius.zero,
                      topRight: index == _contentList.length - 1
                          ? Radius.circular(50.r)
                          : Radius.zero,
                      bottomRight: index == _contentList.length - 1
                          ? Radius.circular(50.r)
                          : Radius.zero,
                    ),
                    color: _currentPage == index
                        ? Colors.blue
                        : Colors.transparent,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
