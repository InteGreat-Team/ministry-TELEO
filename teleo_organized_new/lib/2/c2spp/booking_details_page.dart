import 'package:flutter/material.dart';
import 'c2s3_service_approval_page.dart';
import '../c2inbox/cancel_reason.dart';

class BookingDetailsPage extends StatefulWidget {
  final String reference;
  final String requesterName;
  final String location;
  final String serviceType;
  final String date;
  final String time;
  final bool isScheduledForLater;
  final String venue;
  final String assignedTo;

  const BookingDetailsPage({
    super.key,
    this.reference = 'AJSNDFB934U9382RFIWB',
    this.requesterName = 'Service Requester Name',
    this.location = 'Default location where they\'re booking from',
    this.serviceType = 'Baptism and Dedication',
    this.date = '[Date]',
    this.time = '3:00 PM',
    this.isScheduledForLater = true,
    this.venue = 'To the church',
    this.assignedTo = '@Lebron James',
  });

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  // Track expanded/collapsed state for each section
  final Map<String, bool> _expandedSections = {
    'Personal Details': false,
    'Service Information': false,
    'Payment Details': false,
    'Amount Paid': false,
  };

  @override
  Widget build(BuildContext context) {
    // Define the exact color to ensure consistency
    const Color navyBlue = Color(0xFF000233);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          color: navyBlue,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Upcoming Services',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the header
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Details section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Booking Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Reference #:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        widget.reference,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Date:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${widget.date} at ${widget.time}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Service Requester Info
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile image
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Name and location
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.requesterName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          widget.location,
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
            ),

            // Service details
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  // Service type
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Service:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.serviceType,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Time
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Time:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.time,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (widget.isScheduledForLater)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6F4FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Scheduled for Later',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF0078D4),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.venue,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Assigned to
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Assigned to:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.assignedTo,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4A90E2),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Collapsible sections
            _buildCollapsibleSection('Personal Details'),
            _buildCollapsibleSection('Service Information'),
            _buildCollapsibleSection('Payment Details'),
            _buildCollapsibleSection('Amount Paid'),

            // Action buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: OutlinedButton(
                      onPressed: () {
                        // Navigate to ServiceApprovalPage when Reassign Facilitator is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ServiceApprovalPage(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF000233)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'Reassign Facilitator',
                        style: TextStyle(
                          color: Color(0xFF000233),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: OutlinedButton(
                      onPressed: () {
                        // Navigate to CancelReasonPage
                        _navigateToCancelReasonPage();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'Cancel Booking',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
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

  // Method to navigate to the CancelReasonPage
  void _navigateToCancelReasonPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CancelReasonPage(
          reference: widget.reference,
          requesterName: widget.requesterName,
          location: widget.location,
          serviceType: widget.serviceType,
          date: widget.date,
          time: widget.time,
          isScheduledForLater: widget.isScheduledForLater,
          venue: widget.venue,
          assignedTo: widget.assignedTo,
        ),
      ),
    );
  }

  Widget _buildCollapsibleSection(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _expandedSections[title] = !(_expandedSections[title] ?? false);
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  _expandedSections[title] ?? false
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          // Show content if expanded
          if (_expandedSections[title] ?? false)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sample content for each section
                  if (title == 'Personal Details')
                    _buildSamplePersonalDetails(),
                  if (title == 'Service Information')
                    _buildSampleServiceInformation(),
                  if (title == 'Payment Details') _buildSamplePaymentDetails(),
                  if (title == 'Amount Paid') _buildSampleAmountPaid(),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(color: Colors.grey.shade300),
          ),
        ],
      ),
    );
  }

  // Updated content for Personal Details section
  Widget _buildSamplePersonalDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Full Name', 'John G. Dela Cruz'),
        _buildDetailRow('Age', '27'),
        _buildDetailRow('Gender', 'Male'),
        _buildDetailRow('Contact Number', '09272948324'),
        _buildDetailRow('Email Address', 'johngdelacruz@gmail.com'),
        _buildDetailRow('Primary Emergency Person', 'Maria B. Dela Cruz'),
        _buildDetailRow('Primary Emergency Person Number', '0999999999'),
        _buildDetailRow('Primary Emergency Person Relation', 'Spouse'),
        const SizedBox(height: 8),
      ],
    );
  }

  // Updated content for Service Information section
  Widget _buildSampleServiceInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Event Booking', 'Event API stuff'),
        _buildDetailRow('Baptizand Full Name', 'Baby G. Dela Cruz'),
        _buildDetailRow('Date of Birth', '01/20/2025'),
        _buildDetailRow('Gender', 'Male'),
        _buildDetailRow('Type of Ceremony', 'Infant'),
        _buildDetailRow('Name of Parent/Guardian', 'John G. Dela Cruz'),
        _buildDetailRow('Relation to Baptizand', 'Father'),
        _buildDetailRow('Purpose/Reason for Service',
            'Our son is to be baptized into Christianity.'),
        _buildDetailRow('Anything else we need to know?',
            'Please assign Fr. Lebron James if available.'),
        const SizedBox(height: 8),
      ],
    );
  }

  // Updated content for Payment Details section
  Widget _buildSamplePaymentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F9ED),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Paid',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF00C853),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildDetailRow('Date', '[Date when paid]'),
        _buildDetailRow('Method', 'Credit Card'),
        _buildDetailRow('Holder\'s Full Name', 'Jack Black'),
        _buildDetailRow('Transaction ID', 'JSDBK-2893-2384'),
        const SizedBox(height: 8),
      ],
    );
  }

  // Updated content for Amount Paid section
  Widget _buildSampleAmountPaid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Service Fee', '200.00'),
        _buildDetailRow('Distance Fee (* per exceeding 1km)', '20.20'),
        _buildDetailRow('Total', '₱ 220.20'),
        _buildDetailRow('Transaction ID', 'JSDBK-2893-2384'),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
