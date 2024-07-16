import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:monity/screens/transaction%20directory/screens/transaction_page.dart';
import '../../../res/app_strings.dart';
import '../../../utils/app_color.dart';
import '../../profile settings directory/screens/profile_settings_page.dart';
import 'home_screen.dart';

class BottomNavbarScreen extends StatefulWidget {
  int currentPage;

  BottomNavbarScreen({
    super.key,
    this.currentPage = 0,
  });

  @override
  State<BottomNavbarScreen> createState() => _BottomNavbarScreenState();
}

class _BottomNavbarScreenState extends State<BottomNavbarScreen> {
  @override
  void initState() {
    super.initState();
  }

  PageController pageController = PageController();

  void updatePage(int page) {
    setState(() {
      widget.currentPage = page;
    });
    pageController.jumpToPage(page);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.bg,
        body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (page) {
            setState(() {
              widget.currentPage = page;
            });
          },
          children: const [
            HomeScreen(),
            TransactionPage(),
            ProfileSettingsPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 10,
          backgroundColor: Colors.white,
          selectedItemColor: AppColor.primaryColor,
          unselectedItemColor: AppColor.greyColor4,
          type: BottomNavigationBarType.fixed,
          iconSize: 28,
          selectedLabelStyle: TextStyle(
            fontFamily: AppStrings.rubik,
            fontWeight: FontWeight.w500,
            fontSize: 13.sp
          ),
          unselectedLabelStyle: TextStyle(
              fontFamily: AppStrings.rubik,
              fontWeight: FontWeight.w500,
              fontSize: 13.sp
          ),
          onTap: updatePage,
          currentIndex: widget.currentPage,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: ""
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
                label: ""
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
                label: ""
            )
          ],
        )
    );
  }
}
