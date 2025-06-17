import 'package:flutter/material.dart';
import '../2/c1homepage/admin_types.dart';

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
      backgroundColor: const Color(0xFF001A33),
      child: SafeArea(
        child: Column(
          children: [
            // Close button at the top right
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            // Profile section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  // Church icon in white circle
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.church,
                        size: 36,
                        color: Color(0xFFFFAA00),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Church name
                  Text(
                    adminData.churchName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            // Main menu items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildMenuItem(
                    context,
                    Icons.person_outline,
                    'Profile',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(AdminView.profile);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    Icons.church_outlined,
                    'Church',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(AdminView.home);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    Icons.inbox_outlined,
                    'Inbox',
                    onTap: () {
                      Navigator.pop(context);
                      // Inbox functionality will be added later
                    },
                  ),
                  _buildMenuItem(
                    context,
                    Icons.settings_outlined,
                    'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(AdminView.settings);
                    },
                  ),
                ],
              ),
            ),
            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Container(height: 1, color: Colors.white24),
            ),
            // Secondary menu items (without icons)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSecondaryMenuItem(context, 'App Guide'),
                      _buildSecondaryMenuItem(
                        context,
                        'FAQs',
                        onTap: () {
                          Navigator.pop(context);
                          onNavigate(AdminView.faqs);
                        },
                      ),
                      _buildSecondaryMenuItem(context, 'Contact Us'),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Logout button - fixed at the bottom
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/', (route) => false);
                },
                child: Row(
                  children: [
                    const Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Transform.rotate(
                      angle: 3.14159, // 180 degrees in radians
                      child: const Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryMenuItem(
    BuildContext context,
    String title, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
