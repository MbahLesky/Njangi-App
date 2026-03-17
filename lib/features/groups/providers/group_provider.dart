import 'package:flutter/material.dart';

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
    },
  ];

  List<Map<String, dynamic>> get groups => _groups;

  void addGroup(Map<String, dynamic> groupData) {
    _groups.add({
      ...groupData,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'status': 'Active',
      'progress': 0.0,
      'inviteCode': _generateInviteCode(),
    });
    notifyListeners();
  }

  void updateGroup(String id, Map<String, dynamic> updatedData) {
    final index = _groups.indexWhere((g) => g['id'] == id);
    if (index != -1) {
      _groups[index] = {..._groups[index], ...updatedData};
      notifyListeners();
    }
  }

  bool joinGroupByCode(String code, String userName) {
    final index = _groups.indexWhere((g) => g['inviteCode'] == code);
    if (index != -1) {
      _groups[index]['members'] = (_groups[index]['members'] ?? 0) + 1;
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
