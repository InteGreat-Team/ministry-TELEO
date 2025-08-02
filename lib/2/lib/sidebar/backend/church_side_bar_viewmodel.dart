// lib/sidebar/backend/church_side_bar_viewmodel.dart

import 'package:flutter/material.dart';
import '../../models/admin_models.dart'; // Import AdminView and AdminData

class ChurchSideBarViewModel extends ChangeNotifier {
  final Function(AdminView) _onNavigate;

  ChurchSideBarViewModel({required Function(AdminView) onNavigate}) : _onNavigate = onNavigate;

  void navigateTo(BuildContext context, AdminView view) {
    Navigator.pop(context); // Close the drawer
    _onNavigate(view);
  }

  void navigateToDashboard() {
    _onNavigate(AdminView.home);
  }

  void navigateToProfile() {
    _onNavigate(AdminView.profile);
  }

  void navigateToSettings() {
    _onNavigate(AdminView.settings);
  }

  void navigateToReportScreen() {
    _onNavigate(AdminView.reportIssue);
  }

  void navigateToContactUs() {
    _onNavigate(AdminView.contactUs);
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return LogoutDialog( // Assuming LogoutDialog is in frontend/widgets/logout_dialog.dart
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
            Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
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
