import 'package:flutter/material.dart';
import '../admin_types.dart';
import '../authenticator_flow.dart';

class AdminSecuritySettingsView extends StatefulWidget {
  final AdminData adminData;
  final Function(AdminData) onUpdateAdminData;
  final Function(AdminView, {AuthenticatorFlow? flow, String? newValue})
  onNavigate;

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
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.adminData.email);
    _phoneController = TextEditingController(
      text: widget.adminData.phoneNumber,
    );
    _passwordController = TextEditingController(
      text: widget.adminData.password,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildEditableField(
                    label: 'Email',
                    controller: _emailController,
                    enabled: _isEditing,
                  ),
                  const SizedBox(height: 30),
                  _buildEditableField(
                    label: 'Phone Number',
                    controller: _phoneController,
                    enabled: _isEditing,
                  ),
                  const SizedBox(height: 30),
                  _buildEditableField(
                    label: 'Password',
                    controller: _passwordController,
                    enabled: _isEditing,
                    obscureText: true,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_isEditing) {
                    // Save changes
                    widget.onUpdateAdminData(
                      AdminData(
                        churchName: widget.adminData.churchName,
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
                        email: _emailController.text,
                        phoneNumber: _phoneController.text,
                        password: _passwordController.text,
                      ),
                    );
                  }
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A2E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  _isEditing ? 'Save Changes' : 'Edit Profile',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
