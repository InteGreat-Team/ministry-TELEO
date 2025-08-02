import 'package:flutter/material.dart';
import 'c1s8terms_conditions_screen.dart';
import '../../3/c1widgets/back_button.dart';

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

  bool get _isFormValid =>
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty &&
      _passwordController.text == _confirmPasswordController.text;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                "We're almost done!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text("Secure your account with a password."),
              const SizedBox(height: 40),
              const Text('Password'),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 20),
              const Text('Confirm Password'),
              const SizedBox(height: 8),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  errorText: _error,
                ),
                onChanged: (_) {
                  setState(() {
                    _error = _passwordController.text != _confirmPasswordController.text
                        ? "Passwords do not match"
                        : null;
                  });
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
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
                              )

                            ),
                          );

                        }
                      : null,
                  child: const Text('Next'),
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
