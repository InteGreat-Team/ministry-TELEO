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
  bool _isProcessing = false; // Prevent multiple simultaneous operations

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
        if (mounted) setState(() {}); // Rebuild to update box decoration on focus change
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
        if (mounted) setState(() {});
      });
      node.dispose();
    }
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _clearErrorOnInput() {
    if (_error != null && mounted) {
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
      if (!mounted) {
        timer.cancel();
        return;
      }
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
    if (!_isResendEnabled || _isProcessing) return;
    
    setState(() {
      _isProcessing = true;
    });

    // Clear all text fields and errors before resending
    for (var controller in _controllers) {
      controller.clear();
    }
    setState(() {
      _error = null;
    });
    
    // Focus the first field after a brief delay to ensure UI is updated
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNodes[0].requestFocus();
      }
    });

    try {
      final newCode = await EmailService.sendVerificationCode(widget.email, "${widget.firstName} ${widget.lastName}");
      if (!mounted) return;
      setState(() {
        _currentCode = newCode;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verification code resent!')));
      _startCooldownTimer();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to resend code: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _validateCodeAndProceed() async {
    if (_isProcessing || !_isCodeComplete) return;
    
    setState(() {
      _isProcessing = true;
    });

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
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _handleTextChange(String value, int index) {
    if (_isProcessing) return; // Prevent input during processing

    // Handle input
    if (value.length == 1) {
      // A digit was entered - move to next field
      if (index < 5) {
        // Use post frame callback to ensure the text is set before moving focus
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _focusNodes[index + 1].requestFocus();
          }
        });
      } else {
        // Last field - unfocus to hide keyboard
        _focusNodes[index].unfocus();
      }
    } else if (value.isEmpty) {
      // Field was cleared - handle backspace logic
      if (index > 0) {
        // Move to previous field and position cursor at the end
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _focusNodes[index - 1].requestFocus();
            // Set cursor position to end of text
            final controller = _controllers[index - 1];
            controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length),
            );
          }
        });
      }
    }
    
    // Update UI
    if (mounted) {
      setState(() {});
    }
  }

  // Handle paste operation for better UX
  void _handlePaste(String pastedText) {
    if (pastedText.length >= 6) {
      final digits = pastedText.replaceAll(RegExp(r'[^0-9]'), '').substring(0, 6);
      for (int i = 0; i < 6 && i < digits.length; i++) {
        _controllers[i].text = digits[i];
      }
      // Focus the last filled field or unfocus if all are filled
      final lastIndex = digits.length - 1;
      if (lastIndex < 5) {
        _focusNodes[lastIndex + 1].requestFocus();
      } else {
        _focusNodes[lastIndex].unfocus();
      }
      setState(() {});
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
                  enabled: !_isProcessing, // Disable during processing
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Accept only digits
                    // Custom formatter to handle paste operations
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      // Handle paste of multiple digits
                      if (newValue.text.length > 1) {
                        _handlePaste(newValue.text);
                        return oldValue; // Keep the old value, we handle paste manually
                      }
                      return newValue;
                    }),
                  ],
                  style: TextStyle(
                    fontSize: isWeb ? 24.0 : 20.0,
                    fontWeight: FontWeight.bold,
                    color: _isProcessing ? Colors.grey : Colors.black,
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
                  onChanged: (value) => _handleTextChange(value, index),
                  onTap: () {
                    // Ensure cursor is positioned correctly when tapping
                    final controller = _controllers[index];
                    controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.text.length),
                    );
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
            onPressed: (_isResendEnabled && !_isProcessing) ? _resendCode : null,
            child: Text(
              _isResendEnabled
                  ? 'Haven\'t got the code yet? Resend code'
                  : 'Resend in $_formatCooldownTime',
              style: TextStyle(
                color: (_isResendEnabled && !_isProcessing) ? const Color(0xFF007AFF) : Colors.grey, // Hyperlink blue
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
              onPressed: (_isCodeComplete && !_isProcessing) ? _validateCodeAndProceed : null, // Enabled only when code is complete
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
              child: _isProcessing
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
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