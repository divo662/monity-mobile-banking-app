import 'package:flutter/material.dart';

class NavigationHelper {
  static void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static void navigateToReplacement(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  static void navigateToPageWithArguments(
      BuildContext context, Widget page, dynamic arguments) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
        settings: RouteSettings(
          arguments: arguments,
        ),
      ),
    );
  }

  static void navigateToReplacementWithArguments(
      BuildContext context, Widget page, dynamic arguments) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => page,
        settings: RouteSettings(
          arguments: arguments,
        ),
      ),
    );
  }

  static void navigateToNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  static void navigateToNamedWithArguments(
      BuildContext context, String routeName, dynamic arguments) {
    Navigator.pushNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  static void navigateToInitial(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  static void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }
}
