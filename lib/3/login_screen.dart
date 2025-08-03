import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import '../3/widget_login/login_widget.dart'; // Updated import
import 'navigation_service.dart';
import 'c1apphighlights/splash_screen.dart'; // Import the splash screen
import 'c1apphighlights/interest_selection_screen.dart';

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
      setState(() => _emailError = 'Email cannot be empty');
      return false;
    } else if (!emailRegex.hasMatch(email)) {
      setState(() => _emailError = 'Please enter a valid email address');
      return false;
    }
    setState(() => _emailError = null);
    return true;
  }

  bool _validatePassword(String password) {
    if (password.isEmpty) {
      setState(() => _passwordError = 'Password cannot be empty');
      return false;
    }
    setState(() => _passwordError = null);
    return true;
  }

  void _validateForm() {
    final isEmailValid = _validateEmail(_emailController.text);
    final isPasswordValid = _validatePassword(_passwordController.text);
    setState(() => _isFormValid = isEmailValid && isPasswordValid);
  }

  Future<String?> _fetchUserRole(String email) async {
    if (email.toLowerCase() == 'admin@test.com') return 'admin';

    final uri = Uri.parse(
      'https://asia-southeast1-teleo-church-application.cloudfunctions.net/emailrole/api/emailrole?email=$email',
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['role'] as String?;
    }
    return null;
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

      final role = await _fetchUserRole(_emailController.text.trim());
      final user = _auth.currentUser;
      final idToken = await user?.getIdToken();
      print('Firebase ID Token: $idToken');

      if (!mounted) return;

      // Navigate to splash screen first, then it will handle the flow to interest selection and homepage
      if (role == 'admin' || role == 'user') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AppHighlightsSplashScreen()),
        );
      } else {
        setState(
            () => _firebaseError = 'User role not found or not authorized.');
      }
    } on FirebaseAuthException catch (e) {
      setState(() =>
          _firebaseError = e.message ?? 'Login failed. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _continueAsGuest() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Continue as Guest'),
        content: const Text(
          'You will have limited access to admin features. Some functions may require authentication.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to splash screen for guests as well
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AppHighlightsSplashScreen()),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: screenSize.height * 0.04),
              LogoHeader(logoHeight: screenSize.height * 0.15),
              SizedBox(height: screenSize.height * 0.06),
              const Text(
                'Email Address',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF002642)),
              ),
              const SizedBox(height: 8),
              InputField(
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
                    color: Color(0xFF002642)),
              ),
              const SizedBox(height: 8),
              InputField(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: _obscurePassword,
                errorText: _passwordError,
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                onChanged: (_) => _validateForm(),
              ),
              if (_firebaseError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(_firebaseError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12)),
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/forgot-password'),
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                onPressed:
                    _isFormValid && !_isLoading ? _loginWithFirebase : null,
                isLoading: _isLoading,
                label: 'LOGIN',
              ),
              const SizedBox(height: 16),
              OutlinedGuestButton(onPressed: _continueAsGuest),
              const FooterLinks(),
            ],
          ),
        ),
      ),
    );
  }
}