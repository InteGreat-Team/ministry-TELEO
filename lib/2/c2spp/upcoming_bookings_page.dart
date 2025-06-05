import 'package:flutter/material.dart';

class UpcomingBookingsPage extends StatefulWidget {
  final String reference;
  final String requesterName;
  final String location;
  final String serviceType;
  final String date;
  final String time;
  final bool isScheduledForLater;
  final String venue;
  final String assignedTo;
  final String cancelReason;
  final String feedback;
  final String cancelledBy;
  final String cancelledDate;

  const UpcomingBookingsPage({
    super.key,
    this.reference = 'AJSNDFB934U9382RFIWB',
    this.requesterName = 'Service Requester Name',
    this.location = 'Default location where they\'re booking from',
    this.serviceType = 'Baptism and Dedication',
    this.date = '[Date]',
    this.time = 'May 5, 3:00 PM',
    this.isScheduledForLater = true,
    this.venue = 'To the church',
    this.assignedTo = '@Lebron James',
    this.cancelReason = 'Unavailable Facilitator',
    this.feedback = 'Sorry, Fr. Lebron is too busy.',
    this.cancelledBy = 'Church Name - Church Admin',
    this.cancelledDate = '[Date] at [Time]',
  });

  @override
  State<UpcomingBookingsPage> createState() => _UpcomingBookingsPageState();
}

class _UpcomingBookingsPageState extends State<UpcomingBookingsPage> {
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
                        'Upcoming Bookings',
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
            // Back button
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  '< Back',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // Cancellation Details section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cancellation Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF000233),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEB),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'CANCELLED BOOKING',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Cancelled by
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Cancelled by',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        widget.cancelledBy,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Cancelled date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Cancelled date',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        widget.cancelledDate,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Cancel Reason
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Cancel Reason',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        widget.cancelReason,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Feedback
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Feedback',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          widget.feedback,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(color: Colors.grey.shade300),
            ),

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
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF000233),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Reference #
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
                  const SizedBox(height: 8),

                  // Booking Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Booking Date',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        widget.date,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(color: Colors.grey.shade300),
            ),

            // Service Requester Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
          ],
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                  if (title == 'Payment Details')
                    _buildSamplePaymentDetails(),
                  if (title == 'Amount Paid')
                    _buildSampleAmountPaid(),
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

  // Sample content for each collapsible section
  Widget _buildSamplePersonalDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Full Name', 'John Doe'),
        _buildDetailRow('Email', 'johndoe@example.com'),
        _buildDetailRow('Phone', '+1 234 567 8900'),
        _buildDetailRow('Address', '123 Main St, Anytown, USA'),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSampleServiceInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Service Type', widget.serviceType),
        _buildDetailRow('Duration', '2 hours'),
        _buildDetailRow('Number of Attendees', '5'),
        _buildDetailRow('Special Requests', 'Please bring holy water'),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSamplePaymentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Payment Method', 'Credit Card'),
        _buildDetailRow('Card Number', '**** **** **** 4242'),
        _buildDetailRow('Transaction ID', 'TXN123456789'),
        _buildDetailRow('Payment Status', 'Paid'),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSampleAmountPaid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Service Fee', '\$50.00'),
        _buildDetailRow('Tax', '\$5.00'),
        _buildDetailRow('Total Amount', '\$55.00'),
        _buildDetailRow('Refundable Amount', '\$55.00'),
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
