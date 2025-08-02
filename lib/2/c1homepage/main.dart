// lib/2/c1homepage/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sidebar/backend/church_side_bar_viewmodel.dart';
import 'sidebar/backend/profile/church_profile_viewmodel.dart'
    as backend_profile;
import 'sidebar/backend/report_screen/church_report_screen_viewmodel.dart';
import 'sidebar/backend/settings/church_settings_viewmodel.dart';
import 'landing_page/backend/church_landing_page_viewmodel.dart';
import 'models/admin_models.dart';

// Import screens
import 'landing_page/frontend/CHURCH_LANDING_PAGE.dart';
import 'sidebar/frontend/profile/CHURCH_HOMEPAGE_PROFILE.dart';
import 'sidebar/frontend/settings/CHURCH_HOMEPAGE_SETTINGS.dart';
import 'sidebar/frontend/report_screen/CHURCH_REPORT_SCREEN.dart';
import 'sidebar/frontend/faqs_screen/CHURCH_FAQS_SCREEN.dart';
import 'sidebar/frontend/CHURCH_CONTACT_US.dart';
import 'sidebar/frontend/CHURCH_SIDE_BAR.dart';

// Settings sub-screens
import 'sidebar/frontend/settings/CHURCH_ACCOUNT_SETTINGS.dart';
import 'sidebar/frontend/settings/CHURCH_SECURITY_SETTINGS.dart';
import 'sidebar/frontend/settings/CHURCH_CHANGE_EMAIL_SETTING.dart';
import 'sidebar/frontend/settings/CHURCH_CHANGE_PASSWORD_SETTING.dart';
import 'sidebar/frontend/settings/CHURCH_CHANGE_PHONE_SETTING.dart';
import 'sidebar/frontend/settings/CHURCH_NOTIFICATIONS_SETTING.dart';
import 'sidebar/frontend/settings/CHURCH_MASS_SCHEDULE_SETTING.dart';
import 'sidebar/frontend/settings/CHURCH_TNC_SETTING.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AdminView _currentView = AdminView.home;
  AdminData _adminData = AdminData(
    churchName: "Our Lady of Perpetual Help",
    posts: '0',
    following: '0',
    followers: '0',
    loginActivity: '0',
    loginActivityPercentage: '0%',
    dailyFollows: '0',
    dailyFollowsPercentage: '0%',
    dailyVisits: '0',
    dailyVisitsPercentage: '0%',
    bookings: '0',
    bookingsPercentage: '0%',
    currentEmail: "admin@church.com",
    currentPhoneNumber: "09171234567",
    password: '••••••••••••••••',
    location: "123 Divine Street, Grace City",
    description: "A community dedicated to faith, hope, and charity.",
    schedule: "Mon-Fri: 8 AM - 5 PM, Sat: 9 AM - 12 PM, Sun: 7 AM - 6 PM",
    gcash: "09171234567",
    maya: "09187654321",
    bdo: "001234567890",
    bpi: "009876543210",
  );

  void _onUpdateAdminData(AdminData updatedData) {
    setState(() {
      _adminData = updatedData;
    });
  }

  void _navigateTo(AdminView view,
      {AuthenticatorFlow? flow, String? newValue}) {
    setState(() {
      _currentView = view;
      // Optionally handle flow/newValue here
    });
  }

  Widget _buildBody() {
    switch (_currentView) {
      case AdminView.home:
        return ChurchLandingPage();
      case AdminView.profile:
        return ChurchHomepageProfile(
          adminData: _adminData,
          onUpdateAdminData: _onUpdateAdminData,
        );
      case AdminView.settings:
        return ChurchHomepageSettings(
          adminData: _adminData,
          onNavigate: _navigateTo,
        );
      case AdminView.reportIssue:
        return ChurchReportScreen(onNavigate: _navigateTo);
      case AdminView.faqs:
        return CHURCH_FAQS_SCREEN(onNavigate: _navigateTo);
      case AdminView.contactUs:
        return ChurchContactUsScreen(onNavigate: _navigateTo);
      // Settings sub-screens
      case AdminView.accountSettings:
        return ChurchAccountSettings(
          adminData: _adminData,
          onUpdateAdminData: _onUpdateAdminData,
        );
      case AdminView.securitySettings:
        return ChurchSecuritySettings(
          adminData: _adminData,
          onNavigate: _navigateTo,
        );
      case AdminView.changeEmail:
        return ChurchChangeEmailSetting(
          adminData: _adminData,
          onNavigate: _navigateTo,
        );
      case AdminView.changePassword:
        return ChurchChangePasswordSetting(
          adminData: _adminData,
          onNavigate: _navigateTo,
        );
      case AdminView.changePhone:
        return ChurchChangePhoneSetting(
          adminData: _adminData,
          onNavigate: _navigateTo,
        );
      case AdminView.notificationSettings:
        return ChurchNotificationSetting(
          onNavigate: _navigateTo,
        );
      case AdminView.massSchedule:
        return ChurchMassScheduleSetting(
          onNavigate: _navigateTo,
        );
      case AdminView.termsConditions:
        return ChurchTncSetting(
          onNavigate: _navigateTo,
        );
      case AdminView.dashboard:
        return ChurchLandingPage();
      case AdminView.authenticator:
        return const Center(child: Text('Authenticator Screen (TODO)'));
      case AdminView.donate:
        return const Center(child: Text('Donate Screen (TODO)'));
      default:
        return const Center(child: Text('Unknown View'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ChurchSideBarViewModel(onNavigate: _navigateTo),
        ),
        ChangeNotifierProvider(
          create: (_) => backend_profile.ChurchProfileViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChurchReportScreenViewModel(onNavigate: (view) {}),
        ),
        ChangeNotifierProvider(
          create: (_) => ChurchSettingsViewModel(
            adminData: _adminData,
            onNavigate: _navigateTo,
          ),
        ),
        // ChurchHomePageViewModel is only provided above ChurchLandingPage, not globally
      ],
      child: MaterialApp(
        title: 'Teleo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          appBar: _currentView == AdminView.home
              ? AppBar(
                  title: const Text('Teleo App'),
                  backgroundColor: Theme.of(context).primaryColor,
                )
              : null,
          drawer: ChurchSideBar(onNavigate: _navigateTo),
          body: _buildBody(),
        ),
      ),
    );
  }
}
