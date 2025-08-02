// lib/features/SIGNUP/frontend/screens/USER_WELCOMESCREEN_2.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../3/c1widgets/back_button.dart'; // Assuming this path for TeleoBackButton
import '../../backend/viewmodels/USER_SIGNUPVIEWMODELS.dart'; // Import the ViewModel

class UserWelcomeScreen2 extends StatelessWidget {
  const UserWelcomeScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Consumer<UserSignupViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back button row
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: TeleoBackButton(
                        onPressed: () => Navigator.pop(context), // Go back to previous screen
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Hello!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "What's your name?",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // First Name field
                  TextField(
                    controller: TextEditingController(text: viewModel.firstName), // Use ViewModel's data
                    decoration: InputDecoration(
                      hintText: 'First Name',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF002642)),
                      ),
                    ),
                    onChanged: viewModel.setFirstName, // Update ViewModel
                  ),
                  const SizedBox(height: 16),
                  // Last Name field
                  TextField(
                    controller: TextEditingController(text: viewModel.lastName), // Use ViewModel's data
                    decoration: InputDecoration(
                      hintText: 'Last Name',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF002642)),
                      ),
                    ),
                    onChanged: viewModel.setLastName, // Update ViewModel
                  ),
                  const Spacer(),
                  // Next button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: viewModel.isNameFormValid
                            ? () => viewModel.navigateToBirthdayScreen(context) // Delegate navigation to ViewModel
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF002642),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                          shadowColor: Colors.black.withOpacity(0.3),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
