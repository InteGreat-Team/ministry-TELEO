import 'package:flutter/material.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildSettingsSection(
              'Account',
              [
                _buildSettingsItem(
                  context,
                  Icons.person_outline,
                  'Account Settings',
                  'Manage your account information',
                  onTap: () => onNavigate(AdminView.accountSettings),
                ),
                _buildSettingsItem(
                  context,
                  Icons.security,
                  'Security',
                  'Manage your security settings',
                  onTap: () => onNavigate(AdminView.securitySettings),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSettingsSection(
              'Preferences',
              [
                _buildSettingsItem(
                  context,
                  Icons.notifications_outlined,
                  'Notifications',
                  'Manage notification preferences',
                  onTap: () => onNavigate(AdminView.notificationSettings),
                ),
                _buildSettingsItem(
                  context,
                  Icons.event_outlined,
                  'Mass Schedule',
                  'Manage church mass schedules',
                  onTap: () => onNavigate(AdminView.massSchedule),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSettingsSection(
              'Help & Support',
              [
                _buildSettingsItem(
                  context,
                  Icons.help_outline,
                  'FAQs',
                  'View frequently asked questions',
                  onTap: () => onNavigate(AdminView.faqs),
                ),
                _buildSettingsItem(
                  context,
                  Icons.report_outlined,
                  'Report an Issue',
                  'Report technical problems',
                  onTap: () => onNavigate(AdminView.reportIssue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF001A33),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF001A33)),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
