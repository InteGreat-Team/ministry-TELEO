// lib/landing_page/backend/church_landing_page_viewmodel.dart

import 'package:flutter/material.dart';
import '../../models/admin_models.dart'; // Import the models

class ChurchHomePageViewModel extends ChangeNotifier {
  String _currentTitle = 'Teleo Admin';
  AdminView _currentView = AdminView.home;
  AuthenticatorFlow _currentAuthFlow = AuthenticatorFlow.email;

  // Backend-ready: loading and error state
  bool _isLoading = false;
  String? _errorMessage;

  // Store temporary data for authentication flows
  String _newEmail = '';
  String _newPassword = '';
  String _newPhoneNumber = '';

  // Admin data that will be shared across views
  AdminData _adminData = AdminData(
    churchName: 'Sunny Detroit Church',
    posts: '27',
    following: '249',
    followers: '7,265',
    loginActivity: '2,318',
    loginActivityPercentage: '+6.08%',
    dailyFollows: '40',
    dailyFollowsPercentage: '-0.03%',
    dailyVisits: '4,256',
    dailyVisitsPercentage: '+15.03%',
    bookings: '12',
    bookingsPercentage: '+5%',
    email: 'admin@sunnytreasure.org',
    phoneNumber: '(313) 555-1234',
    password: '••••••••••••••••',
    // Initialize new fields with default values or fetched data
    location: '941 Sunny Treasure Line, Detroit, CA 59120',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim...',
    schedule: 'Wednesdays - 8:00 AM - 11:00 AM',
    gcash: '09182763484',
    maya: '09189327642',
    bdo: '00089287394',
    bpi: '0001283974',
  );

  // Backend-ready: Analytics/chart data state
  List<double> _totalReadsData = [10, 20, 15, 30, 25, 40]; // Example data
  List<double> _totalWatchesData = [
    0.6,
    1.0,
    0.7,
    1.2,
    0.4,
    0.9,
  ]; // Example data
  List<String> _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
  String _followersPercent = '+11.01%';

  // Backend-ready: loading and error state for analytics
  bool _isAnalyticsLoading = false;
  String? _analyticsError;

  final void Function(AdminView, {AuthenticatorFlow? flow, String? newValue}) _onNavigate;

  ChurchHomePageViewModel({
    required void Function(AdminView, {AuthenticatorFlow? flow, String? newValue}) onNavigate,
  }) : _onNavigate = onNavigate;

  // Getters for UI to consume
  String get currentTitle => _currentTitle;
  AdminView get currentView => _currentView;
  AuthenticatorFlow get currentAuthFlow => _currentAuthFlow;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get newEmail => _newEmail;
  String get newPassword => _newPassword;
  String get newPhoneNumber => _newPhoneNumber;
  AdminData get adminData => _adminData;
  List<double> get totalReadsData => _totalReadsData;
  List<double> get totalWatchesData => _totalWatchesData;
  List<String> get months => _months;
  String get followersPercent => _followersPercent;
  bool get isAnalyticsLoading => _isAnalyticsLoading;
  String? get analyticsError => _analyticsError;

  static const Map<AdminView, String> _titles = {
    AdminView.home: 'Teleo Admin',
    AdminView.profile: 'Profile',
    AdminView.settings: 'Settings',
    AdminView.accountSettings: 'Account',
    AdminView.securitySettings: 'Security',
    AdminView.changeEmail: 'Change Email',
    AdminView.changePassword: 'Change Password',
    AdminView.changePhone: 'Change Phone Number',
    AdminView.authenticator: 'Security',
    AdminView.events: 'Events',
    AdminView.community: 'Community',
    AdminView.posts: 'Posts',
    AdminView.setRoles: 'Set Roles',
    AdminView.faqs: 'FAQs',
    AdminView.notificationSettings: 'Notifications',
    AdminView.massSchedule: 'Mass Schedule',
    AdminView.reportIssue: 'Report Issue',
    AdminView.termsConditions: 'Terms & Conditions',
    AdminView.contactUs: 'Contact Us',
    AdminView.donate: 'Donate',
  };

  // Constructor to fetch initial data
  ChurchHomePageViewModel() {
    fetchAdminData();
    fetchAnalyticsData();
  }

