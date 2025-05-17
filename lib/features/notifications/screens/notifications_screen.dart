import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting, add to pubspec.yaml
import 'package:net_app/core/theme/app_theme.dart';
import 'package:net_app/data/datasources/mock_data_sources.dart';
import 'package:net_app/data/models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final MockDataSource _dataSource = MockDataSource();
  late List<NotificationModel> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = _dataSource.getNotifications();
    // Sort by timestamp, newest first
    _notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return DateFormat.jm().format(timestamp); // e.g., 5:30 PM
    } else if (difference.inDays == 1 &&
        timestamp.day == now.subtract(const Duration(days: 1)).day) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat.EEEE().format(timestamp); // e.g., Monday
    } else {
      return DateFormat.yMd().format(timestamp); // e.g., 12/31/2023
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications'), elevation: 1),
      body:
          _notifications.isEmpty
              ? Center(
                child: Text(
                  'No notifications yet.',
                  style: theme.textTheme.titleMedium,
                ),
              )
              : ListView.separated(
                itemCount: _notifications.length,
                separatorBuilder: (context, index) => const Divider(height: 0),
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          notification.isRead
                              ? theme.colorScheme.onSurface.withOpacity(0.1)
                              : theme.colorScheme.primary.withOpacity(0.2),
                      child: Icon(
                        notification.isRead
                            ? Icons.notifications_none_outlined
                            : Icons.notifications_active,
                        color:
                            notification.isRead
                                ? theme.colorScheme.onSurface.withOpacity(0.5)
                                : theme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      notification.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight:
                            notification.isRead
                                ? FontWeight.normal
                                : FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      notification.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            notification.isRead
                                ? AppColors.textSecondaryLight
                                : AppColors.textPrimaryLight,
                      ),
                    ),
                    trailing: Text(
                      _formatTimestamp(notification.timestamp),
                      style: theme.textTheme.bodySmall,
                    ),
                    onTap: () {
                      // Mock marking as read
                      setState(() {
                        // This is a mock, in a real app you'd update the model
                        // and potentially persist this state.
                        // For this example, let's just toggle the visual locally if it were mutable.
                        // Since NotificationModel is immutable, we can't directly change isRead.
                        // A real implementation would replace the item or use a stateful widget for the item.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Notification "${notification.title}" tapped.',
                            ),
                          ),
                        );
                      });
                    },
                  );
                },
              ),
    );
  }
}
