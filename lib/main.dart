
import 'package:flutter/material.dart';
import 'package:net_app/app_router.dart';
import 'package:net_app/core/theme/app_theme.dart';

// Global ValueNotifier for theme mode
// In a larger app, you might use a proper DI/Service Locator or State Management (Provider, Riverpod, etc.)
// For this example, a static notifier is simple and effective.
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Static getter for easy access in SettingsScreen
  static ValueNotifier<ThemeMode> get themeNotifier => _themeNotifier;
  static final ValueNotifier<ThemeMode> _themeNotifier = ValueNotifier(ThemeMode.light);


  @override
  Widget build(BuildContext context) {
    // Listen to the themeNotifier to rebuild MaterialApp when theme changes
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeNotifier, // Use the static notifier
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Lence Amazons',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode, // Set themeMode from the notifier
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: AppRouter.splashRoute,
        );
      },
    );
  }
}
