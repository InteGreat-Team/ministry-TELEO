// lib/landing_page/frontend/CHURCH_LANDING_PAGE.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../backend/viewmodels/church_homepage_viewmodel.dart'; // Adjust import path if necessary
import '../../models/admin_models.dart'; // Import AdminView, AuthenticatorFlow, AdminData
import '../../sidebar/frontend/CHURCH_SIDE_BAR.dart'; // Import the sidebar
import '../../sidebar/frontend/profile/CHURCH_HOMEPAGE_PROFILE.dart'; // Import profile screen
import '../../sidebar/frontend/settings/homepage_settings/CHURCH_HOMEPAGE_SETTINGS.dart'; // Import settings screen
import '../../sidebar/frontend/report_screen/CHURCH_REPORT_SCREEN.dart'; // Import report screen
import '../../sidebar/frontend/settings/account_settings/CHURCH_ACCOUNT_SETTINGS.dart'; // Import account settings
import '../../sidebar/frontend/settings/security_settings/CHURCH_SECURITY_SETTINGS.dart'; // Import security settings
import '../../sidebar/frontend/settings/change_email_setting/CHURCH_CHANGE_EMAIL_SETTING.dart'; // Import change email
import '../../sidebar/frontend/settings/change_password_setting/CHURCH_CHANGE_PASSWORD_SETTING.dart'; // Import change password
import '../../sidebar/frontend/settings/change_phone_setting/CHURCH_CHANGE_PHONE_SETTING.dart'; // Import change phone
import '../../sidebar/frontend/settings/notifications_setting/CHURCH_NOTIFICATIONS_SETTING.dart'; // Import notifications
import '../../sidebar/frontend/settings/mass_schedule_setting/CHURCH_MASS_SCHEDULE_SETTING.dart'; // Import mass schedule
import '../../sidebar/frontend/settings/tnc_setting/CHURCH_TNC_SETTING.dart'; // Import TNC
import '../../sidebar/frontend/faqs_screen/CHURCH_FAQS_SCREEN.dart'; // Updated import
import '../../sidebar/frontend/CHURCH_CONTACT_US.dart'; // Import contact us screen
import '../../3/c1widgets/authenticator_screen.dart';
import '../../1/c1homepage/donate_screen.dart';
import 'components/landing_page_components.dart'; // Consolidated components
import '../../3/nav_bar.dart'; // Assuming this path is correct for the existing nav_bar
import '../../2/c2homepage/schedule_tab.dart' as admin_home;
import '../../sidebar/frontend/widgets/chart_painters.dart'; // Import the new chart painters

class ChurchLandingPage extends StatefulWidget {
  const ChurchLandingPage({super.key});

  @override
  State<ChurchLandingPage> createState() => _ChurchLandingPageState();
}

class _ChurchLandingPageState extends State<ChurchLandingPage> {
  AdminView _currentView = AdminView.home;
  AdminData _adminData = AdminData(
    churchName: "Our Lady of Perpetual Help",
    location: "123 Divine Street, Grace City",
    description: "A community dedicated to faith, hope, and charity.",
    schedule: "Mon-Fri: 8 AM - 5 PM, Sat: 9 AM - 12 PM, Sun: 7 AM - 6 PM",
    gcash: "09171234567",
    maya: "09187654321",
    bdo: "001234567890",
    bpi: "009876543210",
    currentEmail: "admin@church.com",
    currentPhoneNumber: "09171234567",
  );

