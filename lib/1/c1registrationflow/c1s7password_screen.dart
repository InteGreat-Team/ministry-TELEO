import 'package:flutter/material.dart';
import 'c1s8terms_conditions_screen.dart';
import '../../3/c1widgets/back_button.dart'; // Import the back button

class PasswordScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final DateTime birthday;
  final String gender;
  final String username;
  final String email;
  final String? phoneNumber;
  final String address;
  final double lat;
  final double lng;
  final String sentCode;

  const PasswordScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.username,
    required this.email,
    required this.address,
    required this.lat,
    required this.lng,
    required this.sentCode,
    this.phoneNumber,
  });

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _error;
  
  // Password visibility states
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Password validation criteria
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasDigit = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validateConfirmPassword);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_validatePassword);
    _confirmPasswordController.removeListener(_validateConfirmPassword);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      _hasDigit = password.contains(RegExp(r'[0-9]'));
      // Updated regex to include more special characters including underscore
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_+=\-\[\]\\\/~`]'));
      _validateConfirmPassword(); // Re-validate confirm password on password change
    });
  }

  void _validateConfirmPassword() {
    setState(() {
      _error = _passwordController.text != _confirmPasswordController.text &&
              _confirmPasswordController.text.isNotEmpty
          ? "Passwords do not match"
          : null;
    });
  }

  bool get _isFormValid {
    return _hasMinLength &&
        _hasUppercase &&
        _hasLowercase &&
        _hasDigit &&
        _hasSpecialChar &&
        _passwordController.text == _confirmPasswordController.text &&
        _passwordController.text.isNotEmpty; // Ensure password field is not empty
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isWeb ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        SizedBox(height: isWeb ? 20 : 60),
        
        // Title section
        Text(
          "We're almost done!",
          style: TextStyle(
            fontSize: isWeb ? 32.0 : 28.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: isWeb ? 12 : 16),
        Text(
          "Secure your account with a password.",
          style: TextStyle(
            fontSize: isWeb ? 18.0 : 16.0,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: isWeb ? 48 : 40),
        
        // Password field
        Text(
          'Password',
          style: TextStyle(
            fontSize: isWeb ? 18.0 : 16.0,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: isWeb ? 12 : 8),
        TextField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          style: TextStyle(fontSize: isWeb ? 18.0 : 16.0),
          decoration: InputDecoration(
            hintText: 'Enter your password',
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
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return RotationTransition(
                    turns: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  key: ValueKey<bool>(_isPasswordVisible),
                  color: Colors.grey[600],
                  size: 20,
                ),
              ),
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
        ),
        
        SizedBox(height: isWeb ? 24 : 20),
        
        // Password checklist
        _buildPasswordChecklistItem('At least 8 characters', _hasMinLength),
        _buildPasswordChecklistItem('Contains an uppercase letter', _hasUppercase),
        _buildPasswordChecklistItem('Contains a lowercase letter', _hasLowercase),
        _buildPasswordChecklistItem('Contains a digit', _hasDigit),
        _buildPasswordChecklistItem('Contains a special character', _hasSpecialChar),
        
        SizedBox(height: isWeb ? 24 : 20),
        
        // Confirm Password field
        Text(
          'Confirm Password',
          style: TextStyle(
            fontSize: isWeb ? 18.0 : 16.0,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: isWeb ? 12 : 8),
        TextField(
          controller: _confirmPasswordController,
          obscureText: !_isConfirmPasswordVisible,
          style: TextStyle(fontSize: isWeb ? 18.0 : 16.0),
          decoration: InputDecoration(
            hintText: 'Confirm your password',
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
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return RotationTransition(
                    turns: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Icon(
                  _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  key: ValueKey<bool>(_isConfirmPasswordVisible),
                  color: Colors.grey[600],
                  size: 20,
                ),
              ),
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
            errorText: _error,
          ),
        ),
        
        const Spacer(),
        
        // Next button
        Padding(
          padding: EdgeInsets.only(bottom: isWeb ? 20.0 : 40.0),
          child: SizedBox(
            width: double.infinity,
            height: isWeb ? 60.0 : 56.0,
            child: ElevatedButton(
              onPressed: _isFormValid
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TermsConditionsScreen(
                            firstName: widget.firstName,
                            lastName: widget.lastName,
                            birthday: widget.birthday,
                            gender: widget.gender,
                            username: widget.username,
                            email: widget.email,
                            phoneNumber: widget.phoneNumber,
                            password: _passwordController.text,
                            address: widget.address,
                            lat: widget.lat,
                            lng: widget.lng,
                            sentCode: widget.sentCode,
                            isViewOnly: false,
                          ),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF002540), // Consistent color
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: Text(
                'Next',
                style: TextStyle(
                  fontSize: isWeb ? 18.0 : 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        if (isWeb) const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildPasswordChecklistItem(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              isValid ? Icons.check_circle : Icons.remove_circle_outline,
              key: ValueKey<bool>(isValid), // Key is crucial for AnimatedSwitcher
              color: isValid ? Colors.green : Colors.grey,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              color: isValid ? Colors.black87 : Colors.grey,
              fontSize: 14,
            ),
            child: Text(text),
          ),
        ],
      ),
    );
  }
}