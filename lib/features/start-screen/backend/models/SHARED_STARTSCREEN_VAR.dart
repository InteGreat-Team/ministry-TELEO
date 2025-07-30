import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SharedStartScreenVariables {
  // App Configuration
  static const String appTitle = 'Teleo';
  static const Size designSize = Size(430, 932);
  static const double devicePixelRatio = 3.0;
  static const EdgeInsets iosSafeAreas = EdgeInsets.only(top: 47, bottom: 34);
  
  // Colors
  static const Color primaryColor = Color(0xFF002642);
  static const Color backgroundColor = Colors.white;
  static const Color greyTextColor = Color(0xFF4A4A4A);
  
  // Text Content
  static const String welcomeText = 'Welcome to Teleo!';
  static const String teleoTitle = 'TELEO';
  static const String tagline = 'Connecting Churches, Empowering Ministry';
  static const String createAccountButtonText = 'Create a new account';
  static const String loginButtonText = 'Log in';
  static const String guestButtonText = 'Continue as Guest';
  static const String orDividerText = 'or';
  static const String churchRegistrationPrompt = 'Registered Church? ';
  static const String signUpText = 'Sign Up';
  
  // Guest Options Modal
  static const String guestOptionsTitle = 'Choose Guest Access';
  static const String guestOptionsSubtitle = 'Select how you\'d like to explore Teleo. The following app is currently in testing mode and some features may not work as expected.';
  static const String memberGuestTitle = 'Browse as Member (Testing)';
  static const String memberGuestSubtitle = 'Explore church services and community features';
  static const String adminGuestTitle = 'Preview Admin Panel (Testing)';
  static const String adminGuestSubtitle = 'View church management features';
  static const String cancelButtonText = 'Cancel';
  
  // Admin Preview Dialog
  static const String adminPreviewTitle = 'Admin Preview Mode';
  static const String adminPreviewContent = 'You\'ll have limited access to admin features. Some functions require authentication and won\'t be available in preview mode.';
  static const String continueButtonText = 'Continue';
  
  // Assets
  static const String logoAsset = 'assets/images/teleo_logo.png';
  
  // Styling
  static const TextStyle welcomeTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );
  
  static const TextStyle teleoTitleStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: primaryColor,
    letterSpacing: 2.0,
  );
  
  static const TextStyle taglineStyle = TextStyle(
    fontSize: 16,
    color: greyTextColor,
  );
  
  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle orDividerStyle = TextStyle(
    color: Color(0xFF6B7280),
    fontSize: 14,
  );
  
  static const TextStyle churchRegistrationPromptStyle = TextStyle(
    color: Colors.black87,
    fontSize: 14,
  );
  
  static const TextStyle signUpTextStyle = TextStyle(
    color: Colors.blue,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle guestOptionsTitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );
  
  static TextStyle guestOptionsSubtitleStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey.shade600,
  );
  
  static const TextStyle guestOptionTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: primaryColor,
  );
  
  static TextStyle guestOptionSubtitleStyle = TextStyle(
    fontSize: 12,
    color: Colors.grey.shade600,
  );
  
  static const TextStyle cancelButtonStyle = TextStyle(
    fontSize: 16,
    color: Colors.grey,
  );
  
  static const TextStyle adminPreviewTitleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );
  
  static const TextStyle adminPreviewContentStyle = TextStyle(
    fontSize: 14,
  );
  
  static const TextStyle dialogCancelStyle = TextStyle(
    color: Colors.grey,
  );
  
  // Button Styles
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    elevation: 0,
  );
  
  static final ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: primaryColor,
    side: const BorderSide(color: primaryColor, width: 2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  );
  
  static final ButtonStyle dialogContinueButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
  
  // Decorations
  static const BoxDecoration bottomSheetDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    ),
  );
  
  static BoxDecoration handleBarDecoration = BoxDecoration(
    color: Colors.grey.shade300,
    borderRadius: BorderRadius.circular(2),
  );
  
  static BoxDecoration guestOptionDecoration = BoxDecoration(
    border: Border.all(color: Colors.grey.shade200),
    borderRadius: BorderRadius.circular(12),
  );
  
  static BoxDecoration guestOptionIconDecoration = BoxDecoration(
    color: primaryColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(12),
  );
  
  static final RoundedRectangleBorder dialogShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  );
  
  // Theme Data
  static final ThemeData appTheme = ThemeData(
    primaryColor: primaryColor,
    fontFamily: 'SF Pro Display',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: primaryColor,
      elevation: 0,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
  
  static final MediaQueryData iphoneMediaQuery = const MediaQueryData(
    size: designSize,
    devicePixelRatio: devicePixelRatio,
    padding: iosSafeAreas,
  );
  
  static final ThemeData iosTheme = ThemeData(
    platform: TargetPlatform.iOS,
  );
  
  // Routes
  static const Map<String, String> appRoutes = {
    'home': '/',
    'login': '/login',
    'signup': '/signup',
    'forgotPassword': '/forgot-password',
    'approvalStatus': '/approval-status',
    'userHome': '/home',
    'adminHome': '/admin',
  };
}
