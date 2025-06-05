import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'navigation_service.dart';
import '../2/c1approvalstatus/approval_status_check_screen.dart';
import '../2/c1homepage/home_page.dart'; // Import your admin home page

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  String? _firebaseError;
  bool _isFormValid = false;
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (email.isEmpty) {
      setState(() {
        _emailError = 'Email cannot be empty';
      });
      return false;
    } else if (!emailRegex.hasMatch(email)) {
      setState(() {
        _emailError = 'Please enter a valid email address';
      });
      return false;
    }
    setState(() {
      _emailError = null;
    });
    return true;
  }

  bool _validatePassword(String password) {
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    final hasDigit = RegExp(r'[0-9]').hasMatch(password);
    final hasMinLength = password.length >= 8;

    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Password cannot be empty';
      });
      return false;
    } else if (!hasUppercase || !hasLowercase || !hasDigit || !hasMinLength) {
      setState(() {
        _passwordError =
            'Password must have at least 8 characters, 1 uppercase, 1 lowercase, and 1 digit';
      });
      return false;
    }
    setState(() {
      _passwordError = null;
    });
    return true;
  }

  void _validateForm() {
    final isEmailValid = _validateEmail(_emailController.text);
    final isPasswordValid = _validatePassword(_passwordController.text);
    setState(() {
      _isFormValid = isEmailValid && isPasswordValid;
    });
  }

  Future<String?> _fetchUserRole(String email) async {
    // For testing purposes
    if (email.toLowerCase() == 'admin@test.com') {
      return 'admin';
    }

    // Regular cloud function call
    final uri = Uri.parse(
      'https://asia-southeast1-teleo-church-application.cloudfunctions.net/getUserRole?email=$email',
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['role'] as String?;
    } else {
      return null;
    }
  }

  Future<void> _loginWithFirebase() async {
    setState(() {
      _isLoading = true;
      _firebaseError = null;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Fetch user role from NeonDB via Cloud Function
      final role = await _fetchUserRole(_emailController.text.trim());

      if (!mounted) return;

      if (role == 'admin') {
        NavigationService.navigateToAdminHome(context);
      } else if (role == 'user') {
        NavigationService.navigateToUserHome(context);
      } else {
        setState(() {
          _firebaseError = 'User role not found or not authorized.';
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _firebaseError = e.message ?? 'Login failed. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // New method for guest access
  void _continueAsGuest() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Continue as Guest'),
          content: const Text(
            'You will have limited access to admin features. Some functions may require authentication.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate directly to admin home page as guest
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const AdminHomePage(),
                  ),
                );
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Color(0xFF002642)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: screenSize.height * 0.04),
              Center(
                child: Image.asset(
                  'assets/images/teleo_logo.png',
                  height: screenSize.height * 0.15,
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'TELEO',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF002642),
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.06),
              const Text(
                'Email Address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF002642),
                ),
              ),
              const SizedBox(height: 8),
              _buildInputField(
                controller: _emailController,
                hintText: 'Email',
                errorText: _emailError,
                onChanged: (_) => _validateForm(),
              ),

              const SizedBox(height: 20),
              const Text(
                'Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF002642),
                ),
              ),
              const SizedBox(height: 8),
              _buildInputField(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: _obscurePassword,
                errorText: _passwordError,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed:
                      () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                ),
                onChanged: (_) => _validateForm(),
              ),

              if (_firebaseError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _firebaseError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed:
                      () => Navigator.pushNamed(context, '/forgot-password'),
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed:
                      _isFormValid && !_isLoading ? _loginWithFirebase : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF002642),
                    disabledBackgroundColor: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                ),
              ),

              const SizedBox(height: 16),
              // Continue as Guest Button
              SizedBox(
                height: 56,
                child: OutlinedButton(
                  onPressed: _continueAsGuest,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF002642), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Continue as Guest',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF002642),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Register your church? ',
                    style: TextStyle(fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: Navigate to church registration
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed:
                      () => Navigator.pushNamed(context, '/approval-status'),
                  child: const Text(
                    'Check Approval Status',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    String? errorText,
    Widget? suffixIcon,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: errorText != null ? Colors.red : Colors.grey.shade300,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              suffixIcon: suffixIcon,
            ),
            onChanged: onChanged,
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8.0),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
