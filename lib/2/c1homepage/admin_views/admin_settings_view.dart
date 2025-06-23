import 'package:flutter/material.dart';
import '../admin_types.dart';
import '../authenticator_flow.dart';

class AdminSettingsView extends StatelessWidget {
  final void Function(AdminView, {AuthenticatorFlow? flow, String? newValue})
  onNavigate;

  const AdminSettingsView({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: ListView(
        children: [
          _buildSettingsCard(
            context,
            icon: Icons.person_outline,
            title: 'Your Account',
            subtitle: 'Edit your account information',
            onTap: () => onNavigate(AdminView.accountSettings),
          ),
          const SizedBox(height: 16),
          _buildSettingsCard(
            context,
            icon: Icons.security,
            title: 'Security and Account Access',
            subtitle: 'Manage your account\'s security',
            onTap: () => onNavigate(AdminView.securitySettings),
          ),
          const SizedBox(height: 16),
          _buildSettingsCard(
            context,
            icon: Icons.notifications_outlined,
            title: 'Manage Notifications',
            subtitle: 'Manage notifications received',
            onTap: () => onNavigate(AdminView.notificationSettings),
          ),
          const SizedBox(height: 16),
          _buildSettingsCard(
            context,
            icon: Icons.calendar_today,
            title: 'Mass Schedule',
            subtitle: 'Manage church mass schedules',
            onTap: () => onNavigate(AdminView.massSchedule),
          ),
          const SizedBox(height: 16),
          _buildSettingsCard(
            context,
            icon: Icons.report_gmailerrorred_outlined,
            title: 'Report an Issue',
            subtitle: 'Report issues',
            onTap: () => onNavigate(AdminView.reportIssue),
          ),
          const SizedBox(height: 16),
          _buildSettingsCard(
            context,
            icon: Icons.description_outlined,
            title: 'Terms and Conditions',
            subtitle: 'Legal notes',
            onTap: () => onNavigate(AdminView.termsAndConditions),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
      ),
      elevation: 0,
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Icon(icon, color: Colors.black, size: 28),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.black),
        onTap: onTap,
      ),
    );
  }
}
