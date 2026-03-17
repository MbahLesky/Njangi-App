import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../providers/group_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../activity/providers/activity_provider.dart';
import '../../notifications/providers/notification_provider.dart';

class JoinGroupScreen extends StatefulWidget {
  const JoinGroupScreen({super.key});

  @override
  State<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

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
                hintStyle: TextStyle(color: AppColors.lightTextSecondary.withOpacity(0.3)),
                helperText: 'Enter the invite code (e.g. FAM789)',
              ),
              textCapitalization: TextCapitalization.characters,
              maxLength: 6,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (_codeController.text.length == 6) {
                  _findAndConfirmGroup(context);
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

  void _findAndConfirmGroup(BuildContext context) {
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
    final group = groupProvider.groups.firstWhere(
      (g) => g['inviteCode'] == _codeController.text,
      orElse: () => {},
    );

    if (group.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid invite code. Please try FAM789 or TECH12.')),
      );
      return;
    }

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
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.groups_rounded, color: AppColors.primary, size: 40),
            ),
            const SizedBox(height: 24),
            Text('Found: ${group['name']}', style: AppTypography.h3),
            const SizedBox(height: 8),
            Text(
              'Admin: ${group['admin']}\n${group['members']} Members • ${group['amount']} ${group['frequency']}',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.lightTextSecondary),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
                final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
                
                final userName = '${authProvider.userProfile?['firstName']} ${authProvider.userProfile?['lastName']}';

                groupProvider.joinGroupByCode(_codeController.text, userName);

                activityProvider.addActivity({
                  'type': 'group_joined',
                  'title': 'Joined Group',
                  'subtitle': 'You joined ${group['name']}',
                  'amount': group['amount'],
                });

                notificationProvider.addNotification({
                  'title': 'Joined Successfully',
                  'message': 'You are now a member of ${group['name']}.',
                });

                Navigator.pop(context); // Close bottom sheet
                context.go('/groups');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Successfully joined ${group['name']}!')),
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
