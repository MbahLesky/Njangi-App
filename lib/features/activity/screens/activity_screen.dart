import 'package:flutter/material.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/constants/mock_data.dart';
import '../../home/widgets/activity_preview_item.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Feed', style: AppTypography.h2),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: 10, // Showing more for the activity feed
        separatorBuilder: (context, index) => const Divider(height: 32),
        itemBuilder: (context, index) {
          // Reusing mock data items for prototype
          final activity = MockData.recentActivity[index % MockData.recentActivity.length];
          return ActivityPreviewItem(activity: activity);
        },
      ),
    );
  }
}
