import 'package:flutter/material.dart';
import 'c1s7password_screen.dart';
import 'email_service.dart'; // Import the email service
import '../../3/c1widgets/back_button.dart'; // Import the back button

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
                phoneNumber: _phoneController.text.trim().isEmpty  // Changed from 'phone' to 'phoneNumber'
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
    final size = MediaQuery.sizeOf(context);
    final isWeb = size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Back button at absolute top-left corner
            const Positioned(
              top: 8.0,
              left: 8.0,
              child: TeleoBackButton(),
            ),
            
            // Main content
            if (isWeb)
              Center(
                child: SizedBox(
                  width: 400,
                  child: _buildForm(isWeb),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildForm(isWeb),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(bool isWeb) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isWeb ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          SizedBox(height: isWeb ? 20 : 60),
          
          // Title section
          Center(
            child: Column(
              children: [
                Text(
                  "Let's keep in touch!",
                  style: TextStyle(
                    fontSize: isWeb ? 32.0 : 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isWeb ? 12 : 8),
                Text(
                  "You'll need this to login",
                  style: TextStyle(
                    fontSize: isWeb ? 18.0 : 16.0,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: isWeb ? 64 : 60),
          
          // Email field
          Text(
            'Email',
            style: TextStyle(
              fontSize: isWeb ? 18.0 : 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: isWeb ? 12 : 8),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            enabled: !_isLoading,
            style: TextStyle(fontSize: isWeb ? 18.0 : 16.0),
            decoration: InputDecoration(
              hintText: 'example@email.com',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: isWeb ? 18.0 : 16.0,
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: EdgeInsets.symmetric(
                horizontal: isWeb ? 24.0 : 16.0,
                vertical: isWeb ? 20.0 : 16.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF002540), width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || !value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          
          SizedBox(height: isWeb ? 32 : 24),
          
          // Phone field
          Text(
            'Phone Number',
            style: TextStyle(
              fontSize: isWeb ? 18.0 : 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: isWeb ? 12 : 8),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            enabled: !_isLoading,
            maxLength: 13, // Updated to accept 13 characters (+63xxxxxxxxxx)
            style: TextStyle(fontSize: isWeb ? 18.0 : 16.0),
            decoration: InputDecoration(
              hintText: '+639xxxxxxxxx', // Updated hint text for Philippine numbers
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: isWeb ? 18.0 : 16.0,
              ),
              filled: true,
              fillColor: Colors.grey[50],
              counterText: '', // Hide the character counter
              contentPadding: EdgeInsets.symmetric(
                horizontal: isWeb ? 24.0 : 16.0,
                vertical: isWeb ? 20.0 : 16.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF002540), width: 2),
              ),
            ),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                // Updated regex for Philippine numbers (+639xxxxxxxxx)
                final phoneRegex = RegExp(r'^\+639\d{9}$');
                if (!phoneRegex.hasMatch(value)) {
                  return 'Enter a valid +639499768524 or Philippine number';
                }
              }
              return null;
            },
          ),
          
          const Spacer(),
          
          // Next button - exact measurements and placement from birthday screen
          Padding(
            padding: EdgeInsets.only(bottom: isWeb ? 20.0 : 40.0),
            child: SizedBox(
              width: double.infinity,
              height: isWeb ? 60.0 : 56.0, // Same height as birthday screen
              child: ElevatedButton(
                onPressed: _isLoading ? null : _goToPasswordScreen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF002540), // Updated color
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Same border radius as birthday screen
                  ),
                  elevation: 0, // Same elevation as birthday screen
                  shadowColor: Colors.transparent,
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Next',
                        style: TextStyle(
                          fontSize: isWeb ? 18.0 : 16.0, // Same font size as birthday screen
                          fontWeight: FontWeight.w600, // Same font weight as birthday screen
                        ),
                      ),
              ),
            ),
          ),
          if (isWeb) const SizedBox(height: 40),
        ],
      ),
    );
  }
}