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
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Email'),
            subtitle: Text(widget.adminData.email),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              widget.onNavigate(AdminView.changeEmail);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.phone_outlined),
            title: const Text('Phone Number'),
            subtitle: Text(widget.adminData.phoneNumber),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              widget.onNavigate(AdminView.changePhone);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Password'),
            subtitle: const Text('••••••••••••••••'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              widget.onNavigate(AdminView.changePassword);
            },
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
