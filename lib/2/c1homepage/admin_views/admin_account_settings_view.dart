import 'package:flutter/material.dart';
import '../admin_types.dart';

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
  late TextEditingController _churchNameController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  late TextEditingController _scheduleController;
  late TextEditingController _gcashController;
  late TextEditingController _mayaController;
  late TextEditingController _bdoController;
  late TextEditingController _bpiController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _churchNameController = TextEditingController(
      text: widget.adminData.churchName,
    );
    _locationController = TextEditingController(
      text: '941 Sunny Treasure Line, Detroit, CA 59120',
    );
    _descriptionController = TextEditingController(
      text:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim...',
    );
    _scheduleController = TextEditingController(
      text: 'Wednesdays - 8:00 AM - 11:00 AM',
    );
    _gcashController = TextEditingController(text: '09182763484');
    _mayaController = TextEditingController(text: '09189327642');
    _bdoController = TextEditingController(text: '00089287394');
    _bpiController = TextEditingController(text: '0001283974');
  }

  @override
  void dispose() {
    _churchNameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _scheduleController.dispose();
    _gcashController.dispose();
    _mayaController.dispose();
    _bdoController.dispose();
    _bpiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      backgroundImage: AssetImage(
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
                      widget.adminData.churchName,
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
                _buildEditableField('Church Name', _churchNameController),
                const SizedBox(height: 16),
                // Location with edit icon
                _buildEditableFieldWithIcon('Location', _locationController),
                const SizedBox(height: 16),
                // Description with edit icon
                _buildEditableFieldWithIcon(
                  'Church Description',
                  _descriptionController,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                // Scheduled Masses with edit icon and add button
                Row(
                  children: [
                    Expanded(
                      child: _buildEditableFieldWithIcon(
                        'Scheduled Masses',
                        _scheduleController,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (_isEditing)
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
                          _buildDonationField('Gcash', _gcashController),
                          _buildDonationField('Maya', _mayaController),
                          _buildDonationField('BDO', _bdoController),
                          _buildDonationField('BPI', _bpiController),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/avatar.png'),
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
                    onPressed: () {
                      if (_isEditing) {
                        // Create a new AdminData object with updated values
                        final updatedAdminData = AdminData(
                          churchName: _churchNameController.text,
                          // Retain existing values for other fields
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
                          bookingsPercentage:
                              widget.adminData.bookingsPercentage,
                          email: widget.adminData.email,
                          phoneNumber: widget.adminData.phoneNumber,
                          password: widget.adminData.password,
                        );
                        // Call the callback to update the data in the parent widget
                        widget.onUpdateAdminData(updatedAdminData);
                      }
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A1633),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _isEditing ? 'Save Changes' : 'Edit Profile',
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
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: _isEditing,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.black12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.black12),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.black12),
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
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            if (_isEditing)
              IconButton(
                icon: const Icon(Icons.edit, size: 18),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: _isEditing,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.black12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.black12),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.black12),
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

  Widget _buildDonationField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: controller,
        enabled: _isEditing,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black12),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black12),
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
