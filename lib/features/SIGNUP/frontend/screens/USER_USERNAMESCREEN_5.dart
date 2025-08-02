// lib/features/SIGNUP/frontend/screens/USER_USERNAMESCREEN_5.dart
//IMPORT PACKAGE 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//IMPORT MVVM UPDATED 
import '../../backend/viewmodels/USER_SIGNUPVIEWMODELS.dart'; // Import the ViewModel

//IMPORT NOT MVVM UPDATED 
import '../../../../3/c1widgets/back_button.dart'; // Assuming this path for TeleoBackButton
import '../../../../1/c1registrationflow/c1s5_1location_question_screen.dart';

class UserUsernameScreen5 extends StatelessWidget {
  const UserUsernameScreen5({super.key});

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
                    "How should we call you?",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Give yourself a cool nickname",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // Username field
                  TextField(
                    controller: viewModel.usernameController, // Use ViewModel's controller
                    decoration: InputDecoration(
                      hintText: 'Username',
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
                    onChanged: viewModel.setUsername, // Explicitly call ViewModel setter
                  ),
                  const Spacer(),
                  // Next button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: viewModel.isUsernameInputValid // Enable if username is entered
                            ? () => viewModel.navigateToLocationQuestionScreen(context) // Delegate navigation to ViewModel
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
