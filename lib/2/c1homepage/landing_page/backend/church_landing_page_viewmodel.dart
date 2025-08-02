// lib/landing_page/backend/church_landing_page_viewmodel.dart

import 'package:flutter/material.dart';
import '../../models/admin_models.dart';

class ChurchHomePageViewModel extends ChangeNotifier {
  final AdminData adminData;
  final void Function(dynamic view, {dynamic flow, dynamic newValue})
      onNavigate;

  String? currentTitle;
  int currentNavBarIndex = 0;
  dynamic currentView;

  ChurchHomePageViewModel({
    required this.adminData,
    required this.onNavigate,
  });

  void onNavBarTap(dynamic view) {
    currentView = view;
    notifyListeners();
  }

  void Function(AdminData)? onUpdateAdminData;

  // Add your viewmodel logic here
}
