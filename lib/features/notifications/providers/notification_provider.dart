import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _notifications = [
    {
      "id": "n1",
      "title": "Payment Reminder",
      "message": "Your contribution for 'Family Savings' is due in 2 days.",
      "time": "1 hour ago",
      "isRead": false,
    },
    {
      "id": "n2",
      "title": "New Member Joined",
      "message": "Sarah joined 'Tech Entrepreneurs' group.",
      "time": "5 hours ago",
      "isRead": true,
    },
  ];

  List<Map<String, dynamic>> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n['isRead']).length;

  void addNotification(Map<String, dynamic> notification) {
    _notifications.insert(0, {
      ...notification,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'time': 'Just now',
      'isRead': false,
    });
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n['id'] == id);
    if (index != -1) {
      _notifications[index]['isRead'] = true;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n['isRead'] = true;
    }
    notifyListeners();
  }
}
