
import 'package:flutter/material.dart';
import 'package:net_app/app_router.dart';
import 'package:net_app/core/theme/app_theme.dart';
import 'package:net_app/core/utils/app_constants.dart';
import 'package:net_app/data/datasources/mock_data_sources.dart';
import 'package:net_app/main.dart'; // To access themeNotifier

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final MockDataSource _dataSource = MockDataSource();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = MyApp.themeNotifier.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 1,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: Text('Account', style: theme.textTheme.titleLarge),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg, vertical: AppDimensions.xs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${_dataSource.mockUserName}', style: theme.textTheme.bodyLarge),
                const SizedBox(height: AppDimensions.xs),
                Text('Phone: ${_dataSource.mockUserPhoneNumber}', style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
          const Divider(height: AppDimensions.lg),

          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text('Appearance', style: theme.textTheme.titleLarge),
          ),
          SwitchListTile(
            title: Text('Dark Mode', style: theme.textTheme.bodyLarge),
            value: isDarkMode,
            onChanged: (bool value) {
              MyApp.themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
            },
            secondary: Icon(
              isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              color: theme.colorScheme.primary,
            ),
            activeColor: theme.colorScheme.primary,
          ),
          const Divider(height: AppDimensions.lg),

          ListTile(
            leading: const Icon(Icons.bar_chart_outlined), // Changed Icon
            title: Text('Usage Statistics', style: theme.textTheme.bodyLarge), // Changed Text
            onTap: () {
              Navigator.of(context).pushNamed(AppRouter.statisticsRoute); // Navigate to statistics
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline, color: theme.colorScheme.secondary),
            title: Text('About ${AppConstants.appName}', style: theme.textTheme.bodyLarge),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('About ${AppConstants.appName}'),
                  content: Text(
                      '${AppConstants.slogan}\nVersion: 1.0.0 (Mock)\n${AppConstants.copyrightYear} ${AppConstants.companyFullName}'),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.help_outline, color: theme.colorScheme.secondary),
            title: Text('Help & Support', style: theme.textTheme.bodyLarge),
            onTap: () {
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigate to Help & Support page (Not Implemented)')),
              );
            },
          ),

          const Divider(height: AppDimensions.lg),

          Padding(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRouter.loginRoute,
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
