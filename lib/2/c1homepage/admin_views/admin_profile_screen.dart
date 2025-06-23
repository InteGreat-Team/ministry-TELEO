import 'package:flutter/material.dart';
import '../admin_types.dart';
import 'admin_profile_view.dart';

class AdminProfileScreen extends StatelessWidget {
  final AdminData adminData;
  final Function(AdminData) onUpdateAdminData;

  const AdminProfileScreen({
    super.key,
    required this.adminData,
    required this.onUpdateAdminData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AdminProfileView(
        adminData: adminData,
        onUpdateAdminData: onUpdateAdminData,
      ),
    );
  }
}
