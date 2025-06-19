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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 18),
          const Text(
            'Settings',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          const Text(
            'Admin Dashboard',
            style: TextStyle(color: Colors.black45, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          Expanded(
            child: ListView(
              children: [
                _buildSettingsCard(
                  context,
                  icon: Icons.person_outline,
                  title: 'Your Account',
                  subtitle: 'Edit your account information',
                  onTap: () => onNavigate(AdminView.accountSettings),
                ),
                _buildSettingsCard(
                  context,
                  icon: Icons.security,
                  title: 'Security and Account Access',
                  subtitle: 'Manage your account\'s security',
                  onTap: () => onNavigate(AdminView.securitySettings),
                ),
                _buildSettingsCard(
                  context,
                  icon: Icons.notifications_outlined,
                  title: 'Manage Notifications',
                  subtitle: 'Manage notifications received',
                  onTap: () => onNavigate(AdminView.notificationSettings),
                ),
                _buildSettingsCard(
                  context,
                  icon: Icons.calendar_today,
                  title: 'Mass Schedule',
                  subtitle: 'Manage church mass schedules',
                  onTap: () => onNavigate(AdminView.massSchedule),
                ),
                _buildSettingsCard(
                  context,
                  icon: Icons.report_gmailerrorred_outlined,
                  title: 'Report an Issue',
                  subtitle: 'Report issues',
                  onTap: () => onNavigate(AdminView.reportIssue),
                ),
                _buildSettingsCard(
                  context,
                  icon: Icons.description_outlined,
                  title: 'Terms and Conditions',
                  subtitle: 'Legal notes',
                  onTap: () => onNavigate(AdminView.termsAndConditions),
                ),
              ],
            ),
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
      color: Colors.white.withOpacity(0.7),
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[700], size: 28),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.black54, fontSize: 13),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.black38),
        onTap: onTap,
      ),
    );
  }
}
