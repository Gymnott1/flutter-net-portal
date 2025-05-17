import 'package:flutter/material.dart';
import 'package:net_app/core/theme/app_theme.dart';
// Removed import for PrimaryButton as we're using ElevatedButton directly

class ActiveSubscriptionCard extends StatefulWidget {
  final String subscriptionName;
  final String dataUsed;
  final String expiryDate;
  final VoidCallback
  onReconnect; // This callback is triggered when reconnection process starts

  const ActiveSubscriptionCard({
    super.key,
    required this.subscriptionName,
    required this.dataUsed,
    required this.expiryDate,
    required this.onReconnect,
  });

  @override
  State<ActiveSubscriptionCard> createState() => _ActiveSubscriptionCardState();
}

class _ActiveSubscriptionCardState extends State<ActiveSubscriptionCard> {
  bool _isReconnecting = false;
  bool _isConnected = false; // To keep track if already connected

  Future<void> _handleReconnect() async {
    if (_isConnected) return; // Do nothing if already connected

    setState(() {
      _isReconnecting = true;
    });

    widget.onReconnect(); // Trigger the original callback (e.g., for SnackBar)

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Check if the widget is still mounted before calling setState
    if (mounted) {
      setState(() {
        _isReconnecting = false;
        _isConnected = true;
      });
      // Optional: Show a success message specifically for connection
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully reconnected!'),
          backgroundColor: AppColors.successLight,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonBackgroundColor =
        _isConnected
            ? AppColors.successLight.withOpacity(
              0.7,
            ) // A bit dimmer green when connected
            : (_isReconnecting ? AppColors.infoLight : AppColors.successLight);
    final buttonForegroundColor = Colors.white;
    final buttonText =
        _isConnected
            ? 'CONNECTED'
            : (_isReconnecting ? 'RECONNECTING...' : 'RECONNECT');

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: AppDimensions.md),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your active subscriptions",
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.subscriptionName,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.xs),
                      Text(
                        'Used: ${widget.dataUsed}',
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        'Expires: ${widget.expiryDate}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimensions.sm),
                ElevatedButton(
                  onPressed:
                      (_isReconnecting || _isConnected)
                          ? null
                          : _handleReconnect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonBackgroundColor,
                    foregroundColor: buttonForegroundColor,
                    disabledBackgroundColor: buttonBackgroundColor.withOpacity(
                      0.5,
                    ), // For disabled state
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.md,
                      vertical: AppDimensions.xs,
                    ),
                    textStyle: theme.textTheme.labelLarge?.copyWith(
                      fontSize: 13,
                    ),
                  ).copyWith(
                    // Ensure the button retains its size during loading
                    minimumSize: MaterialStateProperty.all(
                      const Size(120, 36),
                    ), // Adjust size as needed
                  ),
                  child:
                      _isReconnecting
                          ? SizedBox(
                            width: 18, // Adjust size of progress indicator
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                buttonForegroundColor,
                              ),
                            ),
                          )
                          : Text(buttonText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
