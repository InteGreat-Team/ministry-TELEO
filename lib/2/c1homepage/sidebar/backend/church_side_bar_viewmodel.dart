// lib/sidebar/backend/church_side_bar_viewmodel.dart

import 'package:flutter/material.dart';
import '../../models/admin_models.dart'; // Import AdminView and AdminData
import 'package:ministry_teleo/2/c1homepage/sidebar/frontend/CHURCH_SIDE_BAR.dart';
import 'package:ministry_teleo/2/c1homepage/sidebar/frontend/profile/CHURCH_HOMEPAGE_PROFILE.dart';

class ChurchSideBarViewModel extends ChangeNotifier {
  final AdminData adminData;
  final void Function(AdminData) onUpdateAdminData;
  final void Function(AdminView) onNavigate; // <-- Add this

  ChurchSideBarViewModel({
    required this.adminData,
    required this.onUpdateAdminData,
    required this.onNavigate, // <-- Add this
  });

  void navigateTo(BuildContext context, AdminView view) {
    Navigator.pop(context); // Close the drawer
    onNavigate(view); // <-- Use public field
  }

  void navigateToDashboard() {
    onNavigate(AdminView.home);
  }

  void navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('Profile')),
          drawer: ChurchSideBar(
            adminData: adminData,
            onUpdateAdminData: onUpdateAdminData,
          ),
          body: ChurchHomepageProfile(
            adminData: adminData,
            onUpdateAdminData: onUpdateAdminData,
          ),
        ),
      ),
    );
  }

  void navigateToSettings() {
    onNavigate(AdminView.settings);
  }

  void navigateToReportScreen() {
    onNavigate(AdminView.reportIssue);
  }

  void navigateToContactUs() {
    onNavigate(AdminView.contactUs);
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return LogoutDialog(
          // Assuming LogoutDialog is in frontend/widgets/logout_dialog.dart
          isSuccess: false,
          onConfirm: () {
            Navigator.of(dialogContext).pop(); // Close the confirmation dialog
            _showLogoutSuccessDialog(context);
          },
          onCancel: () {
            Navigator.of(dialogContext).pop();
          },
        );
      },
    );
  }

  void _showLogoutSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return LogoutDialog(
          isSuccess: true,
          onConfirm: () {
            Navigator.of(dialogContext).pop(); // Close the success dialog
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (route) => false);
          },
          onCancel: () {}, // Not used for success dialog
        );
      },
    );
  }

  // Helper methods for building menu items can remain in the UI file
  // or be moved here if they involve more complex logic/state.
  // For now, they are simple UI builders, so they can stay in the UI.
}

// Assuming LogoutDialog is a separate widget.
// If not, you might need to define a simple placeholder or move its definition here.
class LogoutDialog extends StatelessWidget {
  final bool isSuccess;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const LogoutDialog({
    super.key,
    required this.isSuccess,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isSuccess ? 'Logged Out' : 'Confirm Logout'),
      content: Text(isSuccess
          ? 'You have been successfully logged out.'
          : 'Are you sure you want to log out?'),
      actions: [
        if (!isSuccess)
          TextButton(
            onPressed: onCancel,
            child: const Text('Cancel'),
          ),
        ElevatedButton(
          onPressed: onConfirm,
          child: Text(isSuccess ? 'OK' : 'Logout'),
        ),
      ],
    );
  }
}
