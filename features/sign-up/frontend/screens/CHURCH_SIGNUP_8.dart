import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../backend/models/CHURCH_SIGNUP_VAR.dart'; // For ChurchModel, FormValidation
import '../widgets/index.dart'; // For TeleoBackButton, CustomHeader, CustomTextFormField, CustomElevatedButton, LoadingOverlay
import 'CHURCH_SIGNUP_9.dart'; // For next screen

class ChurchAdminInfoScreen extends StatefulWidget {
  final ChurchModel church;

  const ChurchAdminInfoScreen({super.key, required this.church});

  @override
  State<ChurchAdminInfoScreen> createState() => _ChurchAdminInfoScreenState();
}

class _ChurchAdminInfoScreenState extends State<ChurchAdminInfoScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill if data exists
    if (widget.church.admins.isNotEmpty) {
      final admin = widget.church.admins.first; // Assuming one admin for now
      _firstNameController.text = admin.firstName ?? '';
      _lastNameController.text = admin.lastName ?? '';
      _emailController.text = admin.email ?? '';
      _phoneController.text = admin.phoneNumber?.replaceAll('+63', '') ?? '';
    }

    // Add listeners to update form validity
    _firstNameController.addListener(_updateFormValidity);
    _lastNameController.addListener(_updateFormValidity);
    _emailController.addListener(_updateFormValidity);
    _phoneController.addListener(_updateFormValidity);
    
    // Initial validation check
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateFormValidity());
  }

  @override
  void dispose() {
    _firstNameController.removeListener(_updateFormValidity);
    _lastNameController.removeListener(_updateFormValidity);
    _emailController.removeListener(_updateFormValidity);
    _phoneController.removeListener(_updateFormValidity);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _updateFormValidity() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  Future<void> _navigateToNextScreen() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final newAdmin = AdminModel(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phoneNumber: '+63${_phoneController.text}',
        role: 'Church Administrator', // Default role
      );

      final updatedChurch = widget.church.copyWith(
        admins: [newAdmin], // Replace or add to existing admins
      );

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChurchVerificationScreen(church: updatedChurch),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: _isLoading,
          message: 'Saving admin info...',
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              onChanged: () {
                _updateFormValidity();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: TeleoBackButton(),
                  ),
                  const SizedBox(height: 24),
                  
                  // Title
                  const CustomHeader(
                    title: "Church Admin\nPersonal\nInformation",
                    icon: Icons.admin_panel_settings,
                    iconColor: Colors.black,
                  ),
                  const SizedBox(height: 32),
                  
                  // Form fields in a scrollable container
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // First Name
                          const Text(
                            'First Name',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextFormField(
                            controller: _firstNameController,
                            labelText: 'First Name',
                            hintText: 'First name',
                            icon: Icons.person,
                            validator: (value) => FormValidation.validateRequired(value, 'first name'),
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: 16),
                          
                          // Last Name
                          const Text(
                            'Last Name',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextFormField(
                            controller: _lastNameController,
                            labelText: 'Last Name',
                            hintText: 'Last name',
                            icon: Icons.person_outline,
                            validator: (value) => FormValidation.validateRequired(value, 'last name'),
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: 16),
                          
                          // Email
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CustomTextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            labelText: 'Email',
                            hintText: 'example@email.com',
                            icon: Icons.email,
                            validator: (value) => FormValidation.validateEmail(value),
                          ),
                          const SizedBox(height: 16),
                          
                          // Phone Number
                          const Text(
                            'Phone Number',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Country code
                              Container(
                                width: 60,
                                height: 56,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Text(
                                    '+63',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Phone number field
                              Expanded(
                                child: CustomTextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.number,
                                  labelText: 'Phone Number',
                                  hintText: '9123456789',
                                  icon: Icons.phone,
                                  validator: (value) => FormValidation.validatePhone(value),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Next button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0, top: 16.0),
                    child: CustomElevatedButton(
                      onPressed: _isFormValid && !_isLoading
                          ? _navigateToNextScreen
                          : null,
                      text: 'Next',
                      isLoading: _isLoading,
                      backgroundColor: const Color(0xFF002642),
                      foregroundColor: Colors.white,
                      height: 56,
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
