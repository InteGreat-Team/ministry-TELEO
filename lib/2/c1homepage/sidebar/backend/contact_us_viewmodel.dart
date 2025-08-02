// lib/sidebar/backend/contact_us_viewmodel.dart

import 'package:flutter/material.dart';

class ContactUsViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    reasonController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  Future<bool> submitForm() async {
    if (formKey.currentState!.validate()) {
      _isSubmitting = true;
      notifyListeners();

      // Simulate API call to determine success or failure
      // In a real app, you would make a network request here
      await Future.delayed(const Duration(seconds: 1));

      // Randomly decide if the submission was successful or not for demonstration
      final bool isSuccess = (DateTime.now().second % 2) == 0; // Example condition

      _isSubmitting = false;
      notifyListeners();

      if (isSuccess) {
        resetForm();
      }
      return isSuccess;
    }
    return false;
  }

  void resetForm() {
    formKey.currentState?.reset();
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    reasonController.clear();
    detailsController.clear();
  }
}
