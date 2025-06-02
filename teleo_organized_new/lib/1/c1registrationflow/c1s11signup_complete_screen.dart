import 'dart:io';
import 'package:flutter/material.dart';
import '../../../2/c1registration/c1s1churchwelcome_screen.dart';
import '../../../1/user_model.dart';
import '../../../3/c1widgets/animated_wave_background.dart';
import '../../../3/app_highlights/splash_screen.dart';

class SignupCompleteScreen extends StatelessWidget {
  final String firstName;
  final String lastName;
  final DateTime birthday;
  final String gender;
  final String username;
  final String email;
  final String phone;
  final String password;
  final String location;
  final File? profilePicture;

  const SignupCompleteScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.location,
    this.profilePicture,
  });

  @override
  Widget build(BuildContext context) {
    // Create a user model with the collected data
    final user = UserModel(
      firstName: firstName,
      lastName: lastName,
      birthday: birthday,
      gender: gender,
      username: username,
      email: email,
      phone: phone,
      profilePictureUrl: profilePicture?.path,
    );

    // In a real app, you would send this data to your backend
    // and create the user account

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
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to church setup flow
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  ChurchWelcomeScreen(firstName: firstName),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF002642),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.3),
                    ),
                    child: const Text(
                      'Set Up Your Church',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Go to App Highlights button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to app highlights flow
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const AppHighlightsSplashScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF002642),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.3),
                    ),
                    child: const Text(
                      'Continue to App',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
