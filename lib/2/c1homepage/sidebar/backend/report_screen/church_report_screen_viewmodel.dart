// lib/sidebar/backend/report_screen/church_report_screen_viewmodel.dart

import 'package:flutter/material.dart';
import '../../../models/admin_models.dart';

class ChurchReportScreenViewModel extends ChangeNotifier {
  final Function(AdminView) _onNavigate;

  ChurchReportScreenViewModel({required Function(AdminView) onNavigate})
      : _onNavigate = onNavigate;

  void goBack() {
    _onNavigate(AdminView.settings);
  }
}
