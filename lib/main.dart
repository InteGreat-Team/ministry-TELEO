import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Only import files that actually exist and are needed
// Commented out problematic imports - uncomment and fix paths when files are ready
// import 'features/start-screen/backend/models/SHARED_STARTSCREEN_VAR.dart';
// import 'features/start-screen/backend/viewmodels/SHARED_STARTSCREEN_FUNC.dart';
// import 'features/sign-up/backend/viewmodels/CHURCH_SIGNUP_FUNC.dart';
// import 'features/sign-up/backend/viewmodels/USER_SIGNUP_FUNC.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Uncomment when you have Firebase configured
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }
  
  // Disable debug overlays - uncomment when SharedStartScreenFunctions is available
  // SharedStartScreenFunctions.disableDebugOverlays();
  
  runApp(
    MultiProvider(
      providers: [
        // Uncomment when ViewModels are available
        // ChangeNotifierProvider(create: (_) => ChurchSignupViewModel()),
        // ChangeNotifierProvider(create: (_) => PersonViewModel()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812), // Default design size, replace with SharedStartScreenVariables.designSize when available
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
      title: 'Teleo', // Replace with SharedStartScreenVariables.appTitle when available
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ), // Replace with SharedStartScreenVariables.appTheme when available
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/start': (context) => const StartScreen(),
        '/forgot-password': (context) => const Scaffold(
          body: Center(child: Text('Forgot Password Screen - Coming Soon')),
        ),
        '/signup': (context) => const Scaffold(
          body: Center(child: Text('Signup Screen - Coming Soon')),
        ),
        '/approval-status': (context) => const Scaffold(
          body: Center(child: Text('Approval Status Screen - Coming Soon')),
        ),
        '/user-home': (context) => const Scaffold(
          body: Center(child: Text('User Home Screen - Coming Soon')),
        ),
        '/admin-home': (context) => const Scaffold(
          body: Center(child: Text('Admin Home Screen - Coming Soon')),
        ),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        );
      },
    );
  }
}

// Welcome Screen
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Logo placeholder
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Color(0xFF002642),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.church,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              // Welcome text
              const Text(
                'Welcome to Teleo!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF002642),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Create a new account button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF002642),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Create a new account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Log in button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF002642),
                    side: const BorderSide(color: Color(0xFF002642)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Log in',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const Spacer(),
              // Registered Church? Sign Up text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Registered Church? ',
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// Login Screen
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF002642)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.church,
                  size: 80,
                  color: Color(0xFF002642),
                ),
                SizedBox(height: 24),
                Text(
                  'Login Screen',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF002642),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Login functionality will be implemented here',
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
      ),
    );
  }
}

// Start Screen
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: const SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.church,
                  size: 80,
                  color: Color(0xFF002642),
                ),
                SizedBox(height: 24),
                Text(
                  'Start Screen',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF002642),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Start screen functionality will be implemented here',
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
      ),
    );
  }
}