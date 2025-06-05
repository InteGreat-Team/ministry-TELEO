import 'package:flutter/material.dart';

class AttendeeDetailPage extends StatefulWidget {
  final Map<String, dynamic> attendeeData;
  final Map<String, dynamic> eventData;

  const AttendeeDetailPage({
    super.key,
    required this.attendeeData,
    required this.eventData, required Map attendee,
  });

  @override
  State<AttendeeDetailPage> createState() => _AttendeeDetailPageState();
}

class _AttendeeDetailPageState extends State<AttendeeDetailPage> {
  // Track expanded sections
  bool _personalInfoExpanded = true;
  bool _registrationFormExpanded = true;
  bool _paymentDetailsExpanded = true;
  
  // Current image index for the image carousel
  int _currentImageIndex = 0;
  
  // Page controller for the image carousel
  late PageController _imagePageController;
  
  // Local copy of attendee data that can be modified
  late Map<String, dynamic> _attendeeData;
  
  @override
  void initState() {
    super.initState();
    _imagePageController = PageController();
    
    // Create a local copy of the attendee data
    _attendeeData = Map<String, dynamic>.from(widget.attendeeData);
  }
  
  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }
  
  // Get event images
  List<Map<String, dynamic>> get _eventImages {
    if (widget.eventData.containsKey('eventImages') && 
        widget.eventData['eventImages'] is List && 
        (widget.eventData['eventImages'] as List).isNotEmpty) {
      return List<Map<String, dynamic>>.from(widget.eventData['eventImages']);
    } else {
      // Fallback to single image if no eventImages array
      return [
        {
          'url': widget.eventData['imageUrl'] ?? 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-5ie8lHl9F4eq57TmKSu8zKV6fzmIHK.png',
          'label': 'Main Event Image',
          'isDefault': true
        }
      ];
    }
  }

  // Handle check-in action
  void _handleCheckIn() {
    // Update the status to CONFIRMED
    _attendeeData['status'] = 'CONFIRMED';
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Attendee checked in successfully')),
    );
    
    // Return to previous screen with updated data
    Navigator.pop(context, {'action': 'check-in', 'updatedAttendee': _attendeeData});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header with ONLY the cover photo and back button
          SizedBox(
            height: 180,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                PageView.builder(
                  controller: _imagePageController,
                  itemCount: _eventImages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final image = _eventImages[index];
                    return image.containsKey('file') && image['file'] != null
                        ? Image.file(
                            image['file'],
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            image['url'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFF6A1B9A),
                                      Color(0xFF0A0E3D),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                  },
                ),
                
                // Light gradient overlay for better visibility of UI elements
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                
                // Back button only
                SafeArea(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                
                // Image label
                if (_eventImages.length > 1)
                  Positioned(
                    top: 40,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _eventImages[_currentImageIndex]['label'] ?? 'Image ${_currentImageIndex + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                
                // Image indicators
                if (_eventImages.length > 1)
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_eventImages.length, (index) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentImageIndex == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                        );
                      }),
                    ),
                  ),
              ],
            ),
          ),
          
          // ATTENDEE DETAILS header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            width: double.infinity,
            color: Colors.white,
            child: const Center(
              child: Text(
                'ATTENDEE DETAILS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          
          // Divider
          const Divider(height: 1),
          
          // Attendee info and sections
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Attendee header with avatar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[300],
                          child: const Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _attendeeData['name'] ?? 'Alyssa Elona',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                _attendeeData['church'] != null 
                                    ? '${_attendeeData['church']} Member'
                                    : 'Grace Fellowship Member',
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
                  ),
                  
                  // Status and Date
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Status',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(_attendeeData['status']).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _attendeeData['status'] ?? 'PENDING',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: _getStatusColor(_attendeeData['status']),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Date',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _attendeeData['registrationDate'] ?? 'March 20, 2025',
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
                  ),
                  
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  
                  // Personal Information section
                  _buildExpandableSection(
                    title: 'Personal Information',
                    isExpanded: _personalInfoExpanded,
                    onTap: () {
                      setState(() {
                        _personalInfoExpanded = !_personalInfoExpanded;
                      });
                    },
                    content: _personalInfoExpanded ? _buildPersonalInfoContent() : null,
                  ),
                  
                  const Divider(height: 1),
                  
                  // Registration Form section
                  _buildExpandableSection(
                    title: 'Submitted Registration Form',
                    isExpanded: _registrationFormExpanded,
                    onTap: () {
                      setState(() {
                        _registrationFormExpanded = !_registrationFormExpanded;
                      });
                    },
                    content: _registrationFormExpanded ? _buildRegistrationFormContent() : null,
                  ),
                  
                  const Divider(height: 1),
                  
                  // Payment Details section
                  _buildExpandableSection(
                    title: 'Payment Details',
                    isExpanded: _paymentDetailsExpanded,
                    onTap: () {
                      setState(() {
                        _paymentDetailsExpanded = !_paymentDetailsExpanded;
                      });
                    },
                    content: _paymentDetailsExpanded ? _buildPaymentDetailsContent() : null,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Check-In button - only show for PENDING status
                  if (_attendeeData['status'] == 'PENDING' || _attendeeData['status'] == null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleCheckIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Check-In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to get color based on status
  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'CONFIRMED':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.orange; // Default to orange for PENDING
    }
  }
  
  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    Widget? content,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        if (content != null) content,
      ],
    );
  }
  
  Widget _buildPersonalInfoContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Email', _attendeeData['email'] ?? 'alyssa.elona@example.com'),
          _buildInfoRow('Phone', _attendeeData['phone'] ?? '+1 (555) 123-4567'),
          _buildInfoRow('Address', 'Manila, Philippines'),
          _buildInfoRow('Age', '28'),
          _buildInfoRow('Gender', 'Female'),
        ],
      ),
    );
  }
  
  Widget _buildRegistrationFormContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Submission Date', _attendeeData['registrationDate'] ?? 'March 15, 2025'),
          _buildInfoRow('Event Day', 'Day 1'),
          _buildInfoRow('Number of Attendees', '2'),
          _buildInfoRow('Special Requests', 'None'),
        ],
      ),
    );
  }
  
  Widget _buildPaymentDetailsContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Payment Method', 'Credit Card'),
          _buildInfoRow('Amount Paid', 'P400.00'),
          _buildInfoRow('Payment Date', 'March 15, 2025'),
          _buildInfoRow('Payment Status', 'Completed'),
          _buildInfoRow('Transaction ID', 'TXN-12345-67890'),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
