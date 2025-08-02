// lib/sidebar/frontend/settings/CHURCH_HOMEPAGE_SETTINGS.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../backend/models/admin_models.dart'; // Import AdminView and AuthenticatorFlow
import '../../backend/settings/church_settings_viewmodel.dart'; // Updated import

class ChurchHomepageSettings extends StatelessWidget {
  final AdminData adminData;
  final void Function(AdminView, {AuthenticatorFlow? flow, String? newValue})
      onNavigate;

  const ChurchHomepageSettings({super.key, required this.adminData, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChurchSettingsViewModel(
        adminData: adminData,
        onNavigate: onNavigate,
      ),
      child: Consumer<ChurchSettingsViewModel>(
        builder: (context, viewModel, child) {
          final List<_SettingItem> _settingsItems = [
            _SettingItem(
              icon: Icons.account_circle_outlined,
              title: 'Account Settings',
              subtitle: 'Manage your church profile and information',
              onTap: () => viewModel._onNavigate(AdminView.accountSettings),
            ),
            _SettingItem(
              icon: Icons.security_outlined,
              title: 'Security Settings',
              subtitle: 'Manage your password, email, and phone number',
              onTap: () => viewModel._onNavigate(AdminView.securitySettings),
            ),
            _SettingItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Manage your notification preferences',
              onTap: () => viewModel._onNavigate(AdminView.notificationSettings),
            ),
            _SettingItem(
              icon: Icons.calendar_today_outlined,
              title: 'Mass Schedule',
              subtitle: 'Manage your church mass schedule',
              onTap: () => viewModel._onNavigate(AdminView.massSchedule),
            ),
            _SettingItem(
              icon: Icons.policy_outlined,
              title: 'Terms and Conditions',
              subtitle: 'Read our terms and conditions',
              onTap: () => viewModel._onNavigate(AdminView.termsConditions),
            ),
            _SettingItem(
              icon: Icons.report_problem_outlined,
              title: 'Report an Issue',
              subtitle: 'Report a problem or provide feedback',
              onTap: () => viewModel._onNavigate(AdminView.reportIssue),
            ),
          ];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: ListView.separated(
              itemCount: _settingsItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = _settingsItems[index];
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
