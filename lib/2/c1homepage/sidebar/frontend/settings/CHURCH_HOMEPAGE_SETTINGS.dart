// lib/sidebar/frontend/settings/CHURCH_HOMEPAGE_SETTINGS.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/admin_models.dart';
import '../../../sidebar/backend/settings/church_settings_viewmodel.dart';
import 'package:ministry_teleo/2/c1homepage/sidebar/frontend/CHURCH_SIDE_BAR.dart';
import './CHURCH_ACCOUNT_SETTINGS.dart';
import './CHURCH_SECURITY_SETTINGS.dart';
import './CHURCH_NOTIFICATIONS_SETTING.dart';
import './CHURCH_MASS_SCHEDULE_SETTING.dart';
import './CHURCH_TNC_SETTING.dart';
import '../report_screen/CHURCH_REPORT_SCREEN.dart';

// Settings item model
class SettingItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  SettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

class ChurchHomepageSettings extends StatelessWidget {
  final AdminData adminData;
  final void Function(AdminView, {AuthenticatorFlow? flow, String? newValue})
      onNavigate;

  const ChurchHomepageSettings({
    super.key,
    required this.adminData,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: ChurchSideBar(
        adminData: adminData,
        onUpdateAdminData: (adminData) {},
      ),
      body: ChangeNotifierProvider(
        create: (context) => ChurchSettingsViewModel(
          adminData: adminData,
          onNavigate: onNavigate,
        ),
        child: Consumer<ChurchSettingsViewModel>(
          builder: (context, viewModel, child) {
            final settingsItems = [
              SettingItem(
                icon: Icons.account_circle_outlined,
                title: 'Account Settings',
                subtitle: 'Manage your church profile and information',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChurchAccountSettings(
                        adminData: adminData,
                        onUpdateAdminData: (updatedData) {
                          // Update the admin data in the parent widget
                          final viewModel =
                              context.read<ChurchSettingsViewModel>();
                          viewModel.toggleEditing(); // Exit edit mode
                          // Notify parent about the updated data
                          viewModel.saveChanges((newData) {
                            // This will update the admin data in the view model
                            // and notify any listeners
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              SettingItem(
                icon: Icons.security_outlined,
                title: 'Security Settings',
                subtitle: 'Manage your password, email, and phone number',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChurchSecuritySettings(
                        adminData: adminData,
                        onNavigate: (view, {flow, newValue}) {
                          onNavigate(view, flow: flow, newValue: newValue);
                        },
                      ),
                    ),
                  );
                },
              ),
              SettingItem(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Manage your notification preferences',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (_) => ChurchSettingsViewModel(
                          adminData: adminData,
                          onNavigate: onNavigate,
                        ),
                        child: ChurchNotificationSetting(
                          onNavigate: onNavigate,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SettingItem(
                icon: Icons.calendar_today_outlined,
                title: 'Mass Schedule',
                subtitle: 'Manage your church mass schedule',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChurchMassScheduleSetting(
                        onNavigate: onNavigate,
                      ),
                    ),
                  );
                },
              ),
              SettingItem(
                icon: Icons.policy_outlined,
                title: 'Terms and Conditions',
                subtitle: 'Read our terms and conditions',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (_) => ChurchSettingsViewModel(
                          adminData: adminData,
                          onNavigate: onNavigate,
                        ),
                        child: ChurchTncSetting(
                          onNavigate: onNavigate,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SettingItem(
                icon: Icons.report_problem_outlined,
                title: 'Report an Issue',
                subtitle: 'Report a problem or provide feedback',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChurchReportScreen(
                        onNavigate: onNavigate,
                      ),
                    ),
                  );
                },
              ),
            ];

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: ListView.separated(
                itemCount: settingsItems.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = settingsItems[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side:
                          const BorderSide(color: Color(0xFFE0E0E0), width: 1),
                    ),
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      leading: Icon(item.icon, color: Colors.black, size: 28),
                      title: Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        item.subtitle,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      trailing:
                          const Icon(Icons.chevron_right, color: Colors.black),
                      onTap: item.onTap,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
