import 'package:flutter/material.dart';
import '../admin_types.dart';
import '../authenticator_flow.dart';

class AdminChangeEmailView extends StatelessWidget {
  final AdminData adminData;
  final Function(AdminView, {AuthenticatorFlow? flow, String? newValue})
  onNavigate;

  const AdminChangeEmailView({
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
            'Change Email',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'New Email',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              onNavigate(
                AdminView.authenticator,
                flow: AuthenticatorFlow.email,
                newValue: value,
              );
            },
          ),
        ],
      ),
    );
  }
}
