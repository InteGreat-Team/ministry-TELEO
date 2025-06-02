import 'package:flutter/material.dart';
import '../c2spp/c2s2_edit_service_page.dart';

class CancellationRequestPage extends StatefulWidget {
  final String serviceName;
  final String requesterName;
  final String location;
  final String reference;
  final String date;
  final String time;
  final String assignedTo;
  final String cancelReason;
  final String feedback;

  const CancellationRequestPage({
    super.key,
    required this.serviceName,
    required this.requesterName,
    required this.location,
    this.reference = 'AJSNDFB934U9382RFIWB',
    this.date = '[Date]',
    this.time = 'May 5, 3:00 PM',
    this.assignedTo = '@Lebron James',
    this.cancelReason = 'Family Emergency',
    this.feedback = 'Too much going on right now',
  });

  @override
  State<CancellationRequestPage> createState() =>
      _CancellationRequestPageState();
}

class _CancellationRequestPageState extends State<CancellationRequestPage> {
  // Track expanded/collapsed state for each section
  final Map<String, bool> _expandedSections = {
    'Personal Details': false,
    'Service Information': false,
    'Payment Details': false,
    'Amount Paid': false,
  };

  // Add status variables
  String _status = 'PENDING APPROVAL';
  Color _statusColor = const Color(0xFFFF9800);
  Color _statusBgColor = const Color(0xFFFFF3E0);
  bool _isRejected = false;

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_ios, size: 12, color: Colors.black),
                      SizedBox(width: 4),
                      Text(
                        'Back',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Cancellation Request section with red left border
            Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: const Border(
                  left: BorderSide(color: Colors.red, width: 4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cancellation Request',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Status',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _statusBgColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            _status,
                            style: TextStyle(
                              fontSize: 12,
                              color: _statusColor,
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
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const Text(
                          'Service Requester',
                          style: TextStyle(fontSize: 14),
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
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          '${widget.date} at [Time]',
                          style: const TextStyle(fontSize: 14),
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
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          widget.cancelReason,
                          style: const TextStyle(fontSize: 14),
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
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Flexible(
                          child: Text(
                            widget.feedback,
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Action buttons - show only if not rejected
                    if (!_isRejected)
                      Row(
                        children: [
                          // Reject Request button
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // Show rejection confirmation dialog
                                _showRejectConfirmationDialog(context);
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFF000233),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: const Text(
                                'Reject Request',
                                style: TextStyle(
                                  color: Color(0xFF000233),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Approve Cancellation button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Show confirmation dialog
                                _showCancelConfirmationDialog(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF000233),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: const Text(
                                'Approve Cancellation',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                    // Show rejection timestamp if rejected
                    if (_isRejected)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Rejected on ${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')} ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Booking Details section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Booking Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  // Reference #
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Reference #:',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        widget.reference,
                        style: const TextStyle(fontSize: 14),
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
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(widget.date, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),

            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Divider(color: Colors.grey.shade300),
            ),

            // Service Requester Info
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
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
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.serviceName,
                        style: const TextStyle(fontSize: 14),
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
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(width: 4),
                      Text(widget.time, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
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
                      const Text(
                        'To the church',
                        style: TextStyle(fontSize: 14),
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
                        style: TextStyle(fontSize: 14, color: Colors.grey),
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

            // Reassign Facilitator button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: OutlinedButton(
                  onPressed: () {
                    // Navigate to the service approval page for reassigning facilitator
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ServiceApprovalPage(
                          serviceName: widget.serviceName,
                          requesterName: widget.requesterName,
                          location: widget.location,
                          date: widget.date,
                          time: widget.time,
                          assignedTo: widget.assignedTo.replaceAll(
                            '@',
                            '',
                          ), // Remove @ symbol if present
                        ),
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
            ),
          ],
        ),
      ),
    );
  }

  // Method to show the reject confirmation dialog
  void _showRejectConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button at top right
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                ),

                // Warning icon
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 48,
                  color: Color(0xFFCCCCCC),
                ),
                const SizedBox(height: 16),

                // Title
                const Text(
                  'Reject Request',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // Message
                const Text(
                  'Are you sure you want to reject this cancellation request?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    // No button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF000233)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'No',
                          style: TextStyle(
                            color: Color(0xFF000233),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Yes, proceed button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Close dialog and update status to rejected
                          Navigator.of(context).pop();
                          setState(() {
                            _status = 'REQUEST REJECTED';
                            _statusColor = Colors.red;
                            _statusBgColor = const Color(0xFFFFEBEE);
                            _isRejected = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF000233),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Yes, proceed',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
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
  }

  // Method to show the cancel confirmation dialog
  void _showCancelConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button at top right
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                ),

                // Warning icon
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 48,
                  color: Color(0xFFCCCCCC),
                ),
                const SizedBox(height: 16),

                // Title
                const Text(
                  'Cancel Booking',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // Message
                const Text(
                  'Are you sure you want to approve this service booking cancellation request?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    // No button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF000233)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'No',
                          style: TextStyle(
                            color: Color(0xFF000233),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Yes, proceed button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Close dialog and handle approval
                          Navigator.of(context).pop();
                          // You can add additional logic here for what happens after approval
                          Navigator.of(
                            context,
                          ).pop(); // Return to previous screen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF000233),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Yes, proceed',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
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
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
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
        _buildDetailRow('Service Type', 'Home Blessing and Cleansing'),
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
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceApprovalPage extends StatelessWidget {
  final String serviceName;
  final String requesterName;
  final String location;
  final String date;
  final String time;
  final String assignedTo;

  const ServiceApprovalPage({
    Key? key,
    required this.serviceName,
    required this.requesterName,
    required this.location,
    required this.date,
    required this.time,
    required this.assignedTo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Service Approval')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Service Name: $serviceName'),
            Text('Requester Name: $requesterName'),
            Text('Location: $location'),
            Text('Date: $date'),
            Text('Time: $time'),
            Text('Assigned To: $assignedTo'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
