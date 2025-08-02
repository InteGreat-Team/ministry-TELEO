// lib/sidebar/frontend/profile/CHURCH_HOMEPAGE_PROFILE.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../backend/models/admin_models.dart'; // Import AdminData
import '../../../backend/viewmodels/church_profile_viewmodel.dart'; // Import ChurchProfileViewModel
import '../../../backend/viewmodels/church_homepage_viewmodel.dart'; // Import ChurchHomePageViewModel for onUpdateAdminData

class ChurchHomepageProfile extends StatelessWidget {
  // These props are still needed because this screen might be navigated to directly
  // and needs initial data, or it might be part of a larger flow where data is passed.
  // The ViewModel will then manage this data.
  final AdminData adminData;
  final Function(AdminData) onUpdateAdminData; // Callback to update parent ViewModel

  const ChurchHomepageProfile({
    super.key,
    required this.adminData,
    required this.onUpdateAdminData,
  });

  @override
  Widget build(BuildContext context) {
    // Provide the ChurchProfileViewModel to this subtree.
    // It takes the initial adminData from the parent (ChurchHomePageViewModel).
    return ChangeNotifierProvider(
      create: (context) => ChurchProfileViewModel(adminData: adminData),
      child: Consumer<ChurchProfileViewModel>(
        builder: (context, profileViewModel, child) {
          // Access the adminData from the profileViewModel
          final currentAdminData = profileViewModel.adminData;

          return Container(
            color: const Color(0xFF001A33),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              'assets/images/church_logo.png',
                              width: 60,
                              height: 60,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.church,
                                  size: 40,
                                  color: Color(0xFFFFAA00),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            currentAdminData.churchName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentAdminData.email,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildStatsSection(currentAdminData),
                    const SizedBox(height: 32),
                    _buildProfileInfo(currentAdminData),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsSection(AdminData adminData) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Church Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Posts', adminData.posts),
                _buildStatItem('Following', adminData.following),
                _buildStatItem('Followers', adminData.followers),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF001A33),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo(AdminData adminData) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoItem(Icons.email, 'Email', adminData.email),
            const SizedBox(height: 12),
            _buildInfoItem(Icons.phone, 'Phone', adminData.phoneNumber),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF001A33)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
