import 'package:flutter/material.dart';
import 'home_page.dart';
import 'admin_types.dart';

class AdminSettingsView extends StatelessWidget {
  final Function(AdminView) onNavigate;

  const AdminSettingsView({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Settings header
            const Text(
              'Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Admin Dashboard',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Settings menu items
            _buildSettingsItem(
              context,
              Icons.person,
              'Your Account',
              'Edit your account information',
              onTap: () => onNavigate(AdminView.accountSettings),
            ),
            _buildSettingsItem(
              context,
              Icons.security,
              'Security and Account Access',
              'Manage your account\'s security',
              onTap: () => onNavigate(AdminView.securitySettings),
            ),
            _buildSettingsItem(
              context,
              Icons.notifications,
              'Manage Notifications',
              'Manage notifications received',
              onTap: () => onNavigate(AdminView.notificationSettings),
            ),
            _buildSettingsItem(
              context,
              Icons.event,
              'Mass Schedule',
              'Manage church mass schedules',
              onTap: () => onNavigate(AdminView.massSchedule),
            ),
            _buildSettingsItem(
              context,
              Icons.report_problem,
              'Report an Issue',
              'Report issues',
              onTap: () => onNavigate(AdminView.reportIssue),
            ),
            _buildSettingsItem(
              context,
              Icons.description,
              'Terms and Conditions',
              'Legal notes',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey[300]!),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: Icon(icon, color: Colors.black54),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}
