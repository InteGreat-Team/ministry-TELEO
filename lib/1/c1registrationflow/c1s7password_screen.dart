import 'package:flutter/material.dart';
import 'c1s8terms_conditions_screen.dart';
import '../../3/c1widgets/back_button.dart'; // Import the custom back button

class PasswordScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final DateTime birthday;
  final String gender;
  final String username;
  final String email;
  final String? phoneNumber;
  final String address;
  final double lat;
  final double lng;
  final String sentCode;

  const PasswordScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.username,
    required this.email,
    required this.address,
    required this.lat,
    required this.lng,
    required this.sentCode,
    this.phoneNumber,
  });

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _error;

  // Password strength criteria
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasDigit = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
  }

  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      _hasDigit = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

      // Update password mismatch error
      if (_confirmPasswordController.text.isNotEmpty &&
          _passwordController.text != _confirmPasswordController.text) {
        _error = "Passwords do not match";
      } else {
        _error = null;
      }
    });
  }

  bool get _isPasswordStrong =>
      _hasMinLength &&
      _hasUppercase &&
      _hasLowercase &&
      _hasDigit &&
      _hasSpecialChar;

  bool get _isFormValid =>
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty &&
      _passwordController.text == _confirmPasswordController.text &&
      _isPasswordStrong;

  @override
  void dispose() {
    _passwordController.removeListener(_validatePassword);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _buildRequirementRow(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: isMet
                ? Icon(Icons.check_circle_rounded, color: Colors.green.shade600, size: 20, key: ValueKey<bool>(true))
                : Icon(Icons.circle_outlined, color: Colors.grey.shade400, size: 20, key: ValueKey<bool>(false)),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: isMet ? Colors.green.shade700 : Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column( // Main Column to manage overall screen layout
          crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
          children: [
            // Back button at the top
            const Padding(
              padding: EdgeInsets.only(top: 16.0, left: 8.0),
              child: TeleoBackButton(),
            ),
            Expanded( // Allows the content to take available space and scroll if needed
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20), // Adjusted space after back button
                    const Text(
                      "We're almost done!",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Secure your account with a password.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 30), // Adjusted spacing
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade500, width: 1.5),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      ),
                      onChanged: (_) => _validatePassword(),
                    ),
                    const SizedBox(height: 20), // Adjusted spacing
                    // Password strength checklist
                    _buildRequirementRow('At least 8 characters', _hasMinLength),
                    _buildRequirementRow('At least one uppercase letter', _hasUppercase),
                    _buildRequirementRow('At least one lowercase letter', _hasLowercase),
                    _buildRequirementRow('At least one digit', _hasDigit),
                    _buildRequirementRow('At least one special character', _hasSpecialChar),
                    const SizedBox(height: 20), // Adjusted spacing
                    const Text(
                      'Confirm Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Confirm your password',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade500, width: 1.5),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        errorText: _error,
                      ),
                      onChanged: (_) {
                        setState(() {
                          _error = _passwordController.text != _confirmPasswordController.text
                              ? "Passwords do not match"
                              : null;
                        });
                      },
                    ),
                    // Add some padding at the bottom of the scrollable content
                    // This ensures the last text field isn't immediately cut off by the keyboard
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // Next button at the bottom, outside the scrollable area
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0, left: 24.0, right: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isFormValid
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TermsConditionsScreen(
                                firstName: widget.firstName,
                                lastName: widget.lastName,
                                birthday: widget.birthday,
                                gender: widget.gender,
                                username: widget.username,
                                email: widget.email,
                                phoneNumber: widget.phoneNumber,
                                password: _passwordController.text,
                                address: widget.address,
                                lat: widget.lat,
                                lng: widget.lng,
                                sentCode: widget.sentCode,
                                isViewOnly: false,
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF002642),
                    foregroundColor: Colors.white,
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
    );
  }
}