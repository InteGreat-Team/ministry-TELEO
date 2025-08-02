// lib/features/SIGNUP/backend/viewmodels/USER_SIGNUPVIEWMODELS.dart

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

// Import the model
import '../models/USER_SIGNUPMODELS.dart';

// Assuming these are the paths to your screens
import '../../../../features/START/frontend/screens/SHARED_LOGINSCREEN.dart' as main_welcome;
import '../../frontend/screens/USER_WELCOMESCREEN_1.dart'; // For internal navigation if needed, though typically ViewModel doesn't import View
import '../../frontend/screens/USER_WELCOMESCREEN_2.dart'; // The new name screen
import '../../../../1/c1registrationflow/c1s3birthday_screen.dart'; // Assuming this path for BirthdayScreen

class UserSignupViewModel extends ChangeNotifier {
  late AnimationController _textAnimationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;
  Timer? _navigationTimer;
  bool _showSkipButton = false;
  BuildContext? _context; // Store context to navigate

  // Data model for signup
  UserSignupData _signupData = UserSignupData();

  // Getters for UI to consume
  Animation<double> get fadeInAnimation => _fadeInAnimation;
  Animation<double> get scaleAnimation => _scaleAnimation;
  bool get showSkipButton => _showSkipButton;
  AnimationController get textAnimationController => _textAnimationController;

  String get firstName => _signupData.firstName;
  String get lastName => _signupData.lastName;
  bool get isNameFormValid => _signupData.isValid;

  void initAnimations(TickerProvider vsync) {
    _textAnimationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _textAnimationController.forward();
    });

    // Show skip button after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      _showSkipButton = true;
      notifyListeners();
    });

    // Set timer to navigate to next screen after 3 seconds
    _navigationTimer = Timer(const Duration(milliseconds: 3000), () {
      if (_context != null) {
        navigateToNameScreen(_context!);
      }
    });
  }

  void setContext(BuildContext context) {
    _context = context;
  }

  // Navigation methods
  void navigateToNameScreen(BuildContext context) {
    _navigationTimer?.cancel(); // Cancel any pending timers
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ChangeNotifierProvider.value(
          value: this, // Provide the same ViewModel instance
          child: const UserWelcomeScreen2(), // Navigate to the new name screen
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void navigateToBirthdayScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BirthdayScreen(
          firstName: _signupData.firstName,
          lastName: _signupData.lastName,
        ),
      ),
    );
  }

  void navigateBackToWelcome(BuildContext context) {
    _navigationTimer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const main_welcome.LoginScreen(),
      ),
    );
  }

  void skipWelcome(BuildContext context) {
    _navigationTimer?.cancel();
    navigateToNameScreen(context);
  }

  // Name input handlers
  void setFirstName(String value) {
    _signupData.firstName = value;
    notifyListeners();
  }

  void setLastName(String value) {
    _signupData.lastName = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    _navigationTimer?.cancel();
    super.dispose();
  }
}
