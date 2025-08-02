// lib/sidebar/frontend/settings/CHURCH_CHANGE_PHONE_SETTING.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../backend/models/admin_models.dart'; // Import AdminView and AuthenticatorFlow
import '../../backend/settings/church_settings_viewmodel.dart'; // Import the new ViewModel

class ChurchChangePhoneSetting extends StatelessWidget {
  final AdminData adminData;
  final Function(AdminView, {AuthenticatorFlow? flow, String? newValue})
      onNavigate;

  const ChurchChangePhoneSetting({
    super.key,
    required this.adminData,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChurchSettingsViewModel(
        adminData: adminData,
        onNavigate: onNavigate,
      ),
      child: Consumer<ChurchSettingsViewModel>(
        builder: (context, viewModel, child) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: viewModel.phoneFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Old Phone Number
                  TextFormField(
                    initialValue: viewModel.currentPhoneNumber,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Old Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // New Phone Number
                  TextFormField(
                    controller: viewModel.newPhoneController,
                    decoration: InputDecoration(
                      labelText: 'New Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: viewModel.validatePhoneNumber,
                  ),
                  const Spacer(),
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: viewModel.submitChangePhone,
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
