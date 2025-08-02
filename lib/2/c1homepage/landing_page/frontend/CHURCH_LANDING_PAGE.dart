// lib/landing_page/frontend/CHURCH_LANDING_PAGE.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../backend/church_landing_page_viewmodel.dart';
import '../../models/admin_models.dart';
import '../../sidebar/frontend/CHURCH_SIDE_BAR.dart';
import '../../sidebar/frontend/profile/CHURCH_HOMEPAGE_PROFILE.dart';
import '../../sidebar/frontend/settings/CHURCH_HOMEPAGE_SETTINGS.dart';
import '../../sidebar/frontend/report_screen/CHURCH_REPORT_SCREEN.dart';
import '../../sidebar/frontend/settings/CHURCH_ACCOUNT_SETTINGS.dart';
import '../../sidebar/frontend/settings/CHURCH_SECURITY_SETTINGS.dart';
import '../../sidebar/frontend/settings/CHURCH_CHANGE_EMAIL_SETTING.dart';
import '../../sidebar/frontend/settings/CHURCH_CHANGE_PASSWORD_SETTING.dart';
import '../../sidebar/frontend/settings/CHURCH_CHANGE_PHONE_SETTING.dart';
import '../../sidebar/frontend/settings/CHURCH_NOTIFICATIONS_SETTING.dart';
import '../../sidebar/frontend/settings/CHURCH_MASS_SCHEDULE_SETTING.dart';
import '../../sidebar/frontend/settings/CHURCH_TNC_SETTING.dart';
import '../../sidebar/frontend/faqs_screen/CHURCH_FAQS_SCREEN.dart';
import '../../sidebar/frontend/CHURCH_CONTACT_US.dart';
import 'package:ministry_teleo/widgets/nav_bar.dart';
// import '../../../3/c1widgets/authenticator_screen.dart'; // File not found, comment out or fix path if needed
// import '../../../1/c1homepage/donate_screen.dart'; // File not found, comment out or fix path if needed

class ChurchLandingPage extends StatelessWidget {
  const ChurchLandingPage({super.key});

  AdminView _viewForNavBarIndex(int index) {
    switch (index) {
      case 0:
        return AdminView.home;
      case 1:
        return AdminView.settings;
      case 2:
        return AdminView.reportIssue;
      case 3:
        return AdminView.accountSettings;
      case 4:
        return AdminView.profile;
      default:
        return AdminView.home;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChurchHomePageViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(viewModel.currentTitle ?? 'Teleo Admin'),
          ),
          drawer: ChurchSideBar(
            adminData: viewModel.adminData,
            onUpdateAdminData: viewModel.onUpdateAdminData ?? (adminData) {},
          ),
          body: _buildBody(context, viewModel),
          bottomNavigationBar: NavBar(
            currentIndex: viewModel.currentNavBarIndex,
            onTap: (index) {
              viewModel.onNavBarTap(_viewForNavBarIndex(index));
            },
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ChurchHomePageViewModel viewModel) {
    switch (viewModel.currentView) {
      case AdminView.events:
        return const Placeholder(
            fallbackHeight: 200, fallbackWidth: 200, color: Colors.blue);
      case AdminView.community:
        return const Placeholder(
            fallbackHeight: 200, fallbackWidth: 200, color: Colors.green);
      case AdminView.posts:
        return const Placeholder(
            fallbackHeight: 200, fallbackWidth: 200, color: Colors.orange);
      case AdminView.setRoles:
        return const Placeholder(
            fallbackHeight: 200, fallbackWidth: 200, color: Colors.purple);
      case AdminView.home:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome to the Dashboard!',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 20),
              Text('Church Name: ${viewModel.adminData.churchName}',
                  style: Theme.of(context).textTheme.titleLarge),
              Text('Location: ${viewModel.adminData.location}',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => viewModel.onNavigate(AdminView.profile),
                child: const Text('Go to Profile'),
              ),
              ElevatedButton(
                onPressed: () => viewModel.onNavigate(AdminView.settings),
                child: const Text('Go to Settings'),
              ),
              ElevatedButton(
                onPressed: () => viewModel.onNavigate(AdminView.reportIssue),
                child: const Text('Go to Reports'),
              ),
            ],
          ),
        );
      case AdminView.profile:
        return ChurchHomepageProfile(
          adminData: viewModel.adminData,
          onUpdateAdminData: viewModel.onUpdateAdminData ?? (adminData) {},
        );
      case AdminView.settings:
        return ChurchHomepageSettings(
          adminData: viewModel.adminData,
          onNavigate: viewModel.onNavigate,
        );
      case AdminView.reportIssue:
        return ChurchReportScreen(onNavigate: viewModel.onNavigate);
      case AdminView.accountSettings:
        return ChurchAccountSettings(
          adminData: viewModel.adminData,
          onUpdateAdminData: viewModel.onUpdateAdminData ?? (adminData) {},
        );
      case AdminView.securitySettings:
        return ChurchSecuritySettings(
          adminData: viewModel.adminData,
          onNavigate: viewModel.onNavigate,
        );
      case AdminView.changeEmail:
        return ChurchChangeEmailSetting(
          adminData: viewModel.adminData,
          onNavigate: viewModel.onNavigate,
        );
      case AdminView.changePassword:
        return ChurchChangePasswordSetting(
          adminData: viewModel.adminData,
          onNavigate: viewModel.onNavigate,
        );
      case AdminView.changePhone:
        return ChurchChangePhoneSetting(
          adminData: viewModel.adminData,
          onNavigate: viewModel.onNavigate,
        );
      case AdminView.notificationSettings:
        return ChurchNotificationSetting(
          onNavigate: viewModel.onNavigate,
        );
      case AdminView.massSchedule:
        return ChurchMassScheduleSetting(
          onNavigate: viewModel.onNavigate,
        );
      case AdminView.termsConditions:
        return ChurchTncSetting(
          onNavigate: viewModel.onNavigate,
        );
      case AdminView.authenticator:
        return Center(
          child: Text('Authenticator Screen (Simulated)',
              style: Theme.of(context).textTheme.headlineMedium),
        );
      case AdminView.faqs:
        return CHURCH_FAQS_SCREEN(onNavigate: viewModel.onNavigate);
      case AdminView.contactUs:
        return ChurchContactUsScreen(onNavigate: viewModel.onNavigate);
      case AdminView.donate:
        return const Placeholder(fallbackHeight: 200, fallbackWidth: 200);
      case AdminView.dashboard:
        return const Placeholder(fallbackHeight: 200, fallbackWidth: 200);
      default:
        return const Center(child: Text('Unknown View'));
    }
  }
}
