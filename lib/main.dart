import 'package:flutter/material.dart';

import 'screen/splash_screen.dart';
import 'screen/login_screen.dart';
import 'screen/register_screen.dart';
import 'screen/home_screen.dart';
import 'screen/search_screen.dart';
import 'screen/add_report_screen.dart';
import 'screen/notification_screen.dart';
import 'screen/profile_screen.dart';
import 'screen/location_screen.dart';
import 'screen/report_history_screen.dart';
import 'screen/settings_screen.dart';
import 'screen/help_screen.dart';

void main() {
  runApp(const ReClaimApp());
}

class ReClaimApp extends StatelessWidget {
  const ReClaimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReClaim',

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3989E8),
        ),
      ),

      initialRoute: '/',

      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/location': (context) => const LocationScreen(),
        '/home': (context) => const HomeScreen(),
        '/search': (context) => const SearchScreen(),
        '/add-report': (context) => const AddReportScreen(),
        '/notification': (context) => const NotificationScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/report-history': (context) => const ReportHistoryScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/help': (context) => const HelpScreen(),
        
        
      },
    );
  }
}
