// <start of main.dart>
import 'package:flutter/material.dart';
import 'package:net_app/app_router.dart';
import 'package:net_app/core/theme/app_theme.dart';
import 'package:overlay_support/overlay_support.dart'; // Import overlay_support

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static ValueNotifier<ThemeMode> get themeNotifier => _themeNotifier;
  static final ValueNotifier<ThemeMode> _themeNotifier =
      ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        // Wrap MaterialApp with OverlaySupport.global
        return OverlaySupport.global(
          child: MaterialApp(
            title: 'Lence Amazons',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: currentMode,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: AppRouter.splashRoute,
            // You can optionally provide a navigatorKey if needed by overlay_support
            // for specific scenarios, but often not required for basic usage.
            // navigatorKey: GlobalKey<NavigatorState>(),
          ),
        );
      },
    );
  }
}
// <end of main.dart>