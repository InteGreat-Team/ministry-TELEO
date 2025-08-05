import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../3/widget_login/login_widget.dart'; // Updated import
import 'navigation_service.dart';
import '../2/c1homepage/home_page.dart';
import '../1/c1homepage/lpcontent/homepage/landingpage.dart';
// Add these imports for the new screens
import '../3/c1forgotpassword/c1s1forgot_password_screen.dart';
import '../2/c1registration/c1s1churchwelcome_screen.dart';
import '../2/c1approvalstatus/approval_status_check_screen.dart';

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

      if (role == 'admin') {
        NavigationService.navigateToAdminHome(context);
      } else if (role == 'user') {
        NavigationService.navigateToUserHome(context);
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
    // Removed guest functionality
  }

  // Navigation methods for the connected screens
  void _navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordScreen(),
      ),
    );
  }

  void _navigateToSignUp() {
    // Navigate to ChurchWelcomeScreen for sign up
    // You'll need to provide a firstName - you might want to get this from user input
    // For now, using a placeholder
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChurchWelcomeScreen(firstName: "User"),
      ),
    );
  }

  void _navigateToApprovalStatus() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ApprovalStatusCheckScreen(),
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
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = keyboardHeight > 0;
    
    // Enhanced responsive breakpoints
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isTablet = screenWidth >= 768;
    final isSmallScreen = screenHeight < 600;
    final isVerySmallScreen = screenHeight < 500;
    final isMediumScreen = screenHeight >= 600 && screenHeight < 800;
    final isLargeScreen = screenHeight >= 800;
    
    // Responsive spacing values
    final horizontalPadding = isTablet ? 48.0 : 24.0;
    final logoHeight = isVerySmallScreen ? 60.0 : isSmallScreen ? 70.0 : isMediumScreen ? 90.0 : 100.0;
    final fieldSpacing = isVerySmallScreen ? 12.0 : isSmallScreen ? 16.0 : 20.0;
    final sectionSpacing = isVerySmallScreen ? 8.0 : isSmallScreen ? 12.0 : 16.0;
    final bottomSpacing = isVerySmallScreen ? 12.0 : isSmallScreen ? 16.0 : 24.0;
    
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight;
            
            return SingleChildScrollView(
              physics: isKeyboardOpen ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: availableHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Top section with logo - responsive flex values
                        Flexible(
                          flex: isVerySmallScreen ? 1 : isSmallScreen ? 2 : isMediumScreen ? 2 : 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LogoHeader(logoHeight: logoHeight),
                            ],
                          ),
                        ),
                        
                        // Middle section with form fields - optimized spacing
                        Flexible(
                          flex: isVerySmallScreen ? 6 : isSmallScreen ? 5 : isMediumScreen ? 4 : 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Email Address or Phone Number',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF002642)),
                              ),
                              const SizedBox(height: 8),
                              InputField(
                                controller: _emailController,
                                hintText: 'Email or Phone Number',
                                errorText: _emailError,
                                onChanged: (_) => _validateForm(),
                              ),
                              SizedBox(height: sectionSpacing), // Optimized spacing
                              const Text(
                                'Password',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
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
                                  onPressed: _navigateToForgotPassword,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 32),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 14, 
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF6366F1),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Bottom section with buttons and footer - responsive spacing
                        Flexible(
                          flex: isVerySmallScreen ? 3 : isSmallScreen ? 3 : isMediumScreen ? 3 : 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: isTablet ? 56 : 52, // Slightly larger on tablets
                                child: ElevatedButton(
                                  onPressed: _isFormValid && !_isLoading ? _loginWithFirebase : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF002642),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    disabledBackgroundColor: Colors.grey.shade300,
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'Login',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                ),
                              ),
                              SizedBox(height: fieldSpacing),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Register your church? ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _navigateToSignUp,
                                    child: const Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF6366F1),
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: sectionSpacing * 0.75), // Slightly reduced
                              GestureDetector(
                                onTap: _navigateToApprovalStatus,
                                child: const Text(
                                  "Check Approval Status",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6366F1),
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              SizedBox(height: bottomSpacing), // Responsive bottom spacing
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}