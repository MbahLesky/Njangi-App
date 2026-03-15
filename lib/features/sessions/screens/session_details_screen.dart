import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class SessionDetailsScreen extends StatelessWidget {
  final String sessionId;
  final String groupId;

  const SessionDetailsScreen({
    super.key,
    required this.sessionId,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Session #$sessionId', style: AppTypography.h3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Session Status Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Payout',
                            style: AppTypography.bodyMedium.copyWith(color: Colors.white70),
                          ),
                          Text(
                            '600,000 XAF',
                            style: AppTypography.h2.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.stars, color: Colors.white, size: 32),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statusInfo('Recipient', 'Sarah Johnson'),
                      _statusInfo('Date', 'April 12, 2026'),
                      _statusInfo('Status', 'Ongoing'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Text('Contribution Progress', style: AppTypography.h3),
            const SizedBox(height: 16),
            _buildProgressItem('Mbah Lesky', true),
            _buildProgressItem('John Doe', true),
            _buildProgressItem('Amadou Diallo', false),
            _buildProgressItem('Alice Wong', false),
            _buildProgressItem('Bob Smith', false),
            _buildProgressItem('Sarah Johnson', true),

            const SizedBox(height: 40),
            if (true) // If Admin
              ElevatedButton(
                onPressed: () => _confirmPayout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.lightTextPrimary,
                ),
                child: const Text('Confirm & Release Payout'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _statusInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.caption.copyWith(color: Colors.white70)),
        Text(value, style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildProgressItem(String name, bool paid) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.lightSurface,
            child: Text(name[0], style: const TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(name, style: AppTypography.bodyMedium)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: (paid ? AppColors.success : AppColors.warning).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              paid ? 'Paid' : 'Pending',
              style: AppTypography.caption.copyWith(
                color: paid ? AppColors.success : AppColors.warning,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmPayout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Payout?'),
        content: const Text('This will record the payout as received by Sarah Johnson and advance the cycle to the next session.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
