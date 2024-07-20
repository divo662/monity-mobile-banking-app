import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:monity/res/app_routes.dart';
import 'package:monity/res/app_strings.dart';
import 'package:monity/screens/splashscreen%20directory/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/services/notification_services_settings.dart';
import 'core/utils/transaction_notify_manager.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'dart:async';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    HttpOverrides.global = MyHttpOverrides();
  }

  tz.initializeTimeZones();

  await Supabase.initialize(
    url: 'https://bauofyfbfvxkbiuxmpqp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJhdW9meWZiZnZ4a2JpdXhtcHFwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTk1MDM1NTAsImV4cCI6MjAzNTA3OTU1MH0.7ha_uZYjH2zDXhVocWfxNxdBfjmX3h59ysM7tp46N_0',
  );

  final notificationService = NotificationService();
  await notificationService.initNotification();

  final String? userId = supabase.auth.currentUser?.id;
  final transactionNotificationManager = TransactionNotificationManager();
  if (userId != null) {
    transactionNotificationManager.startListening(userId);
  }

  runApp(const Monity());
}

final supabase = Supabase.instance.client;

class Monity extends StatelessWidget {
  const Monity({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppStrings.appName,
          home: const SplashScreen(),
          routes: AppRoutes.routes,
          onGenerateRoute: AppRoutes.generateRoute,
        );
      },
    );
  }
}

