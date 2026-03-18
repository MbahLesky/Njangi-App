import 'package:flutter/material.dart';
import '../../../app/services/local_notification_service.dart';

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

    LocalNotificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Contribution Recorded',
      body: 'Contribution of $amount by $memberName has been logged.',
      payload: '/activity',
    );

    notifyListeners();
  }

  void completeSession(String groupId, String sessionId) {
    final groupSessions = _sessionsByGroup[groupId];
    if (groupSessions != null) {
      final index = groupSessions.indexWhere((s) => s['id'] == sessionId);
      if (index != -1) {
        final session = groupSessions[index];
        groupSessions[index] = {
          ...session,
          'isCompleted': true,
          'status': 'Completed',
        };

        LocalNotificationService.showNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: 'Payout Confirmed',
          body: '${session['recipient']} has received the payout for ${session['name']}.',
          payload: '/groups/$groupId/sessions/$sessionId',
        );

        // Advance next session to ongoing
        if (index + 1 < groupSessions.length) {
          final nextSession = groupSessions[index + 1];
          groupSessions[index + 1] = {
            ...nextSession,
            'status': 'Ongoing',
          };

          LocalNotificationService.showNotification(
            id: (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 1,
            title: 'New Session Started',
            body: '${nextSession['name']} is now ongoing. Recipient: ${nextSession['recipient']}.',
            payload: '/groups/$groupId/sessions/${nextSession['id']}',
          );
          
          // Schedule a reminder for 2 days from now (mock)
          LocalNotificationService.scheduleNotification(
            id: (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 2,
            title: 'Contribution Reminder',
            body: 'Your contribution for ${nextSession['name']} is due soon.',
            scheduledTime: DateTime.now().add(const Duration(days: 2)),
            payload: '/groups/$groupId/sessions/${nextSession['id']}',
          );
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

    LocalNotificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Circle Initialized',
      body: 'Payout rotation set for $groupId. First recipient: ${rotationOrder[0]}.',
      payload: '/groups/$groupId',
    );

    notifyListeners();
  }
}
