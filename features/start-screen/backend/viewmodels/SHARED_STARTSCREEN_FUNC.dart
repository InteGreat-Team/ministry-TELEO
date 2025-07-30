import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_core/firebase_core.dart';

class SharedStartScreenFunctions {
  // Initialize Firebase
  static Future<void> initializeFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }
  
  // Disable debug overlays
  static void disableDebugOverlays() {
    debugPaintSizeEnabled = false;
    debugPaintBaselinesEnabled = false;
    debugPaintLayerBordersEnabled = false;
    debugPaintPointersEnabled = false;
    debugRepaintRainbowEnabled = false;
  }
  
  // Set system UI overlay style for the start screen
  static void setSystemUIOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }
  
  // Navigate to login screen
  static void navigateToLogin(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }
  
  // Navigate to signup screen
  static void navigateToSignup(BuildContext context) {
    Navigator.pushNamed(context, '/signup');
  }
  
  // Navigate to forgot password screen
  static void navigateToForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, '/forgot-password');
  }
  
  // Navigate to approval status screen
  static void navigateToApprovalStatus(BuildContext context) {
    Navigator.pushNamed(context, '/approval-status');
  }
  
  // Navigate to home screen
  static void navigateToHome(BuildContext context) {
    Navigator.pushNamed(context, '/home');
  }
  
  // Navigate to admin screen
  static void navigateToAdmin(BuildContext context) {
    Navigator.pushNamed(context, '/admin');
  }
  
  // Check if user has an existing session
  static Future<bool> checkExistingSession() async {
    // Implement session checking logic here
    // For example, check if there's a valid token in secure storage
    
    // Placeholder implementation
    await Future.delayed(const Duration(milliseconds: 500));
    return false;
  }
  
  // Handle app initialization
  static Future<void> handleAppInitialization() async {
    await initializeFirebase();
    disableDebugOverlays();
    setSystemUIOverlayStyle();
  }
}
