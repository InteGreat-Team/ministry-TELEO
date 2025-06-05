import 'package:flutter/material.dart';
import '../models/registered_service.dart';


class SuccessScreen extends StatelessWidget {
  final Map<String, String> allDetails;

  const SuccessScreen({
    super.key,
    required this.allDetails,
  });

  @override
  Widget build(BuildContext context) {
    // Create service details
    final serviceDetails = ServiceDetails(
      serviceType: 'Funeral Service', // Set to 'Funeral Service'
      location: allDetails['location'] ?? 'Serenity Funeral Home, Sample Street 12, Brgy. 222, City, 1011',
      scheduledDate: DateTime(2025, 4, 18),
      scheduledTime: const TimeOfDay(hour: 9, minute: 30),
      churchName: 'Serenity Funeral Home',
      contactPerson: allDetails['name'] ?? 'Contact Name',
      contactNumber: allDetails['contact'] ?? '09283829329',
      email: allDetails['email'] ?? 'email@example.com',
      bookingDate: DateTime.now(),
      // Funeral-specific fields stored in customFields
      additionalInfo: allDetails['additionalInfo'], brideName: '', groomName: '', ceremonyType: '',
    );
    
    // Add service to the registered services
    RegisteredServiceManager.addService(serviceDetails);
    
    // Register the service as an event in the appointments section
    // This will create an event and register it with the RegisteredEventManager
    RegisteredServiceManager.registerServiceAsEvent(serviceDetails);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A4A),
        elevation: 0,
        title: const Text(
          'Success',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        leadingWidth: 70,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Booking Confirmed',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Your funeral service booking was successful.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              
              // Service provider card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/funeral_home.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: const Icon(Icons.home_work, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Serenity Funeral Home',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'P. Sherman, 42 Wallaby Way, Sydney, Manila, 1011',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.phone, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '09283829329',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Service details
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/funeral_service.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.church, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          allDetails['serviceTypes'] ?? 'Funeral Service',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              'Schedule: ${allDetails['scheduledDate'] ?? 'April 18, 2025'} - ${allDetails['scheduledTime'] ?? '9:30 AM'}',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.person, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'For: ${allDetails['deceasedName'] ?? 'John Doe'}',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Action buttons
              ElevatedButton(
                onPressed: () {
                  // Navigate to the appointments section
                  _navigateToMainAndSelectTab(context, 3); // 3 is the index for appointments tab
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0A0A4A),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Color(0xFF0A0A4A)),
                  ),
                ),
                child: const Text(
                  'View All Bookings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the services section
                  _navigateToMainAndSelectTab(context, 0); // 0 is the index for services tab
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A0A4A),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Book Another Service?',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Navigate to the main app and select a specific tab
  void _navigateToMainAndSelectTab(BuildContext context, int tabIndex) {
    // Navigate back to the main screen (root)
    Navigator.of(context).popUntil((route) => route.isFirst);
    
    // Navigate to the main app's home page
    Navigator.of(context).pushReplacementNamed('/home');
    
    // Delay slightly to ensure the home page is loaded
    Future.delayed(const Duration(milliseconds: 100), () {
      // Find the bottom navigation bar controller and select the specified tab
      final pageController = _findPageController(context);
      if (pageController != null) {
        pageController.jumpToPage(tabIndex);
      }
    });
  }

  // Helper method to find the PageController in the widget tree
  PageController? _findPageController(BuildContext context) {
    try {
      // Try to find the main app's state that contains the PageController
      final mainAppState = context.findAncestorStateOfType<State>();
      if (mainAppState != null) {
        // Use reflection to access the controller field
        final controller = mainAppState.widget.runtimeType.toString() == 'MainApp'
            ? (mainAppState as dynamic)._pageController as PageController?
            : null;
        return controller;
      }
    } catch (e) {
      print('Error finding PageController: $e');
    }
    return null;
  }
}
