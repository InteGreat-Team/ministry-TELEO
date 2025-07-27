import 'package:flutter/material.dart';
import '../../backend/models/CHURCH_SIGNUP_VAR.dart'; // For ChurchModel
import '../../backend/viewmodels/CHURCH_SIGNUP_FUNC.dart'; // For ChurchSignupViewModel
import '../widgets/index.dart'; // For CustomElevatedButton, ReferenceCodeWidget
import 'CHURCH_SIGNUP_12.dart'; // For QuoteScreen

class ApplicationSubmittedScreen extends StatelessWidget {
  final ChurchModel church;
  final ChurchSignupViewModel viewModel;

  const ApplicationSubmittedScreen({
    super.key,
    required this.church,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              
              // Success Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.green.shade200,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  size: 60,
                  color: Colors.green.shade600,
                ),
              ),
              const SizedBox(height: 32),
              
              // Title
              const Text(
                "Your application has been sent!",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Subtitle
              const Text(
                "Please stand by as we check the validity of your church and your documents.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Reference Code Display
              if (church.referenceCode != null)
                ReferenceCodeWidget(
                  referenceCode: church.referenceCode!,
                ),
              
              const Spacer(flex: 2),
              
              // Action Buttons
              Column(
                children: [
                  // Check Status Button
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/approval-status',
                      );
                    },
                    text: 'Check Approval Status',
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF002642),
                    height: 56,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 16),
                  
                  // Done Button
                  CustomElevatedButton(
                    onPressed: () {
                      viewModel.resetForm();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuoteScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    text: 'Done',
                    backgroundColor: const Color(0xFF002642),
                    foregroundColor: Colors.white,
                    height: 56,
                    width: double.infinity,
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
