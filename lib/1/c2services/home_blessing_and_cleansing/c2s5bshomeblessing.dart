import 'package:flutter/material.dart';
import '../widgets/step_indicator.dart';
import 'c2s6bshomeblessing.dart';

class ServiceInformationScreen extends StatefulWidget {
  final Map<String, String> personalDetails;

  const ServiceInformationScreen({
    super.key, 
    required this.personalDetails,
  });

  @override
  State<ServiceInformationScreen> createState() => _ServiceInformationScreenState();
}

class _ServiceInformationScreenState extends State<ServiceInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers to store user input
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _additionalInfoController = TextEditingController();
  
  // Consent selection
  String? _consentSelection;

  @override
  void dispose() {
    _reasonController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A4A),
        elevation: 0,
        title: const Text(
          'Home Blessing and Cleansing',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
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
      body: Column(
        children: [
          // Progress indicator using the reusable StepIndicator widget
          const Padding(
            padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: StepIndicator(currentStep: 4, totalSteps: 5),
          ),
          
          // Main content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Service Information',
                        style: TextStyle(
                          color: Color(0xFF0A0A4A),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Please fill out the following fields',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Consent to guidelines with red asterisk
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Do you consent to the home blessing guidelines? ',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Radio buttons for consent
                      RadioListTile<String>(
                        title: const Text('Yes, I consent'),
                        value: 'Yes',
                        groupValue: _consentSelection,
                        activeColor: const Color(0xFF0A0A4A),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        onChanged: (value) {
                          setState(() {
                            _consentSelection = value;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('No'),
                        value: 'No',
                        groupValue: _consentSelection,
                        activeColor: const Color(0xFF0A0A4A),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        onChanged: (value) {
                          setState(() {
                            _consentSelection = value;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      
                      // Additional Information section
                      const Text(
                        'Additional information',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Reason/Purpose of Service
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Reason/Purpose of Service ',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            TextSpan(
                              text: '*',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _reasonController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          hintText: "Enter reason for home blessing",
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a reason for the service';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Anything else we need to know
                      const Text(
                        'Anything else we need to know?',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _additionalInfoController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          hintText: "(Optional)",
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
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
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate() && _consentSelection != null) {
                                  // Combine personal details with service details
                                  final allDetails = {
                                    ...widget.personalDetails,
                                    'consent': _consentSelection!,
                                    'reasonForService': _reasonController.text,
                                    'additionalInfo': _additionalInfoController.text,
                                  };
                                  
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventManagementScreen(
                                        allDetails: allDetails,
                                      ),
                                    ),
                                  );
                                } else if (_consentSelection == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please select whether you consent to the guidelines'),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0A0A4A),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Continue',
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}