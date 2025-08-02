// lib/sidebar/backend/church_homepage_viewmodel.dart

import 'package:flutter/material.dart';
import '../../models/admin_models.dart';

class ChurchHomepageViewModel extends ChangeNotifier {
  final Function(AdminView) _onNavigate;

  ChurchHomepageViewModel({required Function(AdminView) onNavigate})
      : _onNavigate = onNavigate;

  void navigateToProfile() {
    _onNavigate(AdminView.profile);
  }

  void navigateToSettings() {
    _onNavigate(AdminView.settings);
  }

  void navigateToEvents() {
    _onNavigate(AdminView.events);
  }

  void navigateToCommunity() {
    _onNavigate(AdminView.community);
  }

  void navigateToPosts() {
    _onNavigate(AdminView.posts);
  }

  void navigateToSetRoles() {
    _onNavigate(AdminView.setRoles);
  }

  void navigateToFaqs() {
    _onNavigate(AdminView.faqs);
  }

  void navigateToReportIssue() {
    _onNavigate(AdminView.reportIssue);
  }

  void navigateToTermsConditions() {
    _onNavigate(AdminView.termsConditions);
  }

  void navigateToContactUs() {
    _onNavigate(AdminView.contactUs);
  }

  void navigateToDonate() {
    _onNavigate(AdminView.donate);
  }

  void navigateToDashboard() {
    _onNavigate(AdminView.dashboard);
  }
}
