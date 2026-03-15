class MockData {
  static const String userName = "Mbah Lesky";
  
  static const List<Map<String, dynamic>> userGroups = [
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
    },
  ];

  static const List<Map<String, dynamic>> recentActivity = [
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

  static const List<Map<String, dynamic>> notifications = [
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
}
