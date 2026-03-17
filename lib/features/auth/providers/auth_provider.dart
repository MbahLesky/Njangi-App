import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _phoneNumber;
  Map<String, dynamic>? _userProfile;
  bool _isLoading = false;

  bool get isAuthenticated => _isAuthenticated;
  String? get phoneNumber => _phoneNumber;
  Map<String, dynamic>? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  // Mock OTP for prototype
  final String _mockOtp = "123456";

  void setPhoneNumber(String phone) {
    _phoneNumber = phone;
    notifyListeners();
  }

  Future<bool> verifyOtp(String otp) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (otp == _mockOtp) {
      _isLoading = false;
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  void completeProfile(Map<String, dynamic> profileData) {
    _userProfile = {
      ...profileData,
      'phone': _phoneNumber,
      'id': 'user_123',
      'initials': '${profileData['firstName'][0]}${profileData['lastName'][0]}',
    };
    _isAuthenticated = true;
    notifyListeners();
  }

  void updateProfile(Map<String, dynamic> updatedData) {
    if (_userProfile != null) {
      _userProfile = {..._userProfile!, ...updatedData};
      notifyListeners();
    }
  }

  void logout() {
    _isAuthenticated = false;
    _phoneNumber = null;
    _userProfile = null;
    notifyListeners();
  }
}
