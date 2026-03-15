import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class ActivityPreviewItem extends StatelessWidget {
  final Map<String, dynamic> activity;

  const ActivityPreviewItem({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final bool isContribution = activity['type'] == 'contribution';

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (isContribution ? AppColors.primary : AppColors.secondary).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isContribution ? Icons.south_west_rounded : Icons.north_east_rounded,
            color: isContribution ? AppColors.primary : AppColors.secondary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity['title'],
                style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                activity['subtitle'],
                style: AppTypography.bodyMedium.copyWith(color: AppColors.lightTextSecondary),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              activity['amount'],
              style: AppTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: isContribution ? AppColors.lightTextPrimary : AppColors.success,
              ),
            ),
            Text(
              activity['date'],
              style: AppTypography.caption.copyWith(color: AppColors.lightTextSecondary),
            ),
          ],
        ),
      ],
    );
  }
}
