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
      backgroundColor: const Color(0xFF001A33), // Dark blue background
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
                  // Church logo
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/church_logo.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.church,
                            size: 40,
                            color: Color(0xFFFFAA00),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Church name
                  Text(
                    adminData.churchName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
                    Icons.church,
                    'Church',
                    onTap: () {
                      Navigator.pop(context);
                      onNavigate(AdminView.home);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    Icons.inbox,
                    'Inbox',
                    onTap: () {
                      Navigator.pop(context);
                      // Inbox functionality will be added later
                    },
                  ),
                  _buildMenuItem(
                    context,
                    Icons.settings,
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
                vertical: 16.0,
              ),
              child: Container(height: 1, color: Colors.white.withOpacity(0.2)),
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

            // Spacer to push logout to bottom
            const Spacer(),

            // Logout button - fixed at the bottom
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () {
                  // Logout functionality
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
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Transform.rotate(
                      angle: 3.14159, // 180 degrees in radians
                      child: const Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 20,
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
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
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
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
