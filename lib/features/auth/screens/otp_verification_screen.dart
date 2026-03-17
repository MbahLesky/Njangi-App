import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../providers/auth_provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();
  int _timerValue = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerValue == 0) {
        setState(() {
          _timer?.cancel();
        });
      } else {
        setState(() {
          _timerValue--;
        });
      }
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _handleVerification() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isValid = await authProvider.verifyOtp(_pinController.text);
    
    if (!mounted) return;

    if (isValid) {
      _showSuccessDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid OTP. Please try 123456.'),
          backgroundColor: AppColors.error,
        ),
      );
      _pinController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: AppTypography.h2,
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primary, width: 2),
      borderRadius: BorderRadius.circular(12),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.lightTextPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Verify Phone',
                style: AppTypography.h2,
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.lightTextSecondary,
                  ),
                  children: [
                    const TextSpan(text: 'Enter the 6-digit code sent to '),
                    TextSpan(
                      text: authProvider.phoneNumber ?? '+237 670 000 000',
                      style: const TextStyle(
                        color: AppColors.lightTextPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: Pinput(
                  length: 6,
                  controller: _pinController,
                  focusNode: _focusNode,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  onCompleted: (pin) => _handleVerification(),
                  cursor: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 9),
                        width: 22,
                        height: 1,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive code? ",
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: _timerValue == 0
                        ? () {
                            setState(() {
                              _timerValue = 60;
                              _startTimer();
                            });
                          }
                        : null,
                    child: Text(
                      _timerValue == 0 ? 'Resend' : 'Resend in ${_timerValue}s',
                      style: TextStyle(
                        color: _timerValue == 0 ? AppColors.primary : AppColors.lightTextSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: authProvider.isLoading || _pinController.text.length < 6
                    ? null
                    : _handleVerification,
                child: authProvider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Verify and Continue'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Verification Successful',
              style: AppTypography.h3,
            ),
            const SizedBox(height: 8),
            const Text(
              'Your phone number has been verified successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.lightTextSecondary),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                context.go('/complete-profile');
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
