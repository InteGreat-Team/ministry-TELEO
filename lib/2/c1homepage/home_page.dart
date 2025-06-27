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
import '../../3/contact_us_screen.dart';
import '../../3/c1widgets/authenticator_screen.dart';
import '../../1/c1homepage/donate_screen.dart';

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
          _currentTitle = 'Terms & Conditions';
          break;
        case AdminView.contactUs:
          _currentTitle = 'Contact Us';
          break;
        case AdminView.donate:
          _currentTitle = 'Donate';
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
                  Navigator.of(context).pop();
                  // Navigate back to the security settings view
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
    // Prevent the app from rotating
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          _currentView == AdminView.faqs
              ? null
              : AppBar(
                title: Text(
                  _currentTitle,
                  style: const TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                leading:
                    _currentView != AdminView.home
                        ? IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: Colors.black,
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
                    color: Colors.black,
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

  Widget _buildBody() {
    switch (_currentView) {
      case AdminView.setRoles:
        return const SetRoleScreen();
      case AdminView.faqs:
        return FAQsScreen(onNavigate: _navigateTo);
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
          currentEmail: _adminData.email,
          onNavigate: _navigateTo,
        );
      case AdminView.changePassword:
        return AdminChangePasswordView(onNavigate: _navigateTo);
      case AdminView.changePhone:
        return AdminChangePhoneView(
          currentPhoneNumber: _adminData.phoneNumber,
          onNavigate: _navigateTo,
        );
      case AdminView.authenticator:
        return AuthenticatorScreen(
          onSuccess: _handleAuthenticationSuccess,
          onCancel: () => _navigateTo(AdminView.securitySettings),
        );
      case AdminView.notificationSettings:
        return NotificationSettingsView(onNavigate: _navigateTo);
      case AdminView.massSchedule:
        return const MassScheduleScreen();
      case AdminView.reportIssue:
        return ReportApp(onNavigate: _navigateTo);
      case AdminView.termsAndConditions:
        return AdminTermsConditionsView(onNavigate: _navigateTo);
      case AdminView.contactUs:
        return const ContactUsScreen();
      case AdminView.donate:
        return const DonateScreen();
      case AdminView.home:
        return _buildHomeView();
    }
  }

  Widget _buildHomeView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Church profile card
          _buildChurchProfileCard(),
          const SizedBox(height: 16),

          // Metrics cards in 2x2 grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
          const SizedBox(height: 16),

          // Analytics chart
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildAnalyticsChart(),
          ),
          const SizedBox(height: 16),

          // Manage Content section
          _buildManageContentSection(),
        ],
      ),
    );
  }

  Widget _buildChurchProfileCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2B3576),
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage('assets/images/church_interior.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Color(0xFF2B3576), BlendMode.overlay),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
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
                      size: 35,
                      color: Color(0xFFF9B233),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _adminData.churchName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildStatsSection(),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatColumn(Icons.post_add, _adminData.posts, 'Posts'),
          _buildVerticalDivider(),
          _buildStatColumn(
            Icons.person_add_alt_1,
            _adminData.following,
            'Following',
          ),
          _buildVerticalDivider(),
          _buildStatColumn(Icons.people, _adminData.followers, 'Followers'),
        ],
      ),
    );
  }

  Widget _buildStatColumn(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 48,
      width: 1.5,
      color: Colors.white.withOpacity(0.25),
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
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
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF2B3576),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF2B3576),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              percent,
              style: TextStyle(
                color: percent.startsWith('+') ? Colors.green : Colors.red,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsChart() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabBar(
              controller: _tabController,
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Colors.orange,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 2.0,
              tabs: const [
                Tab(text: 'Total Reads'),
                Tab(text: 'Total Watches'),
                Tab(text: 'Total Follows'),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 150,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTotalReadsChart(),
                  _buildTotalWatchesChart(),
                  _buildTotalFollowersDisplay(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalReadsChart() {
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            painter: LineChartPainter(),
            size: const Size(double.infinity, double.infinity),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun']
                  .map(
                    (month) => Text(
                      month,
                      style: TextStyle(color: Colors.grey[600], fontSize: 10),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildTotalWatchesChart() {
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            painter: BarChartPainter(),
            size: const Size(double.infinity, double.infinity),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
              ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun']
                  .map(
                    (month) => Text(
                      month,
                      style: TextStyle(color: Colors.grey[600], fontSize: 10),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildTotalFollowersDisplay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _adminData.followers,
          style: const TextStyle(
            color: Colors.orange,
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              '+11.01%',
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
            SizedBox(width: 4),
            Icon(Icons.trending_up, color: Colors.green, size: 16),
          ],
        ),
      ],
    );
  }

  Widget _buildManageContentSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                const Text(
                  'Manage Content',
                  style: TextStyle(
                    color: Color(0xFF2B3576),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B3576),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.help_outline,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildManageContentIcon(Icons.event, Colors.red),
                _buildManageContentIcon(Icons.people, Colors.orange),
                _buildManageContentIcon(Icons.article, Colors.brown),
                _buildManageContentIcon(
                  Icons.admin_panel_settings,
                  Colors.blue,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildManageContentList(),
        ],
      ),
    );
  }

  Widget _buildManageContentIcon(IconData icon, Color color) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildManageContentList() {
    final items = [
      {'icon': Icons.event, 'title': 'Events', 'color': Colors.red},
      {'icon': Icons.people, 'title': 'Community', 'color': Colors.orange},
      {'icon': Icons.article, 'title': 'Posts', 'color': Colors.brown},
      {
        'icon': Icons.admin_panel_settings,
        'title': 'Set Roles',
        'color': Colors.blue,
      },
    ];

    return Column(
      children:
          items.map((item) {
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!, width: 1),
                ),
              ),
              child: ListTile(
                leading: Icon(
                  item['icon'] as IconData,
                  color: item['color'] as Color,
                  size: 20,
                ),
                title: Text(
                  item['title'] as String,
                  style: const TextStyle(
                    color: Color(0xFF2B3576),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: 20,
                ),
                onTap: () {
                  switch (item['title']) {
                    case 'Events':
                      _navigateTo(AdminView.events);
                      break;
                    case 'Community':
                      _navigateTo(AdminView.community);
                      break;
                    case 'Posts':
                      _navigateTo(AdminView.posts);
                      break;
                    case 'Set Roles':
                      _navigateTo(AdminView.setRoles);
                      break;
                  }
                },
              ),
            );
          }).toList(),
    );
  }

  int _navBarIndexForView(AdminView view) {
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

  AdminView _viewForNavBarIndex(int index) {
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
}

class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.orange
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final path = Path();
    // Replicating points from image
    final points = [
      Offset(size.width * 0.05, size.height * 0.4),
      Offset(size.width * 0.18, size.height * 0.7),
      Offset(size.width * 0.31, size.height * 0.5),
      Offset(size.width * 0.44, size.height * 0.2),
      Offset(size.width * 0.57, size.height * 0.25),
      Offset(size.width * 0.70, size.height * 0.05),
      Offset(size.width * 0.83, size.height * 0.3),
      Offset(size.width * 0.95, size.height * 0.4),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);

    final pointPaint =
        Paint()
          ..color = Colors.orange
          ..style = PaintingStyle.fill;

    final borderPaint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
      canvas.drawCircle(point, 4, borderPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class BarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const leftOffset = 30.0;
    final drawableWidth = size.width - leftOffset;

    final yAxisLabelPaint = TextPainter(
      textAlign: TextAlign.right,
      textDirection: TextDirection.ltr,
    );
    final yLabels = ['30K', '20K', '10K', '0'];
    for (var i = 0; i < yLabels.length; i++) {
      yAxisLabelPaint.text = TextSpan(
        text: yLabels[i],
        style: TextStyle(color: Colors.grey[600], fontSize: 10),
      );
      yAxisLabelPaint.layout();
      final y = (size.height / (yLabels.length - 1)) * i;
      yAxisLabelPaint.paint(
        canvas,
        Offset(
          leftOffset - yAxisLabelPaint.width - 8,
          y - yAxisLabelPaint.height / 2,
        ),
      );
    }

    final barPaint = Paint()..color = Colors.orange;
    final barData = [0.6, 1.0, 0.7, 1.2, 0.4, 0.9]; // Sample data
    final maxVal = 1.3;
    final barWidth = (drawableWidth / barData.length) * 0.4;
    final spacing = (drawableWidth / barData.length) * 0.6;

    for (var i = 0; i < barData.length; i++) {
      final barHeight = (barData[i] / maxVal) * size.height;
      final x = leftOffset + (i * (barWidth + spacing)) + spacing / 2;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, size.height - barHeight, barWidth, barHeight),
          const Radius.circular(4),
        ),
        barPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
