import 'package:flutter/material.dart';
import '../admin_types.dart';

class AdminSettingsView extends StatelessWidget {
  final Function(AdminView, {AuthenticatorFlow? flow, String? newValue})
  onNavigate;

  const AdminSettingsView({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text('Account Settings'),
          leading: const Icon(Icons.person_outline),
          onTap: () => onNavigate(AdminView.accountSettings),
        ),
        ListTile(
          title: const Text('Security Settings'),
          leading: const Icon(Icons.security),
          onTap: () => onNavigate(AdminView.securitySettings),
        ),
        ListTile(
          title: const Text('Notification Settings'),
          leading: const Icon(Icons.notifications_outlined),
          onTap: () => onNavigate(AdminView.notificationSettings),
        ),
        ListTile(
          title: const Text('Mass Schedule'),
          leading: const Icon(Icons.calendar_today),
          onTap: () => onNavigate(AdminView.massSchedule),
        ),
      ],
    );
  }
}
