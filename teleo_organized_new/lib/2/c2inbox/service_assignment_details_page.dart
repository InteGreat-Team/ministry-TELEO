import 'package:flutter/material.dart';
import 'dart:async';

class ServiceAssignmentDetailsPage extends StatefulWidget {
  final String serviceName;
  final String requesterName;
  final String location;
  final String referenceNumber;
  final String dateTime;

  const ServiceAssignmentDetailsPage({
    super.key,
    required this.serviceName,
    required this.requesterName,
    required this.location,
    required this.referenceNumber,
    required this.dateTime,
  });

  @override
  State<ServiceAssignmentDetailsPage> createState() => _ServiceAssignmentDetailsPageState();
}

class _ServiceAssignmentDetailsPageState extends State<ServiceAssignmentDetailsPage> {
  // Track expanded/collapsed state for each section
  final Map<String, bool> _expandedSections = {
    'Personal Details': false,
    'Service Information': false,
  };
  
  // Timer variables
  late Timer _timer;
  int _secondsRemaining = 90; // 1 minute and 30 seconds
  bool _isAccepted = false;

  @override
  void initState() {
    super.initState();
    // Start the countdown timer
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel timer when page is disposed
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
          if (!_isAccepted) {
            _acceptAssignment(); // Auto-accept when timer reaches zero
          }
        }
      });
    });
  }

  void _acceptAssignment() {
    setState(() {
      _isAccepted = true;
    });
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Assignment accepted successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    
    // Navigate back to inbox after a delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Go back to inbox
    });
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          color: const Color(0xFF000233), // Navy blue color
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
                        'Assigned Service',
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
                      fontWeight: FontWeight.w600,
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
                        widget.referenceNumber,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Date
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
                      Row(
                        children: [
                          Text(
                            widget.dateTime,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
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
                        widget.serviceName,
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
                        widget.dateTime,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
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
                        widget.location,
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
                      const Text(
                        '@Lebron James',
                        style: TextStyle(
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

            // Collapsible sections - only Personal Details and Service Information
            _buildCollapsibleSection('Personal Details'),
            _buildCollapsibleSection('Service Information'),
            
            // Accept button with timer inside
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isAccepted ? null : _acceptAssignment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000233),
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isAccepted ? 'Accepted' : 'Accept',
                        style: TextStyle(
                          color: _isAccepted ? Colors.grey.shade700 : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (!_isAccepted) ...[
                        const SizedBox(width: 8),
                        Text(
                          "(${_formatTime(_secondsRemaining)})",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
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
        _buildDetailRow('Service Type', 'Baptism and Dedication'),
        _buildDetailRow('Duration', '2 hours'),
        _buildDetailRow('Number of Attendees', '5'),
        _buildDetailRow('Special Requests', 'Please bring holy water'),
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
