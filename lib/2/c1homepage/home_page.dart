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
import 'admin_views/admin_terms_conditions_view.dart';

// Import NavBar
import '../../3/nav_bar.dart';

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
        case AdminView.termsAndConditions:
          _currentTitle = 'Terms and Conditions';
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
      backgroundColor: Colors.white,
      appBar:
          _currentView == AdminView.profile
              ? null
              : AppBar(
                title: Text(_currentTitle),
                backgroundColor: const Color(0xFF2B3576),
                foregroundColor: Colors.white,
                elevation: 0,
                leading:
                    _currentView != AdminView.home
                        ? IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: const Color(0xFFF9B233),
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
                            } else if (_currentView ==
                                    AdminView.securitySettings ||
                                _currentView == AdminView.accountSettings ||
                                _currentView == AdminView.massSchedule ||
                                _currentView ==
                                    AdminView.notificationSettings) {
                              _navigateTo(AdminView.settings);
                            } else if (_currentView == AdminView.faqs) {
                              _navigateTo(AdminView.home);
                            } else if (_currentView == AdminView.profile) {
                              _navigateTo(AdminView.home);
                            } else if (_currentView == AdminView.reportIssue ||
                                _currentView == AdminView.termsAndConditions) {
                              _navigateTo(AdminView.settings);
                            } else {
                              _navigateTo(AdminView.home);
                            }
                          },
                        )
                        : null,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    color: const Color(0xFFF9B233),
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
      bottomNavigationBar: NavBar(
        currentIndex: _navBarIndexForView(_currentView),
        onTap: (index) {
          _navigateTo(_viewForNavBarIndex(index));
        },
      ),
    );
  }

  int _navBarIndexForView(AdminView view) {
    switch (view) {
      case AdminView.home:
        return 0;
      case AdminView.community:
        return 1;
      case AdminView.events:
        return 2;
      case AdminView.posts:
        return 3;
      case AdminView.profile:
        return 4;
      default:
        return 0;
    }
  }

  AdminView _viewForNavBarIndex(int index) {
    switch (index) {
      case 0:
        return AdminView.home;
      case 1:
        return AdminView.community;
      case 2:
        return AdminView.events;
      case 3:
        return AdminView.posts;
      case 4:
        return AdminView.profile;
      default:
        return AdminView.home;
    }
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
        return ReportApp(onNavigate: _navigateTo);
      case AdminView.termsAndConditions:
        return AdminTermsConditionsView(onNavigate: _navigateTo);
      case AdminView.home:
        return _buildHomeView();
    }
  }

  Widget _buildHomeView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Admin dashboard header
          Stack(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  child: Image.asset(
                    'assets/images/church_interior.jpg',
                    fit: BoxFit.cover,
                    color: const Color(0xFF2B3576).withOpacity(0.7),
                    colorBlendMode: BlendMode.darken,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.church,
                            size: 60,
                            color: Color(0xFFF9B233),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/church_logo.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.white,
                                  child: const Icon(
                                    Icons.church,
                                    size: 40,
                                    color: Color(0xFFF9B233),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _adminData.churchName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStatColumn(_adminData.posts, 'Posts'),
                            _buildVerticalDivider(),
                            _buildStatColumn(_adminData.following, 'Following'),
                            _buildVerticalDivider(),
                            _buildStatColumn(_adminData.followers, 'Followers'),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Stats cards
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Login Activity',
                        _adminData.loginActivity,
                        _adminData.loginActivityPercentage,
                        Icons.show_chart,
                        const Color(0xFFF9B233),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Daily Follows',
                        _adminData.dailyFollows,
                        _adminData.dailyFollowsPercentage,
                        Icons.favorite,
                        Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Daily Visits',
                        _adminData.dailyVisits,
                        _adminData.dailyVisitsPercentage,
                        Icons.visibility,
                        Colors.teal,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Bookings',
                        _adminData.bookings,
                        _adminData.bookingsPercentage,
                        Icons.event,
                        const Color(0xFFF9B233),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Add analytics chart section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            child: AnalyticsChart(),
          ),
          // Add manage content section
          ContentManagement(onNavigate: _navigateTo),
          // ...rest of your home content...
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 4,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 4,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 30, width: 1, color: Colors.grey[300]);
  }

  Widget _buildStatCard(
    String title,
    String value,
    String percent,
    IconData icon,
    Color iconColor,
  ) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF2B3576),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF2B3576),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              percent,
              style: TextStyle(
                color: percent.startsWith('+') ? Colors.green : Colors.red,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
