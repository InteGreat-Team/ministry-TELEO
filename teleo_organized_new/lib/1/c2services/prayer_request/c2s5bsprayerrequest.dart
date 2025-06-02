import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/step_indicator.dart';
import 'c2s6bsprayerrequest.dart';

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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _additionalInfoController = TextEditingController();
  
  // Dropdown and radio selection
  String selectedRelation = 'Relative';
  String selectedPrayerTopic = 'Personal and Spiritual Growth';
  String selectedPrayerTime = 'Morning';
  String? _privacyOption;

  @override
  void dispose() {
    _nameController.dispose();
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
          'Prayer Request',
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
            child: StepIndicator(currentStep: 4, totalSteps: 7),
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
                        'Prayer Request Information',
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
                      
                      // Recipient's Information section
                      const Text(
                        'Recipient\'s Information',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Full Name of Person to Pray for
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Full Name of Person to Pray for ',
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
                        controller: _nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          hintText: "Enter full name",
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the person\'s name';
                          }
                          // Only allow letters and spaces
                          if (!RegExp(r'^[a-zA-Z\s\.]+$').hasMatch(value)) {
                            return 'Please enter a valid name (letters only)';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s\.]')),
                        ],
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 16),
                      
                      // Relation to Recipient
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Relation to Recipient ',
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
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedRelation,
                            isExpanded: true,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            items: ['Relative', 'Friend', 'Spouse', 'Parent', 'Child', 'Sibling', 'Self', 'Other']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedRelation = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Prayer Topic
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Prayer Topic ',
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
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedPrayerTopic,
                            isExpanded: true,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            items: [
                              'Personal and Spiritual Growth',
                              'Health and Healing',
                              'Family',
                              'Financial Provision',
                              'Guidance and Direction',
                              'Comfort in Grief',
                              'Thanksgiving',
                              'Other'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedPrayerTopic = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Preferred Prayer Time
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Preferred Prayer Time ',
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
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedPrayerTime,
                            isExpanded: true,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            items: [
                              'Morning',
                              'Afternoon',
                              'Evening',
                              'Night',
                              'Any time'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedPrayerTime = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Privacy Option
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Do you want this request to be kept private? ',
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
                      
                      // Radio buttons for privacy option
                      RadioListTile<String>(
                        title: const Text('Yes, keep it private'),
                        value: 'Private',
                        groupValue: _privacyOption,
                        activeColor: const Color(0xFF0A0A4A),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        onChanged: (value) {
                          setState(() {
                            _privacyOption = value;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('No, make it publicly disclosed'),
                        value: 'Public',
                        groupValue: _privacyOption,
                        activeColor: const Color(0xFF0A0A4A),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        onChanged: (value) {
                          setState(() {
                            _privacyOption = value;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      
                      // Additional Information section
                      const Text(
                        'Additional Information',
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
                          hintText: "Enter reason",
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a reason for the prayer request';
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
                                if (_formKey.currentState!.validate() && _privacyOption != null) {
                                  // Combine personal details with service details
                                  final allDetails = {
                                    ...widget.personalDetails,
                                    'recipientName': _nameController.text,
                                    'relationToRecipient': selectedRelation,
                                    'prayerTopic': selectedPrayerTopic,
                                    'preferredPrayerTime': selectedPrayerTime,
                                    'privacyOption': _privacyOption!,
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
                                } else if (_privacyOption == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please select a privacy option'),
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
