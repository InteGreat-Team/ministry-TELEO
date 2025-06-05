import 'package:flutter/material.dart';
import 'appointment_details_screen.dart';
import '../c2events/models/registered_event.dart';
import '../c2events/models/event.dart';
import '../c2events/c2s1epeventstab.dart';

class MyAppointmentsSection extends StatefulWidget {
  final bool isRefreshed;
  final Future<void> Function() onRefresh;
  final ScrollController scrollController;
  final bool isHeaderCollapsed;

  const MyAppointmentsSection({
    super.key,
    required this.isRefreshed,
    required this.onRefresh,
    required this.scrollController,
    required this.isHeaderCollapsed,
  });

  @override
  State<MyAppointmentsSection> createState() => _MyAppointmentsSectionState();
}

class _MyAppointmentsSectionState extends State<MyAppointmentsSection> {
  // List to store registered events
  List<RegisteredEvent> _registeredEvents = [];

  @override
  void initState() {
    super.initState();
    // Load registered events from storage
    _loadRegisteredEvents();
  }

  @override
  void didUpdateWidget(MyAppointmentsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload events when the widget is refreshed
    if (widget.isRefreshed != oldWidget.isRefreshed) {
      _loadRegisteredEvents();
    }
  }

  // Load registered events
  void _loadRegisteredEvents() {
    setState(() {
      _registeredEvents = RegisteredEventManager.getRegisteredEvents();

      // If no events are registered yet, add a sample event for testing
      if (_registeredEvents.isEmpty) {
        // Add sample data for testing - this would be removed in production
        // Reload events
        _registeredEvents = RegisteredEventManager.getRegisteredEvents();
      }
    });
  }

  // Method to check if an event is a service
  bool _isServiceEvent(Event event) {
    return event.tags.contains('Service');
  }

