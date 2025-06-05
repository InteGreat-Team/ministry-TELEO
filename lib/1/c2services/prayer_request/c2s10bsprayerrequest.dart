import 'package:flutter/material.dart';
import '../models/registered_service.dart';
import '../../c2events/models/event.dart';
import '../../c2events/models/registered_event.dart';
// Import the appointments section

class SuccessScreen extends StatelessWidget {
  final Map<String, String> allDetails;

  const SuccessScreen({super.key, required this.allDetails});

  @override
  Widget build(BuildContext context) {
    // Register the prayer request service in the appointments tab
    _registerPrayerRequestService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A4A),
        elevation: 0,
        title: const Text(
          'Success',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: TextButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 14),
          label: const Text(
            'Back',
            style: TextStyle(color: Colors.white, fontSize: 12),
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
                'Congrats!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Your prayer request was a success.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Prayer center/Spiritual guide card
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
                        'assets/priest_image.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: const Icon(Icons.person, color: Colors.grey),
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
                            'Fr. John Smith',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'St. Mary\'s Parish, 42 Church Street, Manila, 1011',
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
                              const Icon(
                                Icons.phone,
                                size: 14,
                                color: Colors.grey,
                              ),
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

              // Prayer request details
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/prayer_image.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.person_pin,
                            color: Colors.grey,
                          ),
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
                          'Prayer Request',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Schedule: April 18, 2025 - 9:30 AM',
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
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'St. Mary\'s Parish, 42 Church Street, Manila, 1011',
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
                  // Navigate back to main screen and select Appointments tab (index 3)
                  _navigateToMainAndSelectTab(context, 3);
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
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  // Navigate back to main screen and select Services tab (index 0)
                  _navigateToMainAndSelectTab(context, 0);
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

  // Register the prayer request service in the appointments tab
  void _registerPrayerRequestService() {
    // Create event for the prayer request service
    final event = Event(
      title: 'Prayer Request',
      location:
          allDetails['location'] ??
          'St. Mary\'s Parish, 42 Church Street, Manila, 1011',
      date: 'April 18, 2025 - 9:30 AM',
      tags: ['Service', 'Prayer'],
      color: Colors.purple.shade800,
      text: 'PRAY',
      startDate: DateTime(2025, 4, 18),
      startTime: const TimeOfDay(hour: 9, minute: 30),
      venueName: 'St. Mary\'s Parish',
      description: 'Prayer request service',
      contactInfo: '09283829329',
    );

    // Create registration details
    final details = RegistrationDetails(
      fullName: allDetails['name'] ?? 'John Doe',
      email: allDetails['email'] ?? 'example@email.com',
      contactNumber: allDetails['contact'] ?? '09123456789',
      registrationDate: DateTime.now(),
      customFields: {
        'serviceType': 'Prayer Request',
        'recipientName': allDetails['recipientName'] ?? 'Not specified',
        'relationToRecipient': allDetails['relationToRecipient'] ?? 'Relative',
        'prayerTopic':
            allDetails['prayerTopic'] ?? 'Personal and Spiritual Growth',
        'preferredPrayerTime': allDetails['preferredPrayerTime'] ?? 'Morning',
        'privacyOption': allDetails['privacyOption'] ?? 'Private',
        'reasonForService': allDetails['reasonForService'] ?? 'Prayer request',
        'additionalInfo': allDetails['additionalInfo'] ?? '',
      },
    );

    // Create registered event
    final registeredEvent = RegisteredEvent(
      event: event,
      type: RegistrationType.attendee,
      details: details,
    );

    // Add to registered events
    RegisteredEventManager.addRegisteredEvent(registeredEvent);
  }

  // Navigate to main screen and select a specific tab
  void _navigateToMainAndSelectTab(BuildContext context, int tabIndex) {
    // First, navigate back to the main screen (root)
    Navigator.of(context).popUntil((route) => route.isFirst);

    // Then, find the PageController in the main screen and select the tab
    final pageController = _findPageController(context);
    if (pageController != null) {
      pageController.animateToPage(
        tabIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Helper method to find the PageController in the widget tree
  PageController? _findPageController(BuildContext context) {
    try {
      // Try to find the HomePage state that contains the PageController
      final homePageState = context.findAncestorStateOfType<State>();
      if (homePageState != null) {
        // Use reflection to access the private _pageController field
        final pageController =
            homePageState.widget.runtimeType.toString() == 'HomePage'
                ? (homePageState as dynamic)._pageController as PageController?
                : null;
        return pageController;
      }
    } catch (e) {
      // If any error occurs, return null
      print('Error finding PageController: $e');
    }
    return null;
  }
}
