import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../providers/group_provider.dart';
import '../widgets/group_card.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groupProvider = Provider.of<GroupProvider>(context);
    final groups = groupProvider.groups;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Groups', style: AppTypography.h2),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: AppColors.lightTextPrimary),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list, color: AppColors.lightTextPrimary),
          ),
        ],
      ),
      body: groups.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: GroupCard(
                    group: group,
                    onTap: () {
                      context.push('/groups/${group['id']}');
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/groups/create'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Create Group', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group_outlined, size: 80, color: AppColors.lightSurface),
            const SizedBox(height: 24),
            Text('No Groups Yet', style: AppTypography.h3),
            const SizedBox(height: 12),
            Text(
              'Create a group or join one using an invite code to start saving together.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.lightTextSecondary),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.push('/groups/join'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
              child: const Text('Join a Group'),
            ),
          ],
        ),
      ),
    );
  }
}
