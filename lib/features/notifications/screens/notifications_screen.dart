import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../providers/notification_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final notifications = notificationProvider.notifications;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: AppTypography.h2),
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: () => notificationProvider.markAllAsRead(),
              child: const Text('Mark all as read'),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 32),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _NotificationItem(notification: notification);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.notifications_none_rounded, size: 80, color: AppColors.lightSurface),
          const SizedBox(height: 16),
          const Text('No notifications yet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          const Text(
            'We will notify you about updates in your groups.',
            style: TextStyle(color: AppColors.lightTextSecondary),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final Map<String, dynamic> notification;

  const _NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    final bool isRead = notification['isRead'] ?? false;

    return InkWell(
      onTap: () {
        if (!isRead) {
          notificationProvider.markAsRead(notification['id']);
        }
        // Could show details in bottom sheet
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: BoxDecoration(
              color: isRead ? Colors.transparent : AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['title'],
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification['message'],
                  style: AppTypography.bodyMedium.copyWith(
                    color: isRead ? AppColors.lightTextSecondary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  notification['time'],
                  style: AppTypography.caption.copyWith(color: AppColors.lightTextSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
