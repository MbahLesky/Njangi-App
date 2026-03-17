import 'package:flutter/material.dart';

class SessionProvider extends ChangeNotifier {
  Map<String, List<Map<String, dynamic>>> _sessionsByGroup = {
    "1": [
      {"id": "s1_1", "name": "Session 1", "date": "Jan 12, 2026", "isCompleted": true, "recipient": "John Doe", "totalPayout": "600,000 XAF", "status": "Completed"},
      {"id": "s1_2", "name": "Session 2", "date": "Feb 12, 2026", "isCompleted": true, "recipient": "Sarah Johnson", "totalPayout": "600,000 XAF", "status": "Completed"},
      {"id": "s1_3", "name": "Session 3", "date": "Mar 12, 2026", "isCompleted": false, "recipient": "Mbah Lesky", "totalPayout": "600,000 XAF", "status": "Ongoing"},
    ],
    "2": [
      {"id": "s2_1", "name": "Session 1", "date": "Mar 01, 2026", "isCompleted": true, "recipient": "Alice Wong", "totalPayout": "800,000 XAF", "status": "Completed"},
      {"id": "s2_2", "name": "Session 2", "date": "Mar 08, 2026", "isCompleted": false, "recipient": "Bob Smith", "totalPayout": "800,000 XAF", "status": "Ongoing"},
    ],
  };

  Map<String, List<Map<String, dynamic>>> _contributionsBySession = {
    "s1_3": [
      {"id": "c1", "member": "Mbah Lesky", "paid": true, "amount": "50,000 XAF", "date": "Mar 10"},
      {"id": "c2", "member": "John Doe", "paid": true, "amount": "50,000 XAF", "date": "Mar 11"},
      {"id": "c3", "member": "Sarah Johnson", "paid": false, "amount": "50,000 XAF", "date": "Pending"},
    ],
  };

  List<Map<String, dynamic>> getSessionsForGroup(String groupId) {
    return _sessionsByGroup[groupId] ?? [];
  }

  List<Map<String, dynamic>> getContributionsForSession(String sessionId) {
    return _contributionsBySession[sessionId] ?? [];
  }

  void recordContribution(String sessionId, String memberName, String amount) {
    if (!_contributionsBySession.containsKey(sessionId)) {
      _contributionsBySession[sessionId] = [];
    }

    final index = _contributionsBySession[sessionId]!.indexWhere((c) => c['member'] == memberName);
    if (index != -1) {
      _contributionsBySession[sessionId]![index] = {
        ..._contributionsBySession[sessionId]![index],
        'paid': true,
        'amount': amount,
        'date': 'Just now',
      };
    } else {
      _contributionsBySession[sessionId]!.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'member': memberName,
        'paid': true,
        'amount': amount,
        'date': 'Just now',
      });
    }
    notifyListeners();
  }

  void completeSession(String groupId, String sessionId) {
    final groupSessions = _sessionsByGroup[groupId];
    if (groupSessions != null) {
      final index = groupSessions.indexWhere((s) => s['id'] == sessionId);
      if (index != -1) {
        groupSessions[index] = {
          ...groupSessions[index],
          'isCompleted': true,
          'status': 'Completed',
        };

        // Advance next session to ongoing
        if (index + 1 < groupSessions.length) {
          groupSessions[index + 1] = {
            ...groupSessions[index + 1],
            'status': 'Ongoing',
          };
        }
        notifyListeners();
      }
    }
  }

  void initializeCircle(String groupId, List<String> rotationOrder, String amount, String frequency) {
    List<Map<String, dynamic>> sessions = [];
    for (int i = 0; i < rotationOrder.length; i++) {
      sessions.add({
        'id': 's_${groupId}_${i + 1}',
        'name': 'Session ${i + 1}',
        'date': 'TBD',
        'isCompleted': false,
        'recipient': rotationOrder[i],
        'totalPayout': amount,
        'status': i == 0 ? 'Ongoing' : 'Pending',
      });
    }
    _sessionsByGroup[groupId] = sessions;
    notifyListeners();
  }
}
