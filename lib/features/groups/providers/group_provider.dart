import 'package:flutter/material.dart';
import '../../../app/services/local_notification_service.dart';

class GroupProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _groups = [
    {
      "id": "1",
      "name": "Family Savings",
      "members": 12,
      "amount": "50,000 XAF",
      "frequency": "Monthly",
      "status": "Active",
      "nextPayout": "Apr 15",
      "progress": 0.6,
      "admin": "Mbah Lesky",
      "description": "Monthly savings for family projects and emergencies.",
      "inviteCode": "FAM789",
      "deadlineDay": "Sunday",
      "deadlineTime": "18:00",
    },
    {
      "id": "2",
      "name": "Tech Entrepreneurs",
      "members": 8,
      "amount": "100,000 XAF",
      "frequency": "Weekly",
      "status": "Active",
      "nextPayout": "Mar 20",
      "progress": 0.3,
      "admin": "John Doe",
      "description": "Weekly contribution for business capital rotation.",
      "inviteCode": "TECH12",
      "deadlineDay": "Friday",
      "deadlineTime": "20:00",
    },
  ];

  List<Map<String, dynamic>> get groups => _groups;

  void addGroup(Map<String, dynamic> groupData) {
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    final group = {
      ...groupData,
      'id': newId,
      'status': 'Active',
      'progress': 0.0,
      'inviteCode': _generateInviteCode(),
    };
    _groups.add(group);
    
    // Instant notification
    LocalNotificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Group Created',
      body: 'Your new group "${groupData['name']}" is now active.',
      payload: '/groups/$newId',
    );

    // Schedule deadline reminder (mocking for 5 minutes from now for prototype demonstration)
    // In a real app, this would calculate based on deadlineDay and deadlineTime
    _scheduleDeadlineReminder(newId, groupData['name']);
    
    notifyListeners();
  }

  void _scheduleDeadlineReminder(String groupId, String groupName) {
    // For prototype purposes, we schedule a reminder 5 minutes before a "mock" deadline
    // which we will set to be 10 minutes from now.
    final now = DateTime.now();
    final mockDeadline = now.add(const Duration(minutes: 10));
    final reminderTime = mockDeadline.subtract(const Duration(minutes: 5));

    LocalNotificationService.scheduleNotification(
      id: groupId.hashCode,
      title: 'Contribution Deadline Near',
      body: 'The deadline for "$groupName" is in 5 minutes! Don\'t forget to contribute.',
      scheduledTime: reminderTime,
      payload: '/groups/$groupId',
    );
  }

  void updateGroup(String id, Map<String, dynamic> updatedData) {
    final index = _groups.indexWhere((g) => g['id'] == id);
    if (index != -1) {
      _groups[index] = {..._groups[index], ...updatedData};
      
      // If deadline changed, reschedule reminder
      if (updatedData.containsKey('deadlineDay') || updatedData.containsKey('deadlineTime')) {
         _scheduleDeadlineReminder(id, _groups[index]['name']);
      }
      
      notifyListeners();
    }
  }

  bool joinGroupByCode(String code, String userName) {
    final index = _groups.indexWhere((g) => g['inviteCode'] == code);
    if (index != -1) {
      final group = _groups[index];
      group['members'] = (group['members'] ?? 0) + 1;
      
      LocalNotificationService.showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: 'Joined Group',
        body: 'You successfully joined "${group['name']}".',
        payload: '/groups/${group['id']}',
      );
      
      notifyListeners();
      return true;
    }
    return false;
  }

  String _generateInviteCode() {
    return (DateTime.now().millisecondsSinceEpoch % 1000000).toString().padLeft(6, '0');
  }

  Map<String, dynamic>? getGroupById(String id) {
    try {
      return _groups.firstWhere((g) => g['id'] == id);
    } catch (e) {
      return null;
    }
  }
}
