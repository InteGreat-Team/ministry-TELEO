import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SharedStartScreenVariables {
  // App Configuration
  static const String appTitle = 'Teleo';
  static const String initialRoute = '/';
  
  // Screen Dimensions
  static const Size designSize = Size(430, 932);
  static const double devicePixelRatio = 3.0;
  
  // Colors
  static const Color primaryColor = Color(0xFF002642);
  static const Color textColor = Color(0xFF4A4A4A);
  static const Color backgroundColor = Colors.white;
  
  // Text styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: primaryColor,
    letterSpacing: 2.0,
  );
  
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    color: textColor,
  );
  
  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  
  // Button styles
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  );
  
  static final ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
    side: const BorderSide(color: primaryColor, width: 2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  );
  
  // Assets
  static const String logoAsset = 'assets/images/teleo_logo.png';
  
  // App Theme
  static final ThemeData appTheme = ThemeData(
    primaryColor: primaryColor,
    fontFamily: 'SF Pro Display', // iOS font
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: primaryColor,
      elevation: 0,
    ),
    // Enable swipe to go back for iOS feel
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: CupertinoPageTransitionsBuilder(), // Use iOS style even on Android
      },
    ),
  );
  
  // iOS Theme
  static final ThemeData iosTheme = ThemeData(
    platform: TargetPlatform.iOS, // Force iOS look and feel
  );
  
  // MediaQuery Data for iPhone 16 Pro Max
  static const MediaQueryData mediaQueryData = MediaQueryData(
    size: Size(430, 932),
    devicePixelRatio: 3.0,
    padding: EdgeInsets.only(top: 47, bottom: 34), // iOS safe areas
  );
  
  // App Routes
  static final Map<String, WidgetBuilder> appRoutes = {
    '/': (context) => const Scaffold(body: Center(child: Text('Welcome'))),
    '/start': (context) => const Scaffold(body: Center(child: Text('Start Screen'))),
    '/login': (context) => const Scaffold(body: Center(child: Text('Login'))),
    '/signup': (context) => const Scaffold(body: Center(child: Text('Signup'))),
    '/forgot-password': (context) => const Scaffold(body: Center(child: Text('Forgot Password'))),
    '/approval-status': (context) => const Scaffold(body: Center(child: Text('Approval Status'))),
    '/home': (context) => const Scaffold(body: Center(child: Text('Home'))),
    '/admin': (context) => const Scaffold(body: Center(child: Text('Admin'))),
  };
}
