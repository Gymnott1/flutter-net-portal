import 'dart:async';
import 'package:flutter/material.dart';
import 'package:net_app/app_router.dart';
import 'package:net_app/core/theme/app_theme.dart';
import 'package:net_app/core/utils/app_constants.dart';
import 'package:net_app/core/widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();

    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed(AppRouter.loginRoute);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.light
              ? const Color.fromARGB(
                255,
                255,
                255,
                255,
              ) // Orange background for splash
              : AppColors.secondaryDark,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppLogo(height: 100), // Adjust size as needed
              const SizedBox(height: AppDimensions.lg),
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: const Color.fromARGB(
                    193,
                    26,
                    25,
                    25,
                  ), // Text color on splash
                ),
              ),
              const SizedBox(height: AppDimensions.sm),
              Text(
                AppConstants.slogan,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color.fromARGB(
                    193,
                    26,
                    25,
                    25,
                  ), // Text color on splash
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
