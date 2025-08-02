// lib/sidebar/frontend/settings/CHURCH_CHANGE_EMAIL_SETTING.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../backend/models/admin_models.dart'; // Import AdminView and AuthenticatorFlow
import '../../backend/settings/church_settings_viewmodel.dart'; // Import the new ViewModel

class ChurchChangeEmailSetting extends StatelessWidget {
  final AdminData adminData;
  final void Function(AdminView, {AuthenticatorFlow? flow, String? newValue})
      onNavigate;

  const ChurchChangeEmailSetting({
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
              key: viewModel.emailFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Old Email
                  TextFormField(
                    initialValue: viewModel.currentEmail,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Old Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // New Email
                  TextFormField(
                    controller: viewModel.newEmailController,
                    decoration: InputDecoration(
                      labelText: 'New Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: viewModel.validateEmail,
                  ),
                  const Spacer(),
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: viewModel.submitChangeEmail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1A2E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Send Code',
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
