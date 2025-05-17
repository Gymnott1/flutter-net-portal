
import 'package:flutter/material.dart';
import 'package:net_app/data/models/package_model.dart';
import 'package:net_app/features/auth/screens/login_screen.dart';
import 'package:net_app/features/auth/screens/otp_screen.dart';
import 'package:net_app/features/home/screens/home_screen.dart';
import 'package:net_app/features/notifications/screens/notifications_screen.dart';
import 'package:net_app/features/payment/screens/payment_screen.dart';
import 'package:net_app/features/settings/screens/settings_screen.dart';
import 'package:net_app/features/splash/splash_screen.dart';
import 'package:net_app/features/statistics/screens/user_statistics_screen.dart'; // Added

class AppRouter {
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String otpRoute = '/otp';
  static const String homeRoute = '/home';
  static const String paymentRoute = '/payment';
  static const String notificationsRoute = '/notifications';
  static const String settingsRoute = '/settings';
  static const String statisticsRoute = '/statistics'; // Added

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case otpRoute:
        final phoneNumber = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => OtpScreen(phoneNumber: phoneNumber),
        );
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case paymentRoute:
        final package = settings.arguments as PackageModel;
        return MaterialPageRoute(
          builder: (_) => PaymentScreen(package: package),
        );
      case notificationsRoute:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case settingsRoute:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case statisticsRoute: // Added
        return MaterialPageRoute(builder: (_) => const UserStatisticsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
