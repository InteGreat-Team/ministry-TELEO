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

  // In the _AdminHomePageState class, add a new state variable to track the active tab
  int _activeAnalyticsTab = 0;

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
      bottomNavigationBar:
          _currentView == AdminView.home || _currentView == AdminView.profile
              ? _buildBottomNav()
              : null,
    );
  }

  Widget _buildBody() {
    switch (_currentView) {
      case AdminView.setRoles:
        return const SetRoleScreen();
      case AdminView.faqs:
        return const FAQsScreen();
      case AdminView.events:
        return const Center(
          child: Text('Events Screen', style: TextStyle(color: Colors.white)),
        );
      case AdminView.community:
        return const Center(
          child: Text(
            'Community Screen',
            style: TextStyle(color: Colors.white),
          ),
        );
      case AdminView.posts:
        return const Center(
          child: Text('Posts Screen', style: TextStyle(color: Colors.white)),
        );
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
        return Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => _navigateTo(AdminView.settings),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Push Notifications toggle
                _buildNotificationToggle(
                  'Push Notifications',
                  'Receive push notifications for important updates',
                  true,
                ),

                const SizedBox(height: 16),

                // Email Notifications toggle
                _buildNotificationToggle(
                  'Email Notifications',
                  'Receive email notifications for important updates',
                  true,
                ),
              ],
            ),
          ),
        );
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
              // Church profile card
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF002642),
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/church_interior.jpg'),
                    fit: BoxFit.cover,
                    opacity: 0.2,
                  ),
                ),
                child: Column(
                  children: [
                    // Church logo and name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
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
                                    color: Color(0xFFFFAA00),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Church name
                    Text(
                      _adminData.churchName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Stats row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn(_adminData.posts, 'Posts'),
                        _buildVerticalDivider(),
                        _buildStatColumn(_adminData.following, 'Following'),
                        _buildVerticalDivider(),
                        _buildStatColumn(_adminData.followers, 'Followers'),
                      ],
                    ),
                  ],
                ),
              ),

              // Metrics grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            'Login Activity',
                            _adminData.loginActivity,
                            _adminData.loginActivityPercentage,
                            Icons.trending_up,
                            isPositive: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildMetricCard(
                            'Daily Follows',
                            _adminData.dailyFollows,
                            _adminData.dailyFollowsPercentage,
                            Icons.favorite,
                            isPositive: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            'Daily Visits',
                            _adminData.dailyVisits,
                            _adminData.dailyVisitsPercentage,
                            Icons.access_time,
                            isPositive: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildMetricCard(
                            'Bookings',
                            _adminData.bookings,
                            _adminData.bookingsPercentage,
                            Icons.calendar_today,
                            isPositive: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Analytics chart
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF002642),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tab bar
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => _activeAnalyticsTab = 0),
                          child: Text(
                            'Total Reads',
                            style: TextStyle(
                              color:
                                  _activeAnalyticsTab == 0
                                      ? Colors.blue[300]
                                      : Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () => setState(() => _activeAnalyticsTab = 1),
                          child: Text(
                            'Total Watches',
                            style: TextStyle(
                              color:
                                  _activeAnalyticsTab == 1
                                      ? Colors.blue[300]
                                      : Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () => setState(() => _activeAnalyticsTab = 2),
                          child: Text(
                            'Total Followers',
                            style: TextStyle(
                              color:
                                  _activeAnalyticsTab == 2
                                      ? Colors.blue[300]
                                      : Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Content based on active tab
                    if (_activeAnalyticsTab == 0) _buildBarChartContent(),
                    if (_activeAnalyticsTab == 1) _buildTimeSpentContent(),
                    if (_activeAnalyticsTab == 2) _buildFollowersContent(),

                    const SizedBox(height: 16),

                    // Indicator dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color:
                                _activeAnalyticsTab == 0
                                    ? Colors.blue[300]
                                    : Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color:
                                _activeAnalyticsTab == 1
                                    ? Colors.blue[300]
                                    : Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color:
                                _activeAnalyticsTab == 2
                                    ? Colors.blue[300]
                                    : Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Manage Content section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 16),
                    const Text(
                      'Manage Content',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Content management grid
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildContentButton(
                          icon: Icons.calendar_today,
                          color: Colors.red,
                          onTap: () => _navigateTo(AdminView.events),
                        ),
                        _buildContentButton(
                          icon: Icons.people,
                          color: Colors.amber,
                          onTap: () => _navigateTo(AdminView.community),
                        ),
                        _buildContentButton(
                          icon: Icons.book,
                          color: Colors.green,
                          onTap: () => _navigateTo(AdminView.posts),
                        ),
                        _buildContentButton(
                          icon: Icons.person,
                          color: Colors.blue,
                          onTap: () => _navigateTo(AdminView.setRoles),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Content management list
                    _buildManagementListItem(
                      icon: Icons.calendar_today,
                      iconColor: Colors.red,
                      title: 'Events',
                      onTap: () => _navigateTo(AdminView.events),
                    ),
                    _buildManagementListItem(
                      icon: Icons.people,
                      iconColor: Colors.amber,
                      title: 'Community',
                      onTap: () => _navigateTo(AdminView.community),
                    ),
                    _buildManagementListItem(
                      icon: Icons.book,
                      iconColor: Colors.green,
                      title: 'Posts',
                      onTap: () => _navigateTo(AdminView.posts),
                    ),
                    _buildManagementListItem(
                      icon: Icons.person,
                      iconColor: Colors.blue,
                      title: 'Set roles',
                      onTap: () => _navigateTo(AdminView.setRoles),
                    ),
                    const SizedBox(height: 80), // Extra space for bottom nav
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChartContent() {
    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Y-axis labels
          const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('30K', style: TextStyle(color: Colors.white, fontSize: 12)),
              Text('20K', style: TextStyle(color: Colors.white, fontSize: 12)),
              Text('10K', style: TextStyle(color: Colors.white, fontSize: 12)),
              Text('0', style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),

          const SizedBox(width: 10),

          // Jan
          _buildBarChartColumn(0.5, 'Jan'),

          // Feb
          _buildBarChartColumn(0.8, 'Feb'),

          // Mar
          _buildBarChartColumn(0.6, 'Mar'),

          // Apr
          _buildBarChartColumn(0.9, 'Apr'),

          // May
          _buildBarChartColumn(0.4, 'May'),

          // Jun
          _buildBarChartColumn(0.7, 'Jun'),
        ],
      ),
    );
  }

  Widget _buildFollowersContent() {
    return Column(
      children: [
        // Followers count
        Center(
          child: Text(
            '7,265',
            style: TextStyle(
              color: Colors.blue[300],
              fontSize: 72,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Growth indicator
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '+11.01%',
                style: TextStyle(
                  color: Colors.blue[300],
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.trending_up, color: Colors.blue[300], size: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSpentContent() {
    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Jan
          _buildTimeSpentColumn(0.3, 'Jan', false),

          // Feb
          _buildTimeSpentColumn(0.5, 'Feb', false),

          // Mar
          _buildTimeSpentColumn(0.4, 'Mar', false),

          // April
          _buildTimeSpentColumn(0.2, 'April', false),

          // May
          Stack(
            alignment: Alignment.topCenter,
            children: [
              _buildTimeSpentColumn(0.9, 'May', true),
              Container(
                margin: const EdgeInsets.only(bottom: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '243K',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          // June
          _buildTimeSpentColumn(0.1, 'June', false),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 30, width: 1, color: Colors.white24);
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String percentage,
    IconData icon, {
    required bool isPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A3A5A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Icon(
                icon,
                color: isPositive ? Colors.orange : Colors.pink,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            percentage,
            style: TextStyle(
              color:
                  isPositive
                      ? percentage.startsWith('+')
                          ? Colors.green
                          : Colors.red
                      : percentage.startsWith('-')
                      ? Colors.red
                      : Colors.green,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChartColumn(double heightPercentage, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: 150 * heightPercentage,
          decoration: BoxDecoration(
            color: Colors.blue[300],
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildTimeSpentColumn(
    double heightPercentage,
    String label,
    bool isHighlighted,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: 150 * heightPercentage,
          decoration: BoxDecoration(
            color:
                isHighlighted
                    ? Colors.blue[300]
                    : Colors.blue[900]!.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildContentButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF0A3A5A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(child: Icon(icon, color: color, size: 24)),
          ),
        ),
      ),
    );
  }

  Widget _buildManagementListItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white10)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(child: Icon(icon, color: iconColor, size: 24)),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
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
          height: 70, // Increased height
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                'assets/images/home_icon.png',
                isSelected: _currentView == AdminView.home,
                onTap: () => _navigateTo(AdminView.home),
                fallbackIcon: Icons.home,
              ),
              _buildNavItem(
                'assets/images/heart_icon.png',
                isSelected: _currentView == AdminView.community,
                onTap: () => _navigateTo(AdminView.community),
                fallbackIcon: Icons.people,
              ),
              _buildPrayButton(
                onTap: () {
                  // Pray functionality will be added later
                },
              ),
              _buildNavItem(
                'assets/images/bible_icon.png',
                isSelected: _currentView == AdminView.posts,
                onTap: () => _navigateTo(AdminView.posts),
                fallbackIcon: Icons.book,
              ),
              _buildNavItem(
                'assets/images/profile_icon.png',
                isSelected: _currentView == AdminView.setRoles,
                onTap: () => _navigateTo(AdminView.setRoles),
                fallbackIcon: Icons.person,
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
    required IconData fallbackIcon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Image.asset(
          iconPath,
          width: 32, // Increased size
          height: 32, // Increased size
          color: isSelected ? const Color(0xFF3E9BFF) : Colors.white,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              fallbackIcon,
              size: 28,
              color: isSelected ? const Color(0xFF3E9BFF) : Colors.white,
            );
          },
        ),
      ),
    );
  }

  Widget _buildPrayButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64, // Increased size
        height: 64, // Increased size
        decoration: BoxDecoration(
          color: const Color(0xFF3E9BFF),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3E9BFF).withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            'assets/images/pray_icon.png',
            width: 36, // Increased size
            height: 36, // Increased size
            color: Colors.white,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.church, size: 32, color: Colors.white);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationToggle(
    String title,
    String subtitle,
    bool initialValue,
  ) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isEnabled = initialValue;
        return ListTile(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(subtitle),
          trailing: Switch(
            value: isEnabled,
            onChanged: (value) {
              setState(() {
                isEnabled = value;
              });
            },
            activeColor: const Color(0xFF3E9BFF),
          ),
        );
      },
    );
  }
}

// Admin Settings View
class AdminSettingsView extends StatelessWidget {
  final Function(AdminView) onNavigate;

  const AdminSettingsView({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Settings header
            const Text(
              'Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Admin Dashboard',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Settings menu items
            _buildSettingsItem(
              context,
              Icons.person,
              'Your Account',
              'Edit your account information',
              onTap: () => onNavigate(AdminView.accountSettings),
            ),
            _buildSettingsItem(
              context,
              Icons.security,
              'Security and Account Access',
              'Manage your account\'s security',
              onTap: () => onNavigate(AdminView.securitySettings),
            ),
            _buildSettingsItem(
              context,
              Icons.notifications,
              'Manage Notifications',
              'Manage notifications received',
              onTap: () => onNavigate(AdminView.notificationSettings),
            ),
            // HARDCODED MASS SCHEDULE OPTION
            _buildSettingsItem(
              context,
              Icons.event,
              'Mass Schedule',
              'Manage church mass schedules',
              onTap: () => onNavigate(AdminView.massSchedule),
            ),
            _buildSettingsItem(
              context,
              Icons.report_problem,
              'Report an Issue',
              'Report issues',
              onTap: () => onNavigate(AdminView.reportIssue),
            ),
            _buildSettingsItem(
              context,
              Icons.description,
              'Terms and Conditions',
              'Legal notes',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey[300]!),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: Icon(icon, color: Colors.black54),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}

// Admin Profile View
class AdminProfileView extends StatefulWidget {
  final AdminData adminData;
  final Function(AdminData) onUpdateAdminData;

  const AdminProfileView({
    super.key,
    required this.adminData,
    required this.onUpdateAdminData,
  });

  @override
  State<AdminProfileView> createState() => _AdminProfileViewState();
}

class _AdminProfileViewState extends State<AdminProfileView> {
  bool _isEditing = false;
  late TextEditingController _churchNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _churchNameController = TextEditingController(
      text: widget.adminData.churchName,
    );
    _emailController = TextEditingController(text: widget.adminData.email);
    _phoneController = TextEditingController(
      text: widget.adminData.phoneNumber,
    );
  }

  @override
  void dispose() {
    _churchNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      if (_isEditing) {
        // Save changes
        final updatedAdminData = AdminData(
          churchName: _churchNameController.text,
          posts: widget.adminData.posts,
          following: widget.adminData.following,
          followers: widget.adminData.followers,
          loginActivity: widget.adminData.loginActivity,
          loginActivityPercentage: widget.adminData.loginActivityPercentage,
          dailyFollows: widget.adminData.dailyFollows,
          dailyFollowsPercentage: widget.adminData.dailyFollowsPercentage,
          dailyVisits: widget.adminData.dailyVisits,
          dailyVisitsPercentage: widget.adminData.dailyVisitsPercentage,
          bookings: widget.adminData.bookings,
          bookingsPercentage: widget.adminData.bookingsPercentage,
          email: _emailController.text,
          phoneNumber: _phoneController.text,
          password: widget.adminData.password,
        );
        widget.onUpdateAdminData(updatedAdminData);
      } else {
        // Enter edit mode - refresh controllers with current data
        _initControllers();
      }
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF001A33),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header with background image
            Stack(
              children: [
                // Church background image
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage(
                        'assets/images/church_interior.jpg',
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                ),

                // Profile info
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
                  child: Column(
                    children: [
                      // Profile picture
                      Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF001A33),
                                width: 4,
                              ),
                              image: const DecorationImage(
                                image: AssetImage(
                                  'assets/images/church_logo.png',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3E9BFF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Admin',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Name
                      Text(
                        widget.adminData.churchName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Email and phone
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF002642),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.email,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.adminData.email,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Stats section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Church Statistics',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 16),

            // Stats row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Posts
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          widget.adminData.posts,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Posts',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  Container(height: 40, width: 1, color: Colors.white24),

                  // Followers
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          widget.adminData.followers,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Followers',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Edit profile button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _toggleEditMode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _isEditing ? 'Save Profile' : 'Edit Profile',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF001A33),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Edit form (only shown when editing)
            if (_isEditing)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildEditField('Church Name', _churchNameController),
                    _buildEditField('Email', _emailController),
                    _buildEditField('Phone Number', _phoneController),

                    const SizedBox(height: 16),

                    // Cancel button
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = false;
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 80), // Extra space for bottom nav bar
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF002642),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Admin Account Settings View
class AdminAccountSettingsView extends StatefulWidget {
  final AdminData adminData;
  final Function(AdminData) onUpdateAdminData;

  const AdminAccountSettingsView({
    super.key,
    required this.adminData,
    required this.onUpdateAdminData,
  });

  @override
  State<AdminAccountSettingsView> createState() =>
      _AdminAccountSettingsViewState();
}

class _AdminAccountSettingsViewState extends State<AdminAccountSettingsView> {
  bool _isEditing = false;
  late TextEditingController _churchNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _churchNameController = TextEditingController(
      text: widget.adminData.churchName,
    );
    _emailController = TextEditingController(text: widget.adminData.email);
    _phoneController = TextEditingController(
      text: widget.adminData.phoneNumber,
    );
  }

  @override
  void dispose() {
    _churchNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      if (_isEditing) {
        // Save changes
        final updatedAdminData = AdminData(
          churchName: _churchNameController.text,
          posts: widget.adminData.posts,
          following: widget.adminData.following,
          followers: widget.adminData.followers,
          loginActivity: widget.adminData.loginActivity,
          loginActivityPercentage: widget.adminData.loginActivityPercentage,
          dailyFollows: widget.adminData.dailyFollows,
          dailyFollowsPercentage: widget.adminData.dailyFollowsPercentage,
          dailyVisits: widget.adminData.dailyVisits,
          dailyVisitsPercentage: widget.adminData.dailyVisitsPercentage,
          bookings: widget.adminData.bookings,
          bookingsPercentage: widget.adminData.bookingsPercentage,
          email: _emailController.text,
          phoneNumber: _phoneController.text,
          password: widget.adminData.password,
        );
        widget.onUpdateAdminData(updatedAdminData);
      } else {
        // Enter edit mode - refresh controllers with current data
        _initControllers();
      }
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Account header
            const Text(
              'Account',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.adminData.churchName,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Form fields
            _isEditing
                ? _buildEditableField('Church Name', _churchNameController)
                : _buildSettingsField(
                  'Church Name',
                  widget.adminData.churchName,
                ),

            _isEditing
                ? _buildEditableField('Email', _emailController)
                : _buildSettingsField('Email', widget.adminData.email),

            _isEditing
                ? _buildEditableField('Phone Number', _phoneController)
                : _buildSettingsField(
                  'Phone Number',
                  widget.adminData.phoneNumber,
                ),

            const SizedBox(height: 30),

            // Security settings button
            TextButton(
              onPressed: () {
                // Navigate to security settings
                final homePageState =
                    context.findAncestorStateOfType<_AdminHomePageState>();
                homePageState?._navigateTo(AdminView.securitySettings);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.security, color: Color(0xFF002642)),
                  SizedBox(width: 8),
                  Text(
                    'Security Settings',
                    style: TextStyle(
                      color: Color(0xFF002642),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Edit/Save Profile button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _toggleEditMode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF002642),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  _isEditing ? 'Save Profile' : 'Edit Profile',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Cancel button (only in edit mode)
            if (_isEditing)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = false;
                      });
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(value, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF002642),
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Admin Security Settings View
class AdminSecuritySettingsView extends StatefulWidget {
  final AdminData adminData;
  final Function(AdminData) onUpdateAdminData;
  final Function(AdminView, {AuthenticatorFlow? flow, String? newValue})
  onNavigate;

  const AdminSecuritySettingsView({
    super.key,
    required this.adminData,
    required this.onUpdateAdminData,
    required this.onNavigate,
  });

  @override
  State<AdminSecuritySettingsView> createState() =>
      _AdminSecuritySettingsViewState();
}

class _AdminSecuritySettingsViewState extends State<AdminSecuritySettingsView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Security header
            const Text(
              'Security and Account Access',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.adminData.churchName,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Security options
            _buildSecurityOption(
              context,
              Icons.email,
              'Change Email',
              'Update your email address',
              onTap: () => widget.onNavigate(AdminView.changeEmail),
            ),

            _buildSecurityOption(
              context,
              Icons.lock,
              'Change Password',
              'Update your password',
              onTap: () => widget.onNavigate(AdminView.changePassword),
            ),

            _buildSecurityOption(
              context,
              Icons.phone,
              'Change Phone Number',
              'Update your phone number',
              onTap: () => widget.onNavigate(AdminView.changePhone),
            ),

            const SizedBox(height: 20),

            // Current information display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Information',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('Email', widget.adminData.email),
                  const SizedBox(height: 8),
                  _buildInfoRow('Phone', widget.adminData.phoneNumber),
                  const SizedBox(height: 8),
                  _buildInfoRow('Password', '••••••••••••••••'),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Account settings button
            TextButton(
              onPressed: () {
                // Navigate back to account settings
                widget.onNavigate(AdminView.accountSettings);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, color: Color(0xFF002642)),
                  SizedBox(width: 8),
                  Text(
                    'Account Settings',
                    style: TextStyle(
                      color: Color(0xFF002642),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityOption(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey[300]!),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: Icon(icon, color: Colors.black54),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}

// Change Email View
class AdminChangeEmailView extends StatefulWidget {
  final AdminData adminData;
  final Function(AdminView, {AuthenticatorFlow? flow, String? newValue})
  onNavigate;

  const AdminChangeEmailView({
    super.key,
    required this.adminData,
    required this.onNavigate,
  });

  @override
  State<AdminChangeEmailView> createState() => _AdminChangeEmailViewState();
}

class _AdminChangeEmailViewState extends State<AdminChangeEmailView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _currentEmailController;
  late TextEditingController _newEmailController;
  late TextEditingController _confirmEmailController;
  late TextEditingController _passwordController;
  bool _isVerifying = false;
  bool _isVerified = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _currentEmailController = TextEditingController(
      text: widget.adminData.email,
    );
    _newEmailController = TextEditingController();
    _confirmEmailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _currentEmailController.dispose();
    _newEmailController.dispose();
    _confirmEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _verifyPassword() {
    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    // Simulate password verification
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isVerifying = false;
        // In a real app, you would verify the password against the backend
        // For now, we'll just accept any non-empty password
        if (_passwordController.text.isNotEmpty) {
          _isVerified = true;
        } else {
          _errorMessage = 'Incorrect password';
        }
      });
    });
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            obscureText: isPassword,
            validator: validator,
            keyboardType:
                keyboardType ??
                (isPassword
                    ? TextInputType.text
                    : (label.toLowerCase().contains('email')
                        ? TextInputType.emailAddress
                        : (label.toLowerCase().contains('phone')
                            ? TextInputType.phone
                            : TextInputType.text))),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: errorText != null ? Colors.red : Colors.grey[300]!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: errorText != null ? Colors.red : Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color:
                      errorText != null ? Colors.red : const Color(0xFF002642),
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToVerification() {
    // Validate email format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    setState(() {
      if (_newEmailController.text.isEmpty) {
        _errorMessage = 'Please enter a new email';
        return;
      }

      if (!emailRegex.hasMatch(_newEmailController.text)) {
        _errorMessage = 'Please enter a valid email address';
        return;
      }

      if (_newEmailController.text == widget.adminData.email) {
        _errorMessage = 'New email must be different from current email';
        return;
      }

      if (_newEmailController.text != _confirmEmailController.text) {
        _errorMessage = 'Emails do not match';
        return;
      }

      _errorMessage = null;
    });

    if (_errorMessage != null) {
      return;
    }

    // Navigate to authenticator view with email flow
    widget.onNavigate(
      AdminView.authenticator,
      flow: AuthenticatorFlow.email,
      newValue: _newEmailController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Header
              const Text(
                'Change Email',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Update your email address',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Current email (read-only)
              _buildField(
                'Current Email',
                _currentEmailController,
                readOnly: true,
              ),

              // Password verification section
              if (!_isVerified) ...[
                _buildField(
                  'Enter Password to Continue',
                  _passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),

                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isVerifying ? null : _verifyPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002642),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        _isVerifying
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
                              'Verify Password',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
              ],

              // New email fields (only shown after password verification)
              if (_isVerified) ...[
                _buildField(
                  'New Email',
                  _newEmailController,
                  errorText:
                      _newEmailController.text.isNotEmpty &&
                              !RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(_newEmailController.text)
                          ? 'Please enter a valid email address'
                          : null,
                ),

                _buildField(
                  'Confirm New Email',
                  _confirmEmailController,
                  errorText:
                      _confirmEmailController.text.isNotEmpty &&
                              _newEmailController.text !=
                                  _confirmEmailController.text
                          ? 'Emails do not match'
                          : null,
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _proceedToVerification,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002642),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        widget.onNavigate(AdminView.securitySettings);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Change Password View
class AdminChangePasswordView extends StatefulWidget {
  final AdminData adminData;
  final Function(AdminView, {AuthenticatorFlow? flow, String? newValue})
  onNavigate;

  const AdminChangePasswordView({
    super.key,
    required this.adminData,
    required this.onNavigate,
  });

  @override
  State<AdminChangePasswordView> createState() =>
      _AdminChangePasswordViewState();
}

class _AdminChangePasswordViewState extends State<AdminChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _emailController;
  bool _isVerifying = false;
  bool _isVerified = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _emailController = TextEditingController(text: widget.adminData.email);
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _verifyEmail() {
    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    // Simulate email verification
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isVerifying = false;
        // In a real app, you would verify the email against the backend
        // For now, we'll just check if it matches the current email
        if (_emailController.text == widget.adminData.email) {
          _isVerified = true;
        } else {
          _errorMessage = 'Email does not match our records';
        }
      });
    });
  }

  void _validatePassword(String password) {
    setState(() {
      if (password.isEmpty) {
        _errorMessage = 'Password cannot be empty';
      } else if (password.length < 8) {
        _errorMessage = 'Password must be at least 8 characters';
      } else if (!password.contains(RegExp(r'[A-Z]'))) {
        _errorMessage = 'Password must contain at least one uppercase letter';
      } else if (!password.contains(RegExp(r'[a-z]'))) {
        _errorMessage = 'Password must contain at least one lowercase letter';
      } else if (!password.contains(RegExp(r'[0-9]'))) {
        _errorMessage = 'Password must contain at least one number';
      } else {
        _errorMessage = null;
      }
    });
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            obscureText: isPassword,
            validator: validator,
            keyboardType:
                keyboardType ??
                (isPassword
                    ? TextInputType.text
                    : (label.toLowerCase().contains('email')
                        ? TextInputType.emailAddress
                        : (label.toLowerCase().contains('phone')
                            ? TextInputType.phone
                            : TextInputType.text))),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: errorText != null ? Colors.red : Colors.grey[300]!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: errorText != null ? Colors.red : Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color:
                      errorText != null ? Colors.red : const Color(0xFF002642),
                  width: 2,
                ),
              ),
              filled: readOnly,
              fillColor: readOnly ? Colors.grey[100] : null,
              errorText: errorText,
            ),
            onChanged: (value) {
              if (isPassword && label.contains('New Password')) {
                _validatePassword(value);
              }
            },
          ),
        ],
      ),
    );
  }

  void _proceedToVerification() {
    // Validate password requirements
    final password = _newPasswordController.text;

    setState(() {
      if (password.isEmpty) {
        _errorMessage = 'Password cannot be empty';
        return;
      }

      if (password.length < 8) {
        _errorMessage = 'Password must be at least 8 characters';
        return;
      }

      if (!password.contains(RegExp(r'[A-Z]'))) {
        _errorMessage = 'Password must contain at least one uppercase letter';
        return;
      }

      if (!password.contains(RegExp(r'[a-z]'))) {
        _errorMessage = 'Password must contain at least one lowercase letter';
        return;
      }

      if (!password.contains(RegExp(r'[0-9]'))) {
        _errorMessage = 'Password must contain at least one number';
        return;
      }

      if (password != _confirmPasswordController.text) {
        _errorMessage = 'Passwords do not match';
        return;
      }

      _errorMessage = null;
    });

    if (_errorMessage != null) {
      return;
    }

    // Navigate to authenticator view with password flow
    widget.onNavigate(
      AdminView.authenticator,
      flow: AuthenticatorFlow.password,
      newValue: _newPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Header
              const Text(
                'Change Password',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Update your password',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Email verification section
              if (!_isVerified) ...[
                _buildField(
                  'Confirm Your Email',
                  _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),

                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isVerifying ? null : _verifyEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002642),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        _isVerifying
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
                              'Verify Email',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
              ],

              // Password fields (only shown after email verification)
              if (_isVerified) ...[
                _buildField(
                  'Current Password',
                  _currentPasswordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                ),

                _buildField(
                  'New Password',
                  _newPasswordController,
                  isPassword: true,
                  errorText:
                      _newPasswordController.text.isNotEmpty
                          ? _errorMessage
                          : null,
                ),

                _buildField(
                  'Confirm New Password',
                  _confirmPasswordController,
                  isPassword: true,
                  errorText:
                      _confirmPasswordController.text.isNotEmpty &&
                              _newPasswordController.text !=
                                  _confirmPasswordController.text
                          ? 'Passwords do not match'
                          : null,
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _proceedToVerification,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002642),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        widget.onNavigate(AdminView.securitySettings);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Change Phone View
class AdminChangePhoneView extends StatefulWidget {
  final AdminData adminData;
  final Function(AdminView, {AuthenticatorFlow? flow, String? newValue})
  onNavigate;

  const AdminChangePhoneView({
    super.key,
    required this.adminData,
    required this.onNavigate,
  });

  @override
  State<AdminChangePhoneView> createState() => _AdminChangePhoneViewState();
}

class _AdminChangePhoneViewState extends State<AdminChangePhoneView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _currentPhoneController;
  late TextEditingController _newPhoneController;
  late TextEditingController _emailController;
  bool _isVerifying = false;
  bool _isVerified = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _currentPhoneController = TextEditingController(
      text: widget.adminData.phoneNumber,
    );
    _newPhoneController = TextEditingController();
    _emailController = TextEditingController(text: widget.adminData.email);
  }

  @override
  void dispose() {
    _currentPhoneController.dispose();
    _newPhoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _verifyEmail() {
    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    // Simulate email verification
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isVerifying = false;
        // In a real app, you would verify the email against the backend
        // For now, we'll just check if it matches the current email
        if (_emailController.text == widget.adminData.email) {
          _isVerified = true;
        } else {
          _errorMessage = 'Email does not match our records';
        }
      });
    });
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            obscureText: isPassword,
            validator: validator,
            keyboardType:
                keyboardType ??
                (isPassword
                    ? TextInputType.text
                    : (label.toLowerCase().contains('email')
                        ? TextInputType.emailAddress
                        : (label.toLowerCase().contains('phone')
                            ? TextInputType.phone
                            : TextInputType.text))),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: errorText != null ? Colors.red : Colors.grey[300]!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: errorText != null ? Colors.red : Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color:
                      errorText != null ? Colors.red : const Color(0xFF002642),
                  width: 2,
                ),
              ),
              filled: readOnly,
              fillColor: readOnly ? Colors.grey[100] : null,
              errorText: errorText,
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToVerification() {
    // Validate phone number format
    final phoneRegex = RegExp(r'^\d{10,15}$');
    final phone = _newPhoneController.text.replaceAll(RegExp(r'\D'), '');

    setState(() {
      if (_newPhoneController.text.isEmpty) {
        _errorMessage = 'Please enter a new phone number';
        return;
      }

      if (_newPhoneController.text == widget.adminData.phoneNumber) {
        _errorMessage =
            'New phone number must be different from current phone number';
        return;
      }

      if (!phoneRegex.hasMatch(phone)) {
        _errorMessage = 'Please enter a valid phone number';
        return;
      }

      _errorMessage = null;
    });

    if (_errorMessage != null) {
      return;
    }

    // Navigate to authenticator view with phone flow
    widget.onNavigate(
      AdminView.authenticator,
      flow: AuthenticatorFlow.phone,
      newValue: _newPhoneController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Header
              const Text(
                'Change Phone Number',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Update your phone number',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Current phone (read-only)
              _buildField(
                'Current Phone Number',
                _currentPhoneController,
                readOnly: true,
              ),

              // Email verification section
              if (!_isVerified) ...[
                _buildField(
                  'Confirm Your Email',
                  _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),

                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isVerifying ? null : _verifyEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002642),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        _isVerifying
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
                              'Verify Email',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
              ],

              // New phone field (only shown after email verification)
              if (_isVerified) ...[
                _buildField(
                  'New Phone Number',
                  _newPhoneController,
                  keyboardType: TextInputType.phone,
                  errorText:
                      _newPhoneController.text.isNotEmpty &&
                              !RegExp(r'^\d{10,15}$').hasMatch(
                                _newPhoneController.text.replaceAll(
                                  RegExp(r'\D'),
                                  '',
                                ),
                              )
                          ? 'Please enter a valid phone number'
                          : null,
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _proceedToVerification,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002642),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        widget.onNavigate(AdminView.securitySettings);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Notification Settings View
class AdminNotificationSettingsView extends StatelessWidget {
  final VoidCallback onBack;

  const AdminNotificationSettingsView({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: const Center(child: Text('Notification Settings View')),
    );
  }
}
