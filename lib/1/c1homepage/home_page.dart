import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'faqs_screen.dart';
import 'contact_us_screen.dart';
import 'church_profile_screen.dart';
import '../../3/nav_bar.dart';
import 'donate_screen.dart';
import '../../2/c1homepage/authenticator_flow.dart';
import '../../3/report/mainreport.dart';

// Add this enum to track the current filter
enum HomeFilter { all, appointments, events, reading }

// Enum to track current view - Add report to the enum
enum AppView {
  home,
  profile,
  settings,
  accountSettings,
  securitySettings,
  changeEmail,
  changePassword,
  changePhone,
  authenticator,
  faqs,
  report, // Add this line
}

// User model to store user data
class UserData {
  String firstName;
  String lastName;
  String pronouns;
  String birthdate;
  String email;
  String phoneNumber;
  String username;
  String password;

  UserData({
    required this.firstName,
    required this.lastName,
    required this.pronouns,
    required this.birthdate,
    required this.email,
    required this.phoneNumber,
    required this.username,
    required this.password,
  });
}

// Consistent section header style for all major sections
const sectionHeaderStyle = TextStyle(
  color: Colors.white,
  fontSize: 24,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.2,
);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppView _currentView = AppView.home;
  String _currentTitle = 'Teleo';
  AuthenticatorFlow _currentAuthFlow = AuthenticatorFlow.email;

  // Store temporary data for authentication flows
  String _newEmail = '';
  String _newPassword = '';
  String _newPhoneNumber = '';

  // User data that will be shared across views
  UserData _userData = UserData(
    firstName: 'Juan',
    lastName: 'de la Cruz',
    pronouns: 'He/Him',
    birthdate: '01/25/1999',
    email: 'juandelacruz1999@yahoo.com',
    phoneNumber: '09173548926',
    username: '@juandelacruz',
    password: '••••••••••••••••',
  );

  // Add this to the _HomePageState class variables
  HomeFilter _currentFilter = HomeFilter.all;

  // Add these variables to the _HomePageState class
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<Map<String, dynamic>> _searchResults = [];

  void _updateUserData(UserData newData) {
    setState(() {
      _userData = newData;
    });
  }

  void _navigateTo(AppView view, {AuthenticatorFlow? flow, String? newValue}) {
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

      //Purpe of this code is to set titles for the sidebar and also mixed of settings
      switch (view) {
        case AppView.home:
          _currentTitle = 'Teleo';
          break;
        case AppView.profile:
          _currentTitle = 'Profile';
          break;
        case AppView.settings:
          _currentTitle = 'Settings';
          break;
        case AppView.accountSettings:
          _currentTitle = 'Account';
          break;
        case AppView.securitySettings:
          _currentTitle = 'Security';
          break;
        case AppView.changeEmail:
          _currentTitle = 'Change Email';
          break;
        case AppView.changePassword:
          _currentTitle = 'Change Password';
          break;
        case AppView.changePhone:
          _currentTitle = 'Change Phone Number';
          break;
        case AppView.authenticator:
          _currentTitle = 'Security';
          break;
        case AppView.faqs:
          _currentTitle = 'FAQs';
          break;
        case AppView.report: // Add this case
          _currentTitle = 'Report';
          break;
      }
    });
  }

  void _handleAuthenticationSuccess() {
    // Update user data based on the current flow
    UserData updatedUserData;

    switch (_currentAuthFlow) {
      case AuthenticatorFlow.email:
        updatedUserData = UserData(
          firstName: _userData.firstName,
          lastName: _userData.lastName,
          pronouns: _userData.pronouns,
          birthdate: _userData.birthdate,
          email: _newEmail,
          phoneNumber: _userData.phoneNumber,
          username: _userData.username,
          password: _userData.password,
        );
        break;
      case AuthenticatorFlow.password:
        updatedUserData = UserData(
          firstName: _userData.firstName,
          lastName: _userData.lastName,
          pronouns: _userData.pronouns,
          birthdate: _userData.birthdate,
          email: _userData.email,
          phoneNumber: _userData.phoneNumber,
          username: _userData.username,
          password: _newPassword,
        );
        break;
      case AuthenticatorFlow.phone:
        updatedUserData = UserData(
          firstName: _userData.firstName,
          lastName: _userData.lastName,
          pronouns: _userData.pronouns,
          birthdate: _userData.birthdate,
          email: _userData.email,
          phoneNumber: _newPhoneNumber,
          username: _userData.username,
          password: _userData.password,
        );
        break;
    }

    _updateUserData(updatedUserData);

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
                  _navigateTo(AppView.securitySettings);
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

  // Add this method to the _HomePageState class
  void _showSearchBar() {
    setState(() {
      _isSearching = true;
      _searchResults = [];
    });

    // Focus on the search field after a short delay to allow the UI to build
    Future.delayed(const Duration(milliseconds: 100), () {
      _searchFocusNode.requestFocus();
    });
  }

  void _hideSearchBar() {
    setState(() {
      _isSearching = false;
      _searchQuery = '';
      _searchController.clear();
      _searchResults = [];
    });
  }

  // Update the _performSearch method in the _HomePageState class
  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;

      if (query.isEmpty) {
        _searchResults = [];
        return;
      }

      // Mock search results - in a real app, this would query a database
      _searchResults =
          [
                {
                  'name': 'Sunny Detroit Church',
                  'type': 'church',
                  'location': 'Detroit, MI',
                  'members': '1,245',
                  'established': '1985',
                  'joined': '04/12/23',
                },
                {
                  'name': 'Sunny Los Angeles Church',
                  'type': 'church',
                  'location': 'Los Angeles, CA',
                  'members': '2,567',
                  'established': '1992',
                },
                {
                  'name': 'Sunny Hill California Church',
                  'type': 'church',
                  'location': 'San Francisco, CA',
                  'members': '987',
                  'established': '2001',
                },
                {
                  'name': 'Grace Community Church',
                  'type': 'church',
                  'location': 'Chicago, IL',
                  'members': '3,421',
                  'established': '1978',
                },
                {'name': 'Holy Trinity Service', 'type': 'service'},
                {'name': 'Sunday Morning Prayer', 'type': 'event'},
              ]
              .where(
                (result) =>
                    result['name']!.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // Update the build method to include the search overlay
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor:
              _currentView == AppView.home ||
                      _currentView == AppView.profile ||
                      _currentView == AppView.faqs
                  ? const Color(0xFF001A33)
                  : Colors.white,
          appBar: AppBar(
            title: Text(_currentTitle),
            backgroundColor:
                _currentView == AppView.home ||
                        _currentView == AppView.profile ||
                        _currentView == AppView.faqs
                    ? const Color(0xFF001A33)
                    : Colors.white,
            foregroundColor:
                _currentView == AppView.home ||
                        _currentView == AppView.profile ||
                        _currentView == AppView.faqs
                    ? Colors.white
                    : Colors.black,
            elevation: 0,
            leading:
                _currentView != AppView.home
                    ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        if (_currentView == AppView.authenticator) {
                          switch (_currentAuthFlow) {
                            case AuthenticatorFlow.email:
                              _navigateTo(AppView.changeEmail);
                              break;
                            case AuthenticatorFlow.password:
                              _navigateTo(AppView.changePassword);
                              break;
                            case AuthenticatorFlow.phone:
                              _navigateTo(AppView.changePhone);
                              break;
                          }
                        } else if (_currentView == AppView.changeEmail ||
                            _currentView == AppView.changePassword ||
                            _currentView == AppView.changePhone) {
                          _navigateTo(AppView.securitySettings);
                        } else if (_currentView == AppView.securitySettings ||
                            _currentView == AppView.accountSettings) {
                          _navigateTo(AppView.settings);
                        } else if (_currentView == AppView.faqs) {
                          _navigateTo(AppView.home);
                        } else if (_currentView == AppView.profile) {
                          _navigateTo(AppView.home);
                        } else if (_currentView == AppView.report) {
                          // ADD THIS LINE
                          _navigateTo(AppView.settings);
                        } else {
                          _navigateTo(AppView.home);
                        }
                      },
                    )
                    : null,
            actions: [
              if (_currentView == AppView.home)
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    // Notification functionality will be added later
                  },
                ),
            ],
          ),
          drawer:
              _currentView == AppView.home
                  ? AppDrawer(onNavigate: _navigateTo, userData: _userData)
                  : null,
          body: _buildBody(),
          bottomNavigationBar: _buildBottomNav(),
        ),

        // Search overlay
        if (_isSearching) _buildSearchOverlay(),
      ],
    );
  }

  // Update the _buildSearchOverlay method in the _HomePageState class
  Widget _buildSearchOverlay() {
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: SafeArea(
            child: Column(
              children: [
                // Search bar
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0277BD),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          children: [
                            // Back button or hamburger menu
                            IconButton(
                              icon:
                                  _searchQuery.isEmpty
                                      ? const Icon(
                                        Icons.menu,
                                        color: Colors.white,
                                      )
                                      : const Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      ),
                              onPressed: () {
                                if (_searchQuery.isEmpty) {
                                  // Open drawer
                                  Scaffold.of(context).openDrawer();
                                } else {
                                  // Clear search and go back to initial search state
                                  setState(() {
                                    _searchQuery = '';
                                    _searchController.clear();
                                    _searchResults = [];
                                  });
                                }
                              },
                            ),

                            // Search text field
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                focusNode: _searchFocusNode,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'What are you looking for?',
                                  hintStyle: TextStyle(color: Colors.white70),
                                  border: InputBorder.none,
                                ),
                                onChanged: _performSearch,
                              ),
                            ),

                            // Search or clear button
                            IconButton(
                              icon:
                                  _searchQuery.isEmpty
                                      ? const Icon(
                                        Icons.search,
                                        color: Colors.white,
                                      )
                                      : const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                              onPressed: () {
                                if (_searchQuery.isEmpty) {
                                  // Focus on search field
                                  _searchFocusNode.requestFocus();
                                } else {
                                  // Clear search
                                  setState(() {
                                    _searchQuery = '';
                                    _searchController.clear();
                                    _searchResults = [];
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      // Search results
                      if (_searchResults.isNotEmpty)
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0277BD),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  _searchResults.map((result) {
                                    return InkWell(
                                      onTap: () {
                                        // Handle result selection
                                        _hideSearchBar();

                                        // Navigate to the church profile if it's a church
                                        if (result['type'] == 'church') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      ChurchProfileScreen(
                                                        churchData: result,
                                                      ),
                                            ),
                                          );
                                        } else {
                                          // For other types, just show a snackbar
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Selected: ${result['name']}',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16.0,
                                          horizontal: 24.0,
                                        ),
                                        child: Row(
                                          children: [
                                            // Icon based on type
                                            Icon(
                                              result['type'] == 'church'
                                                  ? Icons.church
                                                  : (result['type'] == 'event'
                                                      ? Icons.event
                                                      : Icons
                                                          .miscellaneous_services),
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 12),
                                            // Result name
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    result['name']!,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  if (result['location'] !=
                                                      null)
                                                    Text(
                                                      result['location']!,
                                                      style: const TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            // Arrow icon for navigation
                                            const Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.white70,
                                              size: 14,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Clickable area to dismiss search
                Expanded(
                  child: GestureDetector(
                    onTap: _hideSearchBar,
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: _hideSearchBar,
            ),
            hintText: 'Search...',
            border: InputBorder.none,
          ),
          onChanged: _performSearch,
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentView) {
      case AppView.profile:
        return ProfileView(
          userData: _userData,
          onUpdateUserData: _updateUserData,
        );
      case AppView.settings:
        return SettingsView(onNavigate: _navigateTo);
      case AppView.accountSettings:
        return AccountSettingsView(
          userData: _userData,
          onUpdateUserData: _updateUserData,
        );
      case AppView.securitySettings:
        return SecuritySettingsView(
          userData: _userData,
          onUpdateUserData: _updateUserData,
          onNavigate: _navigateTo,
        );
      case AppView.changeEmail:
        return ChangeEmailView(userData: _userData, onNavigate: _navigateTo);
      case AppView.changePassword:
        return ChangePasswordView(userData: _userData, onNavigate: _navigateTo);
      case AppView.changePhone:
        return ChangePhoneView(userData: _userData, onNavigate: _navigateTo);
      case AppView.authenticator:
        return AuthenticatorView(
          flow: _currentAuthFlow,
          onSuccess: _handleAuthenticationSuccess,
        );
      case AppView.faqs:
        return const FAQsScreen();
      case AppView.report:
        return ReportApp(); // Replace with your actual class name
      case AppView.home:
        return _buildHomeView();
    }
  }

  // Update the _buildHomeView method to match the new design
  // Replace the existing _buildHomeView method with this implementation

  Widget _buildHomeView() {
    return Container(
      color: const Color(0xFF001A33),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          children: [
            const SizedBox(height: 24),
            _buildWelcomeHeader(),
            const SizedBox(height: 24),
            _buildStatsCards(),
            const SizedBox(height: 24),
            _buildActionButtons(),
            const SizedBox(height: 24),
            if (_currentFilter == HomeFilter.all) ...[
              _buildUpcomingServicesRow(),
              const SizedBox(height: 24),
            ],
            if (_currentFilter == HomeFilter.appointments) ...[
              _buildAppointmentsSection(),
              const SizedBox(height: 24),
            ],
            if (_currentFilter == HomeFilter.events) ...[
              _buildEventsSection(),
              const SizedBox(height: 24),
            ],
            if (_currentFilter == HomeFilter.reading) ...[
              _buildReadingSection(),
              const SizedBox(height: 24),
            ],
            if (_currentFilter == HomeFilter.all) ...[
              _buildExploreTeleoSection(),
              const SizedBox(height: 24),
              _buildServicesSection(),
              const SizedBox(height: 24),
              _buildBulletinBoardRow(),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Add this new method for the horizontally scrollable Upcoming Services row
  Widget _buildUpcomingServicesRow() {
    final List<Map<String, String>> services = [
      {
        'title': 'Morning Service',
        'subtitle': 'Join us!',
        'description': 'Sunday Worship',
        'time': '8:00 AM',
        'image': 'assets/images/church_interior.jpg',
      },
      {
        'title': 'Evening Service',
        'subtitle': 'Pray together',
        'description': 'Midweek Prayer',
        'time': '6:00 PM',
        'image': 'assets/images/church_interior.jpg',
      },
      // Add more services as needed
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Services',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 270,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: services.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final service = services[index];
              return _buildUpcomingServiceCardModern(
                service['title']!,
                service['subtitle']!,
                service['description']!,
                service['time']!,
                service['image']!,
              );
            },
          ),
        ),
      ],
    );
  }

  // Modern card for Upcoming Services (matches screenshot)
  Widget _buildUpcomingServiceCardModern(
    String title,
    String subtitle,
    String description,
    String time,
    String imagePath,
  ) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.asset(
                  imagePath,
                  width: 220,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    shadows: [Shadow(blurRadius: 6, color: Colors.black)],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 32, // Increased from 28
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.3, // Increased from 1.2
                ),
                children: [
                  const TextSpan(text: 'Welcome, '),
                  TextSpan(
                    text: _userData.firstName,
                    style: const TextStyle(color: Color(0xFF3E9BFF)),
                  ),
                  const TextSpan(text: '!'),
                ],
              ),
            ),
            const SizedBox(height: 12), // Increased from 8
            const Text(
              "What's the agenda for today?",
              style: TextStyle(
                fontSize: 20, // Increased from 18
                color: Colors.white70,
                height: 1.3, // Increased from 1.2
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: _showSearchBar,
          child: Container(
            width: 64, // Increased from 56
            height: 64, // Increased from 56
            decoration: BoxDecoration(
              color: const Color(0xFF3E9BFF),
              borderRadius: BorderRadius.circular(32), // Increased from 28
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3E9BFF).withOpacity(0.3),
                  blurRadius: 12, // Increased from 8
                  offset: const Offset(0, 6), // Increased from 4
                ),
              ],
            ),
            child: const Icon(
              Icons.search,
              color: Colors.white,
              size: 32,
            ), // Increased from 28
          ),
        ),
      ],
    );
  }

  //STOPPED HERE
  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16), // Reduced padding
            decoration: BoxDecoration(
              color: const Color(0xFF002642),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Streak',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '7 days',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '+100%',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF002642),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lives Reached',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '3,671',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '-0.03%',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _currentFilter = HomeFilter.all;
              });
            },
            child: Container(
              width: 56, // Increased from 48
              height: 56, // Increased from 48
              decoration: BoxDecoration(
                color:
                    _currentFilter == HomeFilter.all
                        ? const Color(0xFF3E9BFF)
                        : const Color(0xFF002642),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.home,
                color: Colors.white,
                size: 28,
              ), // Increased from 24
            ),
          ),
          const SizedBox(width: 16), // Increased from 12
          _buildActionButton(
            Icons.calendar_today_outlined,
            'Appointment',
            Colors.blue,
            filter: HomeFilter.appointments,
          ),
          const SizedBox(width: 16), // Increased from 12
          _buildActionButton(
            Icons.event_note_outlined,
            'Events',
            Colors.blue,
            filter: HomeFilter.events,
          ),
          const SizedBox(width: 16), // Increased from 12
          _buildActionButton(
            Icons.menu_book_outlined,
            'Reading',
            Colors.blue,
            filter: HomeFilter.reading,
          ),
        ],
      ),
    );
  }

  Widget _buildBulletinBoardRow() {
    return Row(
      children: [
        Expanded(child: _buildBulletinBoard('Bulletin Board', Icons.dashboard)),
        const SizedBox(width: 12),
        Expanded(child: _buildBulletinBoard('Discussion Board', Icons.forum)),
        const SizedBox(width: 12),
        Expanded(child: _buildBulletinBoard('Bulletin Board', Icons.dashboard)),
      ],
    );
  }

  Widget _buildExploreTeleoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Explore TELEO', style: sectionHeaderStyle),
        const SizedBox(height: 22),
        SizedBox(
          height: 280,
          child: PageView(
            controller: PageController(viewportFraction: 0.9),
            children: [
              _buildTeleoCard(
                "What is TELEO?",
                "What is TELEO?",
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.",
                0,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('What is TELEO tapped')),
                  );
                },
              ),
              _buildTeleoCard(
                "Book Services!",
                "Book Services with Us",
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                1,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Book Services tapped')),
                  );
                },
              ),
              _buildTeleoCard(
                "Join Events!",
                "Join our Events!",
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                2,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Join Events tapped')),
                  );
                },
              ),
              _buildTeleoCard(
                "Prayer Wall",
                "Pray with Us!",
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                3,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Prayer Wall tapped')),
                  );
                },
              ),
              _buildTeleoCard(
                "Discussion",
                "Share your Thoughts!",
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                4,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Discussion tapped')),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Services', style: sectionHeaderStyle),
        const SizedBox(height: 22),
        SizedBox(
          height: 267,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildServiceCardItem(
                'Baptism',
                'Welcome into His grace, rejoice in your new life with Christ.',
                'assets/images/baptism_service.jpg',
                'Book Now',
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Baptism booking requested')),
                  );
                },
              ),
              _buildServiceCardItem(
                'Funerals',
                'Commemorate a beautiful life held in God\'s eternal care.',
                'assets/images/funeral_service.jpg',
                'Book Now',
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funeral service booking requested'),
                    ),
                  );
                },
              ),
              _buildServiceCardItem(
                'Youth',
                'Ignite your faith- where passion, purpose, and God\'s love unite!',
                'assets/images/youth_service.jpg',
                'Join',
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Youth program joining requested'),
                    ),
                  );
                },
              ),
              _buildServiceCardItem(
                'Outreach',
                'Spreading hope and kindness- guided by God\'s grace.',
                'assets/images/outreach_service.jpg',
                'Join',
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Outreach program joining requested'),
                    ),
                  );
                },
              ),
              _buildServiceCardItem(
                'Partner with Us',
                'Give with a heart of faith by blessing others and changing lives.',
                'assets/images/partner_service.jpg',
                'Donate',
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Donation process initiated')),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Add these methods to the _HomePageState class

  // Find the _buildAppointmentsSection method and replace it with this implementation
  Widget _buildAppointmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Services',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        // Service cards
        _buildServiceCard(
          'Wedding',
          'Service',
          'Wed March 5 - 10:00 AM',
          'assets/images/wedding_service.jpg',
          Icons.favorite,
        ),

        const SizedBox(height: 12),

        _buildServiceCard(
          'Funeral',
          'Service',
          'Fri March 21 - 10:00 AM',
          'assets/images/funeral_service.jpg',
          Icons.church,
        ),

        const SizedBox(height: 12),

        _buildServiceCard(
          'Baptism',
          'Service',
          'Sun April 6 - 10:00 AM',
          'assets/images/baptism_service.jpg',
          Icons.water_drop,
        ),
      ],
    );
  }

  void _showAppointmentBookingDialog(String serviceType) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF002642),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Book $serviceType',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Date picker
              GestureDetector(
                onTap: () {
                  // Show date picker
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF001A33),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.white, size: 20),
                      SizedBox(width: 12),
                      Text(
                        'Select Date',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Time picker
              GestureDetector(
                onTap: () {
                  // Show time picker
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF001A33),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.white, size: 20),
                      SizedBox(width: 12),
                      Text(
                        'Select Time',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Notes
              TextField(
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Additional notes...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF001A33),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),

              const SizedBox(height: 24),

              // Book button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$serviceType booked successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3E9BFF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Book Appointment',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Events', style: sectionHeaderStyle),
        const SizedBox(height: 24),
        // Improved event card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.asset(
                  'assets/images/wedding_service.jpg',
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 50,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Celebration of Christ',
                      style: TextStyle(
                        color: Color(0xFF3E9BFF),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Join us for a special celebration of faith, music, and community. All are welcome to participate and experience the joy of Christ together.',
                      style: TextStyle(color: Color(0xFF001A33), fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Color(0xFF3E9BFF),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'April 18, 2025',
                              style: TextStyle(
                                color: Color(0xFF001A33),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.group_add, size: 18),
                          label: const Text('Join Event'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3E9BFF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReadingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Daily Readings', style: sectionHeaderStyle),
        const SizedBox(height: 24),

        // Reading cards
        _buildReadingCard(
          'Daily Devotional',
          'May 15, 2025',
          'Psalm 23:1-6',
          'The LORD is my shepherd; I shall not want. He makes me lie down in green pastures. He leads me beside still waters. He restores my soul...',
          'assets/images/devotional.jpg',
        ),

        const SizedBox(height: 24),

        _buildReadingCard(
          'Weekly Scripture',
          'Week of May 12-18',
          'John 3:16-17',
          'For God so loved the world, that he gave his only Son, that whoever believes in him should not perish but have eternal life...',
          'assets/images/scripture.jpg',
        ),

        const SizedBox(height: 36),

        Text('Church Publications', style: sectionHeaderStyle),
        const SizedBox(height: 24),

        // Publication cards
        _buildPublicationCard(
          'Monthly Newsletter',
          'May 2025',
          'Updates on church activities, upcoming events, and community outreach programs.',
          'assets/images/newsletter.jpg',
        ),

        const SizedBox(height: 24),

        _buildPublicationCard(
          'Sermon Notes',
          'Last Sunday\'s Message',
          'Notes from Pastor\'s sermon on "Faith in Action" with key points and scripture references.',
          'assets/images/sermon_notes.jpg',
        ),
      ],
    );
  }

  Widget _buildReadingCard(
    String title,
    String date,
    String verse,
    String content,
    String imagePath,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF002642),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          // Added subtle shadow
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reading image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              imagePath,
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 110,
                  width: double.infinity,
                  color: Colors.grey[800],
                  child: const Icon(
                    Icons.menu_book,
                    color: Colors.white54,
                    size: 40,
                  ),
                );
              },
            ),
          ),

          // Reading details
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF3E9BFF),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  verse,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                // Read more button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Show reading details
                        _showReadingDetails(
                          title,
                          date,
                          verse,
                          content,
                          imagePath,
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF3E9BFF),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ), // Added padding
                      ),
                      child: const Text(
                        'Read More',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublicationCard(
    String title,
    String subtitle,
    String description,
    String imagePath,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF002642),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Publication image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.asset(
              imagePath,
              height: 120,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  width: 100,
                  color: Colors.grey[800],
                  child: const Icon(
                    Icons.description,
                    color: Colors.white54,
                    size: 40,
                  ),
                );
              },
            ),
          ),

          // Publication details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF3E9BFF),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReadingDetails(
    String title,
    String date,
    String verse,
    String content,
    String imagePath,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF002642),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reading image
                  Image.asset(
                    imagePath,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.menu_book,
                          color: Colors.white54,
                          size: 50,
                        ),
                      );
                    },
                  ),

                  // Reading details
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Color(0xFF3E9BFF),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          date,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          verse,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          content,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildReadingActionButton(
                              Icons.bookmark_border,
                              'Save',
                            ),
                            _buildReadingActionButton(Icons.share, 'Share'),
                            _buildReadingActionButton(
                              Icons.format_quote,
                              'Highlight',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildReadingActionButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  // Add these helper methods for the new UI components
  Widget _buildDotIndicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? const Color(0xFF3E9BFF) : Colors.grey[300],
      ),
    );
  }

  Widget _buildBulletinBoard(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 16,
      ), // Increased padding
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3E9BFF), Color(0xFF0277BD)],
        ),
        borderRadius: BorderRadius.circular(16), // Increased radius
        boxShadow: [
          // Added subtle shadow
          BoxShadow(
            color: const Color(0xFF3E9BFF).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 36), // Increased icon size
          const SizedBox(height: 12), // Increased spacing
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14, // Increased font size
              fontWeight: FontWeight.bold,
              height: 1.2, // Added line height
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    String title,
    String subtitle,
    String dateTime,
    String imagePath,
    IconData fallbackIcon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), // Added margin
      decoration: BoxDecoration(
        color: const Color(0xFF002642),
        borderRadius: BorderRadius.circular(16), // Increased radius
        boxShadow: [
          // Added subtle shadow
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Green indicator bar
          Container(
            width: 6, // Slightly wider
            height: 100, // Increased height
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Service image
          Padding(
            padding: const EdgeInsets.all(16.0), // Increased padding
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12), // Increased radius
              child: Image.asset(
                imagePath,
                width: 64, // Increased size
                height: 64, // Increased size
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 64,
                    height: 64,
                    color: Colors.grey[800],
                    child: Icon(
                      fallbackIcon,
                      color: Colors.white54,
                      size: 32, // Increased size
                    ),
                  );
                },
              ),
            ),
          ),

          // Service details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18, // Increased font size
                    fontWeight: FontWeight.bold,
                    height: 1.2, // Added line height
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16, // Increased font size
                    height: 1.2, // Added line height
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Colors.white54,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      dateTime,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                        height: 1.2, // Added line height
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // More options button
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white54,
              size: 24, // Increased size
            ),
            onPressed: () {
              // Show options menu
            },
          ),
        ],
      ),
    );
  }

  // Add this method to build the event card for the second design
  Widget _buildEventCard(
    String title,
    String subtitle,
    String description,
    String dateTime,
    String imagePath,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF002642),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Green indicator bar
          Container(
            width: 4,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Event details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF3E9BFF),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Colors.white54,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        dateTime,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // Event image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: Image.asset(
              imagePath,
              width: 150,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 150,
                  height: 200,
                  color: Colors.grey[800],
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.white54,
                    size: 40,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Add this method to build the service card for the third design
  Widget _buildUpcomingServiceCard(
    String title,
    String time,
    String imagePath,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF002642),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 150,
                  color: Colors.grey[800],
                  child: const Icon(
                    Icons.church,
                    color: Colors.white54,
                    size: 50,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Update the _buildActionButton method to handle filter selection
  Widget _buildActionButton(
    IconData icon,
    String label,
    Color color, {
    HomeFilter? filter,
  }) {
    final bool isSelected = filter != null && _currentFilter == filter;

    return GestureDetector(
      onTap: () {
        if (filter != null) {
          setState(() {
            _currentFilter = filter;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ), // Increased from 16, 12
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3E9BFF) : const Color(0xFF002642),
          borderRadius: BorderRadius.circular(28), // Increased from 24
          border: Border.all(color: const Color(0xFF0A3A5A)),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF3E9BFF),
              size: 24, // Increased from 20
            ),
            const SizedBox(width: 12), // Increased from 8
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16, // Increased from 14
                fontWeight: FontWeight.w500,
              ),
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
                isSelected: _currentView != AppView.profile,
                onTap: () {
                  if (_currentView != AppView.home) {
                    _navigateTo(AppView.home);
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
                isSelected: _currentView == AppView.profile,
                onTap: () {
                  _navigateTo(AppView.profile);
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
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Image.asset(
          iconPath,
          width: 32, // Increased size
          height: 32, // Increased size
          color: isSelected ? const Color(0xFF3E9BFF) : Colors.white,
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
          ),
        ),
      ),
    );
  }

  // Remove these methods from the _HomePageState class
  // void _navigateToAppointmentScreen() { ... }
  // void _navigateToEventsScreen() { ... }
  // void _navigateToReadingScreen() { ... }

  Widget _buildTeleoCard(
    String buttonText,
    String title,
    String description,
    int cardIndex,
    VoidCallback onTap, {
    String? customLogoUrl,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: const Color(0xFF001A33),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF0A3A5A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section with logo and button
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border.all(color: const Color(0xFF0A3A5A), width: 1),
            ),
            child: Stack(
              children: [
                // Logo in center
                if (customLogoUrl != null)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        customLogoUrl,
                        width: 200,
                        height: 100,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: Color(0xFF001A33),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.church,
                              color: Colors.white,
                              size: 40,
                            ),
                          );
                        },
                      ),
                    ),
                  )
                else
                  Center(
                    child: Image.asset(
                      'assets/images/teleo_logo.png',
                      width: 80,
                      height: 80,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: Color(0xFF001A33),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.church,
                            color: Colors.white,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                // Button in top left
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF001A33),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF3E9BFF),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),

          // Dots at bottom
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            index == cardIndex % 5
                                ? Colors.white
                                : Colors.white.withOpacity(0.3),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Add this helper method to the _HomePageState class
  // Add it near the other helper methods like _buildTeleoCard

  Widget _buildServiceCardItem(
    String title,
    String description,
    String imagePath,
    String buttonText,
    VoidCallback onPressed,
  ) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF001A33),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF0A3A5A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              imagePath,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  width: double.infinity,
                  color: Colors.grey[800],
                  child: Icon(
                    title == 'Baptism'
                        ? Icons.water_drop
                        : title == 'Funerals'
                        ? Icons.church
                        : title == 'Youth'
                        ? Icons.people
                        : title == 'Outreach'
                        ? Icons.volunteer_activism
                        : Icons.favorite,
                    color: Colors.white54,
                    size: 40,
                  ),
                );
              },
            ),
          ),

          // Content section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E9BFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Remove the conflicting _buildServiceCard method that has the same parameter signature
  // as the one we're using for the services section
}

