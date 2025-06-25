import 'package:flutter/material.dart';
import 'dart:async';
import '../admin_types.dart';
import '../authenticator_flow.dart';

class AdminChangeEmailView extends StatefulWidget {
  final String currentEmail;
  final Function(AdminView, {AuthenticatorFlow? flow, String? newValue})
  onNavigate;

  const AdminChangeEmailView({
    super.key,
    required this.currentEmail,
    required this.onNavigate,
  });

  @override
  State<AdminChangeEmailView> createState() => _AdminChangeEmailViewState();
}

class _AdminChangeEmailViewState extends State<AdminChangeEmailView> {
  final _formKey = GlobalKey<FormState>();
  final _newEmailController = TextEditingController();
  bool _isSubmitted = false;

  @override
  void dispose() {
    _newEmailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitted = true;
      });
      // Navigate to authenticator view
      widget.onNavigate(
        AdminView.authenticator,
        flow: AuthenticatorFlow.email,
        newValue: _newEmailController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Old Email
            TextFormField(
              initialValue: widget.currentEmail,
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Old Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // New Email
            TextFormField(
              controller: _newEmailController,
              decoration: InputDecoration(
                labelText: 'New Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const Spacer(),
            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A2E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Send Code',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
