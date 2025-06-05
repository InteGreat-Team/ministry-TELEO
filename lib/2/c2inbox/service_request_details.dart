// File: service_request_details.dart
import 'package:flutter/material.dart';
import 'service_assignment_page.dart'; // Import the new assignment page

class ServiceRequestDetailsPage extends StatefulWidget {
  final Map<String, dynamic> requestData;

  const ServiceRequestDetailsPage({
    super.key,
    required this.requestData,
  });

  @override
  State<ServiceRequestDetailsPage> createState() => _ServiceRequestDetailsPageState();
}

class _ServiceRequestDetailsPageState extends State<ServiceRequestDetailsPage> {
  bool _isPersonalDetailsExpanded = false;
  bool _isServiceInfoExpanded = false; // Added state for Service Information section

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF000233), // Dark navy
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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text('Back'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  side: const BorderSide(color: Colors.black38),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),

            // Service requestor info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile image
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
                          widget.requestData['name'] ?? 'Service Requestor Name',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.requestData['location'] ?? 'Default location where theyre booking from',
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
            ),

            const SizedBox(height: 16),

            // Service with heart icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
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
                      widget.requestData['service'] ?? 'Baptism and Dedication',
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
            ),

            const SizedBox(height: 12),

            // Time with icon and tag
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
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
                    padding: const EdgeInsets.only(left: 26), // Same as icon width + spacing
                    child: Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          widget.requestData['timeType'] == 'fast' ? 'Fast Booking' : (widget.requestData['timeText'] ?? 'May 5, 3:00 PM'),
                          style: TextStyle(
                            fontSize: 14,
                            color: widget.requestData['timeType'] == 'fast' ? const Color(0xFF2196F3) : const Color(0xFF333333),
                          ),
                        ),
                        if (widget.requestData['timeType'] != 'fast' && widget.requestData['scheduledText'] != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD), // Light blue background
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              widget.requestData['scheduledText'] ?? 'Scheduled for Later',
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
            ),

            const SizedBox(height: 12),

            // Location with icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
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
                      'To your location: ${widget.requestData['destination'] ?? 'To the church'}',
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
            ),

            // Note about priest assignment
            Padding(
              padding: const EdgeInsets.only(left: 42, top: 4, right: 16),
              child: Text(
                '"Please assign Fr. Lebron James if available"',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade600,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Personal Details expandable section - UPDATED to use GestureDetector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector( // Changed from InkWell to GestureDetector
                onTap: () {
                  setState(() {
                    _isPersonalDetailsExpanded = !_isPersonalDetailsExpanded;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Personal Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Icon(
                      _isPersonalDetailsExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ),

            // Personal Details expanded content
            if (_isPersonalDetailsExpanded) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Personal Details fields
                    _buildInfoRow('Full Name', 'John G. Dela Cruz'),
                    _buildInfoRow('Age', '32'),
                    _buildInfoRow('Gender', 'Male'),
                    _buildInfoRow('Contact Number', '09272348324'),
                    _buildInfoRow('Email Address', 'johngdelacrutz@gmail.com'),
                    _buildInfoRow('Primary Emergency Person', 'Maria B. Dela Cruz'),
                    _buildInfoRow('Primary Emergency Person Number', '09999999999'),
                    _buildInfoRow('Primary Emergency Person Relation', 'Spouse'),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Service Information section - UPDATED to be collapsible
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector( // Using GestureDetector to avoid highlight
                onTap: () {
                  setState(() {
                    _isServiceInfoExpanded = !_isServiceInfoExpanded;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Service Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Icon(
                      _isServiceInfoExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ),

            // Service Information expanded content
            if (_isServiceInfoExpanded) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service information fields
                    _buildInfoRow('Event Booking', 'Fast Booking', 'Event API stuff'),
                    _buildInfoRow('Baptizand Full Name', 'Baby G. Dela Cruz'),
                    _buildInfoRow('Date of Birth', '01/20/2025'),
                    _buildInfoRow('Gender', 'Male'),
                    _buildInfoRow('Type of Ceremony', 'Infant'),
                    _buildInfoRow('Name of Parent/Guardian', 'John G. Dela Cruz'),
                    _buildInfoRow('Relation to Baptizand', 'Father'),
                    _buildInfoRow('Purpose/Reason for Service', 'Our son is to be baptized into Christianity.'),

                    const SizedBox(height: 12),
                    Text(
                      'Anything else we need to know?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Please assign Fr. Lebron James if available.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Action buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Reject button
                  Expanded(
                    child: Container(
                      height: 48,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF000233), // Dark navy border
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Reject',
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
                      height: 48,
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF000233), // Dark navy background
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {
                          // Navigate to the service assignment page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServiceAssignmentPage(
                                serviceDetails: {
                                  'name': widget.requestData['name'] ?? 'Service Requestor Name',
                                  'location': widget.requestData['location'] ?? 'Default location where theyre booking from',
                                  'service': widget.requestData['service'] ?? 'Baptism and Dedication',
                                  'timeType': widget.requestData['timeType'],
                                  'timeText': widget.requestData['timeText'] ?? 'May 5, 3:00 PM',
                                  'scheduledText': widget.requestData['scheduledText'] ?? 'Scheduled for Later',
                                  'destination': widget.requestData['destination'] ?? 'To the church',
                                  'note': 'Please assign Fr. Lebron James if available',
                                },
                              ),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Accept',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, [String? rightValue]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
          ),
          if (rightValue != null)
            Expanded(
              flex: 2,
              child: Text(
                rightValue,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
                textAlign: TextAlign.right,
              ),
            ),
        ],
      ),
    );
  }
}
