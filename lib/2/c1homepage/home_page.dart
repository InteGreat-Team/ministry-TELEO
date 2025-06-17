import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'faqs_screen.dart';
import 'set_role_screen.dart';
import 'mass_schedule_screen.dart';
import '../../3/sidebar.dart';
import '../../1/c1homepage/home_page.dart' show AuthenticatorView;
import 'authenticator_flow.dart';
import 'admin_types.dart';
import '../../3/report/mainreport.dart';
import 'events_screen.dart';
import 'community_screen.dart';
import 'posts_screen.dart';

// Import new components
import 'components/church_profile.dart';
import 'components/metrics_grid.dart';
import 'components/analytics_chart.dart';
import 'components/content_management.dart';
import 'components/notification_settings.dart';

// Import admin views
import 'admin_views/admin_profile_view.dart';
import 'admin_views/admin_settings_view.dart';
import 'admin_views/admin_security_settings_view.dart';
import 'admin_views/admin_account_settings_view.dart';
import 'admin_views/admin_change_email_view.dart';
import 'admin_views/admin_change_password_view.dart';
import 'admin_views/admin_change_phone_view.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage>
    with SingleTickerProviderStateMixin {
  String _currentTitle = 'Teleo Admin';
  late TabController _tabController;
  AuthenticatorFlow _currentAuthFlow = AuthenticatorFlow.email;

  // Store temporary data for authentication flows
  String _newEmail = '';
  String _newPassword = '';
  String _newPhoneNumber = '';

  // Admin data that will be shared across views
  AdminData _adminData = AdminData(
    churchName: 'Sunny Treasure',
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
  );

  AdminView _currentView = AdminView.home;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateAdminData(AdminData newData) {
    setState(() {
      _adminData = newData;
    });
  }

  void _navigateTo(
    AdminView view, {
    AuthenticatorFlow? flow,
    String? newValue,
  }) {
    setState(() {
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

      switch (view) {
        case AdminView.home:
          _currentTitle = 'Teleo Admin';
          break;
        case AdminView.profile:
          _currentTitle = 'Profile';
          break;
        case AdminView.settings:
          _currentTitle = 'Settings';
          break;
        case AdminView.accountSettings:
          _currentTitle = 'Account';
          break;
        case AdminView.securitySettings:
          _currentTitle = 'Security';
          break;
        case AdminView.changeEmail:
          _currentTitle = 'Change Email';
          break;
        case AdminView.changePassword:
          _currentTitle = 'Change Password';
          break;
        case AdminView.changePhone:
          _currentTitle = 'Change Phone Number';
          break;
        case AdminView.authenticator:
          _currentTitle = 'Security';
          break;
        case AdminView.events:
          _currentTitle = 'Events';
          break;
        case AdminView.community:
          _currentTitle = 'Community';
          break;
        case AdminView.posts:
          _currentTitle = 'Posts';
          break;
        case AdminView.setRoles:
          _currentTitle = 'Set Roles';
          break;
        case AdminView.faqs:
          _currentTitle = 'FAQs';
          break;
        case AdminView.notificationSettings:
          _currentTitle = 'Notifications';
          break;
        case AdminView.massSchedule:
          _currentTitle = 'Mass Schedule';
          break;
        case AdminView.reportIssue:
          _currentTitle = 'Report Issue';
          break;
      }
    });
  }

  void _handleAuthenticationSuccess() {
    // Update admin data based on the current flow
    AdminData updatedAdminData;

    switch (_currentAuthFlow) {
      case AuthenticatorFlow.email:
        updatedAdminData = AdminData(
          churchName: _adminData.churchName,
          posts: _adminData.posts,
          following: _adminData.following,
          followers: _adminData.followers,
          loginActivity: _adminData.loginActivity,
          loginActivityPercentage: _adminData.loginActivityPercentage,
          dailyFollows: _adminData.dailyFollows,
          dailyFollowsPercentage: _adminData.dailyFollowsPercentage,
          dailyVisits: _adminData.dailyVisits,
          dailyVisitsPercentage: _adminData.dailyVisitsPercentage,
          bookings: _adminData.bookings,
          bookingsPercentage: _adminData.bookingsPercentage,
          email: _newEmail,
          phoneNumber: _adminData.phoneNumber,
          password: _adminData.password,
        );
        break;
      case AuthenticatorFlow.password:
        updatedAdminData = AdminData(
          churchName: _adminData.churchName,
          posts: _adminData.posts,
          following: _adminData.following,
          followers: _adminData.followers,
          loginActivity: _adminData.loginActivity,
          loginActivityPercentage: _adminData.loginActivityPercentage,
          dailyFollows: _adminData.dailyFollows,
          dailyFollowsPercentage: _adminData.dailyFollowsPercentage,
          dailyVisits: _adminData.dailyVisits,
          dailyVisitsPercentage: _adminData.dailyVisitsPercentage,
          bookings: _adminData.bookings,
          bookingsPercentage: _adminData.bookingsPercentage,
          email: _adminData.email,
          phoneNumber: _adminData.phoneNumber,
          password: _newPassword,
        );
        break;
      case AuthenticatorFlow.phone:
        updatedAdminData = AdminData(
          churchName: _adminData.churchName,
          posts: _adminData.posts,
          following: _adminData.following,
          followers: _adminData.followers,
          loginActivity: _adminData.loginActivity,
          loginActivityPercentage: _adminData.loginActivityPercentage,
          dailyFollows: _adminData.dailyFollows,
          dailyFollowsPercentage: _adminData.dailyFollowsPercentage,
          dailyVisits: _adminData.dailyVisits,
          dailyVisitsPercentage: _adminData.dailyVisitsPercentage,
          bookings: _adminData.bookings,
          bookingsPercentage: _adminData.bookingsPercentage,
          email: _adminData.email,
          phoneNumber: _newPhoneNumber,
          password: _adminData.password,
        );
        break;
    }

    _updateAdminData(updatedAdminData);

    // Show success dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(_getSuccessTitle()),
            content: Text(_getSuccessMessage()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _navigateTo(AdminView.securitySettings);
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  String _getSuccessTitle() {
    switch (_currentAuthFlow) {
      case AuthenticatorFlow.email:
        return 'Email Updated';
      case AuthenticatorFlow.password:
        return 'Password Updated';
      case AuthenticatorFlow.phone:
        return 'Phone Number Updated';
    }
  }

  String _getSuccessMessage() {
    switch (_currentAuthFlow) {
      case AuthenticatorFlow.email:
        return 'Your email has been successfully updated.';
      case AuthenticatorFlow.password:
        return 'Your password has been successfully updated.';
      case AuthenticatorFlow.phone:
        return 'Your phone number has been successfully updated.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _currentView == AdminView.home ||
                  _currentView == AdminView.profile ||
                  _currentView == AdminView.faqs
              ? const Color(0xFF001A33)
              : Colors.white,
      appBar: AppBar(
        title: Text(_currentTitle),
        backgroundColor:
            _currentView == AdminView.home ||
                    _currentView == AdminView.profile ||
                    _currentView == AdminView.faqs
                ? const Color(0xFF001A33)
                : Colors.white,
        foregroundColor:
            _currentView == AdminView.home ||
                    _currentView == AdminView.profile ||
                    _currentView == AdminView.faqs
                ? Colors.white
                : Colors.black,
        elevation: 0,
        leading:
            _currentView != AdminView.home
                ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    if (_currentView == AdminView.authenticator) {
                      switch (_currentAuthFlow) {
                        case AuthenticatorFlow.email:
                          _navigateTo(AdminView.changeEmail);
                          break;
                        case AuthenticatorFlow.password:
                          _navigateTo(AdminView.changePassword);
                          break;
                        case AuthenticatorFlow.phone:
                          _navigateTo(AdminView.changePhone);
                          break;
                      }
                    } else if (_currentView == AdminView.changeEmail ||
                        _currentView == AdminView.changePassword ||
                        _currentView == AdminView.changePhone) {
                      _navigateTo(AdminView.securitySettings);
                    } else if (_currentView == AdminView.securitySettings ||
                        _currentView == AdminView.accountSettings ||
                        _currentView == AdminView.massSchedule ||
                        _currentView == AdminView.notificationSettings) {
                      _navigateTo(AdminView.settings);
                    } else if (_currentView == AdminView.faqs) {
                      _navigateTo(AdminView.home);
                    } else if (_currentView == AdminView.profile) {
                      _navigateTo(AdminView.home);
                    } else if (_currentView == AdminView.reportIssue) {
                      _navigateTo(AdminView.home);
                    } else {
                      _navigateTo(AdminView.home);
                    }
                  },
                )
                : null,
        actions: [
          if (_currentView == AdminView.home)
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                // Notification functionality will be added later
              },
            ),
        ],
      ),
      drawer:
          _currentView == AdminView.home
              ? AdminDrawer(onNavigate: _navigateTo, adminData: _adminData)
              : null,
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody() {
    switch (_currentView) {
      case AdminView.setRoles:
        return const SetRoleScreen();
      case AdminView.faqs:
        return const FAQsScreen();
      case AdminView.events:
        return const EventsScreen();
      case AdminView.community:
        return const CommunityScreen();
      case AdminView.posts:
        return const PostsScreen();
      case AdminView.profile:
        return AdminProfileView(
          adminData: _adminData,
          onUpdateAdminData: _updateAdminData,
        );
      case AdminView.settings:
        return AdminSettingsView(onNavigate: _navigateTo);
      case AdminView.accountSettings:
        return AdminAccountSettingsView(
          adminData: _adminData,
          onUpdateAdminData: _updateAdminData,
        );
      case AdminView.securitySettings:
        return AdminSecuritySettingsView(
          adminData: _adminData,
          onUpdateAdminData: _updateAdminData,
          onNavigate: _navigateTo,
        );
      case AdminView.changeEmail:
        return AdminChangeEmailView(
          adminData: _adminData,
          onNavigate: _navigateTo,
        );
      case AdminView.changePassword:
        return AdminChangePasswordView(
          adminData: _adminData,
          onNavigate: _navigateTo,
        );
      case AdminView.changePhone:
        return AdminChangePhoneView(
          adminData: _adminData,
          onNavigate: _navigateTo,
        );
      case AdminView.authenticator:
        return AuthenticatorView(
          flow: _currentAuthFlow,
          onSuccess: _handleAuthenticationSuccess,
        );
      case AdminView.notificationSettings:
        return NotificationSettingsView(onNavigate: _navigateTo);
      case AdminView.massSchedule:
        return const MassScheduleScreen();
      case AdminView.reportIssue:
        return ReportApp();
      case AdminView.home:
        return _buildHomeView();
    }
  }

  Widget _buildHomeView() {
    return Container(
      color: const Color(0xFF001A33),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChurchProfile(adminData: _adminData),
              MetricsGrid(adminData: _adminData),
              const AnalyticsChart(),
              ContentManagement(onNavigate: _navigateTo),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF001A33),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                'assets/images/home_icon.png',
                isSelected: _currentView == AdminView.home,
                onTap: () {
                  if (_currentView != AdminView.home) {
                    _navigateTo(AdminView.home);
                  }
                },
              ),
              _buildNavItem(
                'assets/images/heart_icon.png',
                isSelected: false,
                onTap: () {
                  // Community functionality will be added later
                },
              ),
              _buildPrayButton(
                onTap: () {
                  // Pray functionality will be added later
                },
              ),
              _buildNavItem(
                'assets/images/bible_icon.png',
                isSelected: false,
                onTap: () {
                  // Bible functionality will be added later
                },
              ),
              _buildNavItem(
                'assets/images/profile_icon.png',
                isSelected: _currentView == AdminView.profile,
                onTap: () {
                  _navigateTo(AdminView.profile);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    String iconPath, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 24,
              height: 24,
              color: isSelected ? Colors.white : Colors.white54,
            ),
            const SizedBox(height: 4),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.white : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.favorite, color: Color(0xFF001A33), size: 28),
      ),
    );
  }
}
