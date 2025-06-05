import 'package:flutter/material.dart';
import '../c2eventscreation/models/event.dart';
import '../c2eventscreation/c2s10caeventcreation.dart';
import '../c2eventscreation/services/event_service.dart';
import '../c2hostedevents/c2s1ethostedevents.dart';
import '../c2eventscreation/c2s1caeventcreation.dart';
import '../widgets/event_card.dart' as custom_card;

class EventsTab extends StatefulWidget {
  const EventsTab({super.key});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  // Use EventService to manage events
  final EventService _eventService = EventService();
  List<Map<String, dynamic>> _allEvents = [];
  List<Map<String, dynamic>> _upcomingEvents = [];
  List<Map<String, dynamic>> _pendingEvents = [];

  @override
  void initState() {
    super.initState();

    // Initialize with sample data if EventService is empty
    if (_eventService.events.isEmpty) {
      _eventService.initialize([
        {
          'title': 'Love! Live! Couples for Christ Community Night',
          'assignedTo': '@Jake Sim',
          'location': 'Paxton Hall, Yoshida Center',
          'time': 'February 14, 2025 - 6:00 PM - 8:00 PM',
          'status': 'UPCOMING',
          'description':
              'A community night for couples to strengthen their relationship with Christ and each other.',
          'eventFee': '200',
          'speakers': ['Pastor John Doe', 'Dr. Jane Smith'],
          'dressCode': 'Smart Casual',
          'tags': [],
        },
        {
          'title': 'pRAISE the lord',
          'assignedTo': '@Youth Ministry',
          'location': 'Paxton Hall, Yoshida Center',
          'time': 'May 7, 2025 - 7:00 PM - 9:00 PM',
          'status': 'UPCOMING',
          'description': 'fdasjfjdsajfdjfsad',
          'eventFee': '200',
          'speakers': ['Mr. Catubag', 'Youth Choir'],
          'dressCode': 'Semi-formal',
          'tags': [],
        },
      ]);
    }

    // Get initial events
    _updateEventLists();

    // Listen for changes to events
    _eventService.eventsStream.listen((events) {
      if (mounted) {
        setState(() {
          _allEvents = List.from(events);
          _updateEventLists();
        });
      }
    });
  }

