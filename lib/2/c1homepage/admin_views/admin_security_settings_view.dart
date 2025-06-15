import 'package:flutter/material.dart';
import '../admin_types.dart';
import '../authenticator_flow.dart';

class AdminSecuritySettingsView extends StatelessWidget {
  final AdminData adminData;
  final Function(AdminData) onUpdateAdminData;
  final Function(AdminView, {AuthenticatorFlow? flow, String? newValue})
  onNavigate;

  const AdminSecuritySettingsView({
    super.key,
    required this.adminData,
    required this.onUpdateAdminData,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text('Change Email'),
          subtitle: Text(adminData.email),
          leading: const Icon(Icons.email_outlined),
          onTap: () => onNavigate(AdminView.changeEmail),
        ),
        ListTile(
          title: const Text('Change Password'),
          subtitle: Text(adminData.password),
          leading: const Icon(Icons.lock_outline),
          onTap: () => onNavigate(AdminView.changePassword),
        ),
        ListTile(
          title: const Text('Change Phone Number'),
          subtitle: Text(adminData.phoneNumber),
          leading: const Icon(Icons.phone_outlined),
          onTap: () => onNavigate(AdminView.changePhone),
        ),
      ],
    );
  }
}
