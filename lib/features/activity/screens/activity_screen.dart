import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../providers/activity_provider.dart';
import '../../home/widgets/activity_preview_item.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activityProvider = Provider.of<ActivityProvider>(context);
    final activities = activityProvider.activities;

    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Feed', style: AppTypography.h2),
      ),
      body: activities.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: activities.length,
              separatorBuilder: (context, index) => const Divider(height: 32),
              itemBuilder: (context, index) {
                final activity = activities[index];
                return ActivityPreviewItem(activity: activity);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history_rounded, size: 80, color: AppColors.lightSurface),
          const SizedBox(height: 16),
          Text('No activities yet', style: AppTypography.h3),
          const SizedBox(height: 8),
          const Text(
            'Your transactions and group actions will appear here.',
            style: TextStyle(color: AppColors.lightTextSecondary),
          ),
        ],
      ),
    );
  }
}
