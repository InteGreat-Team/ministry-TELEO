//SHARED_WELCOMESCREEN.dart 
//IMPORT PACKAGE
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; 
import 'package:provider/provider.dart';

//MVVM STRUCTURED
import '../../../SIGNUP/frontend/screens/USER_WELCOMESCREEN_1.dart' as signup; 
import '/features/SIGNUP/frontend/screens/CHURCH_WELCOMESCREEN_1.dart';
import 'SHARED_LOGINSCREEN.dart'; 
import '../../../../features/SIGNUP/backend/viewmodels/CHURCH_SIGNUPVIEWMODELS.dart';
import '../../../../features/SIGNUP/backend/viewmodels/USER_SIGNUPVIEWMODELS.dart' as signup;

//NOT MVVM STRUCTURED 
import '../../../../1/c1homepage/home_page.dart';
import '../../../../2/c1homepage/home_page.dart' as admin;

class LogoHeader extends StatelessWidget {
  final double logoHeight;
  const LogoHeader({super.key, required this.logoHeight});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/teleo_logo.png', height: logoHeight);
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _showGuestOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Choose Guest Access',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF002642),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Select how you\'d like to explore Teleo. The following app is currently in testing mode and some features may not work as expected.',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                _buildGuestOption(
                  context,
                  title: 'Browse as Member (Testing)',
                  subtitle: 'Explore church services and community features',
                  icon: Icons.person_outline,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildGuestOption(
                  context,
                  title: 'Preview Admin Panel (Testing)',
                  subtitle: 'View church management features',
                  icon: Icons.admin_panel_settings_outlined,
                  onTap: () {
                    Navigator.pop(context);
                    _showAdminGuestConfirmation(context);
                  },
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAdminGuestConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Admin Preview Mode',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF002642),
            ),
          ),
          content: const Text(
            'You\'ll have limited access to admin features. Some functions require authentication and won\'t be available in preview mode.',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const admin.AdminHomePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF002642),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGuestOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF002642).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF002642), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF002642),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

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
              LogoHeader(logoHeight: 120), // Using the moved LogoHeader
              const SizedBox(height: 24),
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
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (_) => signup.UserSignupViewModel(), // Provide the ViewModel here
                          child: const signup.WelcomeScreen(),
                        ),
                      ),
                    );
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
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(height: 1, color: Colors.grey.shade300),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'or',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(height: 1, color: Colors.grey.shade300),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    _showGuestOptions(context);
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
                    'Continue as Guest',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Registered Church? ',
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ChangeNotifierProvider(
                                create: (_) => ChurchSignupViewModel(), // Provide the ViewModel here
                                child: const ChurchWelcomeScreen(),
                              ),
                        ),
                      );
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
