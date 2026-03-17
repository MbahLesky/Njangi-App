import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  Map<String, dynamic> _profile = {
    "firstName": "Mbah",
    "lastName": "Lesky",
    "email": "mbahlesky@example.com",
    "phone": "+237 670 000 000",
    "avatar": null,
  };

  Map<String, dynamic> get profile => _profile;

  void updateProfile(Map<String, dynamic> updatedData) {
    _profile = {..._profile, ...updatedData};
    notifyListeners();
  }
}
