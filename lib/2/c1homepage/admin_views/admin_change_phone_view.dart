import 'package:flutter/material.dart';
import '../admin_types.dart';
import '../authenticator_flow.dart';

class AdminChangePhoneView extends StatefulWidget {
  final String currentPhoneNumber;
  final Function(AdminView, {AuthenticatorFlow? flow, String? newValue})
  onNavigate;

  const AdminChangePhoneView({
    super.key,
    required this.currentPhoneNumber,
    required this.onNavigate,
  });

  @override
  State<AdminChangePhoneView> createState() => _AdminChangePhoneViewState();
}

class _AdminChangePhoneViewState extends State<AdminChangePhoneView> {
  final _formKey = GlobalKey<FormState>();
  final _newPhoneController = TextEditingController();

  @override
  void dispose() {
    _newPhoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onNavigate(
        AdminView.authenticator,
        flow: AuthenticatorFlow.phone,
        newValue: _newPhoneController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => widget.onNavigate(AdminView.securitySettings),
        ),
        title: const Text(
          'Change Phone Number',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Old Phone Number
              TextFormField(
                initialValue: widget.currentPhoneNumber,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Old Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // New Phone Number
              TextFormField(
                controller: _newPhoneController,
                decoration: InputDecoration(
                  labelText: 'New Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid phone number';
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
      ),
    );
  }
}
