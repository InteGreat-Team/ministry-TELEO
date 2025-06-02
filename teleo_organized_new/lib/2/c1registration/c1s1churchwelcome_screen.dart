import 'package:flutter/material.dart';
import '../../3/c1widgets/dynamic_wave_background.dart';
import 'c1s2church_location_screen.dart';
import '../c1approvalstatus/approval_status_check_screen.dart';
import '../../2/church_model.dart';

class ChurchWelcomeScreen extends StatelessWidget {
  final String firstName;

  const ChurchWelcomeScreen({super.key, required this.firstName});

  @override
  Widget build(BuildContext context) {
    return DynamicWaveBackground(
      child: Center(
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
                onPressed: () {
                  // Navigate to ChurchLocationScreen instead of ChurchNameScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ChurchLocationScreen(
                            church: ChurchModel(
                              name: "",
                              establishedDate: DateTime.now(),
                              email: "",
                              referenceCode: "",
                            ),
                          ),
                    ),
                  );
                },
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ApprovalStatusCheckScreen(),
                  ),
                );
              },
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
      ),
    );
  }
}
