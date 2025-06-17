import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'admin_types.dart';

class AdminChangePhoneView extends StatefulWidget {
  final AdminData adminData;
  final Function(AdminView, {AuthenticatorFlow? flow, String? newValue}) onNavigate;

  const AdminChangePhoneView({
    super.key,
    required this.adminData,
    required this.onNavigate,
  });

  @override
  State<AdminChangePhoneView> createState() => _AdminChangePhoneViewState();
}

class _AdminChangePhoneViewState extends State<AdminChangePhoneView> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _phoneController.text = widget.adminData.phoneNumber;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Change Phone Number',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Enter your new phone number below. You will need to verify this number before the change takes effect.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'New Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                  hintText: '(XXX) XXX-XXXX',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                  _PhoneNumberFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  // Remove non-digits for validation
                  final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
                  if (digitsOnly.length != 10) {
                    return 'Please enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onNavigate(
                        AdminView.authenticator,
                        flow: AuthenticatorFlow.phone,
                        newValue: _phoneController.text,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF001A33),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Continue'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    widget.onNavigate(AdminView.securitySettings);
                  },
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final buffer = StringBuffer();
    final digits = text.replaceAll(RegExp(r'\D'), '');

    int index = 0;
    // Area code
    if (digits.length > 0) {
      buffer.write('(');
      buffer.write(digits.substring(0, min(3, digits.length)));
      if (digits.length >= 3) buffer.write(') ');
      index = 3;
    }
    // First three digits
    if (digits.length > 3) {
      buffer.write(digits.substring(3, min(6, digits.length)));
      if (digits.length >= 6) buffer.write('-');
      index = 6;
    }
    // Last four digits
    if (digits.length > 6) {
      buffer.write(digits.substring(6, min(10, digits.length)));
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }

  int min(int a, int b) => a < b ? a : b;
}