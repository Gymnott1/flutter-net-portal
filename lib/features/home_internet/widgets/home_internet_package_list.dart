// <start of features/home_internet/widgets/home_internet_package_list_item.dart>
import 'package:flutter/material.dart';
import 'package:net_app/core/theme/app_theme.dart';
import 'package:net_app/data/models/home_internet_package_model.dart';

class HomeInternetPackageListItem extends StatelessWidget {
  final HomeInternetPackageModel package;
  final VoidCallback onSelect;

  const HomeInternetPackageListItem({
    super.key,
    required this.package,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCurrentPlan = package.isCurrentPlan;

    return Card(
      elevation: isCurrentPlan ? 4.0 : 2.0,
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        side: BorderSide(
          color: isCurrentPlan
              ? theme.colorScheme.primary
              : theme.dividerColor.withOpacity(0.3),
          width: isCurrentPlan ? 2.0 : 1.0,
        ),
      ),
      color: isCurrentPlan ? theme.colorScheme.primary.withOpacity(0.05) : theme.cardColor,
      child: InkWell(
        onTap: isCurrentPlan ? null : onSelect, // Allow selection only if not current plan
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Row(
            children: [
              // Speed Indicator
              Container(
                width: 70, // Fixed width for the speed indicator part
                padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.sm, horizontal: AppDimensions.xs),
                decoration: BoxDecoration(
                  color: (isCurrentPlan ? theme.colorScheme.primary : Colors.grey.shade300).withOpacity(isCurrentPlan ? 0.2 : 1.0),
                  borderRadius: BorderRadius.circular(AppDimensions.buttonRadius / 1.5),
                  border: Border.all(color: isCurrentPlan ? theme.colorScheme.primary : Colors.grey.shade400, width: 0.5)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      package.speedMbps,
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isCurrentPlan ? theme.colorScheme.primary : theme.colorScheme.secondary,
                      ),
                    ),
                    Text(
                      "Mbps",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: (isCurrentPlan ? theme.colorScheme.primary : theme.colorScheme.secondary).withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              // Package Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.description,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      "KES ${package.price.toStringAsFixed(0)}",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              // Action Button or Chip
              if (isCurrentPlan)
                Chip(
                  label: Text('Current', style: TextStyle(color: theme.colorScheme.onPrimary)),
                  backgroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm, vertical: AppDimensions.xs / 2),
                )
              else
                ElevatedButton(
                  onPressed: onSelect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.lg, vertical: AppDimensions.sm),
                    textStyle: theme.textTheme.labelLarge,
                  ),
                  child: const Text('SELECT'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
// <end of features/home_internet/widgets/home_internet_package_list_item.dart>