  // Backend-ready: placeholder for fetching admin data
  Future<void> fetchAdminData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      // TODO: Replace with real backend call
      await Future.delayed(const Duration(milliseconds: 500));
      // Example: final data = await ApiService.getAdminData();
      // _adminData = data;
    } catch (e) {
      _errorMessage = 'Failed to load admin data.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Backend-ready: placeholder for updating admin data
  Future<void> updateAdminData(AdminData newData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      // TODO: Replace with real backend call
      await Future.delayed(const Duration(milliseconds: 500));
      // Example: await ApiService.updateAdminData(newData);
      _adminData = newData;
    } catch (e) {
      _errorMessage = 'Failed to update admin data.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Backend-ready: placeholder for fetching analytics/chart data
  Future<void> fetchAnalyticsData() async {
    _isAnalyticsLoading = true;
    _analyticsError = null;
    notifyListeners();
    try {
      // TODO: Replace with real backend call to fetch analytics/chart data
      await Future.delayed(const Duration(milliseconds: 500));
      // Example:
      // final analytics = await ApiService.getAnalyticsData();
      // _totalReadsData = analytics.reads;
      // _totalWatchesData = analytics.watches;
      // _followersPercent = analytics.followersPercent;
      // _months = analytics.months;
    } catch (e) {
      _analyticsError = 'Failed to load analytics data.';
    } finally {
      _isAnalyticsLoading = false;
      notifyListeners();
    }
  }

  void navigateTo(
    AdminView view, {
    AuthenticatorFlow? flow,
    String? newValue,
  }) {
    _currentView = view;
    if (flow != null) {
      _currentAuthFlow = flow;
    }
    // Store temporary data based on the flow
    if (newValue != null) {
      switch (_currentAuthFlow) {
        case AuthenticatorFlow.email:
          _newEmail = newValue;
          break;
        case AuthenticatorFlow.password:
          _newPassword = newValue;
          break;
        case AuthenticatorFlow.phone:
          _newPhoneNumber = newValue;
          break;
      }
    }
    _currentTitle = _titles[view] ?? 'Teleo Admin';
    notifyListeners();
  }

  // Example: Navigate to the profile screen
  void navigateToProfile() {
    _onNavigate(AdminView.profile);
  }

  // Example: Navigate to the settings screen
  void navigateToSettings() {
    _onNavigate(AdminView.settings);
  }

  // Example: Navigate to the report screen
  void navigateToReportScreen() {
    _onNavigate(AdminView.reportIssue);
  }

  String getSuccessTitle() {
    switch (_currentAuthFlow) {
      case AuthenticatorFlow.email:
        return 'Email Updated';
      case AuthenticatorFlow.password:
        return 'Password Updated';
      case AuthenticatorFlow.phone:
        return 'Phone Number Updated';
    }
  }

  String getSuccessMessage() {
    switch (_currentAuthFlow) {
      case AuthenticatorFlow.email:
        return 'Your email has been successfully updated.';
      case AuthenticatorFlow.password:
        return 'Your password has been successfully updated.';
      case AuthenticatorFlow.phone:
        return 'Your phone number has been successfully updated.';
    }
  }

  int navBarIndexForView(AdminView view) {
    switch (view) {
      case AdminView.home:
        return 0;
      case AdminView.events:
        return 1;
      case AdminView.community:
        return 2;
      case AdminView.posts:
        return 3;
      case AdminView.profile:
        return 4;
      default:
        return 0;
    }
  }

  AdminView viewForNavBarIndex(int index) {
    switch (index) {
      case 0:
        return AdminView.home;
      case 1:
        return AdminView.events;
      case 2:
        return AdminView.community;
      case 3:
        return AdminView.posts;
      case 4:
        return AdminView.profile;
      default:
        return AdminView.home;
    }
  }

  // Method to handle authentication success and update admin data
  void handleAuthenticationSuccess() {
    AdminData updatedAdminData = _adminData;
    switch (_currentAuthFlow) {
      case AuthenticatorFlow.email:
        updatedAdminData = _adminData.copyWith(email: _newEmail);
        break;
      case AuthenticatorFlow.password:
        updatedAdminData = _adminData.copyWith(password: _newPassword);
        break;
      case AuthenticatorFlow.phone:
        updatedAdminData = _adminData.copyWith(phoneNumber: _newPhoneNumber);
        break;
    }
    _adminData = updatedAdminData; // Update the internal state
    notifyListeners(); // Notify UI of the change
  }
}
