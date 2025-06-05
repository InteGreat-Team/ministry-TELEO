import 'package:flutter/material.dart';
import '../../c2events/models/registered_event.dart';
import '../models/registered_service.dart';

class SuccessScreen extends StatelessWidget {
  final Map<String, String?> allDetails; // Changed to nullable String values

  const SuccessScreen({super.key, required this.allDetails});

  @override
  Widget build(BuildContext context) {
    // Create service details with null safety
    final serviceDetails = ServiceDetails(
      serviceType: 'Wedding',
      location: allDetails['location'] ?? 'Not specified',
      scheduledDate: DateTime(2025, 4, 18),
      scheduledTime: const TimeOfDay(hour: 9, minute: 30),
      churchName: allDetails['church'] ?? 'Not specified',
      contactPerson: allDetails['name'] ?? 'Contact Person',
      contactNumber: allDetails['contact'] ?? '09283829329',
      email: allDetails['email'] ?? 'email@example.com',
      bookingDate: DateTime.now(),
      // Wedding-specific fields - all nullable now
      brideName: allDetails['brideName'] ?? 'Bride',
      groomName: allDetails['groomName'] ?? 'Groom',
      ceremonyType: allDetails['ceremonyType'] ?? 'Traditional',
      reasonForService: allDetails['reasonForService'],
      additionalInfo: allDetails['additionalInfo'],
    );

    // Add service to the registered services
    RegisteredServiceManager.addService(serviceDetails);

    // Register the service as an event in the appointments section
    RegisteredServiceManager.registerServiceAsEvent(serviceDetails);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A4A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A4A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Back',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
        ),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Checkmark icon in circle
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.check, color: Color(0xFF0A0A4A), size: 40),
                ),
              ),
              const SizedBox(height: 20),

              // Request Submitted text
              const Text(
                'Request Submitted!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // Success message
              Text(
                'Your wedding service request for ${serviceDetails.brideName} and ${serviceDetails.groomName} has been submitted successfully.',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // White card with details
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Wedding Service Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A0A4A),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Details in gray boxes
                    _buildDetailItem(
                      icon: Icons.people,
                      label: 'Couple',
                      value:
                          '${serviceDetails.brideName} & ${serviceDetails.groomName}',
                    ),
                    _buildDetailItem(
                      icon: Icons.calendar_today,
                      label: 'Date',
                      value: allDetails['date'] ?? 'Not specified',
                    ),
                    _buildDetailItem(
                      icon: Icons.access_time,
                      label: 'Time',
                      value: allDetails['time'] ?? 'Not specified',
                    ),
                    _buildDetailItem(
                      icon: Icons.location_on,
                      label: 'Location',
                      value: allDetails['location'] ?? 'Not specified',
                    ),
                    _buildDetailItem(
                      icon: Icons.church,
                      label: 'Church',
                      value: allDetails['church'] ?? 'Not specified',
                    ),
                    _buildDetailItem(
                      icon: Icons.celebration,
                      label: 'Ceremony',
                      value: serviceDetails.ceremonyType ?? 'Traditional',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Next Steps section
              const Text(
                'Next Steps',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),

              // Step 1
              _buildStepItem(
                number: 1,
                text:
                    'Our team will review your request and contact you within 2 business days.',
              ),

              // Step 2 (yellow warning bar)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Text(
                    'EDITING YOUR DETAILS IS NOT AVAILABLE AT THE MOMENT',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Step 3
              _buildStepItem(
                number: 3,
                text:
                    'Once approved, you will receive a confirmation email with further instructions.',
              ),

              const SizedBox(height: 32),

              // Action buttons
              ElevatedButton(
                onPressed: () {
                  // Navigate back to the main screen (root)
                  Navigator.of(context).popUntil((route) => route.isFirst);

                  // Navigate to the main app's home page
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0A0A4A),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Return to Home',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for detail items
  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(icon, color: const Color(0xFF0A0A4A), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for step items
  Widget _buildStepItem({required int number, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  color: Color(0xFF0A0A4A),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to find the bottom navigation controller in the main app
  PageController? _findBottomNavController(BuildContext context) {
    try {
      // Try to find the main app's state that contains the bottom navigation controller
      final mainAppState = context.findAncestorStateOfType<State>();
      if (mainAppState != null) {
        // Use reflection to access the controller field
        final controller =
            mainAppState.widget.runtimeType.toString() == 'MainApp'
                ? (mainAppState as dynamic)._bottomNavController
                    as PageController?
                : null;
        return controller;
      }
    } catch (e) {
      // If any error occurs, return null
      print('Error finding bottom navigation controller: $e');
    }
    return null;
  }
}
