import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../backend/models/CHURCH_SIGNUP_VAR.dart'; // For ChurchModel, FormValidation
import '../widgets/index.dart'; // For TeleoBackButton, CustomHeader, CustomTextFormField, CustomElevatedButton
import 'CHURCH_SIGNUP_7.dart'; // For next screen

class ChurchContactScreen extends StatefulWidget {
  final ChurchModel church;

  const ChurchContactScreen({
    super.key,
    required this.church,
  });

  @override
  State<ChurchContactScreen> createState() => _ChurchContactScreenState();
}

class _ChurchContactScreenState extends State<ChurchContactScreen> {
  final _churchEmailController = TextEditingController();
  final _contactEmailController = TextEditingController(); // Renamed for clarity
  final _phoneController = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill if data exists
    if (widget.church.email != null && widget.church.email!.isNotEmpty) {
      _churchEmailController.text = widget.church.email!;
    }
    // Assuming contactEmail and contactPhone are separate fields in ChurchModel
    // For now, mapping to existing email and phoneNumber for simplicity
    if (widget.church.email != null && widget.church.email!.isNotEmpty) {
      _contactEmailController.text = widget.church.email!;
    }
    if (widget.church.phoneNumber != null && widget.church.phoneNumber!.isNotEmpty) {
      _phoneController.text = widget.church.phoneNumber!.replaceAll('+63', '');
    }
    
    // Add listeners to update form validity
    _churchEmailController.addListener(_updateFormValidity);
    _contactEmailController.addListener(_updateFormValidity);
    _phoneController.addListener(_updateFormValidity);
    
    // Initial validation check
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateFormValidity());
  }

  @override
  void dispose() {
    _churchEmailController.removeListener(_updateFormValidity);
    _contactEmailController.removeListener(_updateFormValidity);
    _phoneController.removeListener(_updateFormValidity);
    _churchEmailController.dispose();
    _contactEmailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _updateFormValidity() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            onChanged: () {
              // This onChanged is called when any form field changes,
              // which is useful for real-time validation updates.
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
                  title: "Contact\nInformation",
                  icon: Icons.contact_mail,
                  iconColor: Colors.black,
                ),
                const SizedBox(height: 32),
                
                // Church Email
                const Text(
                  'Church Email',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: _churchEmailController,
                  keyboardType: TextInputType.emailAddress,
                  labelText: 'Church Email',
                  hintText: 'example@church.com',
                  icon: Icons.email,
                  validator: (value) => FormValidation.validateEmail(value),
                ),
                const SizedBox(height: 16),
                
                // Contact Person Email (renamed from 'Email' for clarity)
                const Text(
                  'Contact Person Email',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: _contactEmailController,
                  keyboardType: TextInputType.emailAddress,
                  labelText: 'Contact Email',
                  hintText: 'example@email.com',
                  icon: Icons.person,
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
                      height: 56, // Match CustomTextFormField height
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
                
                const Spacer(),
                
                // Next button
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: CustomElevatedButton(
                    onPressed: _isFormValid
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              final updatedChurch = widget.church.copyWith(
                                email: _churchEmailController.text, // Church email
                                // Assuming a separate field for contact person's email
                                // For now, mapping to existing email field
                                phoneNumber: '+63${_phoneController.text}',
                              );
                              
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChurchSecureAccountScreen(
                                    church: updatedChurch,
                                  ),
                                ),
                              );
                            }
                          }
                        : null,
                    text: 'Next',
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
    );
  }
}
