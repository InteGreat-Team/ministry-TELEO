// lib/features/SIGNUP/frontend/screens/USER_PASSWORDSCREEN_9.dart
// This file is assumed to be correct and does not need modifications.
// Placeholder content for brevity, replace with actual content if available.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teleo_app/features/SIGNUP/backend/viewmodels/USER_SIGNUPVIEWMODELS.dart';
import 'package:teleo_app/features/3/c1widgets/back_button.dart';

class UserPasswordScreen9 extends StatelessWidget {
  static const routeName = '/user-password';

  const UserPasswordScreen9({super.key});

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
                "Create your password",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                "Make it strong and memorable.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: viewModel.passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Minimum 6 characters',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  errorText: viewModel.passwordError,
                ),
                onChanged: viewModel.validatePassword,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: viewModel.confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  errorText: viewModel.confirmPasswordError,
                ),
                onChanged: viewModel.validateConfirmPassword,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: viewModel.isPasswordFormValid
                      ? () => viewModel.handlePasswordNext(context)
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
