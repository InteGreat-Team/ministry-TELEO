import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for FilteringTextInputFormatter
import 'email_service.dart';
import 'c1s10profile_picture_screen.dart';
import '../../3/c1widgets/back_button.dart';

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
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  bool _isResendEnabled = true;
  int _cooldownSeconds = 0;
  Timer? _cooldownTimer;
  String? _error;
  String? _currentCode;
  String? _resendStatusMessage; // New state for dynamic message

  @override
  void initState() {
    super.initState();
    _currentCode = widget.sentCode;
    _startCooldownTimer(initialCall: true); // Pass initialCall flag

    // Request focus on the hidden TextField when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _otpFocusNode.requestFocus();
    });

    // Listen to changes in the single OTP controller to update UI
    _otpController.addListener(() {
      setState(() {
        // This rebuilds the UI to update the visual boxes and button state
      });
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldownTimer({bool initialCall = false}) {
    setState(() {
      _isResendEnabled = false;
      _cooldownSeconds = 60;
      if (!initialCall) { // Only show "Verification Sent" on actual resend action
        _resendStatusMessage = 'Verification Sent';
      }
    });

    // Clear previous timer if exists
    _cooldownTimer?.cancel();

    // Delay showing the timer if "Verification Sent" message is active
    Future.delayed(Duration(seconds: initialCall ? 0 : 2), () {
      if (!mounted) return;
      setState(() {
        _resendStatusMessage = null; // Clear "Verification Sent" message
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
    });
  }

  String get _formatCooldownTime {
    final minutes = (_cooldownSeconds / 60).floor();
    final seconds = _cooldownSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool get _isCodeComplete => _otpController.text.length == 6;
  String get _fullCode => _otpController.text;

  Future<void> _resendCode() async {
    if (!_isResendEnabled) return;
    final newCode = await EmailService.sendVerificationCode(widget.email, "${widget.firstName} ${widget.lastName}");
    if (!mounted) return;
    setState(() {
      _currentCode = newCode;
      _otpController.clear(); // Clear the input field
      _otpFocusNode.requestFocus(); // Re-focus the input field
      SystemChannels.textInput.invokeMethod('TextInput.show'); // Ensure keyboard is shown
      _error = null; // Clear any previous error
    });
    _startCooldownTimer(); // Start the cooldown and dynamic message
  }

  Future<void> _validateCodeAndProceed() async {
    try {
      // Simulate verification delay
      await Future.delayed(const Duration(milliseconds: 500));

      final isValid = _fullCode == _currentCode; // Use the sentCode for verification
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
          children: [
            // Back button at the top left
            const Padding(
              padding: EdgeInsets.only(top: 16.0, left: 8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: TeleoBackButton(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView( // Allow scrolling if content overflows (e.g., keyboard)
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // Center text elements
                  children: [
                    const SizedBox(height: 40), // Space after back button
                    Text(
                      'We\'ve sent a code\nto your email!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Enter the six digit code generated by your\nauthentication app.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Visual representation of the OTP input boxes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Evenly space the input boxes
                      children: List.generate(6, (index) {
                        String char = index < _otpController.text.length ? _otpController.text[index] : '';
                        bool isActive = _otpFocusNode.hasFocus && index == _otpController.text.length;
                        return GestureDetector(
                          onTap: () {
                            FocusScope.of(context).requestFocus(_otpFocusNode); // Ensure focus is requested
                            // Move cursor to the end of the current text in the hidden field
                            _otpController.selection = TextSelection.fromPosition(
                              TextPosition(offset: _otpController.text.length),
                            );
                          },
                          child: Container(
                            width: 48, // Slightly wider for aesthetic
                            height: 45, // Slightly shorter than width
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8), // Slightly rounded corners
                              border: Border.all(
                                color: isActive ? Colors.blue.shade700 : Colors.grey.shade300, // Highlight active box
                                width: 1.0, // Adjusted border width
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05), // Very subtle shadow
                                  spreadRadius: 0,
                                  blurRadius: 8,
                                  offset: Offset(0, 4), // Shadow below
                                ),
                              ],
                            ),
                            alignment: Alignment.center, // Center the character
                            child: Text(
                              char,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                          ),
                        );
                      }),
                    ),
                    // Hidden TextField for actual input
                    SizedBox(
                      width: 0, // Make it effectively invisible and not take space
                      height: 0,
                      child: Opacity(
                        opacity: 0.0,
                        child: TextField(
                          controller: _otpController,
                          focusNode: _otpFocusNode,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly, // Only allow digits
                          ],
                          decoration: InputDecoration(
                            counterText: '', // Hide the character counter
                            border: InputBorder.none, // Remove default TextField border
                          ),
                          // onChanged is used here to trigger setState for UI updates
                          // The actual typing and backspace logic is handled by the native TextField
                          onChanged: (value) {
                            setState(() {}); // Trigger rebuild to update the visual boxes
                          },
                        ),
                      ),
                    ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.red, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: 32),
                    Text(
                      'Haven\'t got the code yet? ',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8), // Space between static text and dynamic message/button
                    if (_resendStatusMessage != null)
                      Text(
                        _resendStatusMessage!,
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      )
                    else
                      TextButton(
                        onPressed: _isResendEnabled ? _resendCode : null,
                        child: Text(
                          _isResendEnabled
                              ? 'Resend code'
                              : 'Resend in $_formatCooldownTime',
                          style: TextStyle(
                            color: _isResendEnabled ? Colors.blue.shade700 : Colors.grey.shade500,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    const SizedBox(height: 40), // Space before the end of scrollable content
                  ],
                ),
              ),
            ),
            // Next button at the bottom, outside the scrollable area
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0, left: 24.0, right: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isCodeComplete ? _validateCodeAndProceed : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isCodeComplete
                        ? const Color(0xFF002642) // Dark blue when enabled
                        : Colors.grey.shade400, // Grey when disabled
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                  child: const Text(
                    'Next', // Changed from 'Verify' to 'Next'
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
    );
  }
}