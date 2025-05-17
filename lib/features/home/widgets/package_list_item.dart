
import 'package:flutter/material.dart';
import 'package:net_app/app_router.dart';
import 'package:net_app/core/theme/app_theme.dart';
import 'package:net_app/data/models/package_model.dart';

class PackageListItem extends StatelessWidget {
  final PackageModel package;
  final VoidCallback onToggleFavorite;

  const PackageListItem({
    super.key,
    required this.package,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.sm + 4), // Increased bottom margin
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(
          color: package.isFavorite ? theme.colorScheme.primary.withOpacity(0.7) : theme.dividerColor.withOpacity(0.5),
          width: package.isFavorite ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(isDark ? 0.15 : 0.06),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(AppRouter.paymentRoute, arguments: package);
          },
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
          splashColor: theme.colorScheme.primary.withOpacity(0.1),
          highlightColor: theme.colorScheme.primary.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${package.price} = ${package.fullDescription}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          // Updated color logic:
                          color: (package.isUnlimiNET && package.isFavorite)
                              ? theme.colorScheme.primary // Orange only if UnlimiNET AND Favorite
                              : theme.textTheme.titleMedium?.color, // Default otherwise
                        ),
                      ),
                      if (package.validity.isNotEmpty && !package.isUnlimiNET)
                        Padding(
                          padding: const EdgeInsets.only(top: AppDimensions.xs / 2),
                          child: Text(package.validity, style: theme.textTheme.bodySmall),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: AppDimensions.xs / 2),
                        child: Text(package.devices, style: theme.textTheme.bodySmall),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimensions.sm),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        package.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                        color: package.isFavorite ? Colors.amber.shade600 : theme.iconTheme.color?.withOpacity(0.6),
                      ),
                      iconSize: 26, // Slightly smaller icon for better balance
                      padding: const EdgeInsets.all(AppDimensions.xs), // Add some padding around icon
                      constraints: const BoxConstraints(),
                      tooltip: package.isFavorite ? 'Remove from favorites' : 'Add to favorites',
                      onPressed: onToggleFavorite,
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRouter.paymentRoute, arguments: package);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.8)),
                        foregroundColor: theme.colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.md,
                          vertical: AppDimensions.xs / 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.buttonRadius / 1.5), // Slightly less rounded
                        ),
                        textStyle: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      child: const Text('BUY'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
