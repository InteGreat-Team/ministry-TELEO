import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/rendering.dart'; // Import for debug painting flags
import 'package:flutter/cupertino.dart'; // For CupertinoPageTransitionsBuilder

// Firebase options
import '../Firebase/firebase_options.dart'; // Corrected path: from lib/3/ up to lib/, then into Firebase/

// Your app screens (paths relative to lib/3/main.dart)
import 'welcome_screen.dart'; // Path: lib/3/welcome_screen.dart - Confirmed class name is WelcomeScreen
import 'login_screen.dart'; // Path: lib/3/login_screen.dart
import 'forgotpassword/c1s1forgot_password_screen.dart'; // Path: lib/3/forgotpassword/c1s1forgot_password_screen.dart
import '../2/c1approvalstatus/approval_status_check_screen.dart'; // Path: from lib/3/ up to lib/, then into 2/c1approvalstatus/
import 'signup/c1s1signupwelcome_screen.dart'
    as signup; // Path: lib/3/signup/c1s1signupwelcome_screen.dart
import '../1/c1home/landingpage.dart'
    as member_home; // Path: from lib/3/ up to lib/, then into 1/c1home/
import 'app_highlights/splash_screen.dart'; // Path: lib/3/app_highlights/splash_screen.dart - Confirmed class name is SplashScreen
import 'report/main_report_screen.dart'; // Path: lib/3/report/main_report_screen.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Disable debug painting overlays
  debugPaintSizeEnabled = false;
  debugPaintBaselinesEnabled = false;
  debugPaintLayerBordersEnabled = false;
  debugPaintPointersEnabled = false;
  debugRepaintRainbowEnabled = false;

  runApp(
    ScreenUtilInit(
      designSize: const Size(430, 932), // Your design size (iPhone 16 Pro Max)
      minTextAdapt: true,
      splitScreenMode: true, // Optional: enables split screen support
      builder: (context, child) {
        return const MyApp(); // Your root application widget
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teleo',
      debugShowCheckedModeBanner: false, // This disables the debug banner
      theme: ThemeData(
        primaryColor: const Color(0xFF002642),
        fontFamily: 'SF Pro Display', // iOS font
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF002642),
          elevation: 0,
        ),
        // Enable swipe to go back for iOS feel
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android:
                CupertinoPageTransitionsBuilder(), // Use iOS style even on Android
          },
        ),
        // Force iOS platform look and feel if desired globally
        platform: TargetPlatform.iOS,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(), // Using WelcomeScreen
        '/login': (context) => const LoginScreen(),
        '/signup':
            (context) =>
                const signup.WelcomeScreen(), // Using aliased signup welcome screen
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/approval-status': (context) => const ApprovalStatusCheckScreen(),
        '/home':
            (context) =>
                const member_home.LandingPage(), // Using aliased member home
        '/report': (context) => const MainReportScreen(),
        '/splash':
            (context) => const SplashScreen(), // CORRECTED: Using SplashScreen
      },
      // Removed the custom builder that hardcoded MediaQueryData
      // ScreenUtilInit already handles the responsiveness based on designSize
    );
  }
}
