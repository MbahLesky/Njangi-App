import 'package:flutter/material.dart';

class ActivityProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _activities = [
    {
      "id": "a1",
      "type": "contribution",
      "title": "Contribution Successful",
      "subtitle": "Family Savings - March Session",
      "amount": "50,000 XAF",
      "date": "2 hours ago",
      "status": "success",
    },
    {
      "id": "a2",
      "type": "payout",
      "title": "Payout Received",
      "subtitle": "Tech Entrepreneurs - Session 4",
      "amount": "800,000 XAF",
      "date": "Yesterday",
      "status": "success",
    },
  ];

  List<Map<String, dynamic>> get activities => _activities;

  void addActivity(Map<String, dynamic> activity) {
    _activities.insert(0, {
      ...activity,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'date': 'Just now',
    });
    notifyListeners();
  }
}
