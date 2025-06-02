import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'models/event.dart';
import 'models/registered_event.dart';
import 'c2s3_2epeventstab.dart';

class EventRegistrationScreen extends StatefulWidget {
  final Event event;

  const EventRegistrationScreen({super.key, required this.event});

  @override
  State<EventRegistrationScreen> createState() =>
      _EventRegistrationScreenState();
}

class _EventRegistrationScreenState extends State<EventRegistrationScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _dietaryNeedsController = TextEditingController();
  final TextEditingController _churchNameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emergencyContactNameController =
      TextEditingController();
  final TextEditingController _emergencyContactNumberController =
      TextEditingController();
  final TextEditingController _secondaryEmergencyContactNameController =
      TextEditingController();
  final TextEditingController _secondaryEmergencyContactNumberController =
      TextEditingController();

  // Dropdown values
  String? _selectedGender;
  String? _selectedShirtSize;
  String? _selectedRelation;
  String? _selectedSecondaryRelation;

  // Terms and conditions
  bool _agreedToTerms = false;
  bool _hasViewedTerms = false;

  // List of options for dropdowns
  final List<String> _genderOptions = ['Male', 'Female', 'Prefer not to say'];
  final List<String> _shirtSizeOptions = ['S', 'M', 'L', 'XL', 'XXL', 'XXXL'];
  final List<String> _relationOptions = [
    'Spouse',
    'Parent',
    'Child',
    'Sibling',
    'Relative',
    'Friend',
    'Other',
  ];

  // Error flags for required fields
  bool _showFullNameError = false;
  bool _showNicknameError = false;
  bool _showGenderError = false;
  bool _showShirtSizeError = false;
  bool _showChurchNameError = false;
  bool _showPositionError = false;
  bool _showContactNumberError = false;
  bool _showEmailError = false;
  bool _showEmergencyContactNameError = false;
  bool _showEmergencyContactNumberError = false;
  bool _showEmergencyRelationError = false;
  bool _showTermsError = false;

  @override
  void initState() {
    super.initState();

    // Check if already registered as attendee
    if (RegisteredEventManager.isRegisteredAsAttendee(widget.event)) {
      // Show a message and go back
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => AlertDialog(
                title: const Text('Already Registered'),
                content: Text(
                  'You are already registered as an attendee for ${widget.event.title}.',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Go back to event details
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      });
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    _fullNameController.dispose();
    _nicknameController.dispose();
    _occupationController.dispose();
    _dietaryNeedsController.dispose();
    _churchNameController.dispose();
    _positionController.dispose();
    _contactNumberController.dispose();
    _emailController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactNumberController.dispose();
    _secondaryEmergencyContactNameController.dispose();
    _secondaryEmergencyContactNumberController.dispose();
    super.dispose();
  }

  // Validate Philippine mobile number (10 digits)
  bool _isValidPhilippineNumber(String number) {
    // Remove any non-digit characters
    final cleanNumber = number.replaceAll(RegExp(r'\D'), '');

    // Check if it's exactly 10 digits
    return cleanNumber.length == 10;
  }

  // Validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );
    return emailRegex.hasMatch(email);
  }

  // Show terms and conditions
  Future<void> _showTermsAndConditions() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TermsAndConditionsScreen()),
    );

    if (result == true) {
      setState(() {
        _agreedToTerms = true;
        _hasViewedTerms = true;
        _showTermsError = false;
      });
    }
  }

  // Validate the form
  bool _validateForm() {
    bool isValid = true;

    // Reset all error flags
    setState(() {
      _showFullNameError = false;
      _showNicknameError = false;
      _showGenderError = false;
      _showShirtSizeError = false;
      _showChurchNameError = false;
      _showPositionError = false;
      _showContactNumberError = false;
      _showEmailError = false;
      _showEmergencyContactNameError = false;
      _showEmergencyContactNumberError = false;
      _showEmergencyRelationError = false;
      _showTermsError = false;
    });

    // Validate required fields
    if (_fullNameController.text.trim().isEmpty) {
      setState(() => _showFullNameError = true);
      isValid = false;
    }

    if (_nicknameController.text.trim().isEmpty) {
      setState(() => _showNicknameError = true);
      isValid = false;
    }

    if (_selectedGender == null) {
      setState(() => _showGenderError = true);
      isValid = false;
    }

    if (_selectedShirtSize == null) {
      setState(() => _showShirtSizeError = true);
      isValid = false;
    }

    if (_churchNameController.text.trim().isEmpty) {
      setState(() => _showChurchNameError = true);
      isValid = false;
    }

    if (_positionController.text.trim().isEmpty) {
      setState(() => _showPositionError = true);
      isValid = false;
    }

    // Validate contact number
    if (_contactNumberController.text.trim().isEmpty) {
      setState(() => _showContactNumberError = true);
      isValid = false;
    } else if (!_isValidPhilippineNumber(_contactNumberController.text)) {
      setState(() => _showContactNumberError = true);
      isValid = false;
    }

    // Validate email
    if (_emailController.text.trim().isEmpty) {
      setState(() => _showEmailError = true);
      isValid = false;
    } else if (!_isValidEmail(_emailController.text)) {
      setState(() => _showEmailError = true);
      isValid = false;
    }

    // Validate emergency contact
    if (_emergencyContactNameController.text.trim().isEmpty) {
      setState(() => _showEmergencyContactNameError = true);
      isValid = false;
    }

    if (_emergencyContactNumberController.text.trim().isEmpty) {
      setState(() => _showEmergencyContactNumberError = true);
      isValid = false;
    } else if (!_isValidPhilippineNumber(
      _emergencyContactNumberController.text,
    )) {
      setState(() => _showEmergencyContactNumberError = true);
      isValid = false;
    }

    if (_selectedRelation == null) {
      setState(() => _showEmergencyRelationError = true);
      isValid = false;
    }

    // Validate terms agreement
    if (!_agreedToTerms) {
      setState(() => _showTermsError = true);
      isValid = false;
    }

    return isValid;
  }

  // Submit the form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Register for the event
      RegisteredEventManager.registerAsAttendee(
        widget.event,
        _fullNameController.text,
        nickname: _nicknameController.text,
        email: _emailController.text,
        contactNumber: _contactNumberController.text,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back to event details with success result
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF000233),
        title: const Text(
          'Event Registration',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Form content
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event title
                    Text(
                      widget.event.title ?? 'Event Registration',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Personal Information section
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Full Name
                    _buildRequiredTextField(
                      controller: _fullNameController,
                      label: 'Full Name',
                      showError: _showFullNameError,
                      errorText: 'Full name is required (letters only)',
                      hintText: 'Enter your complete name',
                      allowOnlyLetters: true,
                    ),

                    // Nickname
                    _buildRequiredTextField(
                      controller: _nicknameController,
                      label: 'Nickname',
                      showError: _showNicknameError,
                      errorText: 'Nickname is required (letters only)',
                      hintText: 'What you prefer to be called',
                      allowOnlyLetters: true,
                    ),

                    // Gender and Shirt Size in a row
                    Row(
                      children: [
                        // Gender dropdown
                        Expanded(
                          child: _buildRequiredDropdown(
                            value: _selectedGender,
                            items: _genderOptions,
                            label: 'Gender',
                            showError: _showGenderError,
                            errorText: 'Gender is required',
                            hintText: 'Select gender',
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value;
                                _showGenderError = false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Shirt Size dropdown
                        Expanded(
                          child: _buildRequiredDropdown(
                            value: _selectedShirtSize,
                            items: _shirtSizeOptions,
                            label: 'Shirt Size',
                            showError: _showShirtSizeError,
                            errorText: 'Shirt size is required',
                            hintText: 'Select size',
                            onChanged: (value) {
                              setState(() {
                                _selectedShirtSize = value;
                                _showShirtSizeError = false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    // Occupation
                    _buildOptionalTextField(
                      controller: _occupationController,
                      label: 'Occupation',
                      hintText: 'Your current job or profession',
                      allowOnlyLetters: true,
                    ),

                    // Special Dietary Needs
                    _buildOptionalTextField(
                      controller: _dietaryNeedsController,
                      label: 'Special Dietary Needs',
                      hintText: 'Any food allergies or restrictions',
                    ),

                    const SizedBox(height: 24),

                    // Church Information section
                    const Text(
                      'Church Name',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Church Name
                    _buildRequiredTextField(
                      controller: _churchNameController,
                      label: 'Church Name',
                      showError: _showChurchNameError,
                      errorText: 'Church name is required',
                      hintText: 'Name of your church',
                    ),

                    // Position in the church
                    _buildRequiredTextField(
                      controller: _positionController,
                      label: 'Position in the church',
                      showError: _showPositionError,
                      errorText: 'Position is required',
                      hintText:
                          'Your role in the church (e.g., Member, Volunteer)',
                      allowOnlyLetters: true,
                    ),

                    const SizedBox(height: 24),

                    // Contact Information section
                    const Text(
                      'Contact Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Contact Number
                    _buildRequiredTextField(
                      controller: _contactNumberController,
                      label: 'Contact Number',
                      showError: _showContactNumberError,
                      errorText:
                          'Enter a valid 11-digit Philippine mobile number',
                      keyboardType: TextInputType.phone,
                      hintText: 'Your 11-digit mobile number',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                    ),

                    // Email Address
                    _buildRequiredTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      showError: _showEmailError,
                      errorText: 'Enter a valid email address',
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'your.email@example.com',
                    ),

                    const SizedBox(height: 24),

                    // In Case of Emergency section
                    const Text(
                      'In Case of Emergency',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Primary Emergency Contact Name
                    _buildRequiredTextField(
                      controller: _emergencyContactNameController,
                      label: 'Primary Emergency Contact Person',
                      showError: _showEmergencyContactNameError,
                      errorText:
                          'Emergency contact name is required (letters only)',
                      hintText: 'Full name of emergency contact',
                      allowOnlyLetters: true,
                    ),

                    // Primary Emergency Contact Number
                    _buildRequiredTextField(
                      controller: _emergencyContactNumberController,
                      label: 'Primary Emergency Contact Number',
                      showError: _showEmergencyContactNumberError,
                      errorText:
                          'Enter a valid 11-digit Philippine mobile number',
                      keyboardType: TextInputType.phone,
                      hintText: 'Emergency contact\'s 11-digit mobile number',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                    ),

                    // Relation
                    _buildRequiredDropdown(
                      value: _selectedRelation,
                      items: _relationOptions,
                      label: 'Relation',
                      showError: _showEmergencyRelationError,
                      errorText: 'Relation is required',
                      hintText: 'Relationship to emergency contact',
                      onChanged: (value) {
                        setState(() {
                          _selectedRelation = value;
                          _showEmergencyRelationError = false;
                        });
                      },
                    ),

                    // Secondary Emergency Contact (Optional)
                    _buildOptionalTextField(
                      controller: _secondaryEmergencyContactNameController,
                      label: 'Secondary Emergency Contact Person (Optional)',
                      hintText: 'Full name of secondary emergency contact',
                      allowOnlyLetters: true,
                    ),

                    // Secondary Emergency Contact Number (Optional)
                    _buildOptionalTextField(
                      controller: _secondaryEmergencyContactNumberController,
                      label: 'Secondary Emergency Contact Number (Optional)',
                      keyboardType: TextInputType.phone,
                      hintText: 'Secondary contact\'s 10-digit mobile number',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),

                    // Secondary Relation (Optional)
                    _buildOptionalDropdown(
                      value: _selectedSecondaryRelation,
                      items: _relationOptions,
                      label: 'Relation (Optional)',
                      hintText: 'Relationship to secondary contact',
                      onChanged: (value) {
                        setState(() {
                          _selectedSecondaryRelation = value;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // Terms and Conditions checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _agreedToTerms,
                          onChanged: (value) {
                            if (value == true && !_hasViewedTerms) {
                              _showTermsAndConditions();
                            } else {
                              setState(() {
                                _agreedToTerms = value ?? false;
                                _showTermsError = false;
                              });
                            }
                          },
                          activeColor: const Color(0xFF000233),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Text.rich(
                                  TextSpan(
                                    text:
                                        'By checking this box, you hereby agree and consent to the ',
                                    style: const TextStyle(fontSize: 14),
                                    children: [
                                      TextSpan(
                                        text:
                                            'Legal Policies and Guidelines for Events',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer:
                                            TapGestureRecognizer()
                                              ..onTap = _showTermsAndConditions,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (_showTermsError)
                                const Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Text(
                                    'You must agree to the terms and conditions',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Back and Continue buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: Color(0xFF000233)),
                            ),
                            child: const Text(
                              'Back',
                              style: TextStyle(color: Color(0xFF000233)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _agreedToTerms ? _submitForm : null,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: const Color(0xFF000233),
                              disabledBackgroundColor: Colors.grey,
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build required text fields
  Widget _buildRequiredTextField({
    required TextEditingController controller,
    required String label,
    required bool showError,
    required String errorText,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? hintText,
    bool allowOnlyLetters = false,
  }) {
    // Create a list of input formatters
    final List<TextInputFormatter> formatters = [
      LengthLimitingTextInputFormatter(50),
    ];

    // Add custom formatters if provided
    if (inputFormatters != null) {
      formatters.addAll(inputFormatters);
    }

    // Add letter-only formatter if specified
    if (allowOnlyLetters) {
      formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const Text(
              ' *',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: showError ? Colors.red : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey.shade200, // Add dark gray background
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
            keyboardType: keyboardType,
            inputFormatters: formatters,
            onChanged: (value) {
              if (showError) {
                setState(() {
                  if (label == 'Contact Number' ||
                      label == 'Primary Emergency Contact Number') {
                    if (_isValidPhilippineNumber(value)) {
                      if (label == 'Contact Number') {
                        _showContactNumberError = false;
                      } else {
                        _showEmergencyContactNumberError = false;
                      }
                    }
                  } else if (label == 'Email Address') {
                    if (_isValidEmail(value)) {
                      _showEmailError = false;
                    }
                  } else if (value.isNotEmpty) {
                    if (label == 'Full Name') {
                      _showFullNameError = false;
                    } else if (label == 'Nickname') {
                      _showNicknameError = false;
                    } else if (label == 'Church Name') {
                      _showChurchNameError = false;
                    } else if (label == 'Position in the church') {
                      _showPositionError = false;
                    } else if (label == 'Primary Emergency Contact Person') {
                      _showEmergencyContactNameError = false;
                    }
                  }
                });
              }
            },
          ),
        ),
        if (showError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Helper method to build optional text fields
  Widget _buildOptionalTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? hintText,
    bool allowOnlyLetters = false,
  }) {
    // Create a list of input formatters
    final List<TextInputFormatter> formatters = [
      LengthLimitingTextInputFormatter(50),
    ];

    // Add custom formatters if provided
    if (inputFormatters != null) {
      formatters.addAll(inputFormatters);
    }

    // Add letter-only formatter if specified
    if (allowOnlyLetters) {
      formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey.shade200, // Add dark gray background
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
            keyboardType: keyboardType,
            inputFormatters: formatters,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Helper method to build required dropdowns
  Widget _buildRequiredDropdown({
    required String? value,
    required List<String> items,
    required String label,
    required bool showError,
    required String errorText,
    required Function(String?) onChanged,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const Text(
              ' *',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: showError ? Colors.red : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey.shade200, // Add dark gray background
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  hintText ?? 'Select',
                  style: TextStyle(color: Colors.grey.shade400),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              items:
                  items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        if (showError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Helper method to build optional dropdowns
  Widget _buildOptionalDropdown({
    required String? value,
    required List<String> items,
    required String label,
    required Function(String?) onChanged,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey.shade200, // Add dark gray background
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  hintText ?? 'Select',
                  style: TextStyle(color: Colors.grey.shade400),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              items:
                  items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
