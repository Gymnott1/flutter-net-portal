// <start of features/splash/splash_screen.dart>
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:net_app/app_router.dart';
import 'package:net_app/core/theme/app_theme.dart';
// import 'package:net_app/core/utils/app_constants.dart'; // No longer needed for appName/slogan
// import 'package:net_app/core/widgets/app_logo.dart'; // No longer needed

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// Remove SingleTickerProviderStateMixin as we are not using AnimationController anymore
class _SplashScreenState extends State<SplashScreen> {
  // Remove _animationController and _fadeAnimation

  @override
  void initState() {
    super.initState();
    // The Timer to navigate remains the same
    Timer(const Duration(seconds: 3), () {
      // Adjust duration as needed for your GIF
      Navigator.of(context).pushReplacementNamed(AppRouter.mainRoute);
    });
  }

  @override
  void dispose() {
    // Remove _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    // Determine background color based on theme
    // You might want a specific color that complements your GIF
    final backgroundColor =
        brightness == Brightness.light
            ? Colors
                .white // Or a specific light theme splash background
            : AppColors
                .scaffoldDark; // Or a specific dark theme splash background

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Image.asset(
          'gifs/loading_animation.gif', // <<< YOUR GIF PATH HERE
          // You can adjust the size of the GIF if needed:
          height: 100,
          width: 100,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
// <end of features/splash/splash_screen.dart>