import 'package:flutter/material.dart';
import '../userhomepage/home_page.dart';

class PasswordResultScreen extends StatelessWidget {
  final bool success;
  
  const PasswordResultScreen({
    super.key,
    required this.success,
  });

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
              // Success or error icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: success ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  success ? Icons.check : Icons.close,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              
              // Status text
              Text(
                success ? 'Successful' : 'Unsuccessful',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              
              // Message
              Text(
                success 
                    ? 'Congratulations! Your password has been changed. Click confirm to login'
                    : 'Your password was not changed. Click confirm to try again.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              
              // Confirm button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (success) {
                      // Navigate directly to home page
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                        (route) => false, // Remove all previous routes
                      );
                    } else {
                      // Go back to new password screen
                      Navigator.pop(context);
                    }
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
                    'Confirm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
