import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class GroupCard extends StatelessWidget {
  final Map<String, dynamic> group;
  final VoidCallback onTap;

  const GroupCard({super.key, required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.lightSurface, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      group['status'],
                      style: AppTypography.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'Next Payout: ${group['nextPayout']}',
                    style: AppTypography.caption.copyWith(color: AppColors.lightTextSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                group['name'],
                style: AppTypography.h3,
              ),
              const SizedBox(height: 4),
              Text(
                '${group['members']} Members • ${group['frequency']}',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.lightTextSecondary),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount',
                        style: AppTypography.caption.copyWith(color: AppColors.lightTextSecondary),
                      ),
                      Text(
                        group['amount'],
                        style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${(group['progress'] * 100).toInt()}% Done',
                          style: AppTypography.caption.copyWith(color: AppColors.lightTextSecondary),
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: group['progress'],
                          backgroundColor: AppColors.lightSurface,
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                          minHeight: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
