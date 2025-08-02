// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teleo_app/sidebar/backend/church_side_bar_viewmodel.dart';
import 'package:teleo_app/sidebar/backend/profile/church_profile_viewmodel.dart';
import 'package:teleo_app/sidebar/backend/report_screen/church_report_screen_viewmodel.dart';
import 'package:teleo_app/sidebar/backend/settings/church_settings_viewmodel.dart';
import 'package:teleo_app/landing_page/backend/church_landing_page_viewmodel.dart';
import 'package:teleo_app/models/admin_models.dart';

// Import screens
import 'package:teleo_app/landing_page/frontend/CHURCH_LANDING_PAGE.dart';
import 'package:teleo_app/sidebar/frontend/profile/CHURCH_HOMEPAGE_PROFILE.dart';
import 'package:teleo_app/sidebar/frontend/settings/CHURCH_HOMEPAGE_SETTINGS.dart';
import 'package:teleo_app/sidebar/frontend/report_screen/CHURCH_REPORT_SCREEN.dart';
import 'package:teleo_app/sidebar/frontend/faqs_screen/CHURCH_FAQS_SCREEN.dart';
import 'package:teleo_app/sidebar/frontend/CHURCH_CONTACT_US.dart'; // Import the new contact us screen

// Settings sub-screens
import 'package:teleo_app/sidebar/frontend/settings/CHURCH_ACCOUNT_SETTINGS.dart';
import 'package:teleo_app/sidebar/frontend/settings/CHURCH_SECURITY_SETTINGS.dart';
import 'package:teleo_app/sidebar/frontend/settings/CHURCH_CHANGE_EMAIL_SETTING.dart';
import 'package:teleo_app/sidebar/frontend/settings/CHURCH_CHANGE_PASSWORD_SETTING.dart';
import 'package:teleo_app/sidebar/frontend/settings/CHURCH_CHANGE_PHONE_SETTING.dart';
import 'package:teleo_app/sidebar/frontend/settings/CHURCH_NOTIFICATIONS_SETTING.dart';
import 'package:teleo_app/sidebar/frontend/settings/CHURCH_MASS_SCHEDULE_SETTING.dart';
import 'package:teleo_app/sidebar/frontend/settings/CHURCH_TNC_SETTING.dart';

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

  void _navigateTo(AdminView view) {
    setState(() {
      _currentView = view;
    });
  }

  Widget _buildBody() {
    switch (_currentView) {
      case AdminView.home:
        return const ChurchLandingPage();
      case AdminView.profile:
        return const ChurchHomepageProfile();
      case AdminView.settings:
        return ChurchHomepageSettings(onNavigate: _navigateTo);
      case AdminView.reportIssue:
        return const ChurchReportScreen();
      case AdminView.faqs:
        return ChurchFAQsScreen(onNavigate: _navigateTo);
      case AdminView.contactUs:
        return ChurchContactUsScreen(onNavigate: _navigateTo);
      // Settings sub-screens
      case AdminView.accountSettings:
        return ChurchAccountSettings(onNavigate: _navigateTo);
      case AdminView.securitySettings:
        return ChurchSecuritySettings(onNavigate: _navigateTo);
      case AdminView.changeEmail:
        return ChurchChangeEmailSetting(onNavigate: _navigateTo);
      case AdminView.changePassword:
        return ChurchChangePasswordSetting(onNavigate: _navigateTo);
      case AdminView.changePhone:
        return ChurchChangePhoneSetting(onNavigate: _navigateTo);
      case AdminView.notificationSettings:
        return ChurchNotificationsSetting(onNavigate: _navigateTo);
      case AdminView.massSchedule:
        return ChurchMassScheduleSetting(onNavigate: _navigateTo);
      case AdminView.termsConditions:
        return ChurchTncSetting(onNavigate: _navigateTo);
      case AdminView.dashboard:
        return const ChurchLandingPage(); // Assuming dashboard is the same as home for now
      case AdminView.authenticator:
      // TODO: Implement Authenticator screen
        return const Center(child: Text('Authenticator Screen (TODO)'));
      case AdminView.donate:
      // TODO: Implement Donate screen
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
          create: (_) => ChurchProfileViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChurchReportScreenViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChurchSettingsViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChurchLandingPageViewModel(),
        ),
        // Add other ViewModels here as needed
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
              : null, // Hide AppBar for other screens if they have custom app bars
          drawer: ChurchSideBar(onNavigate: _navigateTo),
          body: _buildBody(),
        ),
      ),
    );
  }
}
