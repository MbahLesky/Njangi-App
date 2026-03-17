import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../auth/providers/auth_provider.dart';
import '../../activity/providers/activity_provider.dart';
import '../../groups/providers/group_provider.dart';
import '../widgets/summary_card.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/activity_preview_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final activityProvider = Provider.of<ActivityProvider>(context);
    final groupProvider = Provider.of<GroupProvider>(context);
    
    final userName = authProvider.userProfile?['firstName'] ?? 'User';
    final recentActivities = activityProvider.activities.take(3).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, $userName 👋',
                        style: AppTypography.h2,
                      ),
                      Text(
                        'Track your community savings',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => context.go('/profile'),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Text(
                        authProvider.userProfile?['initials'] ?? 'U',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Summary Cards (Horizontal Scroll)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SummaryCard(
                      title: 'Total Contributions',
                      amount: '150,000 XAF',
                      icon: Icons.account_balance_wallet,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 16),
                    const SummaryCard(
                      title: 'Upcoming Payout',
                      amount: '800,000 XAF',
                      subtitle: 'Expected: Apr 15',
                      icon: Icons.trending_up,
                      color: AppColors.secondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Quick Actions
              Text('Quick Actions', style: AppTypography.h3),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  QuickActionButton(
                    icon: Icons.add_circle_outline,
                    label: 'Create',
                    onTap: () => context.push('/groups/create'),
                  ),
                  QuickActionButton(
                    icon: Icons.group_add_outlined,
                    label: 'Join',
                    onTap: () => context.push('/groups/join'),
                  ),
                  QuickActionButton(
                    icon: Icons.history_outlined,
                    label: 'History',
                    onTap: () => context.go('/activity'),
                  ),
                  QuickActionButton(
                    icon: Icons.more_horiz,
                    label: 'More',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Recent Activity
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Activity', style: AppTypography.h3),
                  TextButton(
                    onPressed: () => context.go('/activity'),
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (recentActivities.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'No recent activity',
                      style: TextStyle(color: AppColors.lightTextSecondary),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentActivities.length,
                  separatorBuilder: (context, index) => const Divider(height: 24),
                  itemBuilder: (context, index) {
                    final activity = recentActivities[index];
                    return ActivityPreviewItem(activity: activity);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
