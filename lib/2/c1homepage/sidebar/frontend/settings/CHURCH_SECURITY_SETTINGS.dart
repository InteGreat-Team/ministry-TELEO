// lib/sidebar/frontend/settings/CHURCH_SECURITY_SETTINGS.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/admin_models.dart';
import '../../../sidebar/backend/settings/church_settings_viewmodel.dart';
import './CHURCH_CHANGE_EMAIL_SETTING.dart';
import './CHURCH_CHANGE_PASSWORD_SETTING.dart';
import './CHURCH_CHANGE_PHONE_SETTING.dart';

class ChurchSecuritySettings extends StatelessWidget {
  final AdminData adminData;
  final void Function(AdminView, {AuthenticatorFlow? flow, String? newValue})
      onNavigate;

  const ChurchSecuritySettings({
    super.key,
    required this.adminData,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    // Provide the ChurchSettingsViewModel to this subtree
    return Scaffold(
        appBar: AppBar(
          title: const Text('Security Settings'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ChangeNotifierProvider(
          create: (_) => ChurchSettingsViewModel(
            adminData: adminData,
            onNavigate: onNavigate,
          ),
          child: Consumer<ChurchSettingsViewModel>(
            builder: (context, viewModel, child) {
              final List<_SecuritySettingItem> _securitySettingsItems = [
                _SecuritySettingItem(
                  icon: Icons.email_outlined,
                  title: 'Change Email',
                  subtitle: 'Change your account email address',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (_) => ChurchSettingsViewModel(
                          adminData: adminData,
                          onNavigate: onNavigate,
                        ),
                        child: ChurchChangeEmailSetting(
                          adminData: adminData,
                          onNavigate: onNavigate,
                        ),
                      ),
                    ),
                  ),
                ),
                _SecuritySettingItem(
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                  subtitle: 'Change your account password',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (_) => ChurchSettingsViewModel(
                          adminData: adminData,
                          onNavigate: onNavigate,
                        ),
                        child: ChurchChangePasswordSetting(
                          adminData: adminData,
                          onNavigate: onNavigate,
                        ),
                      ),
                    ),
                  ),
                ),
                _SecuritySettingItem(
                  icon: Icons.phone_outlined,
                  title: 'Change Phone Number',
                  subtitle: 'Change your account phone number',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (_) => ChurchSettingsViewModel(
                          adminData: adminData,
                          onNavigate: onNavigate,
                        ),
                        child: ChurchChangePhoneSetting(
                          adminData: adminData,
                          onNavigate: onNavigate,
                        ),
                      ),
                    ),
                  ),
                ),
                _SecuritySettingItem(
                  icon: Icons.security,
                  title: 'Authenticator App',
                  subtitle: 'Set up two-factor authentication',
                  onTap: () => viewModel.onNavigate(AdminView.authenticator),
                ),
              ];

              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 24.0),
                child: ListView.separated(
                  itemCount: _securitySettingsItems.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = _securitySettingsItems[index];
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
        ));
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

// Private model for security settings item
class _SecuritySettingItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  _SecuritySettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
