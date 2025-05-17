import 'package:flutter/material.dart';
import 'package:net_app/core/theme/app_theme.dart';
import 'package:net_app/core/utils/app_constants.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Customer Service", style: theme.textTheme.titleMedium),
        const SizedBox(height: AppDimensions.xs),
        Text(
          "${AppConstants.customerService1} | ${AppConstants.customerService2}",
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.lg),
        Text(
          "${AppConstants.copyrightYear} ${AppConstants.companyFullName}. All rights reserved.",
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textTertiaryLight,
          ), // Using a specific color for footer
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
