import 'package:flutter/material.dart';
import 'home_page.dart';
import 'admin_types.dart';

class AdminSecuritySettingsView extends StatefulWidget {
  final AdminData adminData;
  final Function(AdminData) onUpdateAdminData;
  final Function(AdminView) onNavigate;

  const AdminSecuritySettingsView({
    super.key,
    required this.adminData,
    required this.onUpdateAdminData,
    required this.onNavigate,
  });

  @override
  State<AdminSecuritySettingsView> createState() =>
      _AdminSecuritySettingsViewState();
}

class _AdminSecuritySettingsViewState extends State<AdminSecuritySettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Security section
                const Text(
                  'Security',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),

                _buildSecurityItem(
                  context,
                  'Change Password',
                  'Update your password regularly for better security',
                  Icons.lock_outline,
                ),

                _buildSecurityItem(
                  context,
                  'Two-factor Authentication',
                  'Add an extra layer of security to your account',
                  Icons.security,
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),

                // Account access section
                const Text(
                  'Account Access',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),

                _buildSecurityItem(
                  context,
                  'Connected Accounts',
                  'Manage connections with other services',
                  Icons.link,
                ),

                _buildSecurityItem(
                  context,
                  'Admin Permissions',
                  'Manage admin access levels and permissions',
                  Icons.admin_panel_settings,
                ),

                _buildSecurityItem(
                  context,
                  'Apps and Sessions',
                  'See apps connected to your account and active sessions',
                  Icons.devices,
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),

                // Current information display
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow('Email', widget.adminData.email),
                      const SizedBox(height: 8),
                      _buildInfoRow('Phone', widget.adminData.phoneNumber),
                      const SizedBox(height: 8),
                      _buildInfoRow('Password', '••••••••••••••••'),
                      const SizedBox(height: 8),
                      _buildInfoRow('Access Level', 'Super Admin'),
                      const SizedBox(height: 8),
                      _buildInfoRow('Last Login', 'Today, 10:45 AM'),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black87),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
