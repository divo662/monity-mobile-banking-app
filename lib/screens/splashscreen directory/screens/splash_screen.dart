import 'dart:async';
import 'package:flutter/material.dart';
import '../../../res/app_icons.dart';
import '../../../utils/app_color.dart';
import '../../../utils/navigator/page_navigator.dart';
import '../../onboarding directory/screens/onboarding_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _controller.forward();

    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        NavigationHelper.navigateToPage(
          context,
          const OnboardingScreen(),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Image.asset(AppIcons.appIcon);
            },
          ),
        ),
      ),
    );
  }

}

