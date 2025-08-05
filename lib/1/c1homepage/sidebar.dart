import 'package:flutter/material.dart';
import '../../3/welcome_screen.dart'; // Import the welcome screen for logout navigation
import './lpcontent/homepage/landingpage.dart'; // Import AppConfig for colors

class Sidebar extends StatelessWidget {
  const Sidebar({super.key}); // Use super.key

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250.0, // Set a fixed narrower width for the sidebar
      backgroundColor:
          AppConfig.primaryColor, // Use the primary color from AppConfig
      child: Column(
        // Use Column to control vertical layout precisely
        children: <Widget>[
          // Fixed Top section with profile
          Padding(
            padding: const EdgeInsets.fromLTRB(
              24.0,
              60.0,
              16.0,
              24.0,
            ), // Adjusted padding for top and bottom
            child: Row( // Use Row to place avatar/name and the three-dot icon
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Placeholder for custom avatar image
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          '/placeholder.svg?height=60&width=60',
                        ), // Placeholder image
                        backgroundColor: Colors.grey,
                      ),
                      const SizedBox(height: 16), // Space between avatar and name
                      const Text(
                        'Guest', // Changed to Guest as per image
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Three-dot icon at the top right
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.white),
                  onPressed: () {
                    // Handle more options tap
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('More options coming soon!'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Scrollable Main content area
          Expanded(
            // This makes the ListView take available space and allows it to scroll
            child: ListView(
              padding: EdgeInsets.zero, // Remove default ListView padding
              children: [
                // Main navigation items
                _buildSidebarItem(
                  context,
                  icon: Icons.person_outline,
                  text: 'Profile',
                  onTap: () {
                    // Handle Profile tap
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                _buildSidebarItem(
                  context,
                  icon: Icons.inbox_outlined,
                  text: 'Inbox',
                  onTap: () {
                    // Handle Inbox tap
                    Navigator.pop(context);
                  },
                ),
                _buildSidebarItem(
                  context,
                  icon: Icons.settings_outlined,
                  text: 'Settings',
                  onTap: () {
                    // Handle Settings tap
                    Navigator.pop(context);
                  },
                ),
                // Donate Now button (kept in place as requested)
                _buildSidebarItem(
                  context,
                  icon:
                      Icons.volunteer_activism_outlined, // A suitable icon for donate
                  text: 'Donate Now',
                  textColor: AppConfig.accentColor, // Highlight donate button
                  onTap: () {
                    // Handle Donate Now tap
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Donate Now functionality coming soon!'),
                      ),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ), // Adjusted padding for divider
                  child: Divider(color: Colors.white54, height: 1), // Divider
                ),
                // App Guide section
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    24.0,
                    8.0,
                    16.0,
                    8.0,
                  ), // Adjusted padding for label
                  child: Text(
                    'App Guide',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _buildSidebarItem(
                  context,
                  icon: null, // No icon for these items in the image
                  text: 'FAQs',
                  onTap: () {
                    // Handle FAQs tap
                    Navigator.pop(context);
                  },
                ),
                _buildSidebarItem(
                  context,
                  icon: null,
                  text: 'Contact Us',
                  onTap: () {
                    // Handle Contact Us tap
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          // Fixed Logout button at the bottom-right corner
          Padding(
            padding: const EdgeInsets.only(
              bottom: 32.0,
              right: 24.0, // Added right padding to push it to the corner
            ),
            child: Align( // Use Align to push the button to the end
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  // Show confirmation dialog before logging out
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: const Text('Confirm Logout'),
                        content: const Text('Are you sure you want to log out?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop(); // Dismiss dialog
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop(); // Dismiss dialog
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WelcomeScreen(),
                                ),
                              );
                            },
                            child: const Text('Log Out', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red, // Set text color to red
                  padding: EdgeInsets.zero, // Remove default padding
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end, // Align content to the right
                  mainAxisSize: MainAxisSize.min, // Shrink to fit content
                  children: [
                    Text('Log Out', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 8), // Space between text and icon
                    Icon(
                      Icons.logout, // Changed icon to logout
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(
    BuildContext context, {
    IconData? icon,
    required String text,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading:
          icon != null ? Icon(icon, color: textColor ?? Colors.white) : null,
      title: Text(
        text,
        style: TextStyle(color: textColor ?? Colors.white, fontSize: 16),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24.0,
      ), // Increased horizontal padding
      minLeadingWidth: 24, // Adjust space for leading icon
      dense: true, // Make list tile more compact
    );
  }
}
