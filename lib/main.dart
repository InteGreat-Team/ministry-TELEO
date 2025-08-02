// IMPORT PACKAGES
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/rendering.dart';

// MVVM IMPORT UPDATED
import 'features/START/frontend/screens/SHARED_WELCOMESCREEN.dart';
import 'features/START/frontend/screens/SHARED_LOGINSCREEN.dart';
import 'features/SIGNUP/frontend/screens/USER_WELCOMESCREEN_1.dart' as signup;
import 'features/START/backend/viewmodels/SHARED_STARTVIEWMODELS.dart';
import 'features/SIGNUP/backend/viewmodels/USER_SIGNUPVIEWMODELS.dart';
import 'features/SIGNUP/backend/viewmodels/CHURCH_SIGNUPVIEWMODELS.dart';
import 'features/START/backend/models/SHARED_STARTMODELS.dart';

// NOT MVVM UPDATED IMPORTS
import '3/firebase_options.dart';
import '3/c1forgotpassword/c1s1forgot_password_screen.dart';
import '2/c1approvalstatus/approval_status_check_screen.dart';
import '1/c1homepage/home_page.dart';
import '2/c1homepage/home_page.dart';
import '3/app_highlights/splash_screen.dart';
import '3/report/main_report_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  debugPaintSizeEnabled = false;
  debugPaintBaselinesEnabled = false;
  debugPaintLayerBordersEnabled = false;
  debugPaintPointersEnabled = false;
  debugRepaintRainbowEnabled = false;
  
  runApp(
    ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      builder: (context, child) => MultiProvider( // Use MultiProvider if you have more than one ViewModel
        providers: [
          ChangeNotifierProvider(create: (_) => LoginViewModel()),
          // Add other ViewModels here if needed
        ],
        child: const MyApp(),
      ),
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
            TargetPlatform.android: CupertinoPageTransitionsBuilder(), // Use iOS style even on Android
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
        '/admin': (context) => const AdminHomePage(), // Fixed: use aliased admin homepage
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
