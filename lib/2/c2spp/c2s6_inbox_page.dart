import 'package:flutter/material.dart';
import '../service_requests_page.dart';
import '../invitations_approval_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../event_invitation_details_page.dart';
import '../c2inbox/cancellation_request_page.dart';
import '../c2inbox/cancelled_booking_details_page.dart';
import '../c2inbox/service_assignment_details_page.dart';
import 'models/inbox_notification_model.dart';

// Change the InboxPage class from StatelessWidget to StatefulWidget
class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  // Add state variable to track sort order
  bool _isAscending = false;
  final String _sortBy = 'Date';
  // Add this after the _sortBy declaration
  final List<InboxNotification> _notificationItems = [];
  List<Widget> _sortedNotificationWidgets = [];

  // Toggle sort order function
  void _toggleSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
      _buildAndSortNotificationItems();
    });
  }

  // Add this method to the _InboxPageState class
  void _buildAndSortNotificationItems() {
    // Clear the existing list
    _notificationItems.clear();

    // Add all notification items with their dates for sorting
    _notificationItems.addAll([
      InboxNotification(
        notificationType: 'serviceAssignment',
        date: DateTime(2023, 5, 14),
        payload: {},
      ),
      InboxNotification(
        notificationType: 'invitationUpdate',
        date: DateTime(2023, 3, 1),
        payload: {
          'churchName': 'Church Name',
          'eventName': 'Event Name Event Name Event',
          'waitingTime': '6 hours',
        },
      ),
      InboxNotification(
        notificationType: 'invitationUpdate',
        date: DateTime(2023, 3, 2),
        payload: {
          'churchName': 'Church Name',
          'eventName': 'Event Name Event Name Event',
          'waitingTime': '22 hours',
        },
      ),
      InboxNotification(
        notificationType: 'serviceCancellation',
        date: DateTime(2023, 3, 4),
        payload: {
          'isRequest': true,
          'serviceName': 'Anointment & Healing Service',
          'requesterName': 'Requester\'s Name',
          'location': 'To their location',
          'distance': '1.8km away',
        },
      ),
      InboxNotification(
        notificationType: 'serviceCancellation',
        date: DateTime(2023, 3, 2),
        payload: {
          'isRequest': false,
          'serviceName': 'Anointment & Healing Service',
          'requesterName': 'Requester\'s Name',
          'location': 'To their location',
          'distance': '1.8km away',
        },
      ),
    ]);

    // Sort the items based on date
    _notificationItems.sort((a, b) {
      // If ascending, older dates first (smaller dates first)
      // If descending, newer dates first (larger dates first)
      return _isAscending
          ? a.date.compareTo(b.date) // Ascending (oldest first)
          : b.date.compareTo(a.date); // Descending (newest first)
    });

    // Add the sorted widgets to the notification items list
    _sortedNotificationWidgets =
        _notificationItems.map((item) => _buildNotificationItem(item)).toList();
  }

  @override
  void initState() {
    super.initState();
    _buildAndSortNotificationItems();
  }

  @override
  Widget build(BuildContext context) {
    // *** ADJUST THIS VALUE to position the FAB ***
    // Increase the value to move the FAB down, decrease to move it up
    final double fabPositionFromTop =
        -10.0; // Same value as service_requests_page.dart

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
          // Main content in Expanded to take all available space
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(
                  bottom: 100), // Add extra padding at bottom
              children: [
                // Notification categories
                _buildNotificationCategory(
                  number: "1",
                  numberColor: Colors.white,
                  numberBgColor: const Color(0xFFFF6B35), // Orange
                  borderColor: const Color(0xFFFF6B35),
                  title: 'Your Upcoming Services',
                  subtitle: 'Baptism, Wedding, and others',
                  onTap: () {
                    // Navigate back to main page and select Services tab (index 1)
                    Navigator.of(context).pop(1);
                  },
                ),
                _buildNotificationCategory(
                  number: "2",
                  numberColor: Colors.white,
                  numberBgColor: const Color(0xFF4CAF50), // Green
                  borderColor: const Color(0xFF4CAF50),
                  title: 'Your Upcoming Hosted Events',
                  subtitle: 'PRAISE! Youth Choir Charity and others',
                  onTap: () {
                    // Navigate back to main page and select Events tab (index 2)
                    Navigator.of(context).pop(2);
                  },
                ),
                _buildNotificationCategory(
                  number: "3",
                  numberColor: Colors.white,
                  numberBgColor: const Color(0xFFE91E63), // Pink
                  borderColor: const Color(0xFFE91E63),
                  title: 'Your Service Requests',
                  subtitle: 'Fast Booking and Scheduled Services',
                  onTap: () {
                    // Navigate to the ServiceRequestsPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ServiceRequestsPage(),
                      ),
                    );
                  },
                ),
                _buildNotificationCategory(
                  number: "4",
                  numberColor: Colors.white,
                  numberBgColor: const Color(0xFF2196F3), // Blue
                  borderColor: const Color(0xFF2196F3),
                  title: 'Event Invitations waiting for Approval!',
                  subtitle: 'YMCA\'s Event',
                  onTap: () {
                    // Navigate to the InvitationsApprovalPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InvitationsApprovalPage(),
                      ),
                    );
                  },
                ),

                // Sort option - UPDATED to use the exact Font Awesome icons from the reference
                GestureDetector(
                  onTap: _toggleSortOrder,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        // Use the exact Font Awesome icons that were circled in the reference image
                        FaIcon(
                          _isAscending
                              ? FontAwesomeIcons
                                  .sortAmountUpAlt // Ascending icon (circled in reference)
                              : FontAwesomeIcons
                                  .sortAmountDown, // Descending icon (circled in reference)
                          size: 18,
                          color: const Color(
                              0xFF1F2156), // Pink color from your image
                        ),
                        const SizedBox(width: 8),
                        // Sort text without dropdown arrow
                        Text(
                          'Sort: $_sortBy',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1F2156),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Replace the hardcoded notification items with the sorted list
                ..._sortedNotificationWidgets,

                // Add extra padding at the bottom to ensure content isn't hidden behind the FAB
                const SizedBox(height: 80),
              ],
            ),
          ),

          // Footer with FAB - UPDATED to match main.dart
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // Footer
              const FooterSection(),

              // FAB positioned to overlap with the footer
              Positioned(
                top: fabPositionFromTop, // ADJUSTABLE POSITION
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(
                        0xFF8A2BE2), // Changed to purple to match main.dart
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.volunteer_activism,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(InboxNotification notification) {
    switch (notification.notificationType) {
      case 'serviceAssignment':
        return _buildServiceAssignmentNotification();
      case 'invitationUpdate':
        return _buildUpdatedInvitationItem(
          date: '${notification.date.month}/${notification.date.day}',
          churchName: notification.payload['churchName'],
          eventName: notification.payload['eventName'],
          waitingTime: notification.payload['waitingTime'],
        );
      case 'serviceCancellation':
        return _buildServiceCancellationCard(
          date: '${notification.date.month}/${notification.date.day}',
          isRequest: notification.payload['isRequest'],
          serviceName: notification.payload['serviceName'],
          requesterName: notification.payload['requesterName'],
          location: notification.payload['location'],
          distance: notification.payload['distance'],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  // KEEPING THIS UNCHANGED
  Widget _buildNotificationCategory({
    required String number,
    required Color numberColor,
    required Color numberBgColor,
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
                // Numbered circle
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: numberBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      number,
                      style: TextStyle(
                        color: numberColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

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

  // UPDATED invitation item to make it clickable and navigate to EventInvitationDetailsPage
  Widget _buildUpdatedInvitationItem({
    required String date,
    required String churchName,
    required String eventName,
    required String waitingTime,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigate to EventInvitationDetailsPage when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventInvitationDetailPage(
              churchName: churchName,
              eventName: eventName,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            // Date header inside the card
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                date,
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
                  // Church avatar with custom painter checkmark
                  Stack(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                          ),
                          child: CustomPaint(
                            painter: CheckmarkPainter(),
                            size: const Size(18, 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),

                  // Invitation details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          churchName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2196F3),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'has invited your organization, [Church Name], to be part of their "$eventName."',
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
                      color: index.isEven
                          ? Colors.grey.shade300
                          : Colors.transparent,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                    ),
                  ),
                ),
              ),
            ),

            // Waiting for approval section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Waiting for your approval...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2196F3),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        waitingTime,
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

  // NEW WIDGET - Service Booking Cancellation Card
  Widget _buildServiceCancellationCard({
    required String date,
    required bool isRequest,
    required String serviceName,
    required String requesterName,
    required String location,
    required String distance,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigate to appropriate page based on whether it's a request or notice
        if (isRequest) {
          // Navigate to CancellationRequestPage for requests
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CancellationRequestPage(
                serviceName: serviceName,
                requesterName: requesterName,
                location: 'Default location where they\'re booking from',
              ),
            ),
          );
        } else {
          // Navigate to CancelledBookingDetailsPage for notices
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CancelledBookingDetailsPage(
                serviceName: serviceName,
                requesterName: requesterName,
                location: 'Default location where they\'re booking from',
                cancelledBy: 'Service Booker',
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            // Date and title
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isRequest
                        ? 'Request: Service Booking Cancellation'
                        : 'Notice: Service Booking Cancellation',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),
            ),

            // Service details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                serviceName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
            ),

            // Requester info
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    requesterName,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Fast',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF2196F3),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Location info
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    location,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '•',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    distance,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
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
                      color: index.isEven
                          ? Colors.grey.shade300
                          : Colors.transparent,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                    ),
                  ),
                ),
              ),
            ),

            // Status message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                isRequest
                    ? 'Waiting for your approval...'
                    : 'Automatically cancelled and refunded',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isRequest
                      ? const Color(0xFFFF6B35) // Orange for waiting approval
                      : const Color(0xFF4CAF50), // Green for auto-cancelled
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // NEW METHOD - Service Assignment Notification
  Widget _buildServiceAssignmentNotification() {
    return GestureDetector(
      onTap: () {
        // Navigate to the service assignment details page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ServiceAssignmentDetailsPage(
              serviceName: 'Baptism and Dedication',
              requesterName: 'Requester\'s Name',
              location: 'To the church',
              referenceNumber: 'AJSNDFR9341U9382RFWB',
              dateTime: 'May 14, 3:00 PM',
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            // Date and title
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'May 14',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Assignment Request: We need you!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),
            ),

            // Service details
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Baptism and Dedication',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
            ),

            // Requester info
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Requester\'s Name',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Fast',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF2196F3),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Location info
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'To the church',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '•',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '1.8km away',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
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
                      color: index.isEven
                          ? Colors.grey.shade300
                          : Colors.transparent,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                    ),
                  ),
                ),
              ),
            ),

            // Status message
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'Waiting for your approval...',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2196F3), // Blue for waiting approval
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for the checkmark
class CheckmarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Define the checkmark path
    final Path checkPath = Path();
    checkPath.moveTo(centerX - 4, centerY);
    checkPath.lineTo(centerX - 1, centerY + 3);
    checkPath.lineTo(centerX + 4, centerY - 2);

    // Paint for the purple/pink checkmark
    final Paint checkPaint = Paint()
      ..color = const Color(0xFFE040FB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Paint for the white outline
    final Paint outlinePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Draw the white outline first (underneath)
    canvas.drawPath(checkPath, outlinePaint);

    // Draw the purple/pink checkmark on top
    canvas.drawPath(checkPath, checkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// Updated FooterSection class to match main.dart
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF000233), // Dark navy blue background
        // Remove the border since it's not needed with the dark background
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.chat_bubble_outline,
              'Chat'), // Keep chat icon for inbox page
          _buildNavItem(Icons.favorite_border, 'Favorite'),
          // Prayer icon is positioned separately in the Stack
          const SizedBox(width: 56), // Space for the Prayer icon
          _buildNavItem(Icons.book_outlined, 'Book'),
          _buildNavItem(Icons.person_outline, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white, // Changed to white
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white, // Changed to white
            fontSize: 12,
          ),
        )
      ],
    );
  }
}
