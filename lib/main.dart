import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:monity/res/app_routes.dart';
import 'package:monity/res/app_strings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/services/notification_services_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/utils/transaction_notify_manager.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  final prefs = await SharedPreferences.getInstance();
  final bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  runApp(Monity(isFirstLaunch: isFirstLaunch));
}
final supabase = Supabase.instance.client;

class Monity extends StatelessWidget {
  final bool isFirstLaunch;

  const Monity({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final bool isFirstLaunch = snapshot.data?.getBool('first_launch') ?? true;

          return ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (context, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: AppStrings.appName,
                routes: AppRoutes.routes,
                initialRoute: isFirstLaunch
                    ? AppRoutes.onboardingScreen
                    : AppRoutes.loginScreen,
                onGenerateRoute: AppRoutes.generateRoute,
              );
            },
          );
        } else {
          return const MaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            home: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

}
