// <start of core/utils/notification_helper.dart>
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:net_app/core/theme/app_theme.dart'; // For AppColors

enum NotificationType { success, error, info, warning }

void showInAppNotification({
  required BuildContext context, // context can be useful for theming, but overlay_support is global
  required String title,
  required String message,
  NotificationType type = NotificationType.info,
  Duration duration = const Duration(seconds: 4),
  VoidCallback? onTap,
}) {
  Color backgroundColor;
  IconData iconData;
  Color iconColor = Colors.white; // Default icon color

  final currentTheme = Theme.of(context); // Get current theme for text colors
  bool isDark = currentTheme.brightness == Brightness.dark;


  switch (type) {
    case NotificationType.success:
      backgroundColor = AppColors.successLight;
      iconData = Icons.check_circle_outline_rounded;
      if(isDark) backgroundColor = AppColors.successDark;
      break;
    case NotificationType.error:
      backgroundColor = AppColors.errorLight;
      iconData = Icons.error_outline_rounded;
       if(isDark) backgroundColor = AppColors.errorDark;
      break;
    case NotificationType.warning:
      backgroundColor = AppColors.warningLight;
      iconData = Icons.warning_amber_rounded;
      iconColor = AppColors.textPrimaryLight; // Amber might need dark icon
       if(isDark) {
        backgroundColor = AppColors.warningDark;
        iconColor = AppColors.textPrimaryDark;
       }
      break;
    case NotificationType.info:
    default:
      backgroundColor = AppColors.infoLight;
      iconData = Icons.info_outline_rounded;
       if(isDark) backgroundColor = AppColors.infoDark;
      break;
  }
  // For text on notification, pick contrasting color
  Color textColor = backgroundColor.computeLuminance() > 0.5 ? AppColors.textPrimaryDark : Colors.white;


  showOverlayNotification(
    (context) {
      return Material( // Important for text styles and theming from context
        color: Colors.transparent,
        child: SafeArea( // Ensures notification is below status bar etc.
          bottom: false, // We only care about top safe area
          child: GestureDetector(
            onTap: onTap, // If user taps the notification
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(iconData, color: iconColor, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // Important for Column height
                      children: [
                        Text(
                          title,
                          style: currentTheme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message,
                          style: currentTheme.textTheme.bodyMedium?.copyWith(
                            color: textColor.withOpacity(0.9),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    duration: duration,
    position: NotificationPosition.top, // Slide from top
  );
}
// <end of core/utils/notification_helper.dart>