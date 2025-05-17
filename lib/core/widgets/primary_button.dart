import 'package:flutter/material.dart';
import 'package:net_app/core/theme/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      style: (theme.elevatedButtonTheme.style ??
              const ElevatedButtonThemeData().style)
          ?.copyWith(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>((
              Set<MaterialState> states,
            ) {
              if (backgroundColor != null) return backgroundColor;
              if (states.contains(MaterialState.disabled)) {
                return theme.colorScheme.primary.withOpacity(0.3);
              }
              return theme.colorScheme.primary;
            }),
            foregroundColor: MaterialStateProperty.all<Color?>(
              textColor ??
                  (theme.brightness == Brightness.light
                      ? AppColors.onPrimaryLight
                      : AppColors.onPrimaryDark),
            ),
            minimumSize: MaterialStateProperty.all<Size>(
              const Size(double.infinity, AppDimensions.buttonHeight),
            ),
          ),
      onPressed: isLoading ? null : onPressed,
      child:
          isLoading
              ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ??
                        (theme.brightness == Brightness.light
                            ? AppColors.onPrimaryLight
                            : AppColors.onPrimaryDark),
                  ),
                ),
              )
              : Text(
                text,
                style: theme.textTheme.labelLarge?.copyWith(
                  color:
                      textColor ??
                      (theme.brightness == Brightness.light
                          ? AppColors.onPrimaryLight
                          : AppColors.onPrimaryDark),
                ),
              ),
    );
  }
}
