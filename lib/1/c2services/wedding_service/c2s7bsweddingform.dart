import 'package:flutter/material.dart';
import 'c2s8bsweddingform.dart';

class SummaryScreen extends StatefulWidget {
  final Map<String, String?> allDetails;

  const SummaryScreen({
    super.key,
    required this.allDetails,
  });

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool _termsAccepted = false;
  
  // Helper function to safely get string values from the map
  String _getSafeString(Map<String, String?> map, String key, [String defaultValue = '']) {
    final value = map[key];
    return value ?? defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A4A),
        elevation: 0,
        title: const Text(
          'Summary',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Wedding Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoSection([
                _buildInfoRow(
                  'Ceremony Type', 
                  _getSafeString(widget.allDetails, 'ceremonyType', 'Traditional'),
                ),
                _buildInfoRow(
                  'Wedding Date', 
                  _getSafeString(widget.allDetails, 'weddingDate', 'Not specified'),
                ),
                _buildInfoRow(
                  'Wedding Time', 
                  _getSafeString(widget.allDetails, 'weddingTime', 'Not specified'),
                ),
                _buildInfoRow(
                  'Venue Type', 
                  _getSafeString(widget.allDetails, 'venueType', 'Church'),
                ),
                _buildInfoRow(
                  'Location', 
                  _getSafeString(widget.allDetails, 'location', 'Not specified'),
                ),
              ]),
              
              const SizedBox(height: 24),
              
              const Text(
                'Couple Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoSection([
                _buildInfoRow(
                  'Bride\'s Name', 
                  _getSafeString(widget.allDetails, 'brideName', 'Not specified'),
                ),
                _buildInfoRow(
                  'Groom\'s Name', 
                  _getSafeString(widget.allDetails, 'groomName', 'Not specified'),
                ),
                _buildInfoRow(
                  'Estimated Guest Count', 
                  _getSafeString(widget.allDetails, 'guestCount', 'Not specified'),
                ),
                _buildInfoRow(
                  'Special Requests', 
                  _getSafeString(widget.allDetails, 'specialRequests', 'None'),
                ),
              ]),
              
              const SizedBox(height: 24),
              
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoSection([
                _buildInfoRow(
                  'Full Name', 
                  _getSafeString(widget.allDetails, 'name', 'Not specified'),
                ),
                _buildInfoRow(
                  'Age', 
                  _getSafeString(widget.allDetails, 'age', 'Not specified'),
                ),
                _buildInfoRow(
                  'Contact Number', 
                  _getSafeString(widget.allDetails, 'contact', 'Not specified'),
                ),
                _buildInfoRow(
                  'Email', 
                  _getSafeString(widget.allDetails, 'email', 'Not specified'),
                ),
              ]),
              
              const SizedBox(height: 24),
              
              const Text(
                'Emergency Contact',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoSection([
                _buildInfoRow(
                  'Name', 
                  _getSafeString(widget.allDetails, 'emergencyName', 'Not specified'),
                ),
                _buildInfoRow(
                  'Relationship', 
                  _getSafeString(widget.allDetails, 'emergencyRelationship', 'Not specified'),
                ),
                _buildInfoRow(
                  'Contact Number', 
                  _getSafeString(widget.allDetails, 'emergencyContact', 'Not specified'),
                ),
              ]),
              
              const SizedBox(height: 32),
              
              // Terms and conditions checkbox
              Row(
                children: [
                  Checkbox(
                    value: _termsAccepted,
                    onChanged: (value) {
                      setState(() {
                        _termsAccepted = value ?? false;
                      });
                    },
                    activeColor: const Color(0xFF0A0A4A),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _termsAccepted = !_termsAccepted;
                        });
                      },
                      child: const Text(
                        'I agree to the terms and conditions for booking a wedding service.',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF0A0A4A)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Color(0xFF0A0A4A),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _termsAccepted
                          ? () {
                              _showConfirmationDialog(context);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A0A4A),
                        disabledBackgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Begin Booking',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoSection(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
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
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.search, size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          'Find a Wedding Service',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Would you like to find a wedding service provider near your location?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF0A0A4A)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'No, I\'ll do it later',
                          style: TextStyle(
                            color: Color(0xFF0A0A4A),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Navigate to the searching screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchingScreen(
                                allDetails: Map<String, String>.from(
                                  widget.allDetails.map((key, value) => 
                                    MapEntry(key, value ?? '')
                                  )
                                ),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A0A4A),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Yes, find now',
                          style: TextStyle(
                            color: Colors.white,
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
}
