// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/START/backend/services/auth_service.dart'; // Relative import
import 'features/START/backend/viewmodels/shared_startviewmodels.dart'; // Relative import
import 'features/START/frontend/screens/shared_welcomescreen.dart'; // Relative import
import 'features/START/frontend/screens/shared_loginscreen.dart'; // Relative import
import 'features/SIGNUP/backend/services/email_service.dart'; // Relative import
import 'features/SIGNUP/backend/services/user_registration_api_service.dart'; // Relative import
import 'features/SIGNUP/backend/services/profile_upload_service.dart'; // Relative import
import 'features/SIGNUP/backend/viewmodels/user_signupviewmodels.dart'; // Relative import
import 'features/SIGNUP/backend/viewmodels/church_signupviewmodels.dart'; // Relative import
import 'features/SIGNUP/geolocation/frontend/geo_locationservice.dart'; // Relative import
import 'features/SIGNUP/geolocation/frontend/geo_locationcubit.dart'; // Relative import
import 'features/SIGNUP/frontend/screens/user_welcomescreen_1.dart'; // Relative import
import 'features/SIGNUP/frontend/screens/user_namescreen_2.dart'; // Relative import
import 'features/SIGNUP/frontend/screens/user_birthdayscreen_3.dart'; // Relative import
import 'features/SIGNUP/frontend/screens/user_genderscreen_4.dart'; // Relative import
import 'features/SIGNUP/frontend/screens/user_usernamescreen_5.dart'; // Relative import
import 'features/SIGNUP/frontend/screens/user_locationquestionscreen_6.dart'; // Relative import
import 'features/SIGNUP/frontend/screens/user_geolocationscreen_7.dart'; // Relative import
import 'features/SIGNUP/frontend/screens/user_contactinfoscreen_8.dart'; // Relative import
import 'features/SIGNUP/frontend/screens/user_passwordscreen_9.dart'; // Relative import
import 'features/SIGNUP/frontend/screens/user_termsandconditionsscreen_10.dart'; // Relative import
import 'features/SIGNUP/frontend/screens/user_verificationcodescreen_11.dart'; // Relative import
import 'features/SIGNUP/frontend/screens/user_profilepicturescreen_12.dart'; // Relative import
import 'features/SIGNUP/frontend/screens/user_signupcompletescreen_13.dart'; // Relative import
import 'features/SIGNUP/frontend/screens/church_welcomescreen_1.dart'; // Relative import
import 'package:flutter_bloc/flutter_bloc.dart'; // For BlocProvider

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<EmailService>(create: (_) => EmailService()),
        Provider<UserRegistrationApiService>(create: (_) => UserRegistrationApiService()),
        Provider<ProfileUploadService>(create: (_) => ProfileUploadService()),
        Provider<LocationService>(create: (_) => LocationService()),

        // ViewModels
        ChangeNotifierProvider(
          create: (context) => SharedStartViewModel(
            authService: Provider.of<AuthService>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => UserSignupViewModel(
            emailService: Provider.of<EmailService>(context, listen: false),
            registrationApiService: Provider.of<UserRegistrationApiService>(context, listen: false),
            profileUploadService: Provider.of<ProfileUploadService>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ChurchSignupViewModel(),
        ),
        // Bloc for Location
        BlocProvider<LocationCubit>(
          create: (context) => LocationCubit(
            Provider.of<LocationService>(context, listen: false),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Teleo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: SharedWelcomeScreen.routeName,
        routes: {
          SharedWelcomeScreen.routeName: (context) => const SharedWelcomeScreen(),
          SharedLoginScreen.routeName: (context) => const SharedLoginScreen(),
          UserWelcomeScreen1.routeName: (context) => const UserWelcomeScreen1(),
          UserNamescreen2.routeName: (context) => const UserNamescreen2(),
          UserBirthdayScreen3.routeName: (context) => const UserBirthdayScreen3(),
          UserGenderScreen4.routeName: (context) => const UserGenderScreen4(),
          UserUsernameScreen5.routeName: (context) => const UserUsernameScreen5(),
          UserLocationQuestionScreen6.routeName: (context) => const UserLocationQuestionScreen6(),
          UserGeolocationScreen7.routeName: (context) => const UserGeolocationScreen7(),
          UserContactInfoScreen8.routeName: (context) => const UserContactInfoScreen8(),
          UserPasswordScreen9.routeName: (context) => const UserPasswordScreen9(),
          UserTermsAndConditionsScreen10.routeName: (context) => const UserTermsAndConditionsScreen10(),
          UserVerificationCodescreen11.routeName: (context) => const UserVerificationCodescreen11(),
          UserProfilePictureScreen12.routeName: (context) => const UserProfilePictureScreen12(),
          UserSignupCompleteScreen13.routeName: (context) => const UserSignupCompleteScreen13(),
          ChurchWelcomeScreen1.routeName: (context) => const ChurchWelcomeScreen1(),
          // Add other routes as needed
          '/home': (context) => const PlaceholderScreen(title: 'Home Screen'), // Placeholder for main app screen
        },
      ),
    );
  }
}

// A simple placeholder screen for navigation
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
