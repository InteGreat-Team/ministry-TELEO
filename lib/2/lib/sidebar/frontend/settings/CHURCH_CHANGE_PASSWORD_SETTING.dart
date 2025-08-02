// lib/sidebar/frontend/settings/CHURCH_CHANGE_PASSWORD_SETTING.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../backend/models/admin_models.dart'; // Import AdminView and AuthenticatorFlow
import '../../backend/settings/church_settings_viewmodel.dart'; // Import the new ViewModel

class ChurchChangePasswordSetting extends StatelessWidget {
  final AdminData adminData;
  final void Function(AdminView, {AuthenticatorFlow? flow, String? newValue})
      onNavigate;

  const ChurchChangePasswordSetting({
    super.key,
    required this.adminData,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChurchSettingsViewModel(
        adminData: adminData,
        onNavigate: onNavigate,
      ),
      child: Consumer<ChurchSettingsViewModel>(
        builder: (context, viewModel, child) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: viewModel.passwordFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Old Password
                  TextFormField(
                    controller: viewModel.oldPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Old Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: viewModel.validateOldPassword,
                  ),
                  const SizedBox(height: 20),
                  // New Password
                  TextFormField(
                    controller: viewModel.newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: viewModel.validateNewPassword,
                  ),
                  const SizedBox(height: 20),
                  // Confirm New Password
                  TextFormField(
                    controller: viewModel.confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: viewModel.validateConfirmPassword,
                  ),
                  const Spacer(),
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: viewModel.submitChangePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1A2E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Update Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
