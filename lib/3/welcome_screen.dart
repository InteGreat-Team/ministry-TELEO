import 'package:flutter/material.dart';
import '../1/c1registrationflow/c1s1signupwelcome_screen.dart' as signup;
import 'login_screen.dart';
import '../2/c1registration/c1s1churchwelcome_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const _primaryColor = Color(0xFF002642);
  static const _buttonHeight = 56.0;
  static const _borderRadius = 30.0;

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
              Image.asset('assets/images/teleo_logo.png', height: 120),
              const SizedBox(height: 24),
              const Text(
                'Welcome to Teleo!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _primaryColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              _buildButton(
                'Create a new account',
                () => _navigate(context, const signup.WelcomeScreen()),
                isPrimary: true,
              ),
              const SizedBox(height: 16),
              _buildButton(
                'Log in',
                () => _navigate(context, const LoginScreen()),
                isPrimary: false,
              ),
              const SizedBox(height: 32),
              _buildDivider(),
              const SizedBox(height: 24),
              _buildChurchSignup(context),
              const Spacer(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed, {required bool isPrimary}) {
    return SizedBox(
      width: double.infinity,
      height: _buttonHeight,
      child: isPrimary
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
                elevation: 0,
              ),
              child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: _primaryColor,
                side: const BorderSide(color: _primaryColor, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
              ),
              child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: Colors.grey[300])),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('or', style: TextStyle(color: Colors.grey, fontSize: 14)),
        ),
        Expanded(child: Container(height: 1, color: Colors.grey[300])),
      ],
    );
  }

  Widget _buildChurchSignup(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Registered Church? ', style: TextStyle(color: Colors.black87, fontSize: 14)),
        GestureDetector(
          onTap: () => _navigate(context, const ChurchWelcomeScreen(firstName: 'Church Admin')),
          child: const Text(
            'Sign Up',
            style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  void _navigate(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}
