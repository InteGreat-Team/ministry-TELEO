import 'dart:io'; // For File
import 'package:flutter/material.dart';
import '../../backend/models/USER_SIGNUP_VAR.dart'; // Import for UserProfile
import '../../lib/2/c1registration/c1s1churchwelcome_screen.dart'; // Import for ChurchWelcomeScreen
import '../../lib/1/user_model.dart'; // Import for UserModel
import '../../lib/3/c1widgets/animated_wave_background.dart'; // Import for AnimatedWaveBackground
import '../../lib/3/app_highlights/splash_screen.dart'; // Import for AppHighlightsSplashScreen
import '../widgets/index.dart'; // Import for CustomElevatedButton

class SignupCompleteScreen extends StatelessWidget {
  final UserProfile userProfile;
  final String email;
  final String phone;
  final String password;
  final String verificationCode;
  final File? profilePicture;

  const SignupCompleteScreen({
    super.key,
    required this.userProfile,
    required this.email,
    required this.phone,
    required this.password,
    required this.verificationCode,
    this.profilePicture,
  });

  @override
  Widget build(BuildContext context) {
    // Create a user model with the collected data
    final user = UserModel(
      firstName: userProfile.firstName,
      lastName: userProfile.lastName,
      birthday: userProfile.birthday,
      gender: userProfile.gender,
      username: userProfile.username,
      email: email,
      phone: phone,
      profilePictureUrl: profilePicture?.path,
      address: userProfile.address,
      location: userProfile.location,
    );

    // In a real app, you would send this 'user' data to your backend
    // and create the user account. For now, it's just a local object.
    print('User data collected: ${user.toJson()}');

    return Scaffold(
      body: AnimatedWaveBackground(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                const Text(
                  "Your account is ready!",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(flex: 1),
                // Set Up Your Church button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: CustomElevatedButton(
                    text: 'Set Up Your Church',
                    onPressed: () {
                      // Navigate to church setup flow
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChurchWelcomeScreen(firstName: userProfile.firstName),
                        ),
                      );
                    },
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF002642),
                  ),
                ),
                const SizedBox(height: 16),
                // Go to App Highlights button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: CustomElevatedButton(
                    text: 'Continue to App',
                    onPressed: () {
                      // Navigate to app highlights flow and remove all previous routes
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AppHighlightsSplashScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF002642),
                  ),
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
