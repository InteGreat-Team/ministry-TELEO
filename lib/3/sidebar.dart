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
    // Padding values for easy adjustment
    const double mainMenuItemSpacing = 20.0;
    const double secondaryMenuItemSpacing = 20.0;
    const double groupSpacing = 36.0;
    const EdgeInsets mainMenuPadding = EdgeInsets.symmetric(horizontal: 20.0);
    const EdgeInsets secondaryMenuPadding = EdgeInsets.symmetric(
      horizontal: 20.0,
    );
    const EdgeInsets logoutPadding = EdgeInsets.only(
      right: 20.0,
      bottom: 24.0,
    ); // bottom right

    return Drawer(
      backgroundColor: const Color(0xFF0A1633),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // All scrollable content in Expanded+SingleChildScrollView
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: logo only
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        left: 20.0,
                        right: 16.0,
                        bottom: 0,
                      ),
                      child: Row(
                        children: [
                          // Circular logo
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/avatar.png', // Placeholder logo
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Icon(
                                      Icons.person,
                                      size: 32,
                                      color: Colors.grey,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Church name
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        top: 8.0,
                        bottom: 24.0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          adminData.churchName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // ================= MAIN MENU ITEMS (edit mainMenuPadding/mainMenuItemSpacing) =================
                    Padding(
                      padding: mainMenuPadding,
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
                          SizedBox(height: mainMenuItemSpacing),
                          _buildMenuItem(
                            context,
                            Icons.church_outlined,
                            'Church',
                            onTap: () {
                              Navigator.pop(context);
                              onNavigate(AdminView.home);
                            },
                          ),
                          SizedBox(height: mainMenuItemSpacing),
                          _buildMenuItem(
                            context,
                            Icons.inbox_outlined,
                            'Inbox',
                            onTap: () {
                              Navigator.pop(context);
                              // Inbox functionality will be added later
                            },
                          ),
                          SizedBox(height: mainMenuItemSpacing),
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
                        horizontal: 20.0,
                        vertical: 18.0,
                      ),
                      child: Container(height: 1, color: Colors.white24),
                    ),
                    // ================= SECONDARY MENU ITEMS (edit secondaryMenuPadding/secondaryMenuItemSpacing) =================
                    Padding(
                      padding: secondaryMenuPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSecondaryMenuItem(context, 'App Guide'),
                          SizedBox(height: secondaryMenuItemSpacing),
                          _buildSecondaryMenuItem(
                            context,
                            'FAQs',
                            onTap: () {
                              Navigator.pop(context);
                              onNavigate(AdminView.faqs);
                            },
                          ),
                          SizedBox(height: secondaryMenuItemSpacing),
                          _buildSecondaryMenuItem(context, 'Contact Us'),
                        ],
                      ),
                    ),
                    SizedBox(height: groupSpacing),
                  ],
                ),
              ),
            ),
            // ================= LOGOUT BUTTON (edit logoutPadding) =================
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: logoutPadding,
                child: InkWell(
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/', (route) => false);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
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
    return InkWell(
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
    );
  }

  Widget _buildSecondaryMenuItem(
    BuildContext context,
    String title, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }
}
