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
import 'features/SIGNUP/frontend/screens/USER_NAMESCREEN_2.dart';
import 'features/SIGNUP/frontend/screens/USER_BIRTHDAYSCREEN_3.dart';
import 'features/SIGNUP/frontend/screens/USER_GENDERSCREEN_4.dart';
import 'features/SIGNUP/frontend/screens/USER_USERNAMESCREEN_5.dart';
import 'features/SIGNUP/frontend/screens/USER_LOCATIONQUESTIONSCREEN_6.dart';
import 'package:teleo_organized_new/features/SIGNUP/frontend/screens/USER_GEOLOCATIONSCREEN_7.dart';
import 'features/START/backend/viewmodels/SHARED_STARTVIEWMODELS.dart';
import 'features/SIGNUP/backend/viewmodels/USER_SIGNUPVIEWMODELS.dart';
import 'features/SIGNUP/backend/viewmodels/CHURCH_SIGNUPVIEWMODELS.dart';
import 'features/START/backend/models/SHARED_STARTMODELS.dart';
import 'features/SIGNUP/geolocation/backend/GEO_LOCATIONVIEWMODEL.dart'; 
//import 'package:teleo_organized_new/features/SIGNUP/frontend/screens/USER_CONTACTINFOSCREEN_8.dart'; // NEW: Placeholder for next screen

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
          ChangeNotifierProvider(create: (_) => UserSignupViewModel()), // Added UserSignupViewModel
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
        '/name': (context) => const UserNamescreen2(),
        '/birthday': (context) => const UserBirthdayScreen3(),
        '/gender': (context) => const UserGenderScreen4(),
        '/username': (context) => const UserUsernameScreen5(),
        '/location-question': (context) => const UserLocationQuestionScreen6(),
        '/geolocation-map': (context) => const UserGeolocationScreen7(), // NEW
        '/contact-info': (context) => const UserContactInfoScreen8(), // NEW: Placeholder
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

// Placeholder for USER_CONTACTINFOSCREEN_8.dart
// You will need to create the actual file and implement its content.
class UserContactInfoScreen8 extends StatelessWidget {
  const UserContactInfoScreen8({super.key});

  @override
  Widget build(BuildContext context) {
    final userSignupViewModel = context.watch<UserSignupViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Info')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This is the Contact Info Screen (8)'),
            Text('First Name: ${userSignupViewModel.firstName}'),
            Text('Last Name: ${userSignupViewModel.lastName}'),
            Text('Birthday: ${userSignupViewModel.birthday?.toLocal().toString().split(' ')[0] ?? 'N/A'}'),
            Text('Gender: ${userSignupViewModel.gender ?? 'N/A'}'),
            Text('Username: ${userSignupViewModel.username ?? 'N/A'}'),
            Text('Address: ${userSignupViewModel.address ?? 'N/A'}'),
            Text('Lat: ${userSignupViewModel.lat ?? 'N/A'}, Lng: ${userSignupViewModel.lng ?? 'N/A'}'),
            Text('Email: ${userSignupViewModel.email}'),
            Text('Password: ${userSignupViewModel.password}'),
            ElevatedButton(
              onPressed: () {
                // Example: Finalize signup or navigate to next step
                print('Final Signup Data:');
                print('First Name: ${userSignupViewModel.firstName}');
                print('Last Name: ${userSignupViewModel.lastName}');
                print('Birthday: ${userSignupViewModel.birthday}');
                print('Gender: ${userSignupViewModel.gender}');
                print('Username: ${userSignupViewModel.username}');
                print('Address: ${userSignupViewModel.address}');
                print('Lat: ${userSignupViewModel.lat}');
                print('Lng: ${userSignupViewModel.lng}');
                print('Email: ${userSignupViewModel.email}');
                print('Password: ${userSignupViewModel.password}');
                // Navigator.pushReplacementNamed(context, '/dashboard'); // Example navigation
              },
              child: const Text('Complete Signup'),
            ),
          ],
        ),
      ),
    );
  }
}
