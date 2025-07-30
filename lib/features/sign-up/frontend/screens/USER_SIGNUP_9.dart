import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // For LatLng, though not directly used in this screen, it's part of UserProfile
import 'USER_SIGNUP_10.dart'; // Import for TermsConditionsScreen
import '../../backend/models/USER_SIGNUP_VAR.dart'; // Import for UserProfile
import '../widgets/index.dart'; // Corrected import for TeleoBackButton and CustomElevatedButton
import '../../backend/viewmodels/USER_SIGNUP_FUNC.dart'; // Updated import path for VerificationService

class PasswordScreen extends StatefulWidget {
  final UserProfile userProfile;
  final String email;
  final String phone;

  const PasswordScreen({
    super.key,
    required this.userProfile,
    required this.email,
    required this.phone,
  });

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _termsAccepted = false;
  String? _passwordError;
  String? _passwordRequirementsError;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isValidPassword(String password) {
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    final hasDigit = RegExp(r'[0-9]').hasMatch(password);
    final hasMinLength = password.length >= 8;
    return hasUppercase && hasLowercase && hasDigit && hasMinLength;
  }

  void _validatePasswords() {
    setState(() {
      if (_passwordController.text != _confirmPasswordController.text) {
        _passwordError = 'Passwords do not match';
      } else {
        _passwordError = null;
      }
      if (_passwordController.text.isNotEmpty &&
          !_isValidPassword(_passwordController.text)) {
        _passwordRequirementsError =
            'Password must be at least 8 characters with at least 1 uppercase letter, 1 lowercase letter, and 1 digit';
      } else {
        _passwordRequirementsError = null;
      }
    });
  }

  Future<void> _goToTerms() async {
    try {
      final sentCode = await VerificationService.sendVerificationCode(
        widget.email,
        '${widget.userProfile.firstName} ${widget.userProfile.lastName}',
      );
      if (!mounted) return;

      final updatedUserProfile = UserProfile(
        firstName: widget.userProfile.firstName,
        lastName: widget.userProfile.lastName,
        birthday: widget.userProfile.birthday,
        gender: widget.userProfile.gender,
        username: widget.userProfile.username,
        address: widget.userProfile.address,
        location: widget.userProfile.location,
        // Add email, phone, password to UserProfile if you want to persist them
        // email: widget.email,
        // phone: widget.phone,
        // password: _passwordController.text,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TermsConditionsScreen(
            userProfile: updatedUserProfile,
            email: widget.email,
            phone: widget.phone,
            password: _passwordController.text,
            sentCode: sentCode,
            isViewOnly: true,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to send code. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: TeleoBackButton(),
              ),
              const SizedBox(height: 40),
              const Text(
                "We’re almost done!",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Secure your account with a password.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorText: _passwordRequirementsError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                onChanged: (_) {
                  _validatePasswords();
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorText: _passwordError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                onChanged: (_) {
                  _validatePasswords();
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Checkbox(
                    value: _termsAccepted,
                    onChanged: (value) {
                      setState(() {
                        _termsAccepted = value ?? false;
                      });
                    },
                    activeColor: const Color(0xFF002642),
                  ),
                  Expanded(
                    child: Text(
                      "I agree to the Terms and Conditions",
                      style: TextStyle(
                        color: Colors.black87,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: CustomElevatedButton(
                  text: 'Next',
                  onPressed: (_passwordController.text.isNotEmpty &&
                          _confirmPasswordController.text.isNotEmpty &&
                          _passwordError == null &&
                          _passwordRequirementsError == null &&
                          _termsAccepted)
                      ? _goToTerms
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
