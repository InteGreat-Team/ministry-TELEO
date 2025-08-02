import 'dart:async';
import 'package:flutter/material.dart';
import '../c2inbox/service_accepted_page.dart';
import 'models/service_request_model.dart';
import 'models/facilitator_model.dart';

class AssignmentConfirmationPage extends StatefulWidget {
  final List<String> selectedFacilitators;
  final ServiceRequest serviceDetails;

  const AssignmentConfirmationPage({
    super.key,
    required this.selectedFacilitators,
    required this.serviceDetails,
  });

  @override
  State<AssignmentConfirmationPage> createState() =>
      _AssignmentConfirmationPageState();
}

class _AssignmentConfirmationPageState
    extends State<AssignmentConfirmationPage> {
  Timer? _timer;
  final Color navyBlue = const Color(0xFF000233);

  @override
  void initState() {
    super.initState();

    // Start a timer to simulate a facilitator accepting after 5 seconds
    _timer = Timer(const Duration(seconds: 5), () {
      // Navigate to the service accepted page
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceAcceptedPage(
              serviceDetails: widget.serviceDetails,
              facilitatorDetails: Facilitator(
                name: 'Lebron James',
                role: 'Pastor',
                status: 'Available',
                isAvailable: true,
                isActive: true,
              ),
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // COMPLETELY REPLACED: Custom app bar implementation
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: Container(
          color: navyBlue, // Fixed navy blue color
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  // Title
                  const Text(
                    'Service Requests',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Empty space to balance the layout
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Step indicator
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 20.0),
                    child: Row(
                      children: [
                        _buildStepCircle(1, true, false),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: Colors.black,
                          ),
                        ),
                        _buildStepCircle(2, false, false),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: Colors.black,
                          ),
                        ),
                        _buildStepCircle(3, true, true),
                      ],
                    ),
                  ),

                  // Illustrations - Made larger and removed horizontal padding
                  Image.asset(
                    'assets/images/assign_service_illustration.JPG',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 20),

                  // Sent to facilitators text
                  Text(
                    'Sent to (${widget.selectedFacilitators.length}) Facilitators',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: navyBlue,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // On hold text
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      'The service request is on hold until a facilitator accepts.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Service request summary card - FIXED OVERFLOW
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
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
                            decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: const BorderRadius.only(
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
                                              widget.serviceDetails.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              widget.serviceDetails.location,
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
                                          widget.serviceDetails.service,
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

                                  // Time - Fixed overflow
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
                                            widget.serviceDetails.timeText,
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
                                          widget.serviceDetails.scheduledText ??
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

                                  // Location - Fixed overflow
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 2.0),
                                        child: Icon(Icons.location_on_outlined,
                                            size: 18, color: Colors.grey[600]),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.serviceDetails.destination,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '"Please assign Fr. Lebron James if available"',
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

                  // Waiting text
                  const Text(
                    'Waiting for someone to accept...',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Hourglass icon
                  const Icon(
                    Icons.hourglass_empty,
                    size: 40,
                    color: Colors.grey,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom section
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Undo button
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: OutlinedButton(
                  onPressed: () {
                    // Go back to the previous screen
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: navyBlue),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Undo Assignment Request',
                    style: TextStyle(
                      color: navyBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step, bool completed, bool active) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? Colors.white : (completed ? navyBlue : Colors.white),
        border: Border.all(
          color: navyBlue,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          step.toString(),
          style: TextStyle(
            color: active ? navyBlue : (completed ? Colors.white : navyBlue),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}