import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for FilteringTextInputFormatter
import 'email_service.dart';
import 'c1s10profile_picture_screen.dart';
import '../../3/c1widgets/back_button.dart'; // Import the back button

class VerificationCodeScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final DateTime birthday;
  final String gender;
  final String username;
  final String email;
  final String password;
  final String sentCode;
  final String? phoneNumber;
  final String address;
  final double lat;
  final double lng;
  final bool hasAcceptedTerms;

  const VerificationCodeScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.username,
    required this.email,
    required this.password,
    required this.sentCode,
    required this.phoneNumber,
    required this.address,
    required this.lat,
    required this.lng,
    required this.hasAcceptedTerms,
  });

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isResendEnabled = true;
  int _cooldownSeconds = 0;
  Timer? _cooldownTimer;
  String? _error;
  String? _currentCode;

  @override
  void initState() {
    super.initState();
    _currentCode = widget.sentCode;
    _startCooldownTimer();

    // Add listeners to clear error when user starts typing
    for (var controller in _controllers) {
      controller.addListener(_clearErrorOnInput);
    }
    // Add listeners to update UI on focus change for visual feedback
    for (var node in _focusNodes) {
      node.addListener(() {
        setState(() {}); // Rebuild to update box decoration on focus change
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.removeListener(_clearErrorOnInput);
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.removeListener(() {
        setState(() {});
      });
      node.dispose();
    }
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _clearErrorOnInput() {
    if (_error != null) {
      setState(() {
        _error = null;
      });
    }
  }

  void _startCooldownTimer() {
    setState(() {
      _isResendEnabled = false;
      _cooldownSeconds = 60;
    });
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_cooldownSeconds > 0) {
          _cooldownSeconds--;
        } else {
          _isResendEnabled = true;
          timer.cancel();
        }
      });
    });
  }

  String get _formatCooldownTime {
    final minutes = (_cooldownSeconds / 60).floor();
    final seconds = _cooldownSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool get _isCodeComplete => _controllers.every((c) => c.text.isNotEmpty);
  String get _fullCode => _controllers.map((c) => c.text).join();

  Future<void> _resendCode() async {
    if (!_isResendEnabled) return;
    // Clear all text fields and errors before resending
    for (var controller in _controllers) {
      controller.clear();
    }
    setState(() {
      _error = null;
    });
    _focusNodes[0].requestFocus(); // Focus the first field

    final newCode = await EmailService.sendVerificationCode(widget.email, "${widget.firstName} ${widget.lastName}");
    if (!mounted) return;
    setState(() {
      _currentCode = newCode;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verification code resent!')));
    _startCooldownTimer();
  }

  Future<void> _validateCodeAndProceed() async {
    try {
      final isValid = await EmailService.verifyCode(widget.email, _fullCode);
      if (!mounted) return;
      if (isValid) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePictureScreen(
              firstName: widget.firstName,
              lastName: widget.lastName,
              birthday: widget.birthday,
              gender: widget.gender,
              username: widget.username,
              email: widget.email,
              phoneNumber: widget.phoneNumber,
              password: widget.password,
              address: widget.address,
              lat: widget.lat,
              lng: widget.lng,
              verificationCode: _fullCode,
              hasAcceptedTerms: widget.hasAcceptedTerms,
              isEmailVerified: true,
            ),
          ),
        );
      } else {
        setState(() => _error = 'Incorrect code. Please try again.');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Verification failed: $e')));
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
            // Back button at absolute top-left corner, consistent with previous screens
            const Positioned(
              top: 8.0,
              left: 8.0,
              child: TeleoBackButton(),
            ),
            
            // Main content area
            if (isWeb)
              Center(
                child: SizedBox(
                  width: 400, // Constrain width for web
                  child: _buildContent(isWeb),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildContent(isWeb),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(bool isWeb) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
      mainAxisAlignment: isWeb ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        SizedBox(height: isWeb ? 20 : 60), // Adjust spacing based on web/mobile
        
        // Title
        Text(
          'We\'ve sent a code to your email!',
          style: TextStyle(
            fontSize: isWeb ? 32.0 : 28.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isWeb ? 12 : 8),
        
        // Subtitle
        Text(
          'Enter the six digit code generated by your\nauthentication app.',
          style: TextStyle(
            fontSize: isWeb ? 18.0 : 16.0,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isWeb ? 48 : 32),
        
        // Verification Code Input Fields
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the row of text fields
          children: List.generate(6, (index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: isWeb ? 8.0 : 4.0), // Adjust spacing
              child: AnimatedContainer( // Use AnimatedContainer for smooth shadow transition
                duration: const Duration(milliseconds: 150), // Short animation duration
                width: isWeb ? 50 : 40, // Adjust width for responsiveness
                height: isWeb ? 60 : 50, // Adjust height for responsiveness
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8), // Slightly rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: _focusNodes[index].hasFocus // Change shadow based on focus
                          ? const Color(0xFF002540).withOpacity(0.3) // More prominent shadow when focused
                          : Colors.grey.withOpacity(0.2), // Subtle shadow when not focused
                      spreadRadius: _focusNodes[index].hasFocus ? 2 : 1, // Spread more when focused
                      blurRadius: _focusNodes[index].hasFocus ? 8 : 5, // Blur more when focused
                      offset: const Offset(0, 3), // Consistent shadow offset
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly // Accept only digits
                  ],
                  style: TextStyle(
                    fontSize: isWeb ? 24.0 : 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    counterText: '', // Hide the character counter
                    border: InputBorder.none, // Remove default TextField border
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero, // Remove default padding
                  ),
                  onChanged: (value) {
                    if (value.length == 1) { // A digit was typed
                      if (index < 5) {
                        _focusNodes[index + 1].requestFocus();
                      } else {
                        _focusNodes[index].unfocus(); // Unfocus last field
                      }
                    } else if (value.isEmpty && index > 0) { // Backspace pressed on an empty field
                      // Move focus to the previous field
                      _focusNodes[index - 1].requestFocus();
                      // Ensure cursor is at the end of the text in the previous field
                      // This helps with smooth backspacing if the user holds down backspace
                      _controllers[index - 1].selection = TextSelection.fromPosition(
                        TextPosition(offset: _controllers[index - 1].text.length),
                      );
                    }
                    setState(() {}); // Rebuild to update button state and focus visuals
                  },
                ),
              ),
            );
          }),
        ),
        
        // Error message
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              _error!,
              style: const TextStyle(color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        
        SizedBox(height: isWeb ? 32 : 24),
        
        // Resend Code button and timer
        Center(
          child: TextButton(
            onPressed: _isResendEnabled ? _resendCode : null,
            child: Text(
              _isResendEnabled
                  ? 'Haven\'t got the code yet? Resend code'
                  : 'Resend in $_formatCooldownTime',
              style: TextStyle(
                color: _isResendEnabled ? const Color(0xFF007AFF) : Colors.grey, // Hyperlink blue
                fontSize: isWeb ? 16.0 : 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        
        const Spacer(),
        
        // Verify Button
        Padding(
          padding: EdgeInsets.only(bottom: isWeb ? 20.0 : 40.0), // Consistent padding
          child: SizedBox(
            width: double.infinity,
            height: isWeb ? 60.0 : 56.0, // Consistent height
            child: ElevatedButton(
              onPressed: _isCodeComplete ? _validateCodeAndProceed : null, // Enabled only when code is complete
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF002540), // Consistent color
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300, // Greyed out when disabled
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Consistent border radius
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: Text(
                'Verify', // Text is 'Verify'
                style: TextStyle(
                  fontSize: isWeb ? 18.0 : 16.0, // Consistent font size
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
}