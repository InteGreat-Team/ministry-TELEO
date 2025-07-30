import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import '../features/start-screen/frontend/screens/SHARED_WELCOMESCREEN.dart';
import '../features/start-screen/frontend/screens/SHARED_LOGINSCREEN.dart';
import '../features/start-screen/frontend/screens/SHARED_STARTSCREEN.dart';
import '../features/start-screen/backend/models/SHARED_STARTSCREEN_VAR.dart';
import '../features/start-screen/backend/viewmodels/SHARED_STARTSCREEN_FUNC.dart';
import '../features/sign-up/backend/viewmodels/CHURCH_SIGNUP_FUNC.dart';
import '../features/sign-up/backend/viewmodels/USER_SIGNUP_FUNC.dart';
import '../features/sign-up/frontend/screens/USER_SIGNUP_1.dart' as signup;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Uncomment when you have Firebase configured
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }
  
  // Disable debug overlays
  SharedStartScreenFunctions.disableDebugOverlays();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChurchSignupViewModel()),
        ChangeNotifierProvider(create: (_) => PersonViewModel()),
      ],
      child: ScreenUtilInit(
        designSize: SharedStartScreenVariables.designSize,
        minTextAdapt: true,
        builder: (context, child) => const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: SharedStartScreenVariables.appTitle,
      debugShowCheckedModeBanner: false,
      theme: SharedStartScreenVariables.appTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const SHARED_LOGIN(),
        '/signup': (context) => const signup.PersonListView(),
        '/start': (context) => const SHARED_STARTSCREEN(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/approval-status': (context) => const ApprovalStatusCheckScreen(),
        '/user-home': (context) => const HomePage(),
        '/admin-home': (context) => const AdminHomePage(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        );
      },
    );
  }
}

// Placeholder screens that will be replaced with actual implementations
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: const Color(0xFF002642),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_reset,
                size: 80,
                color: Color(0xFF002642),
              ),
              SizedBox(height: 24),
              Text(
                'Forgot Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF002642),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Password recovery functionality will be implemented here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ApprovalStatusCheckScreen extends StatelessWidget {
  const ApprovalStatusCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approval Status'),
        backgroundColor: const Color(0xFF002642),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.approval,
                size: 80,
                color: Color(0xFF002642),
              ),
              SizedBox(height: 24),
              Text(
                'Check Approval Status',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF002642),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Approval status checking functionality will be implemented here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: const Color(0xFF002642),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.home,
                size: 80,
                color: Color(0xFF002642),
              ),
              SizedBox(height: 24),
              Text(
                'Home Page',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF002642),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'User home page functionality will be implemented here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color(0xFF002642),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.admin_panel_settings,
                size: 80,
                color: Color(0xFF002642),
              ),
              SizedBox(height: 24),
              Text(
                'Admin Dashboard',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF002642),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Admin dashboard functionality will be implemented here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}