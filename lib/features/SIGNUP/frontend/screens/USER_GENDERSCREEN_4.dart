// lib/features/SIGNUP/frontend/screens/USER_GENDERSCREEN_4.dart
// This file is assumed to be correct and does not need modifications.
// Placeholder content for brevity, replace with actual content if available.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teleo_app/features/SIGNUP/backend/viewmodels/USER_SIGNUPVIEWMODELS.dart';
import 'package:teleo_app/features/3/c1widgets/back_button.dart';

class UserGenderScreen4 extends StatelessWidget {
  static const routeName = '/user-gender';

  const UserGenderScreen4({super.key});

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
                "What's your gender?",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                "This helps us provide a more tailored experience.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Male'),
                    value: 'Male',
                    groupValue: viewModel.signupData.gender,
                    onChanged: (value) => viewModel.setGender(value!),
                  ),
                  RadioListTile<String>(
                    title: const Text('Female'),
                    value: 'Female',
                    groupValue: viewModel.signupData.gender,
                    onChanged: (value) => viewModel.setGender(value!),
                  ),
                  RadioListTile<String>(
                    title: const Text('Prefer not to say'),
                    value: 'Prefer not to say',
                    groupValue: viewModel.signupData.gender,
                    onChanged: (value) => viewModel.setGender(value!),
                  ),
                ],
              ),
              if (viewModel.genderError != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                  child: Text(
                    viewModel.genderError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: viewModel.isGenderValid
                      ? () => viewModel.navigateToUsernameScreen(context)
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
