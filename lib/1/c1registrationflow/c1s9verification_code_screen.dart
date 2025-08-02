import 'dart:async';
import 'package:flutter/material.dart';
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
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _cooldownTimer?.cancel();
    super.dispose();
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: TeleoBackButton(),
              ),
              const SizedBox(height: 40),
              const Text(
                'Enter Verification Code',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text('A code has been sent to ${widget.email}'),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 40,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: const InputDecoration(counterText: ''),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        setState(() {});
                      },
                    ),
                  );
                }),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: _isResendEnabled ? _resendCode : null,
                  child: Text(_isResendEnabled
                      ? 'Resend Code'
                      : 'Resend in $_formatCooldownTime'),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isCodeComplete ? _validateCodeAndProceed : null,
                  child: const Text('Verify'),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
