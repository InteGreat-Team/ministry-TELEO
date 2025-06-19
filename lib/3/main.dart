import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'login_screen.dart';
import 'forgotpassword/c1s1forgot_password_screen.dart';
import '../2/c1approvalstatus/approval_status_check_screen.dart';
import 'signup/c1s1signupwelcome_screen.dart' as signup;
import '../1/c1homepage/home_page.dart';
import '../2/c1homepage/home_page.dart';
import 'app_highlights/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import '../Firebase/firebase_options.dart';
import '../../3/report/main_report_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Import these to disable debug overlays
import 'package:flutter/rendering.dart';

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
      designSize: const Size(430, 932),
      minTextAdapt: true,
      builder: (context, child) => const MyApp(),
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
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const signup.WelcomeScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/approval-status': (context) => const ApprovalStatusCheckScreen(),
        '/home': (context) => const HomePage(),
        '/admin': (context) => const AdminHomePage(),
      },
      builder: (context, child) {
        // This wrapper constrains the app to iPhone 16 Pro Max dimensions
        return MediaQuery(
          // iPhone 16 Pro Max dimensions (430 x 932 points)
          data: const MediaQueryData(
            size: Size(430, 932),
            devicePixelRatio: 3.0,
            padding: EdgeInsets.only(top: 47, bottom: 34), // iOS safe areas
          ),
          child: Theme(
            data: ThemeData(
              platform: TargetPlatform.iOS, // Force iOS look and feel
            ),
            child: child!,
          ),
        );
      },
    );
  }
}
