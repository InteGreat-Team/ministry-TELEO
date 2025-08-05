import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'c1s5_1location_question_screen.dart';
import '../../3/c1widgets/back_button.dart';

class UsernameScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final DateTime birthday;
  final String gender;
    
  const UsernameScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
  });

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final _usernameController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  bool get _isFormValid => _usernameController.text.length >= 4;

  String? _validateUsername(String username) {
    if (username.isEmpty) {
      return null; // Don't show error for empty field
    }
    if (username.length < 4) {
      return 'Username must be at least 4 characters';
    }
    return null;
  }

  void _onUsernameChanged(String value) {
    setState(() {
      _errorMessage = _validateUsername(value);
    });
  }

  void _navigateToNext() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LocationQuestionScreen(
          firstName: widget.firstName,
          lastName: widget.lastName,
          birthday: widget.birthday,
          gender: widget.gender,
          username: _usernameController.text,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          
          var tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          
          // Add fade transition for smoother effect
          var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
              .animate(CurvedAnimation(parent: animation, curve: curve));
          
          return FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(position: offsetAnimation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
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
            // Back button at absolute top-left corner (same as other screens)
            const Positioned(
              top: 8.0,
              left: 8.0,
              child: TeleoBackButton(),
            ),
            
            // Main content - optimized layout
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
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: isWeb ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        SizedBox(height: isWeb ? 20 : 60), // Same height as other screens
        
        // Title
        Text(
          "How should we call you?",
          style: TextStyle(
            fontSize: isWeb ? 40.0 : 32.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isWeb ? 20 : 16),
        
        // Subtitle
        Text(
          "Give yourself a cool nickname",
          style: TextStyle(
            fontSize: isWeb ? 22.0 : 20.0,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isWeb ? 48 : 40),
        
        // Username field
        _buildTextField(
          controller: _usernameController,
          hintText: 'Username',
          isWeb: isWeb,
        ),
        
        // Error message
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
        
        SizedBox(height: isWeb ? 48 : 80), // Same spacing as other screens
        
        // Next button - exact measurements from other screens
        Padding(
          padding: EdgeInsets.only(bottom: isWeb ? 20.0 : 40.0),
          child: SizedBox(
            width: double.infinity,
            height: isWeb ? 60.0 : 56.0,
            child: ElevatedButton(
              onPressed: _isFormValid ? _navigateToNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF002642),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isWeb,
  }) {
    return TextField(
      controller: controller,
      maxLength: 20, // Limit to 20 characters
      inputFormatters: [
        LengthLimitingTextInputFormatter(20), // Enforce 20 character limit
      ],
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: _hintStyle,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isWeb ? 24.0 : 20.0,
          vertical: isWeb ? 20.0 : 18.0,
        ),
        filled: true,
        fillColor: _fillColor,
        border: _errorMessage != null ? _errorBorder : _inputBorder,
        enabledBorder: _errorMessage != null ? _errorBorder : _inputBorder,
        focusedBorder: _errorMessage != null ? _errorFocusedBorder : _focusedBorder,
        counterText: '', // Hide the character counter
      ),
      style: TextStyle(
        fontSize: isWeb ? 18.0 : 16.0,
        color: Colors.black,
      ),
      onChanged: _onUsernameChanged,
    );
  }

  // Cached styles for better performance
  static final _fillColor = Colors.grey.shade50;
  static final _hintStyle = TextStyle(
    color: Colors.grey.shade500,
    fontSize: 16.0,
  );
  static final _inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.grey.shade200),
  );
  static final _focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFF002642), width: 2),
  );
  static final _errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Colors.red),
  );
  static final _errorFocusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Colors.red, width: 2),
  );
}