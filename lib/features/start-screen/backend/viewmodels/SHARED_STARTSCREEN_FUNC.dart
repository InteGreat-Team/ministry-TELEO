import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../Firebase/firebase_options.dart';
import '../1/c1registrationflow/c1s1signupwelcome_screen.dart' as signup;
import 'login_screen.dart';
import '../1/c1homepage/home_page.dart';
import '../2/c1registration/c1s1churchwelcome_screen.dart';
import '../2/c1homepage/home_page.dart' as admin;

class SharedStartScreenFunctions {
  // Firebase and App Initialization
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  
  static void disableDebugOverlays() {
    debugPaintSizeEnabled = false;
    debugPaintBaselinesEnabled = false;
    debugPaintLayerBordersEnabled = false;
    debugPaintPointersEnabled = false;
    debugRepaintRainbowEnabled = false;
  }
  
  // Navigation Functions - Direct MaterialPageRoute
  static void navigateToSignupWelcome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const signup.WelcomeScreen(),
      ),
    );
  }
  
  static void navigateToLoginScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }
  
  static void navigateToGuestHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }
  
  static void navigateToAdminHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const admin.AdminHomePage(),
      ),
    );
  }
  
  static void navigateToChurchRegistration(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChurchWelcomeScreen(
          firstName: 'Church Admin',
        ),
      ),
    );
  }
  
  // Navigation Functions - Named Routes
  static void navigateToRoute(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }
  
  static void navigateToHome(BuildContext context) {
    Navigator.pushNamed(context, '/');
  }
  
  static void navigateToLogin(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }
  
  static void navigateToSignup(BuildContext context) {
    Navigator.pushNamed(context, '/signup');
  }
  
  static void navigateToForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, '/forgot-password');
  }
  
  static void navigateToApprovalStatus(BuildContext context) {
    Navigator.pushNamed(context, '/approval-status');
  }
  
  static void navigateToUserHome(BuildContext context) {
    Navigator.pushNamed(context, '/home');
  }
  
  static void navigateToAdminHomeRoute(BuildContext context) {
    Navigator.pushNamed(context, '/admin');
  }
  
  // Session and State Management
  static bool checkUserSession() {
    // TODO: Implement session checking logic
    return false;
  }
  
  static void clearUserSession() {
    // TODO: Implement session clearing logic
  }
  
  // App Lifecycle
  static Future<void> handleAppInitialization() async {
    await initializeFirebase();
    disableDebugOverlays();
  }
  
  // UI Helper Functions
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  
  static void showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
