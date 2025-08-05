import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../2/c1registration/c1s1churchwelcome_screen.dart';
import 'user_registration_api_service.dart';
import '../user_model.dart';
import '../../../3/c1widgets/animated_wave_background.dart';
import '../../../3/app_highlights/splash_screen.dart';

class SignupCompleteScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final DateTime birthday;
  final String gender;
  final String username;
  final String email;
  final String password;
  final String? profilePictureUrl;
  final String? phoneNumber;
  final String address;
  final double lat;
  final double lng;
  final bool hasAcceptedTerms;
  final bool isEmailVerified;

  const SignupCompleteScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.username,
    required this.email,
    required this.password,
    this.profilePictureUrl,
    required this.address,
    required this.lat,
    required this.lng,
    required this.phoneNumber,
    required this.hasAcceptedTerms,
    required this.isEmailVerified,
  });

  @override
  State<SignupCompleteScreen> createState() => _SignupCompleteScreenState();
}

class _SignupCompleteScreenState extends State<SignupCompleteScreen> {
  bool _isRegistering = false;

  Future<void> _registerUserAndNavigate() async {
    setState(() => _isRegistering = true);

    final user = UserModel(
  firstName: widget.firstName,
  lastName: widget.lastName,
  birthday: widget.birthday,
  gender: widget.gender,
  username: widget.username,
  email: widget.email,
  phoneNumber: widget.phoneNumber,
  address: widget.address,
  lat: widget.lat,
  lng: widget.lng,
  profilePictureUrl: widget.profilePictureUrl,
  hasAcceptedTerms: widget.hasAcceptedTerms,
  isEmailVerified: widget.isEmailVerified,
  password: widget.password,
  userRole: 'user', // <-- Explicitly set here
);


    try {
      final http.Response response = await UserRegistrationApiService.registerUser(user.toJson());

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("User registered: ${data['user']}");
        print("JWT: ${data['token']}");

        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const AppHighlightsSplashScreen()),
          (route) => false,
        );
      } else {
        final error = jsonDecode(response.body);
        _showErrorSnack(error['errors']?[0]?['msg'] ?? 'Registration failed');
      }
    } catch (e) {
      _showErrorSnack("Something went wrong. Please try again.");
    } finally {
      if (mounted) setState(() => _isRegistering = false);
    }
  }

  void _showErrorSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: _isRegistering ? null : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChurchWelcomeScreen(firstName: widget.firstName),
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
                    ),
                    child: const Text(
                      'Set Up Your Church',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: _isRegistering ? null : _registerUserAndNavigate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF002642),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isRegistering
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Continue to App',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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