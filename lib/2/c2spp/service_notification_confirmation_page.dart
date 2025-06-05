import 'package:flutter/material.dart';
import 'dart:async';
import '../c2inbox/service_booking_confirmation_receipt.dart';

class ServiceNotificationConfirmationPage extends StatefulWidget {
  final Map<String, dynamic> serviceDetails;
  final Map<String, dynamic> facilitatorDetails;

  const ServiceNotificationConfirmationPage({
    super.key,
    required this.serviceDetails,
    required this.facilitatorDetails,
  });

  @override
  State<ServiceNotificationConfirmationPage> createState() =>
      _ServiceNotificationConfirmationPageState();
}

class _ServiceNotificationConfirmationPageState
    extends State<ServiceNotificationConfirmationPage> {
  bool _isBookingConfirmed = false;

  // Simulate booking confirmation after a delay
  void _simulateBookingConfirmation() {
    // Simulate network delay
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isBookingConfirmed = true;
        });

        // Automatically navigate to receipt page after a short delay
        Timer(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ServiceBookingConfirmationReceipt(
                  serviceDetails: widget.serviceDetails,
                  personalDetails: _personalDetails,
                  paymentDetails: _paymentDetails,
                ),
              ),
            );
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Auto-simulate booking confirmation after delay
    _simulateBookingConfirmation();
  }

  // Sample data for the receipt page
  Map<String, dynamic> get _personalDetails => {
        'fullName': 'John G. Dela Cruz',
        'age': '27',
        'gender': 'Male',
        'contactNumber': '09272944324',
        'emailAddress': 'johngdelacruz@gmail.com',
        'emergencyPerson': 'Maria B. Dela Cruz',
        'emergencyNumber': '0999999999',
        'emergencyRelation': 'Spouse',
      };

  Map<String, dynamic> get _paymentDetails => {
        'status': 'Paid',
        'date': '[Date when paid]',
        'method': 'Credit Card',
        'holderName': 'Jack Black',
        'transactionId': 'JSDBK-2893-2384',
        'serviceFee': '200.00',
        'distanceFee': '20.20',
        'total': '220.20',
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF000233),
        centerTitle: true,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: Container(color: const Color(0xFF000233)),
        title: const Text(
          'Service Requests',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Progress indicator - UPDATED to match the image exactly
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Step 1 - Inactive (white with blue border and text)
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFF000233),
                          width: 1,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "1",
                          style: TextStyle(
                            color: Color(0xFF000233),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                    // Line between 1 and 2 - Thin black line
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.black,
                      ),
                    ),

                    // Step 2 - Active (blue background with white text)
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF000233),
                      ),
                      child: const Center(
                        child: Text(
                          "2",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                    // Line between 2 and 3 - Thin black line
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.black,
                      ),
                    ),

                    // Step 3 - Inactive (white with blue border and text)
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFF000233),
                          width: 1,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "3",
                          style: TextStyle(
                            color: Color(0xFF000233),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Main content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Service Booking in Progress title
                    const Text(
                      'Service Booking in Progress...',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Notification Sent section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Green envelope icon with checkmark
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CustomPaint(
                            painter: EnvelopeWithCheckmarkPainter(),
                          ),
                        ),

                        const SizedBox(width: 15),

                        // Notification text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Notification Sent!',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'The requester has been notified about the assigned facilitator.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Facilitator info with Reassign button
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left side: Avatar and info
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Profile image
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.grey[300],
                              ),
                              const SizedBox(width: 12),

                              // Name, role and acceptance info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.facilitatorDetails['name'] ??
                                          'Lebron James',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      widget.facilitatorDetails['role'] ??
                                          'Pastor',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            'Accepted on: ${widget.facilitatorDetails['acceptedDate'] ?? '[Date]'} at ${widget.facilitatorDetails['acceptedTime'] ?? '[Time]'}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
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

                        // Right side: Reassign button
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Reassign\nFacilitator',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // Service request summary card
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Pink left border
                            Container(
                              width: 8,
                              decoration: const BoxDecoration(
                                color: Colors.pink,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                              ),
                            ),

                            // Card content
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Service requestor info
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 22,
                                          backgroundColor: Colors.grey[300],
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.serviceDetails['name'] ??
                                                    'Service Requestor Name',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                widget.serviceDetails[
                                                        'location'] ??
                                                    'Default location where theyre booking from',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 13,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),

                                    // Service type
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.favorite_border,
                                            size: 18, color: Colors.grey[600]),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Service: ',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            widget.serviceDetails['service'] ??
                                                'Baptism and Dedication',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),

                                    // Time
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: 8,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.access_time,
                                                size: 18,
                                                color: Colors.grey[600]),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Time: ',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              widget.serviceDetails[
                                                      'timeText'] ??
                                                  'May 5, 3:00 PM',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.blue[50],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            widget.serviceDetails[
                                                    'scheduledText'] ??
                                                'Scheduled for Later',
                                            style: TextStyle(
                                              color: Colors.blue[400],
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),

                                    // Location
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Icon(
                                              Icons.location_on_outlined,
                                              size: 18,
                                              color: Colors.grey[600]),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.serviceDetails[
                                                        'destination'] ??
                                                    'To the church',
                                                style: const TextStyle(
                                                    fontSize: 14),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '"${widget.serviceDetails['specialRequest'] ?? 'Please assign Fr. Lebron James if available'}"',
                                                style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 13,
                                                  color: Colors.grey[500],
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
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

                    const SizedBox(height: 20),

                    // Confirmation message - EXACTLY as in the second image
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'The requester needs to confirm the booking.\nThis may involve additional steps on their end.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                        height:
                            40), // Increased space after confirmation message

                    // UPDATED: Simple gray hourglass icon
                    if (!_isBookingConfirmed)
                      Icon(
                        Icons.hourglass_empty,
                        size: 40,
                        color: Colors.grey[500],
                      ),

                    const SizedBox(
                        height: 50), // Increased space after hourglass

                    // Waiting for confirmation button - EXACTLY as in the second image
                    if (!_isBookingConfirmed)
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'Waiting for Requester\'s Confirmation...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),

                    // Status message when booking is confirmed (instead of button)
                    if (_isBookingConfirmed)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Center(
                          child: Text(
                            'Booking confirmed! Opening receipt...',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
      ),
    );
  }

  // Helper method to build step circle - UPDATED to match the image
  Widget _buildStepCircle(int step, bool isActive) {
    if (step == 1) {
      // Step 1: White background with black number and black outline
      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: Colors.black,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            step.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      );
    } else if (step == 2) {
      // Step 2: Navy blue background with white number
      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF000233), // Navy blue
          border: Border.all(
            color: const Color(0xFF000233),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            step.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      );
    } else {
      // Step 3: White background with black number and black outline
      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: Colors.black,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            step.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      );
    }
  }

  // Helper method to build step line - UPDATED to match the image
  Widget _buildStepLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 1.5,
        color: Colors.black,
        margin: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }
}

// Custom painter to draw the envelope with checkmark icon
class EnvelopeWithCheckmarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw envelope
    final RRect envelope = RRect.fromRectAndRadius(
      Rect.fromLTWH(2, 8, size.width - 4, size.height - 16),
      Radius.circular(2),
    );
    canvas.drawRRect(envelope, paint);

    // Draw envelope flap (X shape)
    final Path path = Path();
    path.moveTo(2, 8);
    path.lineTo(size.width / 2, size.height / 2);
    path.lineTo(size.width - 2, 8);

    path.moveTo(2, size.height - 8);
    path.lineTo(size.width / 2, size.height / 2);
    path.lineTo(size.width - 2, size.height - 8);

    canvas.drawPath(path, paint);

    // Draw checkmark circle
    final Paint circlePaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width - 10, size.height - 10),
      8,
      circlePaint,
    );

    // Draw checkmark
    final Paint checkPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final Path checkPath = Path();
    checkPath.moveTo(size.width - 14, size.height - 10);
    checkPath.lineTo(size.width - 10, size.height - 6);
    checkPath.lineTo(size.width - 6, size.height - 14);

    canvas.drawPath(checkPath, checkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
