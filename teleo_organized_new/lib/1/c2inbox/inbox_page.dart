import 'package:flutter/material.dart';
import '../c2events/models/registered_event.dart';
import '../c2appointments/appointment_details_screen.dart';
import 'service_requests_page.dart';
import 'event_invitations_page.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  bool _isAscending = false;
  final String _sortBy = 'Date';
  
  // Lists to store service requests and event invitations
  late List<RegisteredEvent> _registeredEvents;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  // Load data from the managers
  void _loadData() {
    // Get registered events (both attendee and volunteer)
    _registeredEvents = RegisteredEventManager.getRegisteredEvents();
    
    // Filter events to separate services and regular events
    _sortData();
  }
  
  // Get service requests (events with 'Service' tag)
  List<RegisteredEvent> get serviceRequests {
    return _registeredEvents.where((event) => 
      event.event.tags.contains('Service') && 
      !event.isCancelled
    ).toList();
  }
  
  // Get event invitations (events without 'Service' tag)
  List<RegisteredEvent> get eventInvitations {
    return _registeredEvents.where((event) => 
      !event.event.tags.contains('Service') && 
      !event.isCancelled
    ).toList();
  }
  
  // Check if there are any service requests
  bool get hasServiceRequests => serviceRequests.isNotEmpty;
  
  // Check if there are any event invitations
  bool get hasEventInvitations => eventInvitations.isNotEmpty;
  
  // Check if inbox is empty
  bool get isInboxEmpty => !hasServiceRequests && !hasEventInvitations;

  void _toggleSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
      _sortData();
    });
  }
  
  // Sort the data based on date
  void _sortData() {
    // Sort registered events by start date
    _registeredEvents.sort((a, b) {
      // Handle null dates (place them at the end)
      if (a.event.startDate == null && b.event.startDate == null) {
        return 0;
      } else if (a.event.startDate == null) {
        return _isAscending ? 1 : -1;
      } else if (b.event.startDate == null) {
        return _isAscending ? -1 : 1;
      }
      
      // Compare dates
      final dateComparison = _isAscending
          ? a.event.startDate!.compareTo(b.event.startDate!)
          : b.event.startDate!.compareTo(a.event.startDate!);
      
      // If dates are the same, compare times
      if (dateComparison == 0 && a.event.startTime != null && b.event.startTime != null) {
        final aMinutes = a.event.startTime!.hour * 60 + a.event.startTime!.minute;
        final bMinutes = b.event.startTime!.hour * 60 + b.event.startTime!.minute;
        
        return _isAscending ? aMinutes.compareTo(bMinutes) : bMinutes.compareTo(aMinutes);
      }
      
      return dateComparison;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 1),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Inbox',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Balance the header
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Category cards
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              children: [
                _buildNotificationCategory(
                  borderColor: const Color(0xFFE91E63), // Pink
                  title: 'Your Service Requests',
                  subtitle: hasServiceRequests ? '${serviceRequests.length} services' : 'None',
                  onTap: () {
                    // Navigate to service requests page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ServiceRequestsPage(),
                      ),
                    ).then((_) {
                      // Refresh data when returning from service requests page
                      setState(() {
                        _loadData();
                      });
                    });
                  },
                ),
                _buildNotificationCategory(
                  borderColor: const Color(0xFF4CAF50), // Green
                  title: 'Your Event Invitations',
                  subtitle: hasEventInvitations ? '${eventInvitations.length} events' : 'None',
                  onTap: () {
                    // Navigate to event invitations page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EventInvitationsPage(),
                      ),
                    ).then((_) {
                      // Refresh data when returning from event invitations page
                      setState(() {
                        _loadData();
                      });
                    });
                  },
                ),
              ],
            ),
          ),
          
          // Sort option
          GestureDetector(
            onTap: _toggleSortOrder,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 18,
                    color: const Color(0xFF333333),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Sort: $_sortBy ${_isAscending ? '(Oldest first)' : '(Newest first)'}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Content area - either notifications or empty state
          Expanded(
            child: isInboxEmpty 
                ? _buildEmptyState()
                : _buildNotificationsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCategory({
    required Color borderColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(
          left: BorderSide(
            color: borderColor,
            width: 4,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow icon
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Service requests
        if (hasServiceRequests) ...[
          for (var service in serviceRequests)
            _buildServiceRequestCard(service),
        ],
        
        // Event invitations
        if (hasEventInvitations) ...[
          for (var event in eventInvitations)
            _buildEventInvitationCard(event),
        ],
      ],
    );
  }
  
  Widget _buildServiceRequestCard(RegisteredEvent service) {
    // Format date and time
    String formattedDate = '';
    String formattedTime = '';
    
    if (service.event.startDate != null) {
      formattedDate = "${service.event.startDate!.day}/${service.event.startDate!.month}/${service.event.startDate!.year}";
    }
    
    if (service.event.startTime != null) {
      final hour = service.event.startTime!.hourOfPeriod == 0 ? 12 : service.event.startTime!.hourOfPeriod;
      final minute = service.event.startTime!.minute.toString().padLeft(2, '0');
      final period = service.event.startTime!.period == DayPeriod.am ? 'AM' : 'PM';
      formattedTime = '$hour:$minute $period';
    }
    
    // Get service type from event tags
    String serviceType = 'Service';
    if (service.event.tags.length > 1) {
      serviceType = service.event.tags[1];
    }
    
    return GestureDetector(
      onTap: () {
        // Navigate to event appointment details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventAppointmentDetailsScreen(
              registeredEvent: service,
            ),
          ),
        ).then((_) {
          // Refresh the list when returning from details
          setState(() {
            _loadData();
          });
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFDE1738),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.purple.shade800,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        _getServiceIcon(serviceType),
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Service details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          serviceType,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2196F3),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Scheduled for $formattedTime at ${service.event.location ?? "Church"}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF333333),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Dashed divider line
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(
                  30, // Number of dashes
                  (index) => Expanded(
                    child: Container(
                      height: 1,
                      color: index.isEven ? Colors.grey.shade300 : Colors.transparent,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                    ),
                  ),
                ),
              ),
            ),

            // Status section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Confirmed',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.church,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        service.event.venueName ?? 'Church',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
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
    );
  }
  
  Widget _buildEventInvitationCard(RegisteredEvent event) {
    // Format date
    String formattedDate = '';
    if (event.event.startDate != null) {
      formattedDate = "${event.event.startDate!.day}/${event.event.startDate!.month}/${event.event.startDate!.year}";
    }
    
    return GestureDetector(
      onTap: () {
        // Navigate to event appointment details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventAppointmentDetailsScreen(
              registeredEvent: event,
            ),
          ),
        ).then((_) {
          // Refresh the list when returning from details
          setState(() {
            _loadData();
          });
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFDE1738),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: event.isVolunteer ? Colors.green.shade800 : Colors.blue.shade800,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        event.isVolunteer ? Icons.volunteer_activism : Icons.event,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Event details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.event.title ?? 'Untitled Event',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2196F3),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          event.isVolunteer 
                              ? 'You volunteered as ${event.details.primaryRole ?? "Volunteer"}'
                              : 'You registered for this event',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF333333),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Dashed divider line
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(
                  30, // Number of dashes
                  (index) => Expanded(
                    child: Container(
                      height: 1,
                      color: index.isEven ? Colors.grey.shade300 : Colors.transparent,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                    ),
                  ),
                ),
              ),
            ),

            // Status section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    event.isVolunteer ? 'Volunteer Confirmed' : 'Registration Confirmed',
                    style: TextStyle(
                      fontSize: 14,
                      color: event.isVolunteer ? Colors.green.shade700 : Colors.blue.shade700,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event.event.location ?? 'No location',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
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
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Mailbox illustration
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.blue.shade100.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Mailbox
                  Container(
                    width: 60,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade500,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  // Mailbox pole
                  Positioned(
                    bottom: 30,
                    child: Container(
                      width: 10,
                      height: 50,
                      color: Colors.blue.shade400,
                    ),
                  ),
                  // Mailbox flag
                  Positioned(
                    right: 45,
                    top: 65,
                    child: Container(
                      width: 6,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // Mailbox dots (message)
                  Positioned(
                    left: 45,
                    top: 65,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade700,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade700,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade700,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Empty state text
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue.shade200,
                width: 1,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Text(
                  'Inbox is empty.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Nothing to see here yet.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to get service icon
  IconData _getServiceIcon(String serviceType) {
    switch (serviceType) {
      case 'Wedding':
      case 'Wedding Service':
        return Icons.favorite;
      case 'Funeral Service':
        return Icons.church;
      case 'Prayer Request':
        return Icons.volunteer_activism;
      case 'Baptism':
        return Icons.child_care;
      case 'Hospital Visit':
        return Icons.local_hospital;
      case 'Home Blessing':
        return Icons.home;
      default:
        return Icons.church;
    }
  }
}