  void _onNavigate(AdminView view, {AuthenticatorFlow? flow, String? newValue}) {
    setState(() {
      _currentView = view;
      // Handle specific navigation flows if needed, e.g., for authenticator
      if (view == AdminView.authenticator) {
        // You would typically pass flow and newValue to the authenticator screen
        // For now, we'll just show a snackbar
        String message = 'Navigating to Authenticator for ';
        if (flow == AuthenticatorFlow.email) {
          message += 'email change to $newValue';
        } else if (flow == AuthenticatorFlow.password) {
          message += 'password change';
        } else if (flow == AuthenticatorFlow.phone) {
          message += 'phone change to $newValue';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        // After authentication, you might navigate back or update data
        // For simplicity, we'll just go back to security settings after a delay
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _currentView = AdminView.securitySettings;
            // In a real app, you'd update the actual email/phone/password here
            if (flow == AuthenticatorFlow.email && newValue != null) {
              _adminData = _adminData.copyWith(currentEmail: newValue);
            } else if (flow == AuthenticatorFlow.phone && newValue != null) {
              _adminData = _adminData.copyWith(currentPhoneNumber: newValue);
            }
          });
        });
      }
    });
  }

  void _onUpdateAdminData(AdminData updatedData) {
    setState(() {
      _adminData = updatedData;
    });
  }

  Widget _buildBody() {
    switch (_currentView) {
      case AdminView.home:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to the Dashboard!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Text(
                'Church Name: ${_adminData.churchName}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'Location: ${_adminData.location}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _onNavigate(AdminView.profile),
                child: const Text('Go to Profile'),
              ),
              ElevatedButton(
                onPressed: () => _onNavigate(AdminView.settings),
                child: const Text('Go to Settings'),
              ),
              ElevatedButton(
                onPressed: () => _onNavigate(AdminView.reportIssue),
                child: const Text('Go to Reports'),
              ),
            ],
          ),
        );
      case AdminView.profile:
        return ChurchHomepageProfile(
          adminData: _adminData,
          onUpdateAdminData: _onUpdateAdminData,
        );
      case AdminView.settings:
        return ChurchHomepageSettings(
          adminData: _adminData,
          onUpdateAdminData: _onUpdateAdminData,
          onNavigate: _onNavigate,
        );
      case AdminView.reportIssue:
        return ChurchReportScreen(onNavigate: _onNavigate);
      case AdminView.accountSettings:
        return ChurchAccountSettings(
          adminData: _adminData,
          onUpdateAdminData: _onUpdateAdminData,
        );
      case AdminView.securitySettings:
        return ChurchSecuritySettings(
          adminData: _adminData,
          onNavigate: _onNavigate,
        );
      case AdminView.changeEmail:
        return ChurchChangeEmailSetting(
          adminData: _adminData,
          onNavigate: _onNavigate,
        );
      case AdminView.changePassword:
        return ChurchChangePasswordSetting(
          adminData: _adminData,
          onNavigate: _onNavigate,
        );
      case AdminView.changePhone:
        return ChurchChangePhoneSetting(
          adminData: _adminData,
          onNavigate: _onNavigate,
        );
      case AdminView.notificationSettings:
        return ChurchNotificationSetting(
          onNavigate: (view) => _onNavigate(view),
        );
      case AdminView.massSchedule:
        return ChurchMassScheduleSetting(
          onNavigate: (view) => _onNavigate(view),
        );
      case AdminView.termsConditions:
        return ChurchTncSetting(
          onNavigate: (view) => _onNavigate(view),
        );
      case AdminView.authenticator:
      // This would be your actual authenticator screen
        return Center(
          child: Text(
            'Authenticator Screen (Simulated)',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        );
      case AdminView.faqs:
        return CHURCH_FAQS_SCREEN(onNavigate: _onNavigate);
      case AdminView.contactUs:
        return ChurchContactUsScreen(onNavigate: _onNavigate);
      case AdminView.donate:
        return const DonateScreen();
      case AdminView.dashboard:
        return const admin_home.ScheduleTab();
      default:
        return Center(child: Text('Unknown View: $_currentView'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChurchHomePageViewModel(onNavigate: _onNavigate),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Provider.of<ChurchHomePageViewModel>(context).currentTitle,
          ),
        ),
        drawer: ChurchSideBar(onNavigate: _onNavigate),
        body: _buildBody(),
        bottomNavigationBar: NavBar(
          selectedIndex: Provider.of<ChurchHomePageViewModel>(context)
              .navBarIndexForView(_currentView),
          onItemSelected: (index) {
            Provider.of<ChurchHomePageViewModel>(context, listen: false)
                .navigateTo(
                    Provider.of<ChurchHomePageViewModel>(context, listen: false)
                        .viewForNavBarIndex(index));
          },
        ),
      ),
    );
  }
}
