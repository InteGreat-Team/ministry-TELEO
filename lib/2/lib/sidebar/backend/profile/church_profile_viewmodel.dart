// lib/sidebar/backend/profile/church_profile_viewmodel.dart

import 'package:flutter/material.dart';
import '../../models/admin_models.dart'; // Import the models

class ChurchProfileViewModel extends ChangeNotifier {
  // Example data for the profile
  String _churchName = "St. Peter's Parish";
  String _location = "123 Main St, Anytown, USA";
  String _description = "A welcoming community dedicated to faith and service.";
  String _schedule = "Sunday Mass: 9:00 AM, 11:00 AM";
  String _contactEmail = "info@stpeters.org";
  String _contactPhone = "+1 (123) 456-7890";

  String get churchName => _churchName;
  String get location => _location;
  String get description => _description;
  String get schedule => _schedule;
  String get contactEmail => _contactEmail;
  String get contactPhone => _contactPhone;

  // You can add methods here to fetch data from a backend
  // Future<void> fetchProfileData() async {
  //   // Simulate API call
  //   await Future.delayed(const Duration(seconds: 1));
  //   _churchName = "Updated St. Peter's Parish";
  //   _location = "456 Oak Ave, Othertown, USA";
  //   notifyListeners();
  // }

  // You can also add methods to update data
  // void updateChurchName(String newName) {
  //   _churchName = newName;
  //   notifyListeners();
  //   // Call API to save changes
  // }
}
