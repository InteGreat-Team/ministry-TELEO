import 'package:flutter/material.dart';

class VolunteerFormScreen extends StatefulWidget {
  final Map<String, dynamic> formConfig;
  final Map<String, dynamic> eventData;

  const VolunteerFormScreen({
    super.key,
    required this.formConfig,
    required this.eventData,
  });

  @override
  State<VolunteerFormScreen> createState() => _VolunteerFormScreenState();
}

class _VolunteerFormScreenState extends State<VolunteerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form field controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  
  // Selected dropdown values
  String? _selectedTShirtSize;
  String? _selectedPrimaryRole;
  
  // File upload status
  bool _hasUploadedCV = false;
  
  // Consent form status
  bool _hasAcceptedConsent = false;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize dropdown values if available
    if (widget.formConfig['dropdownOptions'] != null) {
      final tshirtSizes = widget.formConfig['dropdownOptions']['tshirtSize'] as List<String>?;
      if (tshirtSizes != null && tshirtSizes.isNotEmpty) {
        _selectedTShirtSize = tshirtSizes[0];
      }
      
      final primaryRoles = widget.formConfig['dropdownOptions']['primaryRole'] as List<String>?;
      if (primaryRoles != null && primaryRoles.isNotEmpty) {
        _selectedPrimaryRole = primaryRoles[0];
      }
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _availabilityController.dispose();
    _reasonController.dispose();
    super.dispose();
  }
  
  void _showConsentForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.formConfig['consentFormUrl'] ?? 'Consent Form and Waiver',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      widget.formConfig['consentMessage'] ?? 'By checking this box, you hereby agree and consent to the terms and conditions.',
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
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
  
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Check if consent is required and accepted
      if (widget.formConfig['consentRequired'] == true && !_hasAcceptedConsent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please accept the consent form to continue'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Volunteer application submitted successfully'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navigate back
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fieldVisibility = widget.formConfig['fieldVisibility'] as Map<String, bool>?;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Form'),
        backgroundColor: const Color(0xFF0A0E3D),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Progress indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(7, (index) {
                  return Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == 0 ? Colors.orange : Colors.grey[300],
                      border: Border.all(
                        color: index == 0 ? Colors.orange : Colors.grey[400]!,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          color: index == 0 ? Colors.white : Colors.grey[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Volunteer Application',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Use standard form or customize fields',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Name Field
                    if (fieldVisibility?['name'] ?? true)
                      _buildTextField(
                        controller: _nameController,
                        label: 'Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                    
                    // Nickname Field
                    if (fieldVisibility?['nickname'] ?? true)
                      _buildTextField(
                        controller: _nicknameController,
                        label: 'Nickname',
                        validator: (value) => null, // Optional field
                      ),
                    
                    // T-shirt Size Field
                    if (fieldVisibility?['tshirtSize'] ?? true)
                      _buildDropdownField(
                        label: 'T-shirt Size',
                        value: _selectedTShirtSize,
                        items: (widget.formConfig['dropdownOptions']?['tshirtSize'] as List<String>?)
                            ?.map((size) => DropdownMenuItem(value: size, child: Text(size)))
                            .toList() ??
                            ['S', 'M', 'L', 'XL'].map((size) => DropdownMenuItem(value: size, child: Text(size))).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTShirtSize = value as String?;
                          });
                        },
                      ),
                    
                    // Primary Role Field
                    if (fieldVisibility?['primaryRole'] ?? true)
                      _buildDropdownField(
                        label: 'Primary Role of Interest',
                        value: _selectedPrimaryRole,
                        items: (widget.formConfig['dropdownOptions']?['primaryRole'] as List<String>?)
                            ?.map((role) => DropdownMenuItem(value: role, child: Text(role)))
                            .toList() ??
                            [
                              'Music Team',
                              'Discipleship Leader',
                              'Media & Communications',
                              'Hospitality Team',
                              'Youth Ministry',
                              'Community Outreach',
                              'Church Operations',
                            ].map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPrimaryRole = value as String?;
                          });
                        },
                      ),
                    
                    // Availability Field
                    if (fieldVisibility?['availability'] ?? true)
                      _buildTextField(
                        controller: _availabilityController,
                        label: 'Availability',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your availability';
                          }
                          return null;
                        },
                      ),
                    
                    // Reason for Volunteering Field
                    if (fieldVisibility?['reasonForVolunteering'] ?? true)
                      _buildTextField(
                        controller: _reasonController,
                        label: 'Reason for Volunteering',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your reason for volunteering';
                          }
                          return null;
                        },
                        maxLines: 3,
                      ),
                    
                    // CV/Resume Upload Field
                    if (fieldVisibility?['cvResume'] ?? true) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'CV or Resume',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          // Simulate file upload
                          setState(() {
                            _hasUploadedCV = true;
                          });
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('File uploaded successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[100],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _hasUploadedCV ? Icons.check_circle : Icons.upload_file,
                                color: _hasUploadedCV ? Colors.green : Colors.grey[600],
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _hasUploadedCV ? 'resume.pdf (Uploaded)' : 'Upload CV or Resume',
                                style: TextStyle(
                                  color: _hasUploadedCV ? Colors.green : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    
                    // Consent Form
                    if (widget.formConfig['consentRequired'] == true) ...[
                      const SizedBox(height: 24),
                      const Text(
                        'Consent Form and Waiver',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _hasAcceptedConsent,
                            onChanged: (value) {
                              setState(() {
                                _hasAcceptedConsent = value ?? false;
                              });
                            },
                            activeColor: const Color(0xFF0A0E3D),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.formConfig['consentMessage'] ?? 'By checking this box, you hereby agree and consent to the:',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: _showConsentForm,
                                  child: Text(
                                    widget.formConfig['consentFormUrl'] ?? 'Consent Form and Waiver',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Bottom buttons
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A0E3D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Complete Form',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter $label',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF0A0E3D)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            validator: validator,
            maxLines: maxLines,
          ),
        ],
      ),
    );
  }
  
  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required void Function(Object?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[50],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                items: items,
                onChanged: onChanged,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.black, fontSize: 16),
                dropdownColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
