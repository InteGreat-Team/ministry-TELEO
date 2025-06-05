import 'package:flutter/material.dart';
import '../widgets/step_indicator.dart';
import 'c2s8bsprayerrequest.dart';

class SummaryScreen extends StatefulWidget {
  final Map<String, String> allDetails;

  const SummaryScreen({
    super.key,
    required this.allDetails,
  });

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  // Add state for checkbox
  bool _isTermsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Prayer Request',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: TextButton.icon(
          onPressed: () {
            Navigator.pop(context);
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
        ),
        leadingWidth: 80,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0A0A4A),
        ),
        child: Column(
          children: [
            const SizedBox(height: 90),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const StepIndicator(currentStep: 5, totalSteps: 7),
                        const SizedBox(height: 20),
                        
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Your ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: 'Summary',
                                style: TextStyle(
                                  color: Color(0xFF0A0A4A),
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Check and go back to make some edits.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Service Information
                        const Text(
                          'Service Information',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        _buildInfoRow(
                          'Service Type', 
                          'Prayer Request',
                        ),
                        _buildInfoRow(
                          'Prayer Topic', 
                          widget.allDetails['prayerTopic'] ?? 'Not specified',
                        ),
                        _buildInfoRow(
                          'Preferred Prayer Time', 
                          widget.allDetails['preferredPrayerTime'] ?? 'Not specified',
                        ),
                        _buildInfoRow(
                          'Privacy Option', 
                          widget.allDetails['privacyOption'] ?? 'Not specified',
                        ),
                        _buildInfoRow('Location', 'Current Location'),
                        
                        const SizedBox(height: 24),
                        const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                        const SizedBox(height: 24),
                        
                        // Changed to "Recipient's Information"
                        const Text(
                          'Recipient\'s Information',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        _buildInfoRow(
                          'Full Name', 
                          widget.allDetails['recipientName'] ?? 'Not specified',
                        ),
                        _buildInfoRow(
                          'Relation to Recipient', 
                          widget.allDetails['relationToRecipient'] ?? 'Not specified',
                        ),
                        _buildInfoRow(
                          'Purpose/Reason', 
                          widget.allDetails['reasonForService'] ?? 'Not specified',
                        ),
                        if (widget.allDetails['additionalInfo']?.isNotEmpty == true)
                          _buildInfoRow(
                            'Additional Info', 
                            widget.allDetails['additionalInfo'] ?? '',
                          ),
                        
                        const SizedBox(height: 24),
                        const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                        const SizedBox(height: 24),
                        
                        // Personal Information
                        const Text(
                          'Your Information',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        _buildInfoRow(
                          'Full Name', 
                          widget.allDetails['name'] ?? 'Not specified',
                        ),
                        _buildInfoRow(
                          'Age', 
                          widget.allDetails['age'] ?? 'Not specified',
                        ),
                        _buildInfoRow(
                          'Gender', 
                          widget.allDetails['gender'] ?? 'Not specified',
                        ),
                        _buildInfoRow(
                          'Contact Number', 
                          widget.allDetails['contact'] ?? 'Not specified',
                        ),
                        _buildInfoRow(
                          'Email', 
                          widget.allDetails['email'] ?? 'Not specified',
                        ),
                        
                        const SizedBox(height: 24),
                        const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                        const SizedBox(height: 24),
                        
                        // Emergency Contact Information
                        const Text(
                          'Emergency Contact Information',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        _buildInfoRow(
                          'Primary Contact', 
                          widget.allDetails['emergencyContactName'] ?? 'Not specified',
                        ),
                        _buildInfoRow(
                          'Contact Number', 
                          widget.allDetails['emergencyContactNumber'] ?? 'Not specified',
                        ),
                        _buildInfoRow(
                          'Relation', 
                          widget.allDetails['emergencyContactRelation'] ?? 'Not specified',
                        ),
                        
                        if (widget.allDetails['secondaryEmergencyContactName']?.isNotEmpty == true) ...[
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            'Secondary Contact', 
                            widget.allDetails['secondaryEmergencyContactName'] ?? '',
                          ),
                          _buildInfoRow(
                            'Contact Number', 
                            widget.allDetails['secondaryEmergencyContactNumber'] ?? '',
                          ),
                        ],
                        
                        const SizedBox(height: 32),
                        
                        // Terms and conditions - Updated for prayer request
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: _isTermsAccepted,
                              onChanged: (value) {
                                setState(() {
                                  _isTermsAccepted = value ?? false;
                                });
                              },
                              activeColor: const Color(0xFF0A0A4A),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'By checking this box, you hereby agree and consent to the Prayer Request Guidelines and Policies',
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Navigation buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFF0A0A4A)),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
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
                                onPressed: _isTermsAccepted 
                                  ? () => _showConfirmationDialog(context, widget.allDetails)
                                  : null, // Disable button if terms not accepted
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0A0A4A),
                                  disabledBackgroundColor: Colors.grey,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
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
              ),
            ),
          ],
        ),
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

  void _showConfirmationDialog(BuildContext context, Map<String, String> allDetails) {
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
                        const Icon(Icons.help_outline, size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          'Are you sure?',
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
                  'Are you sure you want to begin finding a prayer service provider?',
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
                          'No',
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchingScreen(allDetails: allDetails),
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
                          'Yes',
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
