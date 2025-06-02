import 'package:flutter/material.dart';
import 'c2s4_5ethostedevents.dart'; // Import the volunteer form screen

class VolunteerFormSetupScreen extends StatefulWidget {
  final Map<String, dynamic> eventData;

  const VolunteerFormSetupScreen({
    super.key,
    required this.eventData,
  });

  @override
  State<VolunteerFormSetupScreen> createState() => _VolunteerFormSetupScreenState();
}

class _VolunteerFormSetupScreenState extends State<VolunteerFormSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form field visibility toggles
  Map<String, bool> _fieldVisibility = {
    'name': true,
    'nickname': true,
    'tshirtSize': true,
    'primaryRole': true,
    'availability': true,
    'reasonForVolunteering': true,
    'cvResume': true,
  };
  
  // Dropdown options
  Map<String, List<String>> _dropdownOptions = {
    'tshirtSize': ['S', 'M', 'L', 'XL'],
    'primaryRole': [
      'Music Team',
      'Discipleship Leader',
      'Media & Communications',
      'Hospitality Team',
      'Youth Ministry',
      'Community Outreach',
      'Church Operations',
    ],
  };
  
  // Text controllers for new options
  final Map<String, TextEditingController> _newOptionControllers = {
    'tshirtSize': TextEditingController(),
    'primaryRole': TextEditingController(),
  };
  
  // Consent form settings
  final TextEditingController _consentFormUrlController = TextEditingController();
  final TextEditingController _consentMessageController = TextEditingController();
  bool _consentRequired = true;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize with default values
    _consentFormUrlController.text = 'Consent Form and Waiver';
    _consentMessageController.text = 'By checking this box, you hereby agree and consent to the:';
    
    // Load saved form configuration if available
    if (widget.eventData.containsKey('volunteerFormConfig')) {
      final config = widget.eventData['volunteerFormConfig'];
      if (config != null) {
        _fieldVisibility = Map<String, bool>.from(config['fieldVisibility'] ?? _fieldVisibility);
        _dropdownOptions = Map<String, List<String>>.from(config['dropdownOptions'] ?? _dropdownOptions);
        _consentRequired = config['consentRequired'] ?? true;
        _consentFormUrlController.text = config['consentFormUrl'] ?? _consentFormUrlController.text;
        _consentMessageController.text = config['consentMessage'] ?? _consentMessageController.text;
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
      _showErrorSnackbar('Please provide a consent form title');
      return false;
    }
    
    if (_consentRequired && _consentMessageController.text.isEmpty) {
      _showErrorSnackbar('Please provide a consent message');
      return false;
    }
    
    // Check if at least one field is visible
    if (_fieldVisibility.values.every((visible) => !visible)) {
      _showErrorSnackbar('At least one form field must be visible');
      return false;
    }
    
    return true;
  }
  
  void _saveFormConfiguration() {
    // Create the form configuration
    final formConfig = {
      'fieldVisibility': _fieldVisibility,
      'dropdownOptions': _dropdownOptions,
      'consentRequired': _consentRequired,
      'consentFormUrl': _consentFormUrlController.text,
      'consentMessage': _consentMessageController.text,
    };
    
    // Generate a unique form link
    final formLink = 'https://church-event.com/volunteer/${widget.eventData['id'] ?? 'default'}/form';
    
    // Return the result
    Navigator.pop(context, {
      'volunteerFormConfig': formConfig,
      'volunteerFormLink': formLink,
    });
  }
  
  void _previewForm() {
    if (!_validateForm()) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VolunteerFormScreen(
          formConfig: {
            'fieldVisibility': _fieldVisibility,
            'dropdownOptions': _dropdownOptions,
            'consentRequired': _consentRequired,
            'consentFormUrl': _consentFormUrlController.text,
            'consentMessage': _consentMessageController.text,
          },
          eventData: widget.eventData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Form Setup'),
        backgroundColor: const Color(0xFF0A0E3D),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Volunteer Application',
                      style: TextStyle(
                        color: Color(0xFF0A0E3D),
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
                    
                    // T-shirt Size Field (Dropdown)
                    _buildDropdownFieldToggle(
                      fieldName: 'tshirtSize',
                      label: 'T-shirt Size',
                    ),
                    
                    // Primary Role Field (Dropdown)
                    _buildDropdownFieldToggle(
                      fieldName: 'primaryRole',
                      label: 'Primary Role of Interest',
                    ),
                    
                    // Availability Field
                    _buildFieldToggle(
                      fieldName: 'availability',
                      fieldType: 'Text',
                      label: 'Availability',
                    ),
                    
                    // Reason for Volunteering Field
                    _buildFieldToggle(
                      fieldName: 'reasonForVolunteering',
                      fieldType: 'Text',
                      label: 'Reason for Volunteering',
                    ),
                    
                    // CV/Resume Upload Field
                    _buildFieldToggle(
                      fieldName: 'cvResume',
                      fieldType: 'File Upload',
                      label: 'CV or Resume',
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
                            child: TextFormField(
                              controller: _consentFormUrlController,
                              decoration: const InputDecoration(
                                hintText: 'Enter consent form title',
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
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
                        maxLines: null,
                        minLines: 5,
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
                          activeColor: const Color(0xFF0A0E3D),
                        ),
                        const Text('Require consent form agreement'),
                      ],
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
                      onPressed: _previewForm,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0A0E3D),
                        side: const BorderSide(color: Color(0xFF0A0E3D)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Preview Form',
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
                        }
                      },
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
                                icon: const Icon(Icons.add_circle, color: Color(0xFF0A0E3D), size: 20),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  _showAddOptionDialog(fieldName);
                                },
                              )
                            : IconButton(
                                icon: const Icon(Icons.remove_circle, color: Color(0xFF0A0E3D), size: 20),
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
          backgroundColor: const Color(0xFFF8F0F0),
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
                      borderSide: const BorderSide(color: Color(0xFF0A0E3D)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF0A0E3D)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF0A0E3D), width: 2),
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
                          backgroundColor: const Color(0xFF444444),
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
                          backgroundColor: const Color(0xFF0A0E3D),
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
