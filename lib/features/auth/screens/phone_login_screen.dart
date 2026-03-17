import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../providers/auth_provider.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _selectedCountryCode = '+237'; 

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Enter Phone Number',
                  style: AppTypography.h2,
                ),
                const SizedBox(height: 12),
                Text(
                  'We will send a verification code to this number.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.lightSurface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CountryCodePicker(
                        onChanged: (code) {
                          setState(() {
                            _selectedCountryCode = code.dialCode ?? '+237';
                          });
                        },
                        initialSelection: 'CM',
                        favorite: const ['CM', 'NG', 'GH'],
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                        textStyle: AppTypography.bodyLarge,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: AppTypography.bodyLarge,
                        decoration: const InputDecoration(
                          hintText: 'Phone Number',
                          counterText: '',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (value.length < 8) {
                            return 'Enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final authProvider = Provider.of<AuthProvider>(context, listen: false);
                      authProvider.setPhoneNumber('$_selectedCountryCode ${_phoneController.text}');
                      context.push('/verify-otp');
                    }
                  },
                  child: const Text('Send Verification Code'),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
