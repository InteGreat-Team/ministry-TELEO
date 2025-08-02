// lib/sidebar/frontend/CHURCH_CONTACT_US.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../models/admin_models.dart'; // Import AdminView
import '../backend/contact_us_viewmodel.dart'; // Import the new viewmodel

class ChurchContactUsScreen extends StatelessWidget {
  final Function(AdminView) onNavigate;

  const ChurchContactUsScreen({super.key, required this.onNavigate});

  void _showResultDialog(BuildContext context, bool isSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSuccess ? Icons.check_circle : Icons.cancel,
                color: isSuccess ? Colors.green : Colors.red,
                size: 60,
              ),
              const SizedBox(height: 24),
              Text(
                isSuccess ? 'Successful' : 'Unsuccessful',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isSuccess
                    ? 'Thanks for reaching out! Our team will get back to you shortly.'
                    : 'We have encountered an error. Please try again.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E2A4A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContactUsViewModel(),
      child: Consumer<ContactUsViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            appBar: AppBar(
              backgroundColor: const Color(0xFF0D1B42),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => onNavigate(AdminView.home),
              ),
              title: const Text(
                'Contact Us',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Centered TELEO Header
                    const SizedBox(height: 32),
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'TELEO',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E2A4A),
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Your bridge to a stronger faith',
                            style: TextStyle(
                                fontSize: 14, color: Color(0xFF1E2A4A)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Contact Information Card - Updated to match the design
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF1a1f3a), // Dark blue
                            Color(0xFF2d1b69), // Medium purple
                            Color(0xFF4c1d95), // Purple
                          ],
                          stops: [0.0, 0.5, 1.0],
                        ),
                      ),
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Contact Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Say something to start a live chat!',
                            style: TextStyle(
                                fontSize: 14, color: Color(0xFFB3B3B3)),
                          ),
                          const SizedBox(height: 24),
                          // Phone
                          _buildContactRow(
                              FontAwesomeIcons.phone, '(0917) 445 9934'),
                          const SizedBox(height: 16),
                          // Email section
                          _buildContactRow(
                            FontAwesomeIcons.envelope,
                            'sample.admin@samplemail.com',
                          ),
                          const SizedBox(height: 8),
                          const Padding(
                            padding: EdgeInsets.only(left: 40.0),
                            child: Text(
                              'teleosupport@gmail.com',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Facebook
                          _buildSocialContactRow(
                            FontAwesomeIcons.facebookF,
                            'Teleo Official',
                          ),
                          const SizedBox(height: 16),
                          // Instagram
                          _buildSocialContactRow(
                            FontAwesomeIcons.instagram,
                            'Teleo Official',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Get in Touch Form
                    const Text(
                      'Get in touch with us',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E2A4A),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Form(
                      key: viewModel.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextFormField(
                            'First Name',
                            'Enter your first name',
                            viewModel.firstNameController,
                          ),
                          const SizedBox(height: 16),
                          _buildTextFormField(
                            'Last Name',
                            'Enter your last name',
                            viewModel.lastNameController,
                          ),
                          const SizedBox(height: 16),
                          _buildTextFormField(
                            'Email',
                            'Enter your email',
                            viewModel.emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextFormField(
                            'What are you contacting us for?',
                            'Type it here...',
                            viewModel.reasonController,
                          ),
                          const SizedBox(height: 16),
                          _buildTextFormField(
                            'Specify it here in detail:',
                            'Type it here...',
                            viewModel.detailsController,
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Send Message Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: viewModel.isSubmitting
                            ? null
                            : () async {
                                final success = await viewModel.submitForm();
                                _showResultDialog(context, success);
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF1E2A4A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: viewModel.isSubmitting
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text(
                                'Send Message',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          child: FaIcon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 16),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _buildSocialContactRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(child: FaIcon(icon, color: Colors.white, size: 12)),
          ),
        ),
        const SizedBox(width: 16),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _buildTextFormField(
    String label,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E2A4A),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            fillColor: Colors.white,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
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
              borderSide: const BorderSide(color: Color(0xFF1E2A4A)),
            ),
          ),
          validator: validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return 'This field cannot be empty';
                }
                return null;
              },
        ),
      ],
    );
  }
}

class ChurchContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: Center(child: Text('Contact Us Page')),
    );
  }
}
