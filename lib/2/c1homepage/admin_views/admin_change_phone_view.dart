import 'package:flutter/material.dart';
import '../admin_types.dart';
import '../authenticator_flow.dart';

class AdminChangePhoneView extends StatelessWidget {
  final AdminData adminData;
  final Function(AdminView, {AuthenticatorFlow? flow, String? newValue})
  onNavigate;

  const AdminChangePhoneView({
    super.key,
    required this.adminData,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Change Phone Number',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'New Phone Number',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              onNavigate(
                AdminView.authenticator,
                flow: AuthenticatorFlow.phone,
                newValue: value,
              );
            },
          ),
        ],
      ),
    );
  }
}
