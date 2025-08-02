//IMPORT PACKAGES
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// NOT MVVM IMPORT (cleaned up)
import '../../../../3/c1widgets/dynamic_wave_background.dart';
import '../../backend/viewmodels/CHURCH_SIGNUPVIEWMODELS.dart';



class ChurchWelcomeScreen extends StatelessWidget {
  const ChurchWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicWaveBackground(
      child: Consumer<ChurchSignupViewModel>(
        builder: (context, viewModel, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                const Text(
                  "Let's Set Up Your Church!",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(flex: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: () => viewModel.handleGetStarted(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF002642),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.3),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const Spacer(flex: 3),
                // Check approval status link
                GestureDetector(
                  onTap: () => viewModel.handleCheckApprovalStatus(context),
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Column(
                      children: [
                        Text(
                          "Signed up already?",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        Text(
                          "Check Approval Status",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
