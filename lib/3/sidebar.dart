import 'package:flutter/material.dart';
import '../2/c1homepage/admin_types.dart';
import '../3/c1widgets/logout_dialog.dart';

class AdminDrawer extends StatelessWidget {
  final Function(AdminView) onNavigate;
  final AdminData adminData;

  const AdminDrawer({
    super.key,
    required this.onNavigate,
    required this.adminData,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E2A4A),
      width: 280,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with avatar and name
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Name
                  Text(
                    adminData.churchName.isNotEmpty
                        ? adminData.churchName
                        : 'Sunny Treasure',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Main menu items
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildMenuItem(
                      Icons.person_outline_rounded,
                      'Profile',
                      onTap: () {
                        Navigator.pop(context);
                        onNavigate(AdminView.profile);
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildMenuItem(
                      Icons.church_rounded,
                      'Church',
                      onTap: () {
                        Navigator.pop(context);
                        onNavigate(AdminView.home);
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildMenuItem(
                      Icons.inbox_rounded,
                      'Inbox',
                      onTap: () {
                        Navigator.pop(context);
                        // Inbox functionality
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildMenuItem(
                      Icons.settings_rounded,
                      'Settings',
                      onTap: () {
                        Navigator.pop(context);
                        onNavigate(AdminView.settings);
                      },
                    ),

                    // Divider
                    const SizedBox(height: 40),
                    Container(height: 1, color: Colors.white.withOpacity(0.2)),
                    const SizedBox(height: 30),

                    // Secondary menu items
                    _buildSecondaryMenuItem('App Guide'),
                    const SizedBox(height: 20),
                    _buildSecondaryMenuItem(
                      'FAQs',
                      onTap: () {
                        Navigator.pop(context);
                        onNavigate(AdminView.faqs);
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildSecondaryMenuItem(
                      'Contact Us',
                      onTap: () {
                        Navigator.pop(context);
                        onNavigate(AdminView.contactUs);
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Logout button at bottom right
            Padding(
              padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Log Out',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.logout_rounded,
                            color: Colors.red,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return LogoutDialog(
          isSuccess: false,
          onConfirm: () {
            Navigator.of(dialogContext).pop(); // Close the confirmation dialog
            _showLogoutSuccessDialog(context);
          },
          onCancel: () {
            Navigator.of(dialogContext).pop();
          },
        );
      },
    );
  }

  void _showLogoutSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return LogoutDialog(
          isSuccess: true,
          onConfirm: () {
            Navigator.of(dialogContext).pop(); // Close the success dialog
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/', (route) => false);
          },
          onCancel: () {}, // Not used for success dialog
        );
      },
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryMenuItem(String title, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
