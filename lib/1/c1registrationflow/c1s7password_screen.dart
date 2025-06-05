import 'package:flutter/material.dart';
import 'c1s8terms_conditions_screen.dart';
import 'c1s9verification_code_screen.dart';
import '../../3/c1widgets/back_button.dart';

class PasswordScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final DateTime birthday;
  final String gender;
  final String username;
  final String email;
  final String phone;
  final String location;

  const PasswordScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.username,
    required this.email,
    required this.phone,
    required this.location,
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
    // Check if password meets requirements:
    // - At least 8 characters
    // - At least 1 uppercase letter
    // - At least 1 lowercase letter
    // - At least 1 digit
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
      
      if (_passwordController.text.isNotEmpty && !_isValidPassword(_passwordController.text)) {
        _passwordRequirementsError = 'Password must be at least 8 characters with at least 1 uppercase letter, 1 lowercase letter, and 1 digit';
      } else {
        _passwordRequirementsError = null;
      }
    });
  }

  Future<void> _navigateToTermsAndConditions() async {
    // Navigate to Terms and Conditions screen and wait for result
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => TermsConditionsScreen(
          firstName: widget.firstName,
          lastName: widget.lastName,
          birthday: widget.birthday,
          gender: widget.gender,
          username: widget.username,
          email: widget.email,
          phone: widget.phone,
          location: widget.location,
          isViewOnly: true, // Set to view-only mode
        ),
      ),
    );
    
    // If result is true, user has read the terms
    if (result == true) {
      setState(() {
        _termsAccepted = true;
      });
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
              // Back button
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: TeleoBackButton(),
              ),
              const SizedBox(height: 40),
              
              const Text(
                "Create a Password",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Your password must be at least 8 characters and include uppercase, lowercase, and numbers.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              
              // Password field
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF002642)),
                  ),
                  errorText: _passwordRequirementsError,
                  errorMaxLines: 3,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
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
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              
              // Confirm Password field
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF002642)),
                  ),
                  errorText: _passwordError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
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
                  setState(() {});
                },
              ),
              const SizedBox(height: 24),
              
              // Terms and conditions checkbox
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
                    child: GestureDetector(
                      onTap: _navigateToTermsAndConditions,
                      child: const Text(
                        "I agree to the Terms and Conditions",
                        style: TextStyle(
                          color: Colors.black87,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Next button
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: (_passwordController.text.isNotEmpty &&
                               _confirmPasswordController.text.isNotEmpty &&
                               _passwordError == null &&
                               _passwordRequirementsError == null &&
                               _termsAccepted)
                        ? () {
                            // Navigate directly to verification code screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VerificationCodeScreen(
                                  firstName: widget.firstName,
                                  lastName: widget.lastName,
                                  birthday: widget.birthday,
                                  gender: widget.gender,
                                  username: widget.username,
                                  email: widget.email,
                                  phone: widget.phone,
                                  password: _passwordController.text,
                                  location: widget.location,
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002642),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.3),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
