import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/constants/mock_data.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: AppTypography.h2),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all as read'),
          ),
        ],
      ),
      body: MockData.notifications.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: MockData.notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 32),
              itemBuilder: (context, index) {
                final notification = MockData.notifications[index];
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
          Icon(Icons.notifications_none_rounded, size: 80, color: AppColors.lightSurface),
          const SizedBox(height: 16),
          Text('No notifications yet', style: AppTypography.h3),
          const SizedBox(height: 8),
          Text(
            'We will notify you about updates in your groups.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.lightTextSecondary),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(top: 6, right: 12),
          decoration: BoxDecoration(
            color: notification['isRead'] ? Colors.transparent : AppColors.primary,
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
                  fontWeight: notification['isRead'] ? FontWeight.normal : FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                notification['message'],
                style: AppTypography.bodyMedium.copyWith(
                  color: notification['isRead'] ? AppColors.lightTextSecondary : AppColors.lightTextPrimary,
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
    );
  }
}
