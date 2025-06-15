import 'package:flutter/material.dart';
import '../admin_types.dart';

class AdminAccountSettingsView extends StatelessWidget {
  final AdminData adminData;
  final Function(AdminData) onUpdateAdminData;

  const AdminAccountSettingsView({
    super.key,
    required this.adminData,
    required this.onUpdateAdminData,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text('Church Name'),
          subtitle: Text(adminData.churchName),
          leading: const Icon(Icons.church),
        ),
        ListTile(
          title: const Text('Email'),
          subtitle: Text(adminData.email),
          leading: const Icon(Icons.email_outlined),
        ),
        ListTile(
          title: const Text('Phone Number'),
          subtitle: Text(adminData.phoneNumber),
          leading: const Icon(Icons.phone_outlined),
        ),
      ],
    );
  }
}
