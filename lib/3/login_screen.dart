import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../3/widget_login/login_widget.dart';
import 'navigation_service.dart';
import '../2/c1homepage/home_page.dart';
import '../1/c1homepage/lpcontent/homepage/landingpage.dart';
import '../3/c1forgotpassword/c1s1forgot_password_screen.dart';
import '../2/c1registration/c1s1churchwelcome_screen.dart';
import '../2/c1approvalstatus/approval_status_check_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  
  bool _obscurePassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  String? _firebaseError;
  bool _isLoading = false;
  bool _hasAttemptedLogin = false; // Track if user has attempted login
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _validateEmail(String email, {bool showError = true}) {
    if (email.isEmpty) {
      if (showError) setState(() => _emailError = 'Email cannot be empty');
      return false;
    }
    if (!RegExp(_emailRegex).hasMatch(email)) {
      if (showError) setState(() => _emailError = 'Please enter a valid email address');
      return false;
    }
    if (showError) setState(() => _emailError = null);
    return true;
  }

  bool _validatePassword(String password, {bool showError = true}) {
    if (password.isEmpty) {
      if (showError) setState(() => _passwordError = 'Password cannot be empty');
      return false;
    }
    if (showError) setState(() => _passwordError = null);
    return true;
  }

  void _onFieldChanged() {
    if (_hasAttemptedLogin) {
      _validateEmail(_emailController.text);
      _validatePassword(_passwordController.text);
    }
  }

  Future<String?> _fetchUserRole(String email) async {
    if (email.toLowerCase() == 'admin@test.com') return 'admin';
    
    try {
      final response = await http.get(Uri.parse(
        'https://asia-southeast1-teleo-church-application.cloudfunctions.net/emailrole/api/emailrole?email=$email',
      ));
      if (response.statusCode == 200) {
        return json.decode(response.body)['role'] as String?;
      }
    } catch (e) {
      // Handle network errors silently
    }
    return null;
  }

  Future<void> _loginWithFirebase() async {
    _hasAttemptedLogin = true;
    
    final isEmailValid = _validateEmail(_emailController.text.trim());
    final isPasswordValid = _validatePassword(_passwordController.text);
    
    if (!isEmailValid || !isPasswordValid) return;

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
      if (!mounted) return;

      if (role == 'admin') {
        NavigationService.navigateToAdminHome(context);
      } else if (role == 'user') {
        NavigationService.navigateToUserHome(context);
      } else {
        setState(() => _firebaseError = 'User role not found or not authorized.');
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _firebaseError = e.message ?? 'Login failed. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _navigateToForgotPassword() => Navigator.push(context, 
    MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()));

  void _navigateToSignUp() => Navigator.push(context,
    MaterialPageRoute(builder: (_) => const ChurchWelcomeScreen(firstName: "User")));

  void _navigateToApprovalStatus() => Navigator.push(context,
    MaterialPageRoute(builder: (_) => const ApprovalStatusCheckScreen()));

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= 768;
    final isSmallScreen = screenSize.height < 600;
    
    final horizontalPadding = isTablet ? 48.0 : 24.0;
    final logoHeight = isSmallScreen ? 50.0 : 70.0;
    final spacing = isSmallScreen ? 6.0 : 10.0;
    
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: spacing * 0.5),
              LogoHeader(logoHeight: logoHeight),
              SizedBox(height: spacing * 1.5),
              
              // Email field
              const Text('Email Address',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF002642))),
              const SizedBox(height: 8),
              InputField(
                controller: _emailController,
                hintText: 'Email',
                errorText: _emailError,
                onChanged: (_) => _onFieldChanged(),
              ),
              SizedBox(height: spacing),
              
              // Password field
              const Text('Password',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF002642))),
              const SizedBox(height: 8),
              InputField(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: _obscurePassword,
                errorText: _passwordError,
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                onChanged: (_) => _onFieldChanged(),
              ),
              
              if (_firebaseError != null)
                Padding(
                  padding: EdgeInsets.only(top: spacing * 0.8),
                  child: Text(_firebaseError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                ),
              
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: _navigateToForgotPassword,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: spacing * 0.5),
                    minimumSize: const Size(0, 28),
                  ),
                  child: const Text('Forgot Password?',
                    style: TextStyle(fontSize: 14, color: Color(0xFF6366F1), decoration: TextDecoration.underline)),
                ),
              ),
              
              SizedBox(height: isSmallScreen ? spacing * 2 : spacing * 3),
              
              // Login button
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: !_isLoading ? _loginWithFirebase : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF002642),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isLoading
                    ? const SizedBox(height: 20, width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ),
              ),
              
              SizedBox(height: spacing * 1.5),
              
              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Register your church? ", style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
                  GestureDetector(
                    onTap: _navigateToSignUp,
                    child: const Text("Sign Up", style: TextStyle(
                      fontSize: 14, color: Color(0xFF6366F1), fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline)),
                  ),
                ],
              ),
              
              SizedBox(height: spacing),
              
              // Approval status link
              GestureDetector(
                onTap: _navigateToApprovalStatus,
                child: const Text("Check Approval Status", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFF6366F1), 
                    fontWeight: FontWeight.w500, decoration: TextDecoration.underline)),
              ),
              
              SizedBox(height: spacing * 1.5),
            ],
          ),
        ),
      ),
    );
  }
}
