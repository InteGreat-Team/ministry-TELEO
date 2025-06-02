import 'package:flutter/material.dart';
import 'home_page.dart';
import 'admin_types.dart';

class AdminAccountSettingsView extends StatefulWidget {
  final AdminData adminData;
  final Function(AdminData) onUpdateAdminData;

  const AdminAccountSettingsView({
    super.key,
    required this.adminData,
    required this.onUpdateAdminData,
  });

  @override
  State<AdminAccountSettingsView> createState() =>
      _AdminAccountSettingsViewState();
}

class _AdminAccountSettingsViewState extends State<AdminAccountSettingsView> {
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

                // Account information section
                const Text(
                  'Account information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),

                _buildAccountItem(
                  context,
                  'Church Name',
                  widget.adminData.churchName,
                  Icons.church,
                ),

                _buildAccountItem(
                  context,
                  'Email',
                  widget.adminData.email,
                  Icons.email_outlined,
                ),

                _buildAccountItem(
                  context,
                  'Phone',
                  widget.adminData.phoneNumber,
                  Icons.phone_outlined,
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),

                // Church statistics section
                const Text(
                  'Church Statistics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),

                _buildStatItem(
                  context,
                  'Posts',
                  widget.adminData.posts,
                  Icons.post_add,
                ),

                _buildStatItem(
                  context,
                  'Followers',
                  widget.adminData.followers,
                  Icons.people_outline,
                ),

                _buildStatItem(
                  context,
                  'Following',
                  widget.adminData.following,
                  Icons.person_add_alt_outlined,
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),

                // Edit profile button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Show edit profile dialog or navigate to edit screen
                      _showEditProfileDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF001A33),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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

  Widget _buildAccountItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Padding(
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
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.black87),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF001A33),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final churchNameController = TextEditingController(
      text: widget.adminData.churchName,
    );
    final emailController = TextEditingController(text: widget.adminData.email);
    final phoneController = TextEditingController(
      text: widget.adminData.phoneNumber,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Profile'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: churchNameController,
                    decoration: const InputDecoration(labelText: 'Church Name'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Save changes
                  final updatedAdminData = AdminData(
                    churchName: churchNameController.text,
                    posts: widget.adminData.posts,
                    following: widget.adminData.following,
                    followers: widget.adminData.followers,
                    loginActivity: widget.adminData.loginActivity,
                    loginActivityPercentage:
                        widget.adminData.loginActivityPercentage,
                    dailyFollows: widget.adminData.dailyFollows,
                    dailyFollowsPercentage:
                        widget.adminData.dailyFollowsPercentage,
                    dailyVisits: widget.adminData.dailyVisits,
                    dailyVisitsPercentage:
                        widget.adminData.dailyVisitsPercentage,
                    bookings: widget.adminData.bookings,
                    bookingsPercentage: widget.adminData.bookingsPercentage,
                    email: emailController.text,
                    phoneNumber: phoneController.text,
                    password:
                        widget
                            .adminData
                            .password, // Added missing password parameter
                  );
                  widget.onUpdateAdminData(updatedAdminData);
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }
}
