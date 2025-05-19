// <start of app_router.dart>
import 'package:flutter/material.dart';
import 'package:net_app/data/models/package_model.dart';
import 'package:net_app/data/models/home_internet_package_model.dart';
import 'package:net_app/data/models/cart_item_model.dart';
import 'package:net_app/features/auth/screens/login_screen.dart';
import 'package:net_app/features/auth/screens/otp_screen.dart';
import 'package:net_app/features/home/screens/home_screen.dart';
import 'package:net_app/features/main/screens/main_screen.dart';
import 'package:net_app/features/shop/screens/shop_screen.dart';
import 'package:net_app/features/shop/screens/cart_screen.dart';
import 'package:net_app/features/home_internet/screens/home_internet_screen.dart';
import 'package:net_app/features/notifications/screens/notifications_screen.dart';
import 'package:net_app/features/payment/screens/payment_screen.dart';
import 'package:net_app/features/settings/screens/settings_screen.dart';
import 'package:net_app/features/splash/splash_screen.dart';
import 'package:net_app/features/statistics/screens/user_statistics_screen.dart';
import 'package:net_app/features/shop/screens/checkout_screen.dart';
import 'package:net_app/features/shop/screens/order_confirmation_screen.dart';
import 'package:net_app/data/models/order_model.dart'; // New Import


class AppRouter {
  static const String splashRoute = '/';
  static const String mainRoute = '/main';
  static const String loginRoute = '/login';
  static const String otpRoute = '/otp';
  static const String homeRoute = '/home'; // Hotspot portal
  static const String paymentRoute = '/payment';
  static const String notificationsRoute = '/notifications';
  static const String settingsRoute = '/settings';
  static const String statisticsRoute = '/statistics'; // For Hotspot user stats
  static const String shopRoute = '/shop';
  static const String homeInternetRoute = '/home-internet'; // HomeNet portal
  static const String cartRoute = '/cart'; // Shop cart
  static const String checkoutRoute = '/checkout';
  static const String orderConfirmationRoute = '/order-confirmation';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case mainRoute:
        return MaterialPageRoute(builder: (_) => const MainScreen());
            case checkoutRoute:
        final cartItems = settings.arguments as List<CartItemModel>; // Expecting List<CartItemModel>
        return MaterialPageRoute(builder: (_) => CheckoutScreen(cartItems: cartItems));
      case orderConfirmationRoute:
        final order = settings.arguments as OrderModel; // Expecting OrderModel
        return MaterialPageRoute(builder: (_) => OrderConfirmationScreen(order: order));
      case loginRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
            builder: (_) => LoginScreen(targetRouteArgs: args));
      case otpRoute:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => OtpScreen(
            phoneNumber: args?['phoneNumber'] as String?,
            displayIdentifier: args?['displayIdentifier'] as String?,
            targetRoute: args?['targetRoute'] as String? ?? homeRoute,
          ),
        );
      case homeRoute: // Hotspot portal
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case homeInternetRoute: // HomeNet portal
        return MaterialPageRoute(builder: (_) => const HomeInternetScreen());
      case paymentRoute:
        final packageItem = settings.arguments;
        if (packageItem is PackageModel || packageItem is HomeInternetPackageModel) {
          return MaterialPageRoute(
            builder: (_) => PaymentScreen(packageItem: packageItem),
          );
        }
        // Fallback for wrong argument type for payment
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                appBar: AppBar(title: const Text("Error")),
                body: Center(child: Text('Invalid item type for payment: ${packageItem?.runtimeType}'))));
      case notificationsRoute:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case settingsRoute:
        // Potentially pass arguments if settings differ based on user type (Hotspot/HomeNet)
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case statisticsRoute:
        // This is currently for Hotspot user. If HomeNet has stats, might need a different route or args.
        return MaterialPageRoute(builder: (_) => const UserStatisticsScreen());
      case shopRoute:
        return MaterialPageRoute(builder: (_) => const ShopScreen());
      case cartRoute:
        final cartItems = settings.arguments as List<CartItemModel>? ?? [];
        return MaterialPageRoute(builder: (_) => CartScreen(initialCartItems: cartItems));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text("Error")),
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
// <end of app_router.dart>