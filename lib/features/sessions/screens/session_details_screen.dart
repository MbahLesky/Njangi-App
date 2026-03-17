import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../providers/session_provider.dart';
import '../../activity/providers/activity_provider.dart';

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
    final sessionProvider = Provider.of<SessionProvider>(context);
    final sessions = sessionProvider.getSessionsForGroup(groupId);
    final session = sessions.firstWhere((s) => s['id'] == sessionId, orElse: () => {});
    final contributions = sessionProvider.getContributionsForSession(sessionId);

    if (session.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Session not found')),
      );
    }

    final bool isOngoing = session['status'] == 'Ongoing';
    final bool isCompleted = session['isCompleted'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(session['name'], style: AppTypography.h3),
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
                color: isCompleted ? AppColors.success : AppColors.primary,
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
                            session['totalPayout'] ?? '0 XAF',
                            style: AppTypography.h2.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
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
                      _statusInfo('Recipient', session['recipient'] ?? 'TBD'),
                      _statusInfo('Date', session['date'] ?? 'TBD'),
                      _statusInfo('Status', session['status'] ?? 'Pending'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Text('Contribution Progress', style: AppTypography.h3),
            const SizedBox(height: 16),
            
            if (contributions.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'No contributions recorded yet.',
                    style: TextStyle(color: AppColors.lightTextSecondary),
                  ),
                ),
              )
            else
              ...contributions.map((c) => _buildProgressItem(c['member'], c['paid'], c['amount'], c['date'])),

            const SizedBox(height: 40),
            
            if (isOngoing)
              ElevatedButton(
                onPressed: () => _confirmPayout(context, session),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.lightTextPrimary,
                ),
                child: const Text('Confirm & Release Payout'),
              ),
            
            if (isCompleted)
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.success, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      'This session is completed',
                      style: AppTypography.bodyLarge.copyWith(color: AppColors.success, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
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

  Widget _buildProgressItem(String name, bool paid, String amount, String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.lightSurface,
            child: Text(name[0], style: const TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.bodyMedium),
                Text('$amount • $date', style: AppTypography.caption),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: (paid ? AppColors.success : AppColors.warning).withOpacity(0.1),
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

  void _confirmPayout(BuildContext context, Map<String, dynamic> session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Payout?'),
        content: Text('This will record the payout of ${session['totalPayout']} as received by ${session['recipient']} and advance the cycle to the next session.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
              final activityProvider = Provider.of<ActivityProvider>(context, listen: false);

              sessionProvider.completeSession(groupId, sessionId);

              activityProvider.addActivity({
                'type': 'payout',
                'title': 'Payout Confirmed',
                'subtitle': '${session['recipient']} received payout for ${session['name']}',
                'amount': session['totalPayout'],
              });

              Navigator.pop(context); // Close dialog
              context.pop(); // Go back
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payout confirmed and session completed!')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