  // Method to get service type from event
  String _getServiceType(Event event) {
    if (event.tags.length > 1) {
      return event.tags[1]; // The second tag should be the service type
    }
    return 'Service';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My Appointments',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                ),
              ),
              // Pagination dots
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF000233),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Appointment Cards
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await widget.onRefresh();
              _loadRegisteredEvents(); // Reload registered events on refresh
            },
            color: const Color(0xFF000233),
            child:
                _registeredEvents.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      controller: widget.scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const ClampingScrollPhysics(),
                      itemCount: _registeredEvents.length,
                      itemBuilder: (context, index) {
                        final registration = _registeredEvents[index];

                        return Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 4),
                          child: _buildEventAppointmentCard(
                            registeredEvent: registration,
                            onTap: () => _viewEventDetails(registration),
                          ),
                        );
                      },
                    ),
          ),
        ),
      ],
    );
  }

  // Empty state when no events are registered
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No appointments yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No services, events, or volunteering signed up yet',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  // Navigate to events section
  void _navigateToEventsSection() {
    // Find the parent PageView and navigate to the Events tab (index 1)
    final PageController? pageController = _findPageController(context);
    if (pageController != null) {
      pageController.animateToPage(
        1, // Index 1 is the Events tab
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Fallback if PageController not found - create a standalone EventsSection
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color(0xFF000233),
                  title: const Text(
                    'Events',
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: EventsSection(
                  scrollController: ScrollController(),
                  isHeaderCollapsed: false,
                ),
              ),
        ),
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
        // Note: This is a bit hacky and might break if the field name changes
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

  // Navigate to event details
  void _viewEventDetails(RegisteredEvent registeredEvent) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                EventAppointmentDetailsScreen(registeredEvent: registeredEvent),
      ),
    ).then((_) {
      // Refresh the list when returning from details screen
      setState(() {
        _loadRegisteredEvents();
      });
    });
  }

  // Build appointment card for events
  Widget _buildEventAppointmentCard({
    required RegisteredEvent registeredEvent,
    required VoidCallback onTap,
  }) {
    final event = registeredEvent.event;
    final formattedDate =
        event.startDate != null
            ? _formatDate(event.startDate!)
            : 'Date not specified';
    final formattedTime =
        event.startTime != null
            ? _formatTime(event.startTime!)
            : 'Time not specified';

    // Determine color based on event type or tags
    Color cardColor = const Color(0xFF15D474); // Default green

    // Check if this is a service event
    if (_isServiceEvent(event)) {
      String serviceType = _getServiceType(event);

      // All service types use the same purple color scheme
      cardColor = Colors.purple.shade800;
    } else if (event.tags.contains('Music')) {
      cardColor = Colors.blue;
    } else if (event.tags.contains('Seminar') ||
        event.tags.contains('Education')) {
      cardColor = const Color(0xFFFFD600); // Yellow
    } else if (event.tags.contains('Healing')) {
      cardColor = Colors.purple;
    }

    // Check if the event is cancelled
    final bool isCancelled = registeredEvent.cancellationReason != null;

    // Get service-specific information for display
    String serviceInfo = '';
    if (_isServiceEvent(event)) {
      String serviceType = _getServiceType(event);

      if (serviceType == 'Wedding Service') {
        // For wedding services, show the couple's names
        String brideName =
            registeredEvent.details.customFields['brideName'] ?? '';
        String groomName =
            registeredEvent.details.customFields['groomName'] ?? '';
        if (brideName.isNotEmpty && groomName.isNotEmpty) {
          serviceInfo = 'Wedding for: $brideName & $groomName';
        } else {
          serviceInfo = 'Wedding service';
        }
      } else if (serviceType == 'Baptism') {
        // For baptism, show the child's name
        String childName =
            registeredEvent.details.customFields['childName'] ?? '';
        if (childName.isNotEmpty) {
          serviceInfo = 'Baptism for: $childName';
        } else {
          serviceInfo = 'Baptism service';
        }
      } else {
        // For other services
        serviceInfo = 'Service for: ${registeredEvent.details.fullName}';
      }
    } else if (registeredEvent.isVolunteer) {
      serviceInfo = 'Volunteering as: ${registeredEvent.details.fullName}';
    } else {
      serviceInfo = 'Registered as: ${registeredEvent.details.fullName}';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left colored bar
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: isCancelled ? Colors.red.shade400 : cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    bottomLeft: Radius.circular(6),
                  ),
                ),
              ),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event type and time
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _isServiceEvent(event)
                                    ? _getServiceType(event)
                                    : (event.tags.isNotEmpty
                                        ? event.tags.first
                                        : 'Event'),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Row(
                                children: [
                                  if (isCancelled)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade400,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'Cancelled',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  else if (_isServiceEvent(event))
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: cardColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'Service',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  else if (registeredEvent.isVolunteer)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF4CAF50),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'Volunteer',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  else
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF000233),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'Registered',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.more_vert,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.access_time_rounded,
                                  color: Color(0xFF000233),
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$formattedDate - $formattedTime',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Divider with padding
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey.shade200,
                      ),
                    ),

                    // Event details
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Event color block with text
                          Container(
                            width: 50,
                            height: 85,
                            decoration: BoxDecoration(
                              color: isCancelled ? Colors.grey : event.color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                event.text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Text details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title ?? 'Untitled Event',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  event.venueName ?? 'Church Name',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  event.location ?? 'Location not specified',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 11,
                                    fontFamily: 'Poppins',
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      isCancelled
                                          ? Icons.cancel_outlined
                                          : (_isServiceEvent(event)
                                              ? (_getServiceType(event) ==
                                                      'Wedding Service'
                                                  ? Icons.favorite
                                                  : Icons.church)
                                              : (registeredEvent.isVolunteer
                                                  ? Icons.volunteer_activism
                                                  : Icons.person)),
                                      size: 12,
                                      color:
                                          isCancelled
                                              ? Colors.red.shade400
                                              : (_isServiceEvent(event)
                                                  ? cardColor
                                                  : (registeredEvent.isVolunteer
                                                      ? const Color(0xFF4CAF50)
                                                      : Colors.grey.shade600)),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        isCancelled
                                            ? 'Cancelled: ${registeredEvent.cancellationReason}'
                                            : serviceInfo,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight:
                                              _isServiceEvent(event)
                                                  ? FontWeight.w500
                                                  : FontWeight.normal,
                                          color:
                                              isCancelled
                                                  ? Colors.red.shade400
                                                  : (_isServiceEvent(event)
                                                      ? cardColor
                                                      : (registeredEvent
                                                              .isVolunteer
                                                          ? const Color(
                                                            0xFF4CAF50,
                                                          )
                                                          : Colors
                                                              .grey
                                                              .shade600)),
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Format date to readable string
  String _formatDate(DateTime date) {
    final List<String> weekdays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];

    return '$weekday $month ${date.day}';
  }

  // Format time to readable string
  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }
}
