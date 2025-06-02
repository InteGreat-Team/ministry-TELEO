import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'c1s7password_screen.dart';
import '../../3/c1widgets/back_button.dart';

class ContactInfoScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final DateTime birthday;
  final String gender;
  final String username;
  final String location;

  const ContactInfoScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.username,
    required this.location,
  });

  @override
  State<ContactInfoScreen> createState() => _ContactInfoScreenState();
}

class _ContactInfoScreenState extends State<ContactInfoScreen> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _phoneError;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool get _isFormValid =>
      _emailController.text.isNotEmpty &&
      _isValidEmail(_emailController.text) &&
      _isValidPhone(_phoneController.text);

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\d{10}$'); // Validates a 10-digit phone number
    return phoneRegex.hasMatch(phone);
  }

  void _validatePhone() {
    setState(() {
      if (_phoneController.text.isEmpty) {
        _phoneError = 'Phone number is required';
      } else if (!_isValidPhone(_phoneController.text)) {
        _phoneError = 'Enter a valid 10-digit phone number';
      } else {
        _phoneError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button row
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: TeleoBackButton(),
              ),
              const SizedBox(height: 40),

              const Center(
                child: Text(
                  "Let's keep in touch!",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  "You'll need this to login",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),

              // Email field
              const Text(
                'Email',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'example@email.com',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF002642)),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 20),

              // Phone field with country code
              const Text(
                'Phone Number',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    // Country code part
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      child: const Text(
                        '+63',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Vertical divider
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    // Phone number input
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          hintText: '9123456789',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorText: _phoneError,
                        ),
                        onChanged: (_) => _validatePhone(),
                      ),
                    ),
                  ],
                ),
              ),
              if (_phoneError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _phoneError!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),

              const Spacer(),

              // Next button
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isFormValid
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PasswordScreen(
                                  firstName: widget.firstName,
                                  lastName: widget.lastName,
                                  birthday: widget.birthday,
                                  gender: widget.gender,
                                  username: widget.username,
                                  email: _emailController.text,
                                  phone: '+63 ${_phoneController.text}',
                                  location: widget.location,
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002642),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.3),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
