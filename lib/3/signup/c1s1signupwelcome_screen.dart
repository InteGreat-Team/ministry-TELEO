import 'package:flutter/material.dart';

class SignupWelcomeScreen extends StatelessWidget {
  const SignupWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Signup',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Start your journey with us'),
          ],
        ),
      ),
    );
  }
}
