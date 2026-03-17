import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../providers/group_provider.dart';
import '../providers/chat_provider.dart';
import '../../sessions/providers/session_provider.dart';
import '../../activity/providers/activity_provider.dart';

class StartCircleScreen extends StatefulWidget {
  final String groupId;

  const StartCircleScreen({super.key, required this.groupId});

  @override
  State<StartCircleScreen> createState() => _StartCircleScreenState();
}

class _StartCircleScreenState extends State<StartCircleScreen> {
  late List<String> _rotationOrder;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final groupProvider = Provider.of<GroupProvider>(context, listen: false);
      final group = groupProvider.getGroupById(widget.groupId);
      
      // Seed with some dummy members for the rotation
      _rotationOrder = [
        group?['admin'] ?? 'Admin',
        'John Doe',
        'Sarah Johnson',
        'Amadou Diallo',
        'Alice Wong',
        'Bob Smith',
      ];
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start New Circle', style: AppTypography.h3),
      ),
      body: Column(
        children: [
          Expanded(
            child: ReorderableListView(
              padding: const EdgeInsets.all(20),
              header: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Set Payout Rotation', style: AppTypography.h2),
                  const SizedBox(height: 8),
                  Text(
                    'Drag and drop members to set the order in which they will receive the Njangi payout.',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.lightTextSecondary),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final String item = _rotationOrder.removeAt(oldIndex);
                  _rotationOrder.insert(newIndex, item);
                });
              },
              children: [
                for (int index = 0; index < _rotationOrder.length; index++)
                  ListTile(
                    key: ValueKey(_rotationOrder[index]),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.lightSurface,
                      child: Text('${index + 1}'),
                    ),
                    title: Text(_rotationOrder[index], style: AppTypography.bodyLarge),
                    trailing: const Icon(Icons.drag_handle),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.warning.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.warning),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Starting the circle will lock the rotation order for the current cycle.',
                          style: AppTypography.caption.copyWith(color: AppColors.warning),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _showConfirmation(context),
                  child: const Text('Initialize Circle'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmation(BuildContext context) {
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
    final group = groupProvider.getGroupById(widget.groupId);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Initialize Circle?'),
        content: Text(
            'This will generate ${_rotationOrder.length} sessions based on the rotation order you set. Members will be notified to start contributions.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
              final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
              final chatProvider = Provider.of<ChatProvider>(context, listen: false);

              sessionProvider.initializeCircle(
                widget.groupId, 
                _rotationOrder, 
                group?['amount'] ?? '0 XAF', 
                group?['frequency'] ?? 'Monthly'
              );

              activityProvider.addActivity({
                'type': 'circle_started',
                'title': 'Circle Started',
                'subtitle': 'Njangi circle initialized for ${group?['name']}',
                'amount': group?['amount'] ?? '',
              });

              chatProvider.addAnnouncement(
                widget.groupId, 
                'New Njangi circle started! Rotation order: ${_rotationOrder.join(", ")}'
              );

              Navigator.pop(context); // Close dialog
              context.pop(); // Go back to group details
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Njangi Circle initialized successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(100, 40)),
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}
