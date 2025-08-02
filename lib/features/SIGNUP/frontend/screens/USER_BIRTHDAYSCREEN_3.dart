// lib/features/SIGNUP/frontend/screens/USER_BIRTHDAYSCREEN_3.dart

//IMPORT PACKAGES
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

//IMPORT MVVM UPDATED
import '../../backend/viewmodels/USER_SIGNUPVIEWMODELS.dart'; 

//IMPORT NOT MVVM UPDATED
import '../../../../3/c1widgets/back_button.dart'; 

class UserBirthdayScreen3 extends StatelessWidget {
  const UserBirthdayScreen3({super.key});

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
                  Text(
                    "When's your birthday, ${viewModel.firstName}?", // Use ViewModel's firstName
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "We'd love to know!",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // Date picker
                  SizedBox(
                    height: 200,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: viewModel.birthday ?? DateTime(2000, 1, 1), // Use ViewModel's birthday or default
                      minimumYear: 1900,
                      maximumYear: DateTime.now().year,
                      onDateTimeChanged: (DateTime newDate) {
                        viewModel.setBirthday(newDate); // Update ViewModel
                      },
                    ),
                  ),
                  const Spacer(),
                  // Next button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: viewModel.birthday != null // Enable if birthday is selected
                            ? () => viewModel.navigateToGenderScreen(context) // Delegate navigation to ViewModel
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
