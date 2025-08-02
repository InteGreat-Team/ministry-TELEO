// lib/features/SIGNUP/frontend/screens/USER_GENDERSCREEN_4.dart
//IMPORT PACKAGES
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//IMPORT MVVM UPDATED
import '../../backend/viewmodels/USER_SIGNUPVIEWMODELS.dart'; // Import the ViewModel

//IMPORT NOT UPDATED MVVM 
import '../../../../3/c1widgets/back_button.dart'; // Assuming this path for TeleoBackButton

class UserGenderScreen4 extends StatelessWidget {
  const UserGenderScreen4({super.key});

  // Helper method to build gender option buttons
  Widget _buildGenderOption(BuildContext context, UserSignupViewModel viewModel, String value, String label, IconData icon) {
    final isSelected = viewModel.gender == value;

    return GestureDetector(
      onTap: () {
        viewModel.setGender(value); // Update ViewModel
      },
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF002642) : Colors.grey.shade600,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF002642) : Colors.grey.shade600,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
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
                    "How do you identify as?",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "We want to be respectful!",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),
                  // Gender selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildGenderOption(context, viewModel, 'Male', 'Male', Icons.male),
                      _buildGenderOption(context, viewModel, 'Female', 'Female', Icons.female),
                      _buildGenderOption(context, viewModel, 'Non_binary', 'Non-binary', Icons.person),
                    ],
                  ),
                  const Spacer(),
                  // Next button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: viewModel.isGenderSelected // Enable if gender is selected
                            ? () => viewModel.navigateToUsernameScreen(context) // Delegate navigation to ViewModel
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
