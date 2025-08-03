// lib/features/SIGNUP/frontend/screens/USER_BIRTHDAYSCREEN_3.dart
// This file is assumed to be correct and does not need modifications.
// Placeholder content for brevity, replace with actual content if available.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teleo_app/features/SIGNUP/backend/viewmodels/USER_SIGNUPVIEWMODELS.dart';
import 'package:teleo_app/features/3/c1widgets/back_button.dart';

class UserBirthdayScreen3 extends StatelessWidget {
  static const routeName = '/user-birthday';

  const UserBirthdayScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserSignupViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: TeleoBackButton(),
              ),
              const SizedBox(height: 40),
              const Text(
                "When's your birthday?",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                "We use this to personalize your experience and ensure you meet age requirements.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () => viewModel.selectBirthday(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(
                      text: viewModel.signupData.birthday != null
                          ? '${viewModel.signupData.birthday!.month}/${viewModel.signupData.birthday!.day}/${viewModel.signupData.birthday!.year}'
                          : '',
                    ),
                    decoration: InputDecoration(
                      labelText: 'Birthday',
                      hintText: 'MM/DD/YYYY',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      suffixIcon: const Icon(Icons.calendar_today),
                      errorText: viewModel.birthdayError,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: viewModel.isBirthdayValid
                      ? () => viewModel.navigateToGenderScreen(context)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
