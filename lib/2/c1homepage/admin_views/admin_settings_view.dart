import 'package:flutter/material.dart';
import '../admin_types.dart';
import '../authenticator_flow.dart';

class AdminSettingsView extends StatelessWidget {
  final void Function(AdminView, {AuthenticatorFlow? flow, String? newValue})
  onNavigate;

  const AdminSettingsView({super.key, required this.onNavigate});

  // TODO: Replace with backend data source
  List<_SettingItem> get settingsItems => [
    _SettingItem(
      icon: Icons.person_outline,
      title: 'Your Account',
      subtitle: 'Edit your account information',
      onTap: () => onNavigate(AdminView.accountSettings),
    ),
    _SettingItem(
      icon: Icons.security,
      title: 'Security and Account Access',
      subtitle: 'Manage your account\'s security',
      onTap: () => onNavigate(AdminView.securitySettings),
    ),
    _SettingItem(
      icon: Icons.notifications_outlined,
      title: 'Manage Notifications',
      subtitle: 'Manage notifications received',
      onTap: () => onNavigate(AdminView.notificationSettings),
    ),
    _SettingItem(
      icon: Icons.calendar_today,
      title: 'Mass Schedule',
      subtitle: 'Manage church mass schedules',
      onTap: () => onNavigate(AdminView.massSchedule),
    ),
    _SettingItem(
      icon: Icons.report_gmailerrorred_outlined,
      title: 'Report an Issue',
      subtitle: 'Report issues',
      onTap: () => onNavigate(AdminView.reportIssue),
    ),
    _SettingItem(
      icon: Icons.description_outlined,
      title: 'Terms and Conditions',
      subtitle: 'Legal notes',
      onTap: () => onNavigate(AdminView.termsAndConditions),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: ListView.separated(
        itemCount: settingsItems.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = settingsItems[index];
          return _buildSettingsCard(
            context,
            icon: item.icon,
            title: item.title,
            subtitle: item.subtitle,
            onTap: item.onTap,
          );
        },
      ),
    );
  }

  // Card builder for each settings item
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

// Private model for settings item (for easy backend swap)
class _SettingItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  _SettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
