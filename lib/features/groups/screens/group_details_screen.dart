import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../providers/group_provider.dart';
import '../providers/chat_provider.dart';
import '../../sessions/providers/session_provider.dart';
import '../../auth/providers/auth_provider.dart';

class GroupDetailsScreen extends StatelessWidget {
  final String groupId;

  const GroupDetailsScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final groupProvider = Provider.of<GroupProvider>(context);
    final group = groupProvider.getGroupById(groupId);

    if (group == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Group not found')),
      );
    }

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
            _OverviewTab(group: group),
            _MembersTab(groupId: groupId),
            _SessionsTab(groupId: groupId),
            _ChatTab(groupId: groupId),
            const Center(child: Text('Financial reports and statistics.')),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(context, group),
      ),
    );
  }

  Widget? _buildFloatingActionButton(BuildContext context, Map<String, dynamic> group) {
    // Only show "Start Circle" if no sessions exist yet
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final sessions = sessionProvider.getSessionsForGroup(groupId);

    if (sessions.isEmpty) {
      return FloatingActionButton.extended(
        onPressed: () => context.push('/groups/$groupId/start-circle'),
        backgroundColor: AppColors.secondary,
        label: const Text('Start Circle', style: TextStyle(color: AppColors.lightTextPrimary)),
        icon: const Icon(Icons.play_arrow, color: AppColors.lightTextPrimary),
      );
    }

    return FloatingActionButton.extended(
      onPressed: () => _showContributionSheet(context, group),
      backgroundColor: AppColors.primary,
      label: const Text('Record Contribution', style: TextStyle(color: Colors.white)),
      icon: const Icon(Icons.add_card, color: Colors.white),
    );
  }

  void _showContributionSheet(BuildContext context, Map<String, dynamic> group) {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    
    // Get current ongoing session
    final sessions = sessionProvider.getSessionsForGroup(groupId);
    final currentSession = sessions.firstWhere((s) => s['status'] == 'Ongoing', orElse: () => {});

    if (currentSession.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No ongoing session found.')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ContributionBottomSheet(
        group: group,
        sessionId: currentSession['id'],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final Map<String, dynamic> group;
  const _OverviewTab({required this.group});

  @override
  Widget build(BuildContext context) {
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
                    group['description'] ?? 'No description provided.',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.lightTextSecondary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Invite Code', style: AppTypography.h3),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.lightSurface),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  group['inviteCode'] ?? 'N/A',
                  style: AppTypography.h2.copyWith(letterSpacing: 4, color: AppColors.primary),
                ),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invite code copied!')),
                    );
                  },
                  icon: const Icon(Icons.copy, color: AppColors.primary),
                ),
              ],
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
}

class _MembersTab extends StatelessWidget {
  final String groupId;
  const _MembersTab({required this.groupId});

  @override
  Widget build(BuildContext context) {
    final groupProvider = Provider.of<GroupProvider>(context);
    final group = groupProvider.getGroupById(groupId);
    final memberCount = group?['members'] ?? 0;

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: memberCount,
      itemBuilder: (context, index) {
        final isAdmin = index == 0;
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: AppColors.lightSurface,
            child: Text('${index + 1}'),
          ),
          title: Text(isAdmin ? (group?['admin'] ?? 'Admin') : 'Member $index', style: AppTypography.bodyLarge),
          subtitle: Text(isAdmin ? 'Admin' : 'Member', style: AppTypography.caption),
          trailing: const Icon(Icons.more_vert),
        );
      },
    );
  }
}

class _SessionsTab extends StatelessWidget {
  final String groupId;
  const _SessionsTab({required this.groupId});

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    final sessions = sessionProvider.getSessionsForGroup(groupId);

    if (sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_busy, size: 64, color: AppColors.lightSurface),
            const SizedBox(height: 16),
            const Text('No sessions created yet.'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.push('/groups/$groupId/start-circle'),
              child: const Text('Initialize Circle'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        final isCompleted = session['isCompleted'] ?? false;
        final isOngoing = session['status'] == 'Ongoing';

        return Card(
          elevation: 0,
          color: isOngoing ? AppColors.primary.withValues(alpha: 0.05) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: isOngoing ? AppColors.primary : AppColors.lightSurface),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            onTap: () => context.push('/groups/$groupId/sessions/${session['id']}'),
            title: Text(session['name'], style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
            subtitle: Text('Date: ${session['date']} • Payout: ${session['recipient']}'),
            trailing: isCompleted 
              ? const Icon(Icons.check_circle, color: AppColors.success)
              : isOngoing 
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Live', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  )
                : const Icon(Icons.lock_outline, size: 20),
          ),
        );
      },
    );
  }
}

class _ChatTab extends StatefulWidget {
  final String groupId;
  const _ChatTab({required this.groupId});

  @override
  State<_ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<_ChatTab> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userName = '${authProvider.userProfile?['firstName']} ${authProvider.userProfile?['lastName']}';

    chatProvider.sendMessage(widget.groupId, _messageController.text.trim(), userName);
    _messageController.clear();
    
    // Auto-scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final messages = chatProvider.getMessages(widget.groupId);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(20),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              final isMe = msg['isMe'] ?? false;
              final isAnnouncement = msg['type'] == 'announcement';

              if (isAnnouncement) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      msg['text'],
                      textAlign: TextAlign.center,
                      style: AppTypography.caption.copyWith(color: AppColors.lightTextSecondary),
                    ),
                  ),
                );
              }

              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                  decoration: BoxDecoration(
                    color: isMe ? AppColors.primary : AppColors.lightSurface,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isMe)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            msg['sender'],
                            style: AppTypography.caption.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      Text(
                        msg['text'],
                        style: AppTypography.bodyMedium.copyWith(
                          color: isMe ? Colors.white : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          msg['time'],
                          style: AppTypography.caption.copyWith(
                            fontSize: 10,
                            color: isMe ? Colors.white70 : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.lightSurface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send, color: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ContributionBottomSheet extends StatefulWidget {
  final Map<String, dynamic> group;
  final String sessionId;

  const _ContributionBottomSheet({required this.group, required this.sessionId});

  @override
  State<_ContributionBottomSheet> createState() => _ContributionBottomSheetState();
}

class _ContributionBottomSheetState extends State<_ContributionBottomSheet> {
  String? _selectedMember = 'Mbah Lesky';
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.group['amount'].replaceAll(' XAF', '').replaceAll(',', '');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: 'Amount (XAF)',
              prefixIcon: Icon(Icons.money),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedMember,
            decoration: const InputDecoration(labelText: 'Member'),
            items: const [
              DropdownMenuItem(value: 'Mbah Lesky', child: Text('Mbah Lesky')),
              DropdownMenuItem(value: 'John Doe', child: Text('John Doe')),
              DropdownMenuItem(value: 'Sarah Johnson', child: Text('Sarah Johnson')),
            ],
            onChanged: (v) => setState(() => _selectedMember = v),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
              sessionProvider.recordContribution(widget.sessionId, _selectedMember!, '${_amountController.text} XAF');
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
    );
  }
}
