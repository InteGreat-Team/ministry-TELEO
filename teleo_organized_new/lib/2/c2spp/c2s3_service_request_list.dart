// File: service_request_list.dart
import 'package:flutter/material.dart';
import '../c2inbox/service_request_details.dart';
import '../c2inbox/service_assignment_page.dart';

class ServiceRequestListPage extends StatefulWidget {
  const ServiceRequestListPage({super.key});

  @override
  State<ServiceRequestListPage> createState() => _ServiceRequestListPageState();
}

class _ServiceRequestListPageState extends State<ServiceRequestListPage> {
  // Sample data for service requests
  final List<Map<String, dynamic>> _serviceRequests = [
    {
      'name': 'Service Requestor Name',
      'location': 'Default location where theyre booking from',
      'service': 'Baptism and Dedication',
      'timeType': 'fast',
      'timeText': 'Fast Booking',
      'destination': 'Room 444, UST Hospital, Lacson',
      'countdown': '1:23',
    },
    {
      'name': 'Service Requestor Name',
      'location': 'Default location where theyre booking from',
      'service': 'Baptism and Dedication',
      'timeType': 'scheduled',
      'timeText': 'May 5, 3:00 PM',
      'scheduledText': 'Scheduled for Later',
      'destination': 'To the church',
      'countdown': '',
    },
    {
      'name': 'Service Requestor Name',
      'location': 'Default location where theyre booking from',
      'service': 'Baptism and Dedication',
      'timeType': 'scheduled',
      'timeText': 'May 5, 3:00 PM',
      'scheduledText': 'Scheduled for Later',
      'destination': 'To the church',
      'countdown': '',
    },
    {
      'name': 'Service Requestor Name',
      'location': 'Default location where theyre booking from',
      'service': 'Baptism and Dedication',
      'timeType': 'scheduled',
      'timeText': 'May 5, 3:00 PM',
      'scheduledText': 'Scheduled for Later',
      'destination': 'To the church',
      'countdown': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF000233), // Dark navy
        elevation: 0,
        centerTitle: true, // Center the title
        title: const Text(
          'Service Requests',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _serviceRequests.length,
        itemBuilder: (context, index) {
          final request = _serviceRequests[index];
          return ServiceRequestCard(
            serviceName: request['name'],
            serviceLocation: request['location'],
            serviceType: request['service'],
            timeType: request['timeType'],
            timeText: request['timeText'],
            scheduledText: request['scheduledText'],
            destination: request['destination'],
            countdown: request['countdown'],
          );
        },
      ),
    );
  }
}

class ServiceRequestCard extends StatelessWidget {
  final String serviceName;
  final String serviceLocation;
  final String serviceType;
  final String timeType;
  final String timeText;
  final String? scheduledText;
  final String destination;
  final String countdown;

  const ServiceRequestCard({
    super.key,
    required this.serviceName,
    required this.serviceLocation,
    required this.serviceType,
    required this.timeType,
    required this.timeText,
    this.scheduledText,
    required this.destination,
    required this.countdown,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left pink border
            Container(
              width: 6,
              decoration: const BoxDecoration(
                color: Color(0xFFFF4D8D), // Magenta/pink color
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),

            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with profile image
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Simple circle profile image
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Name and location
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                serviceName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                serviceLocation,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Service with heart icon
                    Row(
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 18,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Service: ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            serviceType,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333333),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Time with icon and tag - FIXED OVERFLOW ISSUE
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // First row with icon and label
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 18,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Time: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),

                        // Second row with time and tag (with padding to align with text above)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 26,
                          ), // Same as icon width + spacing
                          child: Wrap(
                            spacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                timeType == 'fast' ? 'Fast Booking' : timeText,
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      timeType == 'fast'
                                          ? const Color(0xFF2196F3)
                                          : const Color(0xFF333333),
                                ),
                              ),
                              if (timeType != 'fast' && scheduledText != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFE3F2FD,
                                    ), // Light blue background
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    scheduledText!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF2196F3), // Blue text
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Location with icon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 18,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'To your location: $destination',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Action buttons
                    Row(
                      children: [
                        // View Details button - UPDATED with navigation
                        Expanded(
                          child: Container(
                            height: 44,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(
                                  0xFF000233,
                                ), // Dark navy border
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextButton(
                              onPressed: () {
                                // Navigate to the details page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ServiceRequestDetailsPage(
                                          requestData: {
                                            'name': serviceName,
                                            'location': serviceLocation,
                                            'service': serviceType,
                                            'timeType': timeType,
                                            'timeText': timeText,
                                            'scheduledText': scheduledText,
                                            'destination': destination,
                                          },
                                        ),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'View Details',
                                style: TextStyle(
                                  color: Color(0xFF000233), // Dark navy text
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Accept button
                        Expanded(
                          child: Container(
                            height: 44,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF000233,
                              ), // Dark navy background
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Container(
                                        width: 300,
                                        padding: const EdgeInsets.all(24),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Header with icon and close button
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.check_circle_outline,
                                                  color: Colors.grey,
                                                  size: 24,
                                                ),
                                                const SizedBox(width: 8),
                                                const Text(
                                                  'Accept Service',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const Spacer(),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.close,
                                                    size: 20,
                                                  ),
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            // Message
                                            Text(
                                              'Are you sure you want to accept [$serviceType]?',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 24),
                                            // Buttons
                                            Row(
                                              children: [
                                                // Cancel button
                                                Expanded(
                                                  child: OutlinedButton(
                                                    onPressed: () {
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                    },
                                                    style: OutlinedButton.styleFrom(
                                                      side: const BorderSide(
                                                        color: Color(
                                                          0xFF000233,
                                                        ),
                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 12,
                                                          ),
                                                    ),
                                                    child: const Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                        color: Color(
                                                          0xFF000233,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                // Accept button
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                      // Navigate to the service assignment page
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (
                                                                context,
                                                              ) => ServiceAssignmentPage(
                                                                serviceDetails: {
                                                                  'name':
                                                                      serviceName,
                                                                  'location':
                                                                      serviceLocation,
                                                                  'service':
                                                                      serviceType,
                                                                  'timeType':
                                                                      timeType,
                                                                  'timeText':
                                                                      timeText,
                                                                  'scheduledText':
                                                                      scheduledText ??
                                                                      'Scheduled for Later',
                                                                  'destination':
                                                                      destination,
                                                                  'note':
                                                                      'Please assign Fr. Lebron James if available',
                                                                },
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          const Color(
                                                            0xFF000233,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 12,
                                                          ),
                                                    ),
                                                    child: const Text(
                                                      'Accept',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                countdown.isNotEmpty
                                    ? 'Accept ($countdown)'
                                    : 'Accept',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
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
          ],
        ),
      ),
    );
  }
}
