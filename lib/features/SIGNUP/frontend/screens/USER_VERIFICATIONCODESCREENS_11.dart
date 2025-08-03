// lib/features/SIGNUP/frontend/screens/USER_VERIFICATIONCODESCREEN_11.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teleo_app/features/SIGNUP/backend/viewmodels/USER_SIGNUPVIEWMODELS.dart';
import 'package:teleo_app/features/3/c1widgets/back_button.dart';

class UserVerificationCodescreen11 extends StatelessWidget {
  static const routeName = '/user-verification-code';

  const UserVerificationCodescreen11({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserSignupViewModel>(context);

    // Create focus nodes for each digit field
    final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

    // Dispose focus nodes when the widget is removed from the tree
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) {
        for (var node in focusNodes) {
          node.dispose();
        }
      }
    });

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
                'Enter Verification Code',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'A 6-digit code has been sent to ${viewModel.signupData.email ?? 'your email'}. Please enter it below.',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 48, // Slightly wider for better spacing
                    child: TextField(
                      controller: viewModel.verificationCodeController,
                      focusNode: focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1, // Only one character per field
                      decoration: InputDecoration(
                        counterText: '', // Hide character counter
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          if (index < 5) {
                            focusNodes[index + 1].requestFocus();
                          }
                        } else if (value.isEmpty) {
                          if (index > 0) {
                            focusNodes[index - 1].requestFocus();
                          }
                        }
                        // Manually update the controller's text for the specific digit
                        String currentText = viewModel.verificationCodeController.text;
                        if (currentText.length > index) {
                          currentText = currentText.replaceRange(index, index + 1, value);
                        } else {
                          currentText = currentText + value;
                        }
                        viewModel.verificationCodeController.text = currentText;
                        viewModel.validateVerificationCode(viewModel.verificationCodeController.text);
                      },
                    ),
                  );
                }),
              ),
              if (viewModel.verificationCodeError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Center(
                    child: Text(
                      viewModel.verificationCodeError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: viewModel.isResendingCode || viewModel.isSendingCode
                      ? null
                      : () => viewModel.resendVerificationCode(context),
                  child: Text(
                    viewModel.isResendingCode
                        ? 'Resend in ${viewModel.formatCooldownTime}'
                        : 'Resend Code',
                    style: TextStyle(
                      color: viewModel.isResendingCode || viewModel.isSendingCode
                          ? Colors.grey
                          : Colors.blue,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: viewModel.isVerificationCodeValid && !viewModel.isVerifyingCode
                      ? () => viewModel.verifyCodeAndProceed(context)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: viewModel.isVerifyingCode
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Verify',
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