  void _updateEventLists() {
    setState(() {
      _allEvents = List.from(_eventService.events);

      // Filter upcoming events
      _upcomingEvents =
          _allEvents.where((event) => event['status'] == 'UPCOMING').toList();

      // Filter pending events
      _pendingEvents =
          _allEvents.where((event) => event['status'] == 'PENDING').toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Your Hosted Events section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Hosted Events',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                // Updated Create Event button with navigation to CreateEventScreen
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFAF00), // Golden color
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () {
                      try {
                        // Navigate to CreateEventScreen with loading indicator
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );

                        // Simulate a short delay then navigate
                        Future.delayed(const Duration(milliseconds: 300), () {
                          Navigator.pop(context); // Remove loading indicator
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateEventScreen(),
                            ),
                          );
                        });
                      } catch (e) {
                        // Handle navigation error
                        Navigator.pop(
                          context,
                        ); // Remove loading indicator if shown
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error navigating: $e')),
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Create Event',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.add, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing (${_upcomingEvents.length}/${_allEvents.length})',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                TextButton(
                  onPressed: () {
                    try {
                      // Show loading indicator
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );

                      // Simulate a short delay then navigate
                      Future.delayed(const Duration(milliseconds: 300), () {
                        Navigator.pop(context); // Remove loading indicator
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HostedEventsPage(),
                          ),
                        ).then((result) {
                          // If we got updated data back, refresh the state
                          if (result != null && result is bool && result) {
                            _updateEventLists();
                          }
                        });
                      });
                    } catch (e) {
                      // Handle navigation error
                      Navigator.pop(
                        context,
                      ); // Remove loading indicator if shown
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error navigating: $e')),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF000233), // Updated to dark navy
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: Color(0xFF000233), // Updated to dark navy
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Hosted Events cards with navigation to EventDetailPage
            if (_upcomingEvents.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                    _upcomingEvents.length > 2 ? 2 : _upcomingEvents.length,
                itemBuilder: (context, index) {
                  final eventData = _upcomingEvents[index];
                  return GestureDetector(
                    onTap: () {
                      try {
                        // Show loading indicator
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );

                        // Simulate a short delay then navigate
                        Future.delayed(const Duration(milliseconds: 300), () {
                          Navigator.pop(context); // Remove loading indicator
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      EventDetailPage(eventData: eventData),
                            ),
                          ).then((result) {
                            // If we got updated data back, update the state
                            if (result != null) {
                              if (result is Map<String, dynamic> &&
                                  result.containsKey('canceled') &&
                                  result['canceled'] == true) {
                                // Event was canceled, remove it from the list
                                _eventService.removeEvent(eventData['title']);

                                // Show a success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Event has been canceled successfully',
                                    ),
                                  ),
                                );
                              } else if (result is Map<String, dynamic>) {
                                // Event was updated, update the data
                                _eventService.updateEvent(
                                  eventData['title'],
                                  result,
                                );

                                // Show a success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Event details updated successfully',
                                    ),
                                  ),
                                );
                              }
                            }
                          });
                        });
                      } catch (e) {
                        // Handle navigation error
                        Navigator.pop(
                          context,
                        ); // Remove loading indicator if shown
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error navigating: $e')),
                        );
                      }
                    },
                    child: custom_card.EventCard(
                      title: eventData['title'],
                      assignedTo: eventData['assignedTo'],
                      location: eventData['location'],
                      time: eventData['time'],
                      borderColor: const Color(0xFF4CAF50), // Green border
                      backgroundColor: const Color(
                        0xFFF1FBF2,
                      ), // Light green background
                    ),
                  );
                },
              ),
            if (_upcomingEvents.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: Text(
                    'No hosted events yet. Create your first event!',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Your Events Under Review section
            const Text(
              'Your Events Under Review',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing (${_pendingEvents.length}/${_pendingEvents.length})',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                TextButton(
                  onPressed: () {
                    try {
                      // Show loading indicator
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );

                      // Simulate a short delay then navigate
                      Future.delayed(const Duration(milliseconds: 300), () {
                        Navigator.pop(context); // Remove loading indicator
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HostedEventsPage(),
                          ),
                        );
                      });
                    } catch (e) {
                      // Handle navigation error
                      Navigator.pop(
                        context,
                      ); // Remove loading indicator if shown
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error navigating: $e')),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF000233), // Updated to dark navy
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: Color(0xFF000233), // Updated to dark navy
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Events Under Review cards with navigation to EventDetailPage
            if (_pendingEvents.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                    _pendingEvents.length > 2 ? 2 : _pendingEvents.length,
                itemBuilder: (context, index) {
                  final eventData = _pendingEvents[index];
                  return GestureDetector(
                    onTap: () {
                      try {
                        // Show loading indicator
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );

                        // Simulate a short delay then navigate
                        Future.delayed(const Duration(milliseconds: 300), () {
                          Navigator.pop(context); // Remove loading indicator
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      EventDetailPage(eventData: eventData),
                            ),
                          );
                        });
                      } catch (e) {
                        // Handle navigation error
                        Navigator.pop(
                          context,
                        ); // Remove loading indicator if shown
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error navigating: $e')),
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      clipBehavior:
                          Clip.antiAlias, // Add this to prevent content from overflowing
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left orange border for pending events
                            Container(
                              width: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF9800), // Orange for pending
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                ),
                              ),
                            ),

                            // Thumbnail/icon - Updated to 40x40 with border radius 5
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),

                            // Content
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  0,
                                  16,
                                  16,
                                  16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      eventData['title'] ?? 'No Title',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF333333),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),

                                    // Location row
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 16,
                                          color: Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            eventData['location'] ??
                                                'No location',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),

                                    // Time row
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 16,
                                          color: Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            eventData['time'] ??
                                                'No time specified',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            if (_pendingEvents.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: Text(
                    'No events under review.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Accepted Invitations section
            const Text(
              'Accepted Invitations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing (2/6)',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                TextButton(
                  onPressed: () {
                    try {
                      // Show loading indicator
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );

                      // Simulate a short delay then navigate
                      Future.delayed(const Duration(milliseconds: 300), () {
                        Navigator.pop(context); // Remove loading indicator
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HostedEventsPage(),
                          ),
                        );
                      });
                    } catch (e) {
                      // Handle navigation error
                      Navigator.pop(
                        context,
                      ); // Remove loading indicator if shown
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error navigating: $e')),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF000233), // Updated to dark navy
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: Color(0xFF000233), // Updated to dark navy
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Accepted Invitations card - updated to match the design exactly
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD), // Light blue background
                borderRadius: BorderRadius.circular(16), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    spreadRadius: 0,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior:
                  Clip.antiAlias, // Add this to prevent content from overflowing
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left blue border with thicker, curved style
                    Container(
                      width: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2196F3), // Blue border
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                    ),

                    // Thumbnail/icon - keeping circle shape as requested
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    // Main content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pastor Meet and Celebration',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),

                            // Representatives row with icon
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Representatives: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const Expanded(
                                  child: Text(
                                    '@Jake Sim and 12 others',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF4A90E2),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Location row with icon
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Manila City Hall, M. Manila, 1203',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Time row with icon
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'April 14, 2025 - 6:00 PM - 8:00 PM',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// Define EventDetailPage for backward compatibility
class EventDetailPage extends StatelessWidget {
  final Map<String, dynamic> eventData;

  const EventDetailPage({super.key, required this.eventData});

  @override
  Widget build(BuildContext context) {
    // Create a dummy Event object from the map data
    final dummyEvent = Event(
      title: eventData['title'],
      description: eventData['description'],
      contactInfo: eventData['contactInfo'],
      dressCode: eventData['dressCode'],
      speakers: List<String>.from(eventData['speakers'] ?? []),
      tags: List<String>.from(eventData['tags'] ?? []),
      isOnline: eventData['isOnline'] ?? false,
      inviteType: eventData['inviteType'] ?? 'Open Invite',
      expectedCapacity: eventData['expectedCapacity'],
    );

    // Use the EventDetailsScreen from c2s10caeventcreation.dart
    return EventDetailsScreen(event: dummyEvent);
  }
}
