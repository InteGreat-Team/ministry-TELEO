import 'package:flutter/material.dart';
import '../c2spp/assignment_confirmation_page.dart';
import '../c2spp/models/service_request_model.dart';

class ServiceAssignmentPage extends StatefulWidget {
  final Map<String, dynamic> serviceDetails;

  const ServiceAssignmentPage({super.key, required this.serviceDetails});

  @override
  _ServiceAssignmentPageState createState() => _ServiceAssignmentPageState();
}

class _ServiceAssignmentPageState extends State<ServiceAssignmentPage> {
  // List of facilitators with their details
  final List<Map<String, dynamic>> facilitators = [
    {
      'name': 'John Jhong Cook',
      'role': 'Pastor',
      'status': 'Schedule Conflict',
      'isSelected': false,
      'statusColor': Colors.orange,
      'dotColor': Colors.green,
      'hasConflict': true, // Mark as having a conflict
    },
    {
      'name': 'Lebron James',
      'role': 'Pastor',
      'status': 'Available',
      'isSelected': false,
      'statusColor': Colors.green,
      'dotColor': Colors.green,
      'hasConflict': false,
    },
    {
      'name': 'Mah Shayla',
      'role': 'Leader',
      'status': 'Available',
      'isSelected': false,
      'statusColor': Colors.green,
      'dotColor': Colors.grey,
      'hasConflict': false,
    },
    {
      'name': 'Tailor Sweep',
      'role': 'Leader',
      'status': 'Available',
      'isSelected': false,
      'statusColor': Colors.green,
      'dotColor': Colors.green,
      'hasConflict': false,
    },
    {
      'name': 'Sabrina Carpenter',
      'role': 'Pastor',
      'status': 'Available',
      'isSelected': false,
      'statusColor': Colors.green,
      'dotColor': Colors.green,
      'hasConflict': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // UPDATED: Fixed app bar with consistent navy blue color
      appBar: AppBar(
        backgroundColor: const Color(0xFF000233),
        elevation: 0,
        centerTitle: true,
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
          onPressed: () => Navigator.pop(context),
        ),
        // Add these properties to prevent color changes on scroll
        flexibleSpace: null,
        scrolledUnderElevation: 0,
        // Disable any transparency or color blending
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step indicator
            Container(
              color: Colors.white,
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              child: Row(
                children: [
                  _buildStepCircle(1, true, false),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                  ),
                  _buildStepCircle(2, true, true),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                  ),
                  _buildStepCircle(3, false, false),
                ],
              ),
            ),

            // Service details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service requestor info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.person,
                            color: Colors.grey[600], size: 30),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.serviceDetails['name'] ??
                                'Service Requestor Name',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            widget.serviceDetails['location'] ??
                                'Default location where theyre booking from',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Service type
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.favorite_border,
                          size: 22, color: Colors.black54),
                      const SizedBox(width: 8),
                      const Text(
                        'Service: ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.serviceDetails['service'] ??
                            'Baptism and Dedication',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Time
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.access_time,
                          size: 22, color: Colors.black54),
                      const SizedBox(width: 8),
                      const Text(
                        'Time: ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.serviceDetails['timeType'] == 'fast'
                            ? 'Fast Booking'
                            : (widget.serviceDetails['timeText'] ??
                                'May 5, 3:00 PM'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.serviceDetails['scheduledText'] ??
                              'Scheduled for Later',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Location
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 22, color: Colors.black54),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.serviceDetails['destination'] ??
                                  'To the church',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '"Please assign Fr. Lebron James if available"',
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Divider
                  const Divider(thickness: 1),
                  const SizedBox(height: 16),

                  // Assign service section
                  const Text(
                    'Assign Service to a Facilitator',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Pastors and Leaders section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pastors and Leaders',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Active Now (5)',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Handle select all - only select those without conflicts
                              setState(() {
                                // Get only facilitators without conflicts
                                final availableFacilitators = facilitators
                                    .where((f) => !f['hasConflict'])
                                    .toList();

                                // Check if all available facilitators are selected
                                bool allAvailableSelected =
                                    availableFacilitators
                                        .every((f) => f['isSelected']);

                                // Toggle selection for available facilitators only
                                for (var facilitator in facilitators) {
                                  if (!facilitator['hasConflict']) {
                                    facilitator['isSelected'] =
                                        !allAvailableSelected;
                                  }
                                }
                              });
                            },
                            child: Row(
                              children: [
                                const Text(
                                  'Select All',
                                  style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  facilitators
                                          .where((f) => !f['hasConflict'])
                                          .every((f) => f['isSelected'])
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: Colors.deepOrange,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Facilitators list
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: facilitators.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final facilitator = facilitators[index];
                      final hasConflict = facilitator['hasConflict'] == true;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          children: [
                            // Avatar with status dot
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.grey[300],
                                  // Removed the text/letter from the avatar
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: facilitator['dotColor'],
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),

                            // Name and role
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    facilitator['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    facilitator['role'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Status and checkbox
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color:
                                    facilitator['statusColor'] == Colors.green
                                        ? Colors.green[50]
                                        : Colors.orange[50],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                facilitator['status'],
                                style: TextStyle(
                                  color: facilitator['statusColor'],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Make checkbox clickable only if no conflict
                            GestureDetector(
                              onTap: hasConflict
                                  ? null
                                  : () {
                                      setState(() {
                                        facilitator['isSelected'] =
                                            !facilitator['isSelected'];
                                      });
                                    },
                              child: Icon(
                                hasConflict
                                    ? Icons
                                        .check_box_outline_blank // Always show unchecked for conflicts
                                    : (facilitator['isSelected']
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank),
                                color: hasConflict
                                    ? Colors.grey
                                    : Colors.deepOrange, // Grey for conflicts
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Get selected facilitators and explicitly cast to List<String>
            final List<String> selectedFacilitators = facilitators
                .where((f) => f['isSelected'])
                .map((f) => f['name'] as String)
                .toList();

            if (selectedFacilitators.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please select at least one facilitator'),
                ),
              );
              return;
            }

            // Navigate to the confirmation page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AssignmentConfirmationPage(
                  selectedFacilitators: selectedFacilitators,
                  serviceDetails: ServiceRequest(
                    name: widget.serviceDetails['name'],
                    location: widget.serviceDetails['location'],
                    service: widget.serviceDetails['service'],
                    timeType: widget.serviceDetails['timeType'] ?? 'scheduled',
                    timeText: widget.serviceDetails['timeText'],
                    scheduledText: widget.serviceDetails['scheduledText'],
                    destination: widget.serviceDetails['destination'],
                    countdown: '',
                  ),
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF000233),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Send Assignment Request',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepCircle(int step, bool completed, bool active) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active
            ? Colors.white
            : (completed ? const Color(0xFF000233) : Colors.white),
        border: Border.all(
          color: const Color(0xFF000233),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          step.toString(),
          style: TextStyle(
            color: active
                ? const Color(0xFF000233)
                : (completed ? Colors.white : const Color(0xFF000233)),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
