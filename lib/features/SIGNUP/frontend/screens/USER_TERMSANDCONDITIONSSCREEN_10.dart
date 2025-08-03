// lib/features/SIGNUP/frontend/screens/USER_TERMSANDCONDITIONSSCREEN_10.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teleo_app/features/SIGNUP/backend/viewmodels/USER_SIGNUPVIEWMODELS.dart';
import 'package:teleo_app/features/3/c1widgets/back_button.dart';

class UserTermsAndConditionsScreen10 extends StatelessWidget {
  static const routeName = '/user-terms-conditions';

  const UserTermsAndConditionsScreen10({super.key});

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
                "Terms and Conditions",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "1. Acceptance of Terms",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "By accessing and using this application, you agree to be bound by these Terms and Conditions. If you do not agree to all the terms and conditions of this agreement, then you may not access the application or use any services.",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "2. User Responsibilities",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "You are responsible for maintaining the confidentiality of your account and password and for restricting access to your computer, and you agree to accept responsibility for all activities that occur under your account or password.",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "3. Privacy Policy",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Our Privacy Policy, which is incorporated herein by reference, describes how we collect, use, and disclose your personal information.",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "4. Intellectual Property",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "All content included on this application, such as text, graphics, logos, images, as well as the compilation thereof, and any software used on the application, is the property of Teleo or its suppliers and protected by copyright and other laws that protect intellectual property and proprietary rights.",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "5. Limitation of Liability",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "In no event shall Teleo, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from (i) your access to or use of or inability to access or use the application; (ii) any conduct or content of any third party on the application; (iii) any content obtained from the application; and (iv) unauthorized access, use or alteration of your transmissions or content, whether based on warranty, contract, tort (including negligence) or any other legal theory, whether or not we have been informed of the possibility of such damage, and even if a remedy set forth herein is found to have failed of its essential purpose.",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: viewModel.areTermsAccepted,
                    onChanged: viewModel.toggleTermsAccepted,
                    activeColor: Colors.blue,
                  ),
                  const Expanded(
                    child: Text(
                      'I have read and agree to the Terms and Conditions',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              if (viewModel.termsError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    viewModel.termsError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: viewModel.areTermsAccepted
                      ? () => viewModel.handleTermsConditionsNext(context)
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
