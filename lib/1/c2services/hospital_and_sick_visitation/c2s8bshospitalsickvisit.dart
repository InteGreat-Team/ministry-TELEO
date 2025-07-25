import 'package:flutter/material.dart';
import 'dart:async';
import 'c2s9_1bshospitalsickvisit.dart';

class SearchingScreen extends StatefulWidget {
  final Map<String, String> allDetails;

  const SearchingScreen({
    super.key,
    required this.allDetails,
  });

  @override
  State<SearchingScreen> createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen> {
  bool _showDetails = false;
  Timer? _searchTimer;
  double _sheetHeight = 0.25; // Initial height
  
  @override
  void initState() {
    super.initState();
    
    // Show details after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showDetails = true;
        });
      }
    });
    
    // Simulate search completion after 5 seconds
    _searchTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        // Navigate to found screen (you can change this to no_churches_screen for testing)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FoundScreen(allDetails: widget.allDetails),
          ),
        );
      }
    });
  }
  
  @override
  void dispose() {
    _searchTimer?.cancel();
    super.dispose();
  }

  // Function to update the sheet height
  void _updateSheetHeight(double delta) {
    setState(() {
      _sheetHeight = (_sheetHeight + delta).clamp(0.1, 0.8);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A4A),
        elevation: 0,
        title: const Text(
          'Searching...',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: TextButton.icon(
          onPressed: () {
            _showBackToMenuDialog(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 14,
          ),
          label: const Text(
            'Back',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        leadingWidth: 70,
      ),
      body: Stack(
        children: [
          // Map and search elements
          Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    // Map placeholder
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.grey[200],
                      child: Image.asset(
                        'assets/map_placeholder.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.map,
                              size: 100,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    
                    // Center location marker
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A0A4A),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                          // Shadow below the marker
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Search radius circle
                    Center(
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF0A0A4A).withOpacity(0.2),
                          border: Border.all(
                            color: const Color(0xFF0A0A4A).withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    
                    // Hospital icons (placeholders)
                    Positioned(
                      top: 150,
                      left: 100,
                      child: _buildHospitalIcon(),
                    ),
                    Positioned(
                      top: 200,
                      right: 120,
                      child: _buildHospitalIcon(),
                    ),
                    Positioned(
                      bottom: 180,
                      left: 80,
                      child: _buildHospitalIcon(),
                    ),
                    Positioned(
                      bottom: 220,
                      right: 90,
                      child: _buildHospitalIcon(),
                    ),
                    Positioned(
                      top: 300,
                      right: 180,
                      child: _buildHospitalIcon(),
                    ),
                    Positioned(
                      bottom: 300,
                      left: 180,
                      child: _buildHospitalIcon(),
                    ),
                    
                    // Loading indicator at bottom
                    Positioned(
                      bottom: 120,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 100,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const LinearProgressIndicator(
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A0A4A)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Custom bottom sheet with draggable handle
          if (_showDetails)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * _sheetHeight,
              child: Column(
                children: [
                  // Custom draggable handle
                  GestureDetector(
                    onVerticalDragUpdate: (details) {
                      // Convert the drag delta to a fraction of screen height
                      double delta = -details.delta.dy / MediaQuery.of(context).size.height;
                      _updateSheetHeight(delta);
                    },
                    child: Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Content container
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/hospital_visit_image.png',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 60,
                                          height: 60,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.local_hospital, color: Colors.grey),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.allDetails['serviceType'] ?? 'Hospital and Sick Visitation',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Schedule: April 18, 2025 - 9:30 AM',
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.location_on, size: 14, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                'St. Luke\'s Medical Center, Sample Street 12, Brgy. 222, City, 1011',
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 12,
                                                ),
                                                maxLines: 2,
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
                            
                            const Divider(height: 24),
                            
                            // Only show additional details if expanded enough
                            if (_sheetHeight > 0.3) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Service Details',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    
                                    // Updated to match hospital and sick visitation details
                                    _buildDetailRow('Sick Person\'s Name', widget.allDetails['sickPersonName'] ?? 'John Doe'),
                                    _buildDetailRow('Age', widget.allDetails['sickPersonAge'] ?? '45'),
                                    _buildDetailRow('Relation to Sick Person', widget.allDetails['relationToSickPerson'] ?? 'Relative'),
                                    _buildDetailRow('Prayer Session Type', widget.allDetails['prayerSessionType'] ?? 'Private'),
                                    _buildDetailRow('Purpose/Reason for Service', widget.allDetails['reasonForService'] ?? 'Patient is recovering from surgery and requested spiritual support.'),
                                    if (widget.allDetails['additionalInfo']?.isNotEmpty == true)
                                      _buildDetailRow('Additional Information', widget.allDetails['additionalInfo'] ?? 'Patient prefers evening visits.'),
                                    
                                    const SizedBox(height: 24),
                                    
                                    // Cancel button
                                    ElevatedButton(
                                      onPressed: () {
                                        _showCancelSearchDialog(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF0A0A4A),
                                        minimumSize: const Size(double.infinity, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        'Cancel Search',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildHospitalIcon() {
    return Container(
      width: 35, // Slightly bigger
      height: 35, // Slightly bigger
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.local_hospital,
          color: Color(0xFF0A4A8F), // Changed to blue
          size: 22, // Slightly bigger
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Dialog methods remain the same
  void _showBackToMenuDialog(BuildContext context) {
    // Implementation remains the same
  }
  
  void _showCancelSearchDialog(BuildContext context) {
    // Implementation remains the same
  }
}