import 'package:flutter/material.dart';
import '../widgets/step_indicator.dart';
import 'c2s7bsprayerrequest.dart';

class EventManagementScreen extends StatelessWidget {
  final Map<String, String> allDetails;
  
  const EventManagementScreen({
    super.key,
    required this.allDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Prayer Request',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: TextButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 14,
          ),
          label: const Text(
            'Back',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
        leadingWidth: 80,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0A0A4A),
        ),
        child: Column(
          children: [
            const SizedBox(height: 90),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Step indicator moved inside the white container
                      const Align(
                        alignment: Alignment.center,
                        child: StepIndicator(currentStep: 4, totalSteps: 5),
                      ),
                      const SizedBox(height: 24),
                      
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Is this a ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'self-managed event?',
                              style: TextStyle(
                                color: Color(0xFF0A0A4A),
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Skip if you do not need to add an event.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Placeholder for event management content
                      Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Text(
                            '',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Navigation buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF0A0A4A)),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Back',
                                style: TextStyle(
                                  color: Color(0xFF0A0A4A),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SummaryScreen(
                                      allDetails: allDetails,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0A0A4A),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Skip',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
