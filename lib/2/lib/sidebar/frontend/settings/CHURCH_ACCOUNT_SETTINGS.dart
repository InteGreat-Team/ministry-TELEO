// lib/sidebar/frontend/settings/CHURCH_ACCOUNT_SETTINGS.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../backend/models/admin_models.dart'; // Import AdminData
import '../../backend/settings/church_settings_viewmodel.dart'; // Import the new ViewModel

class ChurchAccountSettings extends StatelessWidget {
  final AdminData adminData;
  final Function(AdminData) onUpdateAdminData;

  const ChurchAccountSettings({
    super.key,
    required this.adminData,
    required this.onUpdateAdminData,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChurchSettingsViewModel(
        adminData: adminData,
        onNavigate: (view, {flow, newValue}) {}, // Placeholder for onNavigate
      ),
      child: Consumer<ChurchSettingsViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Container(
                  width: 500,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo and name
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundImage: const AssetImage(
                              'assets/images/church_logo.png',
                            ),
                            backgroundColor: Colors.grey[200],
                            child: Image.asset(
                              'assets/images/church_logo.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.church,
                                  size: 36,
                                  color: Colors.orange,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            viewModel.churchNameController.text, // Use controller text
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const Text(
                            'Church',
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                      // Church Name
                      _buildEditableField('Church Name', viewModel.churchNameController, viewModel.isEditing),
                      const SizedBox(height: 16),
                      // Location with edit icon
                      _buildEditableFieldWithIcon('Location', viewModel.locationController, viewModel.isEditing),
                      const SizedBox(height: 16),
                      // Description with edit icon
                      _buildEditableFieldWithIcon(
                        'Church Description',
                        viewModel.descriptionController,
                        viewModel.isEditing,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      // Scheduled Masses with edit icon and add button
                      Row(
                        children: [
                          Expanded(
                            child: _buildEditableFieldWithIcon(
                              'Scheduled Masses',
                              viewModel.scheduleController,
                              viewModel.isEditing,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (viewModel.isEditing)
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                elevation: 0,
                                side: const BorderSide(color: Colors.black12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Add New Schedule'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Donation Information with avatar
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Donation Information',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                _buildDonationField('Gcash', viewModel.gcashController, viewModel.isEditing),
                                _buildDonationField('Maya', viewModel.mayaController, viewModel.isEditing),
                                _buildDonationField('BDO', viewModel.bdoController, viewModel.isEditing),
                                _buildDonationField('BPI', viewModel.bpiController, viewModel.isEditing),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: const AssetImage('assets/images/avatar.png'),
                            backgroundColor: Colors.grey[200],
                            child: Image.asset(
                              'assets/images/avatar.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.person,
                                  size: 20,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Edit/Save button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => viewModel.saveChanges(onUpdateAdminData),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A1633),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            viewModel.isEditing ? 'Save Changes' : 'Edit Profile',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller,
    bool isEnabled, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: isEnabled,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableFieldWithIcon(
    String label,
    TextEditingController controller,
    bool isEnabled, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            if (isEnabled)
              IconButton(
                icon: const Icon(Icons.edit, size: 18),
                onPressed: () {}, // This button doesn't need specific logic here, as the field is already editable
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: isEnabled,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDonationField(String label, TextEditingController controller, bool isEnabled) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: controller,
        enabled: isEnabled,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