// Authenticator View
class AuthenticatorView extends StatefulWidget {
  final AuthenticatorFlow flow;
  final VoidCallback onSuccess;

  const AuthenticatorView({
    super.key,
    required this.flow,
    required this.onSuccess,
  });

  @override
  State<AuthenticatorView> createState() => _AuthenticatorViewState();
}

class _AuthenticatorViewState extends State<AuthenticatorView> {
  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  bool _isVerifying = false;
  String? _errorMessage;
  int _resendSeconds = 299;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendSeconds > 0) {
          _resendSeconds--;
        } else {
          _resendTimer?.cancel();
        }
      });
    });
  }

  void _resendCode() {
    setState(() {
      _resendSeconds = 299;
      _errorMessage = null;
    });

    _startResendTimer();

    // Clear all fields
    for (var controller in _codeControllers) {
      controller.clear();
    }

    // Focus on first field
    _focusNodes[0].requestFocus();

    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Verification code resent'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _verifyCode() {
    // Get the full code
    final code = _codeControllers.map((c) => c.text).join();

    // Check if code is complete
    if (code.length != 6) {
      setState(() {
        _errorMessage = 'Please enter the complete 6-digit code';
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    // Simulate verification
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isVerifying = false;
      });

      // For demo purposes, any code is valid
      widget.onSuccess();
    });
  }

  String _getPromptText() {
    switch (widget.flow) {
      case AuthenticatorFlow.email:
        return 'Enter the six-digit code sent to your old email.';
      case AuthenticatorFlow.password:
        return 'Enter the six-digit code sent to your email.';
      case AuthenticatorFlow.phone:
        return 'Enter the six-digit code sent to your email.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

          // Header
          const Text(
            'Security',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
            '@juandelacruz',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 30),

          // Prompt text
          Text(
            _getPromptText(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30),

          // Code input fields
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              return Container(
                width: 45,
                height: 55,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  controller: _codeControllers[index],
                  focusNode: _focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    if (value.isNotEmpty && index < 5) {
                      _focusNodes[index + 1].requestFocus();
                    }

                    // Check if all fields are filled
                    if (_codeControllers.every(
                      (controller) => controller.text.isNotEmpty,
                    )) {
                      _verifyCode();
                    }
                  },
                ),
              );
            }),
          ),

          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),

          const SizedBox(height: 30),

          // Confirm button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isVerifying ? null : _verifyCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC62828), // Red color
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
                        'Confirm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
            ),
          ),

          const SizedBox(height: 20),

          // Resend code
          TextButton(
            onPressed: _resendSeconds == 0 ? _resendCode : null,
            child: Text(
              _resendSeconds > 0
                  ? 'Resend code in ${_resendSeconds}s'
                  : 'Resend code',
              style: TextStyle(
                color: _resendSeconds > 0 ? Colors.grey : Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  final Function(AppView) onNavigate;
  final UserData userData;

  const AppDrawer({
    super.key,
    required this.onNavigate,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF001A33),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 36, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Large avatar with border
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 2),
                      color: Colors.white24,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white54,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Guest',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
            // Main menu items
            _buildDrawerMenuItem(context, Icons.person_outline, 'Profile', () {
              Navigator.pop(context);
              onNavigate(AppView.profile);
            }),
            _buildDrawerMenuItem(context, Icons.inbox_outlined, 'Inbox', () {
              Navigator.pop(context);
            }),
            _buildDrawerMenuItem(
              context,
              Icons.volunteer_activism,
              'Donate',
              () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DonateScreen()),
                );
              },
            ),
            _buildDrawerMenuItem(
              context,
              Icons.settings_outlined,
              'Settings',
              () {
                Navigator.pop(context);
                onNavigate(AppView.settings);
              },
            ),
            // Subtle divider
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Divider(color: Colors.white24, thickness: 1),
            ),
            // Secondary menu items (no icons)
            _buildDrawerSecondaryItem(context, 'App Guide'),
            _buildDrawerSecondaryItem(
              context,
              'FAQs',
              onTap: () {
                Navigator.pop(context);
                onNavigate(AppView.faqs);
              },
            ),
            _buildDrawerSecondaryItem(
              context,
              'Contact Us',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactUsScreen(),
                  ),
                );
              },
            ),
            const Spacer(),
            // Log Out button at the bottom right, visually separated
            Padding(
              padding: const EdgeInsets.only(right: 24, bottom: 32, top: 8),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/', (route) => false);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Log Out',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.logout, color: Colors.red, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 22),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerSecondaryItem(
    BuildContext context,
    String title, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 32.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

// Settings View - Updated to include Report an Issue
class SettingsView extends StatelessWidget {
  final Function(AppView) onNavigate;

  const SettingsView({super.key, required this.onNavigate});

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
              '@juandelacruz',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Settings menu items
            _buildSettingsItem(
              context,
              Icons.person,
              'Your Account',
              'Edit your account information',
              onTap: () => onNavigate(AppView.accountSettings),
            ),
            _buildSettingsItem(
              context,
              Icons.security,
              'Security and Account Access',
              'Manage your account\'s security',
              onTap: () => onNavigate(AppView.securitySettings),
            ),
            _buildSettingsItem(
              context,
              Icons.notifications,
              'Manage Notifications',
              'Manage notifications received',
            ),
            // Add the Report an Issue option here
            _buildSettingsItem(
              context,
              Icons.warning_outlined, // Using warning icon to match the image
              'Report an Issue',
              'Report issues',
              onTap: () => onNavigate(AppView.report), // Navigate to report
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

// Profile View
class ProfileView extends StatefulWidget {
  final UserData userData;
  final Function(UserData) onUpdateUserData;

  const ProfileView({
    super.key,
    required this.userData,
    required this.onUpdateUserData,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _isEditing = false;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _pronounsController;
  late TextEditingController _birthdateController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _firstNameController = TextEditingController(
      text: widget.userData.firstName,
    );
    _lastNameController = TextEditingController(text: widget.userData.lastName);
    _pronounsController = TextEditingController(text: widget.userData.pronouns);
    _birthdateController = TextEditingController(
      text: widget.userData.birthdate,
    );
    _emailController = TextEditingController(text: widget.userData.email);
    _phoneController = TextEditingController(text: widget.userData.phoneNumber);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _pronounsController.dispose();
    _birthdateController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      if (_isEditing) {
        // Save changes
        final updatedUserData = UserData(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          pronouns: _pronounsController.text,
          birthdate: _birthdateController.text,
          email: _emailController.text,
          phoneNumber: _phoneController.text,
          username: widget.userData.username,
          password: widget.userData.password,
        );
        widget.onUpdateUserData(updatedUserData);
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
                  height: 160, // Increased height
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage(
                        'assets/images/church_interior.jpg',
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.6), // Darkened overlay
                        BlendMode.darken,
                      ),
                    ),
                  ),
                ),

                // Profile info
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    24,
                    80,
                    24,
                    0,
                  ), // Increased padding
                  child: Column(
                    children: [
                      // Profile picture
                      Stack(
                        children: [
                          Container(
                            width: 120, // Increased size
                            height: 120, // Increased size
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF001A33),
                                width: 4,
                              ),
                              boxShadow: [
                                // Added subtle shadow
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              image: const DecorationImage(
                                image: AssetImage('assets/images/profile.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ), // Increased padding
                              decoration: BoxDecoration(
                                color: const Color(0xFF3E9BFF),
                                borderRadius: BorderRadius.circular(
                                  16,
                                ), // Increased radius
                                boxShadow: [
                                  // Added subtle shadow
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'Church Member',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12, // Increased font size
                                  fontWeight: FontWeight.bold,
                                  height: 1.2, // Added line height
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20), // Increased spacing
                      // Name
                      Text(
                        '${widget.userData.firstName} ${widget.userData.lastName}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28, // Increased font size
                          fontWeight: FontWeight.bold,
                          height: 1.2, // Added line height
                        ),
                      ),

                      const SizedBox(height: 12), // Increased spacing
                      // Pronouns and birthdate
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ), // Increased padding
                            decoration: BoxDecoration(
                              color: const Color(0xFF002642),
                              borderRadius: BorderRadius.circular(
                                20,
                              ), // Increased radius
                              boxShadow: [
                                // Added subtle shadow
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              widget.userData.pronouns,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16, // Increased font size
                                height: 1.2, // Added line height
                              ),
                            ),
                          ),
                          const SizedBox(width: 16), // Increased spacing
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ), // Increased padding
                            decoration: BoxDecoration(
                              color: const Color(0xFF002642),
                              borderRadius: BorderRadius.circular(
                                20,
                              ), // Increased radius
                              boxShadow: [
                                // Added subtle shadow
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.cake,
                                  color: Colors.white70,
                                  size: 18, // Increased size
                                ),
                                const SizedBox(width: 8), // Increased spacing
                                Text(
                                  widget.userData.birthdate,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16, // Increased font size
                                    height: 1.2, // Added line height
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

            const SizedBox(height: 32), // Increased spacing
            // Services & Events section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Services & Events',
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
                  // Booked Services
                  const Expanded(
                    child: Column(
                      children: [
                        Text(
                          '249',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Booked Services',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  Container(height: 40, width: 1, color: Colors.white24),

                  // Events Attended
                  const Expanded(
                    child: Column(
                      children: [
                        Text(
                          '7,265',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Events Attended',
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

            // Tabs
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Booking History',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(height: 3, color: Colors.white),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Events Attended',
                        style: TextStyle(color: Colors.white60, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Container(height: 3, color: Colors.transparent),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Booking history list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildBookingHistoryItem(
                    'Funeral Service',
                    'April 18, 2025',
                    '9:30 AM',
                  ),
                  _buildBookingHistoryItem(
                    'Wedding Service',
                    'April 2, 2025',
                    '9:30 AM',
                  ),
                  _buildBookingHistoryItem(
                    'Funeral Service',
                    'March 15, 2025',
                    '9:30 AM',
                  ),
                  _buildBookingHistoryItem(
                    'Wedding Service',
                    'March 2, 2025',
                    '9:30 AM',
                  ),
                  _buildBookingHistoryItem(
                    'Funeral Service',
                    'February 15, 2025',
                    '9:30 AM',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const SizedBox(height: 80), // Extra space for bottom nav bar
          ],
        ),
      ),
    );
  }

  Widget _buildBookingHistoryItem(String title, String date, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF001A33),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.grey,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Scheduled: $date - $time',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Color(0xFF001A33)),
        ],
      ),
    );
  }
}

// Account Settings View
class AccountSettingsView extends StatefulWidget {
  final UserData userData;
  final Function(UserData) onUpdateUserData;

  const AccountSettingsView({
    super.key,
    required this.userData,
    required this.onUpdateUserData,
  });

  @override
  State<AccountSettingsView> createState() => _AccountSettingsViewState();
}

class _AccountSettingsViewState extends State<AccountSettingsView> {
  bool _isEditing = false;
  late TextEditingController _usernameController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _pronounsController;
  late TextEditingController _birthdateController;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _usernameController = TextEditingController(text: widget.userData.username);
    _firstNameController = TextEditingController(
      text: widget.userData.firstName,
    );
    _lastNameController = TextEditingController(text: widget.userData.lastName);
    _pronounsController = TextEditingController(text: widget.userData.pronouns);
    _birthdateController = TextEditingController(
      text: widget.userData.birthdate,
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _pronounsController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      if (_isEditing) {
        // Save changes
        final updatedUserData = UserData(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          pronouns: _pronounsController.text,
          birthdate: _birthdateController.text,
          email: widget.userData.email,
          phoneNumber: widget.userData.phoneNumber,
          username: _usernameController.text,
          password: widget.userData.password,
        );
        widget.onUpdateUserData(updatedUserData);
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
              widget.userData.username,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Form fields
            _isEditing
                ? _buildEditableField('Username', _usernameController)
                : _buildSettingsField('Username', widget.userData.username),

            _isEditing
                ? _buildEditableField('First Name', _firstNameController)
                : _buildSettingsField('First Name', widget.userData.firstName),

            _isEditing
                ? _buildEditableField('Last Name', _lastNameController)
                : _buildSettingsField('Last Name', widget.userData.lastName),

            _isEditing
                ? _buildEditableField('Pronouns', _pronounsController)
                : _buildSettingsField('Pronouns', widget.userData.pronouns),

            _isEditing
                ? _buildEditableField('Birthdate', _birthdateController)
                : _buildSettingsField('Birthdate', widget.userData.birthdate),

            const SizedBox(height: 30),

            // Security settings button
            TextButton(
              onPressed: () {
                // Navigate to security settings
                final homePageState =
                    context.findAncestorStateOfType<_HomePageState>();
                homePageState?._navigateTo(AppView.securitySettings);
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

// Security Settings View
class SecuritySettingsView extends StatefulWidget {
  final UserData userData;
  final Function(UserData) onUpdateUserData;
  final Function(AppView) onNavigate;

  const SecuritySettingsView({
    super.key,
    required this.userData,
    required this.onUpdateUserData,
    required this.onNavigate,
  });

  @override
  State<SecuritySettingsView> createState() => _SecuritySettingsViewState();
}

class _SecuritySettingsViewState extends State<SecuritySettingsView> {
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
              widget.userData.username,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Security options
            _buildSecurityOption(
              context,
              Icons.email,
              'Change Email',
              'Update your email address',
              onTap: () => widget.onNavigate(AppView.changeEmail),
            ),

            _buildSecurityOption(
              context,
              Icons.lock,
              'Change Password',
              'Update your password',
              onTap: () => widget.onNavigate(AppView.changePassword),
            ),

            _buildSecurityOption(
              context,
              Icons.phone,
              'Change Phone Number',
              'Update your phone number',
              onTap: () => widget.onNavigate(AppView.changePhone),
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
                  _buildInfoRow('Email', widget.userData.email),
                  const SizedBox(height: 8),
                  _buildInfoRow('Phone', widget.userData.phoneNumber),
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
                widget.onNavigate(AppView.accountSettings);
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
class ChangeEmailView extends StatefulWidget {
  final UserData userData;
  final Function(AppView, {AuthenticatorFlow? flow, String? newValue})
  onNavigate;

  const ChangeEmailView({
    super.key,
    required this.userData,
    required this.onNavigate,
  });

  @override
  State<ChangeEmailView> createState() => _ChangeEmailViewState();
}

class _ChangeEmailViewState extends State<ChangeEmailView> {
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
      text: widget.userData.email,
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

      if (_newEmailController.text == widget.userData.email) {
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
      AppView.authenticator,
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
                        widget.onNavigate(AppView.securitySettings);
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
class ChangePasswordView extends StatefulWidget {
  final UserData userData;
  final Function(AppView, {AuthenticatorFlow? flow, String? newValue})
  onNavigate;

  const ChangePasswordView({
    super.key,
    required this.userData,
    required this.onNavigate,
  });

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
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
    _emailController = TextEditingController(text: widget.userData.email);
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
        if (_emailController.text == widget.userData.email) {
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
                horizontal: 8.0,
                vertical: 8.0,
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
    final phoneRegex = RegExp(r'^[0-9]{11}$');

    setState(() {
      if (_newPasswordController.text.isEmpty) {
        _errorMessage = 'Please enter a new password';
        return;
      }

      if (_newPasswordController.text.length < 8) {
        _errorMessage = 'Password must be at least 8 characters';
        return;
      }

      if (_newPasswordController.text == widget.userData.password) {
        _errorMessage = 'New password must be different from current password';
        return;
      }

      if (_newPasswordController.text != _confirmPasswordController.text) {
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
      AppView.authenticator,
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

              // Current email (read-only)
              _buildField('Current Email', _emailController, readOnly: true),

              // Password verification section
              if (!_isVerified) ...[
                _buildField(
                  'Enter Password to Continue',
                  _currentPasswordController,
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

              // New email fields (only shown after password verification)
              if (_isVerified) ...[
                _buildField(
                  'New Password',
                  _newPasswordController,
                  isPassword: true,
                  errorText:
                      _newPasswordController.text.isNotEmpty &&
                              !RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$',
                              ).hasMatch(_newPasswordController.text)
                          ? 'Please enter a valid password'
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
                        widget.onNavigate(AppView.securitySettings);
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
class ChangePhoneView extends StatefulWidget {
  final UserData userData;
  final Function(AppView, {AuthenticatorFlow? flow, String? newValue})
  onNavigate;

  const ChangePhoneView({
    super.key,
    required this.userData,
    required this.onNavigate,
  });

  @override
  State<ChangePhoneView> createState() => ChangePhoneViewState();
}

// Add this class implementation to fix the ChangePhoneViewState error

class ChangePhoneViewState extends State<ChangePhoneView> {
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
      text: widget.userData.phoneNumber,
    );
    _newPhoneController = TextEditingController();
    _emailController = TextEditingController(text: widget.userData.email);
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
        if (_emailController.text == widget.userData.email) {
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

      if (_newPhoneController.text == widget.userData.phoneNumber) {
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
      AppView.authenticator,
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
                        widget.onNavigate(AppView.securitySettings);
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
