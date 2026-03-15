import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/constants/mock_data.dart';

class GroupDetailsScreen extends StatelessWidget {
  final String groupId;

  const GroupDetailsScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final group = MockData.userGroups.firstWhere((g) => g['id'] == groupId);

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(group['name'], style: AppTypography.h3),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings_outlined),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.lightTextSecondary,
            labelStyle: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Members'),
              Tab(text: 'Sessions'),
              Tab(text: 'Chat'),
              Tab(text: 'Reports'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverview(group),
            _buildMembers(),
            _buildSessions(),
            _buildChat(),
            _buildReports(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showContributionSheet(context),
          backgroundColor: AppColors.primary,
          label: const Text('Record Contribution', style: TextStyle(color: Colors.white)),
          icon: const Icon(Icons.add_card, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildOverview(Map<String, dynamic> group) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            elevation: 0,
            color: AppColors.lightSurface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Group Rules', style: AppTypography.h3),
                  const SizedBox(height: 16),
                  _ruleItem(Icons.payments_outlined, 'Contribution: ${group['amount']}'),
                  _ruleItem(Icons.calendar_today_outlined, 'Frequency: ${group['frequency']}'),
                  _ruleItem(Icons.person_outline, 'Admin: ${group['admin']}'),
                  const SizedBox(height: 16),
                  Text(
                    group['description'],
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.lightTextSecondary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Current Cycle Status', style: AppTypography.h3),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Cycle Progress', style: AppTypography.bodyMedium),
                    Text('${(group['progress'] * 100).toInt()}%', style: AppTypography.h3),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: group['progress'],
                  backgroundColor: Colors.white,
                  color: AppColors.primary,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ruleItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(text, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildMembers() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 8,
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: AppColors.lightSurface,
            child: Text('${index + 1}'),
          ),
          title: Text('Member Name ${index + 1}', style: AppTypography.bodyLarge),
          subtitle: Text(index == 0 ? 'Admin' : 'Member', style: AppTypography.caption),
          trailing: const Icon(Icons.more_vert),
        );
      },
    );
  }

  Widget _buildSessions() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 12,
      itemBuilder: (context, index) {
        bool isCompleted = index < 4;
        bool isCurrent = index == 4;
        return Card(
          elevation: 0,
          color: isCurrent ? AppColors.primary.withValues(alpha: 0.05) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: isCurrent ? AppColors.primary : AppColors.lightSurface),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text('Session ${index + 1}', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
            subtitle: Text('Date: April ${index + 1}, 2026'),
            trailing: isCompleted 
              ? const Icon(Icons.check_circle, color: AppColors.success)
              : isCurrent 
                ? const Text('Current', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))
                : const Icon(Icons.lock_outline),
          ),
        );
      },
    );
  }

  Widget _buildChat() {
    return const Center(child: Text('Chat messages will appear here.'));
  }

  Widget _buildReports() {
    return const Center(child: Text('Financial reports and statistics.'));
  }

  void _showContributionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Record Contribution', style: AppTypography.h2),
            const SizedBox(height: 8),
            Text(
              'Confirm that you have received the contribution for the current session.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.lightTextSecondary),
            ),
            const SizedBox(height: 24),
            TextFormField(
              initialValue: '50,000',
              decoration: const InputDecoration(
                labelText: 'Amount (XAF)',
                prefixIcon: Icon(Icons.money),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Member'),
              items: const [
                DropdownMenuItem(value: '1', child: Text('Mbah Lesky')),
                DropdownMenuItem(value: '2', child: Text('John Doe')),
              ],
              onChanged: (v) {},
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contribution recorded successfully!')),
                );
              },
              child: const Text('Confirm Contribution'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
