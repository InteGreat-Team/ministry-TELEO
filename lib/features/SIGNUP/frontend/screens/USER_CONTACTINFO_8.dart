// lib/features/SIGNUP/frontend/screens/USER_CONTACTINFOSCREEN_8.dart
// This file is assumed to be correct and does not need modifications.
// Placeholder content for brevity, replace with actual content if available.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teleo_app/features/SIGNUP/backend/viewmodels/USER_SIGNUPVIEWMODELS.dart';
import 'package:teleo_app/features/3/c1widgets/back_button.dart';

class UserContactInfoScreen8 extends StatelessWidget {
  static const routeName = '/user-contact-info';

  const UserContactInfoScreen8({super.key});

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
                "How can we reach you?",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                "We'll use this to send important updates and verification codes.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: viewModel.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'your.email@example.com',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  errorText: viewModel.emailError,
                ),
                onChanged: viewModel.validateEmail,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: viewModel.phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number (Optional)',
                  hintText: '+63XXXXXXXXXX',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  errorText: viewModel.phoneError,
                ),
                onChanged: viewModel.validatePhoneNumber,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: viewModel.isContactInfoValid && !viewModel.isSendingCode
                      ? () => viewModel.handleContactInfoNext(context)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: viewModel.isSendingCode
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
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
