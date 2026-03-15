import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/constants/mock_data.dart';
import '../widgets/group_card.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: MockData.userGroups.length,
        itemBuilder: (context, index) {
          final group = MockData.userGroups[index];
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
        onPressed: () {},
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Create Group', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
