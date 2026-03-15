import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';

class JoinGroupScreen extends StatefulWidget {
  const JoinGroupScreen({super.key});

  @override
  State<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Group', style: AppTypography.h3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              'Enter Invite Code',
              style: AppTypography.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Ask the group admin for the invite code to join their Njangi group.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _codeController,
              textAlign: TextAlign.center,
              style: AppTypography.h2.copyWith(letterSpacing: 8),
              decoration: InputDecoration(
                hintText: 'XXXXXX',
                hintStyle: TextStyle(color: AppColors.lightTextSecondary.withValues(alpha: 0.3)),
                helperText: 'Enter the 6-character code',
              ),
              textCapitalization: TextCapitalization.characters,
              maxLength: 6,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (_codeController.text.length == 6) {
                  _showJoinConfirmation(context);
                }
              },
              child: const Text('Find Group'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showJoinConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.groups_rounded, color: AppColors.primary, size: 40),
            ),
            const SizedBox(height: 24),
            Text('Found: Business Growth Circle', style: AppTypography.h3),
            const SizedBox(height: 8),
            Text(
              'Admin: Sarah Johnson\n12 Members • 50,000 XAF Monthly',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.lightTextSecondary),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/groups');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Successfully joined Business Growth Circle!')),
                );
              },
              child: const Text('Join this Group'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
