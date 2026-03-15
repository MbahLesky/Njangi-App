import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/constants/mock_data.dart';
import '../widgets/summary_card.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/activity_preview_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                        'Hello, ${MockData.userName} 👋',
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
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: const Icon(Icons.person, color: AppColors.primary),
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
                    SummaryCard(
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
                    onTap: () {},
                  ),
                  QuickActionButton(
                    icon: Icons.group_add_outlined,
                    label: 'Join',
                    onTap: () {},
                  ),
                  QuickActionButton(
                    icon: Icons.history_outlined,
                    label: 'History',
                    onTap: () {},
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
                    onPressed: () {},
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: MockData.recentActivity.length,
                separatorBuilder: (context, index) => const Divider(height: 24),
                itemBuilder: (context, index) {
                  final activity = MockData.recentActivity[index];
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
