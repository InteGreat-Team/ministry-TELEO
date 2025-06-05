import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/event.dart';
import 'models/registered_event.dart';

class VolunteerFormScreen extends StatefulWidget {
  final Event event;

  const VolunteerFormScreen({super.key, required this.event});

  @override
  State<VolunteerFormScreen> createState() => _VolunteerFormScreenState();
}

class _VolunteerFormScreenState extends State<VolunteerFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  // Selected dropdown values
  String? _selectedPrimaryRole;

  // Consent form status
  bool _hasAcceptedConsent = false;
  bool _hasReadConsent = false;

  // Form completion tracking
  bool _isFormValid = false;
  bool _areAllFieldsFilled = false;

  @override
  void initState() {
    super.initState();

    // Check if already registered as volunteer
    if (RegisteredEventManager.isVolunteerForEvent(widget.event)) {
      // Show a message and go back
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => AlertDialog(
                title: const Text('Already Volunteering'),
                content: Text(
                  'You are already registered as a volunteer for ${widget.event.title}.',
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

    // Initialize dropdown values if available
    if (widget.event.volunteerRoles != null &&
        widget.event.volunteerRoles!.isNotEmpty) {
      _selectedPrimaryRole = widget.event.volunteerRoles![0];
    } else {
      _selectedPrimaryRole = 'General Volunteer';
    }

    // Add listeners to all text controllers to check form completion
    _nameController.addListener(_checkFormCompletion);
    _emailController.addListener(_checkFormCompletion);
    _contactNumberController.addListener(_checkFormCompletion);
    _availabilityController.addListener(_checkFormCompletion);
    _reasonController.addListener(_checkFormCompletion);
  }

  @override
  void dispose() {
    // Remove listeners before disposing controllers
    _nameController.removeListener(_checkFormCompletion);
    _emailController.removeListener(_checkFormCompletion);
    _contactNumberController.removeListener(_checkFormCompletion);
    _availabilityController.removeListener(_checkFormCompletion);
    _reasonController.removeListener(_checkFormCompletion);

    // Dispose controllers
    _nameController.dispose();
    _emailController.dispose();
    _contactNumberController.dispose();
    _availabilityController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  // Check if all required fields are filled
  void _checkFormCompletion() {
    setState(() {
      _areAllFieldsFilled =
          _nameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _contactNumberController.text.isNotEmpty &&
          _availabilityController.text.isNotEmpty &&
          _reasonController.text.isNotEmpty &&
          _selectedPrimaryRole != null;

      _isFormValid = _areAllFieldsFilled && _hasAcceptedConsent;
    });
  }

  // Show consent form in a full-screen dialog
  void _showConsentForm() {
    showDialog(
      context: context,
      barrierDismissible: false, // User must interact with the dialog
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: const Color(0xFFF5F5F5), // Light gray background
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and close button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Consent Form and Waiver',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Content in a white container with border
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: SingleChildScrollView(
                          controller: ScrollController(),
                          child: const Text(
                            'By checking this box, you hereby agree and consent to the terms and conditions of volunteering for this event. You acknowledge that you are participating voluntarily and understand the responsibilities and expectations of your role. You agree to follow all guidelines and instructions provided by event organizers and to conduct yourself in a manner consistent with the values and mission of the organization.\n\n'
                            'You understand that photographs and videos may be taken during the event and grant permission for your likeness to be used in promotional materials. You also acknowledge that you are physically able to perform the volunteer duties assigned to you and will notify event organizers of any limitations.\n\n'
                            'You release the organization, its staff, and volunteers from any liability for injuries or damages that may occur during your volunteer service.\n\n'
                            'As a volunteer, you agree to:\n'
                            '1. Arrive on time and stay for your entire shift\n'
                            '2. Notify the volunteer coordinator if you cannot fulfill your commitment\n'
                            '3. Represent the organization in a positive and professional manner\n'
                            '4. Respect the confidentiality of all information related to the organization\n'
                            '5. Follow all safety guidelines and report any concerns immediately\n\n'
                            'The organization reserves the right to dismiss any volunteer who does not adhere to these guidelines or whose behavior is deemed inappropriate.',
                            style: TextStyle(fontSize: 16, height: 1.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Checkbox and button in two lines
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _hasReadConsent,
                          onChanged: (value) {
                            setState(() {
                              _hasReadConsent = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFF0A0E3D),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'I have read and understand the consent form',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed:
                            _hasReadConsent
                                ? () {
                                  Navigator.pop(context);
                                  // Update the main form's state
                                  this.setState(() {
                                    _hasReadConsent = true;
                                    _hasAcceptedConsent = true;
                                    _checkFormCompletion();
                                  });
                                }
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A0E3D),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Accept'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Show confirmation dialog
  void _showConfirmationDialog() {
    if (_formKey.currentState!.validate() && _hasAcceptedConsent) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                const Icon(
                  Icons.volunteer_activism,
                  color: Color(0xFF0A0E3D),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Submit Volunteer Application',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A0E3D),
                  ),
                ),
              ],
            ),
            content: const Text(
              'Are you sure you want to submit your volunteer application for this event?',
              style: TextStyle(fontSize: 14),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFFFAE6E6,
                      ), // Light pink/red background
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red[800],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('No'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0E3D), // Navy blue background
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _submitForm();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Yes, proceed'),
                    ),
                  ),
                ],
              ),
            ],
            actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          );
        },
      );
    }
  }

  void _submitForm() {
    // Create volunteer data
    final volunteerData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'contactNumber': _contactNumberController.text,
      'primaryRole': _selectedPrimaryRole,
      'availability': _availabilityController.text,
      'reasonForVolunteering': _reasonController.text,
    };

    // Register as volunteer
    RegisteredEventManager.registerAsVolunteer(widget.event, volunteerData);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Volunteer application submitted successfully'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back with result = true to indicate successful registration
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Volunteer for: ${widget.event.title}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Volunteers needed: ${widget.event.volunteersNeeded}',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 20),

                    // Name Field - Limited to 50 characters, no special characters
                    _buildTextField(
                      controller: _nameController,
                      label: 'Name',
                      isRequired: true,
                      maxLength: 50,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z\s]'),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),

                    // Email Field - Limited to 50 characters, basic email format
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      isRequired: true,
                      maxLength: 50,
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9@._-]'),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),

                    // Contact Number Field - Philippine mobile number validation
                    _buildTextField(
                      controller: _contactNumberController,
                      label: 'Contact Number',
                      isRequired: true,
                      hintText: '09XXXXXXXXX (11 digits)',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your contact number';
                        }
                        if (value.length != 11) {
                          return 'Please enter exactly 11 digits';
                        }
                        if (!value.startsWith('0')) {
                          return 'Philippine mobile number must start with 9';
                        }
                        return null;
                      },
                    ),

                    // Primary Role Field
                    _buildDropdownField(
                      label: 'Primary Role of Interest',
                      isRequired: true,
                      value: _selectedPrimaryRole,
                      items:
                          widget.event.volunteerRoles != null
                              ? widget.event.volunteerRoles!
                                  .map(
                                    (role) => DropdownMenuItem(
                                      value: role,
                                      child: Text(role),
                                    ),
                                  )
                                  .toList()
                              : [
                                const DropdownMenuItem(
                                  value: 'General Volunteer',
                                  child: Text('General Volunteer'),
                                ),
                              ],
                      onChanged: (value) {
                        setState(() {
                          _selectedPrimaryRole = value as String?;
                          _checkFormCompletion();
                        });
                      },
                    ),

                    // Availability Field - Limited to 50 characters, no special characters
                    _buildTextField(
                      controller: _availabilityController,
                      label: 'Availability',
                      isRequired: true,
                      maxLength: 50,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9\s,.-]'),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your availability';
                        }
                        return null;
                      },
                    ),

                    // Reason for Volunteering Field - Limited to 200 characters
                    _buildTextField(
                      controller: _reasonController,
                      label: 'Reason for Volunteering',
                      isRequired: true,
                      maxLength: 200,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your reason for volunteering';
                        }
                        return null;
                      },
                      maxLines: 3,
                    ),

                    // Consent Form
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Text(
                          'Consent Form and Waiver',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _hasAcceptedConsent,
                            onChanged:
                                _hasReadConsent
                                    ? (value) {
                                      setState(() {
                                        _hasAcceptedConsent = value ?? false;
                                        _checkFormCompletion();
                                      });
                                    }
                                    : null,
                            activeColor: const Color(0xFF0A0E3D),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'By checking this box, you hereby agree',
                                  style: TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'and consent to the:',
                                  style: TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () {
                                    _showConsentForm();
                                  },
                                  child: const Text(
                                    'Consent Form and Waiver',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                if (!_hasReadConsent) ...[
                                  const SizedBox(height: 8),
                                  const Text(
                                    'You must read the consent form before checking this box',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
                      child: const Text('Back', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isFormValid ? _showConfirmationDialog : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A0E3D),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey,
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
    bool isRequired = false,
    int maxLines = 1,
    int? maxLength,
    String? hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isRequired) ...[
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText ?? 'Enter $label',
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
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              filled: true,
              fillColor: Colors.grey[50],
              counterText:
                  maxLength != null
                      ? '${controller.text.length}/$maxLength'
                      : null,
            ),
            validator: validator,
            maxLines: maxLines,
            maxLength: maxLength,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            onChanged: (value) {
              // Force rebuild to update counter and check form completion
              setState(() {
                _checkFormCompletion();
              });
            },
            buildCounter:
                maxLength != null
                    ? (
                      BuildContext context, {
                      required int currentLength,
                      required bool isFocused,
                      required int? maxLength,
                    }) {
                      return Text(
                        '$currentLength/$maxLength',
                        style: TextStyle(
                          color:
                              currentLength >= maxLength!
                                  ? Colors.red
                                  : Colors.grey[600],
                          fontSize: 12,
                        ),
                      );
                    }
                    : null,
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
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isRequired) ...[
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
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
