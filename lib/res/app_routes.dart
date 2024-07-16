import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/auth directory/login auth directory/screens/login_screen.dart';
import '../screens/onboarding directory/screens/onboarding_screen.dart';
import '../screens/splashscreen directory/screens/splash_screen.dart';

class AppRoutes {
  static const String splashScreen = 'splashScreen';
  static const String onboardingScreen = 'onboardingScreen';
  static const String loginScreen = 'loginScreen';

  static Map<String, Widget Function(BuildContext)> routes = {
    splashScreen: (context) => const SplashScreen(),
    onboardingScreen: (context) => const OnboardingScreen(),
    loginScreen: (context) => const LoginScreen(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case onboardingScreen:
        return MaterialPageRoute(
          builder: (context) =>  const OnboardingScreen(),
        );
      case loginScreen:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      default:
        return CupertinoPageRoute(
            builder: (context) => errorView(settings.name!));
    }
  }

  static Widget errorView(String name) {
    return Scaffold(body: Center(child: Text('404 $name View not found')));
  }
}
