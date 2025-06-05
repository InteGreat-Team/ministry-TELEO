import 'package:flutter/material.dart';

class ServiceRequestNotification extends StatefulWidget {
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback onClose;

  const ServiceRequestNotification({
    super.key,
    required this.onAccept,
    required this.onDecline,
    required this.onClose,
  });

  @override
  State<ServiceRequestNotification> createState() => _ServiceRequestNotificationState();
}

class _ServiceRequestNotificationState extends State<ServiceRequestNotification> {
  bool _showDetails = false;
  bool _isCollapsed = false;
  double _sliderPosition = 0.5; // 0.0 is fully left, 1.0 is fully right
  double _dragDistance = 0.0; // Track vertical drag distance

  // Toggle collapsed state
  void _toggleCollapsed() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        // Add vertical drag detection for collapsing
        onVerticalDragUpdate: (details) {
          setState(() {
            _dragDistance += details.delta.dy;
            // If dragged down more than 50 pixels, collapse the notification
            if (_dragDistance > 50 && !_isCollapsed) {
              _isCollapsed = true;
              _dragDistance = 0;
            }
            // If dragged up more than 50 pixels, expand the notification
            else if (_dragDistance < -50 && _isCollapsed) {
              _isCollapsed = false;
              _dragDistance = 0;
            }
          });
        },
        onVerticalDragEnd: (details) {
          setState(() {
            _dragDistance = 0;
          });
        },
        child: _isCollapsed ? _buildCollapsedView() : _buildExpandedView(),
      ),
    );
  }

  // Collapsed view (minimized notification)
  Widget _buildCollapsedView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top gray divider line
          Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 120, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                const Icon(
                  Icons.notifications,
                  color: Color(0xFF000233),
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'New Service Request Received',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000233),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Auto-declines text
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Auto-declines in (1:23)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),

// Progress line with linear gradient - with rounded corners
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2), // This controls the roundness of the corners
              child: Container(
                height: 2,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFCCD2CF), // Light gray
                      Color(0xFFE12D4C), // Red
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Expanded view (full notification)
  Widget _buildExpandedView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top gray divider line
          Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 120, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header with notification icon and title
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                const Icon(
                  Icons.notifications,
                  color: Color(0xFF000233),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'New Service Request Received',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000233),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Requester info
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Service Requester Name',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Default location where they\'re booking from',
                        style: TextStyle(
                          fontSize: 12,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Icon(Icons.favorite_border, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                const Text(
                  'Service: ',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Anointment & Healing Service',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Time
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                const Text(
                  'Time: ',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Fast Booking',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF2196F3),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Location
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on_outlined, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'To their location: Room 444, UST Hospital, Lacson, 1111',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Note
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              '"Please assign Fr. Lebron James if available"',
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade600,
              ),
            ),
          ),

          // View Details button with underline and red arrow
          Center(
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showDetails = !_showDetails;
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF000233),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _showDetails ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        size: 16,
                        color: const Color(0xFFE12D4C), // Using the exact red from the image
                      ),
                    ],
                  ),
                ),
                // Underline
                Container(
                  width: 100, // Slightly wider than the text
                  height: 1,
                  color: const Color(0xFFE12D4C), // Using the exact red from the image
                ),
              ],
            ),
          ),

          // Expanded details section
          if (_showDetails)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Additional details here
                  const Text(
                    'Additional Details',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 8),
                      const Text(
                        'Date: ',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      const Text(
                        'Today, 3:30 PM',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Auto-decline notice
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Auto-declines after timer expires',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),

          // Action bar with slidable timer and dynamic gradient
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SizedBox(
              height: 56,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  final timerWidth = 76.0;
                  final availableWidth = maxWidth - timerWidth;

                  // Calculate the left position for the timer based on slider position
                  final leftPosition = _sliderPosition * availableWidth;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Background gradient container with dynamic gradient based on slider position
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: const [
                              Color(0xFFCCD2CF), // Light gray
                              Color(0xFFE12D4C), // Deeper red
                            ],
                            stops: [_sliderPosition - 0.1, _sliderPosition + 0.1], // Dynamic stops based on slider position
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),

                      // DECLINE text
                      const Positioned(
                        left: 24,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: Text(
                            'DECLINE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),

                      // ACCEPT text
                      const Positioned(
                        right: 24,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: Text(
                            'ACCEPT',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),

                      // Left horizontal line - dynamically sized based on slider position
                      Positioned(
                        left: 90,
                        width: leftPosition - 90, // Dynamic width based on slider position
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: Container(
                            height: 1,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      // Right horizontal line - dynamically sized based on slider position
                      Positioned(
                        left: leftPosition + timerWidth,
                        right: 90,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: Container(
                            height: 1,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      // Slidable timer - positioned based on _sliderPosition
                      Positioned(
                        left: leftPosition,
                        top: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            setState(() {
                              // Calculate new position based on drag
                              final newPosition = _sliderPosition + (details.delta.dx / availableWidth);
                              // Clamp position between 0.0 and 1.0
                              _sliderPosition = newPosition.clamp(0.0, 1.0);

                              // Auto-collapse when slider is dragged far enough to the left (decline side)
                              if (_sliderPosition < 0.3 && !_isCollapsed) {
                                _isCollapsed = true;
                              }
                              // Auto-expand when slider is dragged back toward center or right
                              else if (_sliderPosition >= 0.3 && _isCollapsed) {
                                _isCollapsed = false;
                              }
                            });
                          },
                          onHorizontalDragEnd: (details) {
                            // If slid far enough to the right, accept
                            if (_sliderPosition > 0.7) {
                              widget.onAccept();
                            }
                            // If slid far enough to the left, decline
                            else if (_sliderPosition < 0.3) {
                              // Collapse notification when declined
                              widget.onDecline();
                              _toggleCollapsed();
                            }
                            // Otherwise, reset to center
                            else {
                              setState(() {
                                _sliderPosition = 0.5;
                              });
                            }
                          },
                          child: Center(
                            child: Container(
                              width: timerWidth,
                              height: 34,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(17),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Left chevrons
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: Text(
                                      "<<",
                                      style: TextStyle(
                                        color: const Color(0xFFE12D4C),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  // Timer text
                                  const Text(
                                    "1:23",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  // Right chevrons
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: Text(
                                      ">>",
                                      style: TextStyle(
                                        color: const Color(0xFFE12D4C),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}