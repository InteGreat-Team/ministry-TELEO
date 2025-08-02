import 'package:flutter/material.dart';
import 'c1s7password_screen.dart';
import 'email_service.dart'; // Import the email service

class ContactInfoScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final DateTime birthday;
  final String gender;
  final String username;
  final String address;
  final double lat;
  final double lng;

  const ContactInfoScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.username,
    required this.address,
    required this.lat,
    required this.lng,
  });

  @override
  State<ContactInfoScreen> createState() => _ContactInfoScreenState();
}

class _ContactInfoScreenState extends State<ContactInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false; // Add loading state

  void _goToPasswordScreen() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Send verification code to email
        final sentCode = await EmailService.sendVerificationCode(
          _emailController.text.trim(),
          '${widget.firstName} ${widget.lastName}',
        );

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          // Navigate to password screen with the sent code
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PasswordScreen(
                firstName: widget.firstName,
                lastName: widget.lastName,
                birthday: widget.birthday,
                gender: widget.gender,
                username: widget.username,
                address: widget.address,
                lat: widget.lat,
                lng: widget.lng,
                email: _emailController.text.trim(),
                phoneNumber: _phoneController.text.trim().isEmpty
                    ? null
                    : _phoneController.text.trim(),
                sentCode: sentCode, // Pass the actual sent code
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send verification code: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Information')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                enabled: !_isLoading, // Disable when loading
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number (Optional)',
                ),
                enabled: !_isLoading, // Disable when loading
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final phoneRegex = RegExp(r'^\+63\d{10}$');
                    if (!phoneRegex.hasMatch(value)) {
                      return 'Enter a valid +63XXXXXXXXXX number';
                    }
                  }
                  return null;
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isLoading ? null : _goToPasswordScreen,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}