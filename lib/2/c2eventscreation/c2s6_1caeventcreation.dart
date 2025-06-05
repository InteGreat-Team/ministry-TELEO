import 'package:flutter/material.dart';
import 'models/event.dart';
import 'widgets/step_indicator.dart';
import 'c2s7caeventcreation.dart';
import 'widgets/event_app_bar.dart';
import 'c2s6_2caeventcreation.dart';

class EventRegistrationFormScreen extends StatefulWidget {
  final Event event;

  const EventRegistrationFormScreen({super.key, required this.event});

  @override
  State<EventRegistrationFormScreen> createState() => _EventRegistrationFormScreenState();
}

class _EventRegistrationFormScreenState extends State<EventRegistrationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form field controllers
  final TextEditingController _consentFormUrlController = TextEditingController();
  final TextEditingController _consentMessageController = TextEditingController();
  
  // Form field visibility toggles
  Map<String, bool> _fieldVisibility = {
    'name': true,
    'nickname': true,
    'sex': true,
    'email': true,
    'phoneNumber': true,
    'medications': true,
    'tshirtSize': true,
    'churchName': true,
    'churchPosition': true,
    'emergencyContactName': true,
    'emergencyContactNumber': true,
    'emergencyContactRelation': true,
  };
  
  // Dropdown options
  Map<String, List<String>> _dropdownOptions = {
    'sex': ['Male', 'Female', 'Other'],
    'tshirtSize': ['S', 'M', 'L', 'XL'],
    'emergencyContactRelation': ['Spouse', 'Sibling', 'Parent', 'Other'],
  };
  
  // Text controllers for new options
  final Map<String, TextEditingController> _newOptionControllers = {
    'sex': TextEditingController(),
    'tshirtSize': TextEditingController(),
    'emergencyContactRelation': TextEditingController(),
  };
  
  // Consent form checkbox
  bool _consentRequired = true;
  
  // Terms and conditions status
  bool _hasReadTerms = false;
  bool _hasAcceptedTerms = false;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize with default values
    _consentFormUrlController.text = 'Consent Form and Waiver.com';
    _consentMessageController.text = 'By checking this box, you hereby agree and consent to the:';
    
    // Load saved form configuration if available
    if (widget.event.registrationFormConfig != null) {
      _fieldVisibility = Map.from(widget.event.registrationFormConfig!.fieldVisibility);
      _consentRequired = widget.event.registrationFormConfig!.consentRequired;
      _consentFormUrlController.text = widget.event.registrationFormConfig!.consentFormUrl ?? _consentFormUrlController.text;
      _consentMessageController.text = widget.event.registrationFormConfig!.consentMessage ?? _consentMessageController.text;
      _hasReadTerms = widget.event.registrationFormConfig!.hasReadTerms;
      _hasAcceptedTerms = widget.event.registrationFormConfig!.hasAcceptedTerms;
      
      // Load saved dropdown options if available
      if (widget.event.registrationFormConfig!.dropdownOptions != null) {
        _dropdownOptions = Map.from(widget.event.registrationFormConfig!.dropdownOptions!);
      }
    }
  }
  
  void _toggleFieldVisibility(String fieldName) {
    setState(() {
      _fieldVisibility[fieldName] = !_fieldVisibility[fieldName]!;
    });
  }
  
  void _addDropdownOption(String fieldName) {
    final controller = _newOptionControllers[fieldName];
    if (controller != null && controller.text.isNotEmpty) {
      setState(() {
        _dropdownOptions[fieldName]!.add(controller.text);
        controller.clear();
      });
    } else {
      _showErrorSnackbar('Please enter an option value');
    }
  }
  
  void _removeDropdownOption(String fieldName, int index) {
    if (_dropdownOptions[fieldName]!.length > 1) {
      setState(() {
        _dropdownOptions[fieldName]!.removeAt(index);
      });
    } else {
      _showErrorSnackbar('At least one option is required');
    }
  }
  
  void _saveFormConfiguration() {
    // Create or update the registration form configuration
    final formConfig = RegistrationFormConfig(
      fieldVisibility: Map.from(_fieldVisibility),
      consentRequired: _consentRequired,
      consentFormUrl: _consentFormUrlController.text,
      consentMessage: _consentMessageController.text,
      dropdownOptions: Map.from(_dropdownOptions),
      hasReadTerms: _hasReadTerms,
      hasAcceptedTerms: _hasAcceptedTerms,
    );
    
    // Save to event
    widget.event.registrationFormConfig = formConfig;
  }
  
  void _navigateToConsentForm() {
    if (_consentFormUrlController.text.isEmpty) {
      _showErrorSnackbar('Please enter a consent form URL first');
      return;
    }
    
    if (_consentMessageController.text.isEmpty) {
      _showErrorSnackbar('Please enter consent form content first');
      return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConsentFormScreen(
          title: _consentFormUrlController.text,
          content: _consentMessageController.text,
          onAccept: (accepted) {
            setState(() {
              _hasReadTerms = true;
              _hasAcceptedTerms = accepted;
            });
            
            if (accepted) {
              _showInfoSnackbar('Terms and conditions accepted');
            } else {
              _showInfoSnackbar('Terms and conditions viewed but not accepted');
            }
          },
        ),
      ),
    );
  }
  
  void _showInfoSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
      ),
    );
  }
  
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
  
  bool _validateForm() {
    if (_consentRequired && _consentFormUrlController.text.isEmpty) {
      _showErrorSnackbar('Please provide a consent form URL');
      return false;
    }
    
    if (_consentRequired && _consentMessageController.text.isEmpty) {
      _showErrorSnackbar('Please provide a consent message');
      return false;
    }
    
    if (_consentRequired && !_hasAcceptedTerms) {
      _showErrorSnackbar('Please view and accept the consent form before proceeding');
      return false;
    }
    
    // Check if at least one field is visible
    if (_fieldVisibility.values.every((visible) => !visible)) {
      _showErrorSnackbar('At least one registration field must be visible');
      return false;
    }
    
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EventAppBar(
        onBackPressed: () => Navigator.pop(context), title: '',
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StepIndicator(
                      currentStep: 5,
                      totalSteps: 7,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Registration Form',
                            style: TextStyle(
                              color: Color(0xFF0A0A4A), // Changed to navy blue
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
                          
                          // User Information Section
                          const Text(
                            'User Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Name Field
                          _buildFieldToggle(
                            fieldName: 'name',
                            fieldType: 'Text',
                            label: 'Name',
                          ),
                          
                          // Nickname Field
                          _buildFieldToggle(
                            fieldName: 'nickname',
                            fieldType: 'Text',
                            label: 'Nickname',
                          ),
                          
                          // Sex Field (Dropdown)
                          _buildDropdownFieldToggle(
                            fieldName: 'sex',
                            label: 'Sex',
                          ),
                          
                          // Email Field
                          _buildFieldToggle(
                            fieldName: 'email',
                            fieldType: 'Email',
                            label: 'Email',
                          ),
                          
                          // Phone Number Field
                          _buildFieldToggle(
                            fieldName: 'phoneNumber',
                            fieldType: 'Number',
                            label: 'Phone Number',
                          ),
                          
                          // Medications Field
                          _buildFieldToggle(
                            fieldName: 'medications',
                            fieldType: 'Text',
                            label: 'Medications',
                          ),
                          
                          // T-shirt Size Field (Dropdown)
                          _buildDropdownFieldToggle(
                            fieldName: 'tshirtSize',
                            label: 'T-shirt Size',
                          ),
                          
                          // Church Name Field
                          _buildFieldToggle(
                            fieldName: 'churchName',
                            fieldType: 'Text',
                            label: 'Church Name',
                          ),
                          
                          // Position in the Church Field
                          _buildFieldToggle(
                            fieldName: 'churchPosition',
                            fieldType: 'Text',
                            label: 'Position in the Church',
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Emergency Contact Information Section
                          const Text(
                            'Emergency Contact Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Emergency Contact Name Field
                          _buildFieldToggle(
                            fieldName: 'emergencyContactName',
                            fieldType: 'Text',
                            label: 'Emergency Contact Name',
                          ),
                          
                          // Emergency Contact Number Field
                          _buildFieldToggle(
                            fieldName: 'emergencyContactNumber',
                            fieldType: 'Text',
                            label: 'Emergency Contact No.',
                          ),
                          
                          // Emergency Contact Relation Field (Dropdown)
                          _buildDropdownFieldToggle(
                            fieldName: 'emergencyContactRelation',
                            label: 'Relation',
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Consent Form and Waiver Section
                          const Text(
                            'Consent Form and Waiver',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Consent Form URL
                          Row(
                            children: [
                              const Text(
                                '[Link]:',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _consentFormUrlController,
                                          decoration: const InputDecoration(
                                            hintText: 'Enter consent form URL',
                                            border: InputBorder.none,
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: _navigateToConsentForm,
                                        child: const Icon(
                                          Icons.open_in_new,
                                          color: Colors.blue,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Consent Message
                          const Text(
                            'Consent form message:',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: TextFormField(
                              controller: _consentMessageController,
                              decoration: const InputDecoration(
                                hintText: 'Enter consent message',
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              maxLines: null, // Allow unlimited lines
                              minLines: 10, // Set minimum height with 10 lines
                              textAlignVertical: TextAlignVertical.top,
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Consent Required Toggle
                          Row(
                            children: [
                              Checkbox(
                                value: _consentRequired,
                                onChanged: (value) {
                                  setState(() {
                                    _consentRequired = value ?? true;
                                  });
                                },
                                activeColor: const Color(0xFF0A0A4A),
                              ),
                              const Text('Require consent form agreement'),
                            ],
                          ),
                          
                          // Terms Status Indicator
                          if (_hasReadTerms)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    _hasAcceptedTerms ? Icons.check_circle : Icons.info,
                                    color: _hasAcceptedTerms ? Colors.green : Colors.orange,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _hasAcceptedTerms 
                                        ? 'Consent form has been accepted' 
                                        : 'Consent form has been viewed but not accepted',
                                    style: TextStyle(
                                      color: _hasAcceptedTerms ? Colors.green : Colors.orange,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          
                          // View Terms Button
                          if (_hasReadTerms)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: TextButton.icon(
                                onPressed: _navigateToConsentForm,
                                icon: const Icon(Icons.visibility, size: 18),
                                label: const Text('View Consent Form Again'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                        foregroundColor: const Color(0xFF0A0A4A),
                        side: const BorderSide(color: Color(0xFF0A0A4A)),
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
                      onPressed: () {
                        if (_validateForm()) {
                          _saveFormConfiguration();
                          
                          // Navigate to invite screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventInviteScreen(event: widget.event),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A0A4A),
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
  
  Widget _buildFieldToggle({
    required String fieldName,
    required String fieldType,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: _fieldVisibility[fieldName] ?? true,
            onChanged: (value) {
              _toggleFieldVisibility(fieldName);
            },
            activeColor: Colors.green,
          ),
          const SizedBox(width: 4),
          Text(
            '[$fieldType] Label:',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDropdownFieldToggle({
    required String fieldName,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown field header
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: _fieldVisibility[fieldName] ?? true,
                onChanged: (value) {
                  _toggleFieldVisibility(fieldName);
                },
                activeColor: Colors.green,
              ),
              const SizedBox(width: 4),
              const Text(
                '[Dropdown] Label:',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Dropdown options
        if (_fieldVisibility[fieldName] ?? true)
          Padding(
            padding: const EdgeInsets.only(left: 40.0, bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Existing options
                ..._dropdownOptions[fieldName]!.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        // Add/Remove buttons
                        index == 0
                            ? IconButton(
                                icon: const Icon(Icons.add_circle, color: Color(0xFF0A0A4A), size: 20), // Changed to navy blue
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  _showAddOptionDialog(fieldName);
                                },
                              )
                            : IconButton(
                                icon: const Icon(Icons.remove_circle, color: Color(0xFF0A0A4A), size: 20), // Changed to navy blue
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  _removeDropdownOption(fieldName, index);
                                },
                              ),
                        const SizedBox(width: 8),
                        Text(
                          'Option ${index + 1}:',
                          style: const TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              option,
                              style: const TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }
  
  void _showAddOptionDialog(String fieldName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFF8F0F0), // Light pink/beige background
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Option',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _newOptionControllers[fieldName],
                  decoration: InputDecoration(
                    hintText: 'Enter option value',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF0A0A4A)), // Changed to navy blue
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF0A0A4A)), // Changed to navy blue
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF0A0A4A), width: 2), // Changed to navy blue
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF444444), // Dark gray but not too dark
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_newOptionControllers[fieldName]!.text.isNotEmpty) {
                            _addDropdownOption(fieldName);
                            Navigator.of(context).pop();
                          } else {
                            _showErrorSnackbar('Please enter an option value');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A0A4A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(
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
          ),
        );
      },
    );
  }
}
