import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../app/services/local_notification_service.dart';

class ChatProvider extends ChangeNotifier {
  final Map<String, List<Map<String, dynamic>>> _messagesByGroup = {
    "1": [
      {
        "id": "m1",
        "sender": "John Doe",
        "text": "Hello everyone! Happy to start this cycle.",
        "time": "10:00 AM",
        "isMe": false,
        "type": "text"
      },
      {
        "id": "m2",
        "sender": "System",
        "text": "Cycle started. Payout rotation: John Doe, Sarah Johnson, Mbah Lesky.",
        "time": "10:01 AM",
        "isMe": false,
        "type": "announcement"
      },
      {
        "id": "m3",
        "sender": "Mbah Lesky",
        "text": "Looking forward to it!",
        "time": "10:05 AM",
        "isMe": true,
        "type": "text"
      },
    ],
  };

  List<Map<String, dynamic>> getMessages(String groupId) {
    return _messagesByGroup[groupId] ?? [];
  }

  void sendMessage(String groupId, String text, String senderName) {
    if (!_messagesByGroup.containsKey(groupId)) {
      _messagesByGroup[groupId] = [];
    }
    _messagesByGroup[groupId]!.add({
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "sender": senderName,
      "text": text,
      "time": DateFormat.jm().format(DateTime.now()),
      "isMe": true,
      "type": "text"
    });
    
    notifyListeners();
  }

  void receiveMessage(String groupId, String text, String senderName) {
    if (!_messagesByGroup.containsKey(groupId)) {
      _messagesByGroup[groupId] = [];
    }
    _messagesByGroup[groupId]!.add({
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "sender": senderName,
      "text": text,
      "time": DateFormat.jm().format(DateTime.now()),
      "isMe": false,
      "type": "text"
    });

    LocalNotificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'New Message from $senderName',
      body: text,
      payload: '/groups/$groupId',
    );

    notifyListeners();
  }

  void addAnnouncement(String groupId, String text) {
    if (!_messagesByGroup.containsKey(groupId)) {
      _messagesByGroup[groupId] = [];
    }
    _messagesByGroup[groupId]!.add({
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "sender": "System",
      "text": text,
      "time": DateFormat.jm().format(DateTime.now()),
      "isMe": false,
      "type": "announcement"
    });

    LocalNotificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'New Announcement',
      body: text,
      payload: '/groups/$groupId',
    );

    notifyListeners();
  }
}
