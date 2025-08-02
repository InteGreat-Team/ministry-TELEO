// lib/sidebar/frontend/CHURCH_SIDE_BAR.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../backend/church_side_bar_viewmodel.dart';
import '../../models/admin_models.dart'; // Import AdminView
import 'package:ministry_teleo/2/c1homepage/sidebar/frontend/profile/CHURCH_HOMEPAGE_PROFILE.dart';
import 'package:ministry_teleo/2/c1homepage/sidebar/frontend/settings/CHURCH_HOMEPAGE_SETTINGS.dart';
import 'package:ministry_teleo/2/c1homepage/sidebar/frontend/CHURCH_CONTACT_US.dart';
import 'package:ministry_teleo/3/welcome_screen.dart';
import 'package:ministry_teleo/2/c1homepage/landing_page/frontend/CHURCH_LANDING_PAGE.dart';
import 'package:ministry_teleo/2/c1homepage/landing_page/backend/church_landing_page_viewmodel.dart';

class ChurchSideBar extends StatelessWidget {
  final AdminData adminData;
  final void Function(AdminData) onUpdateAdminData;

  const ChurchSideBar({
    Key? key,
    required this.adminData,
    required this.onUpdateAdminData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChurchSideBarViewModel(
        adminData: adminData,
        onUpdateAdminData: onUpdateAdminData,
        onNavigate: (view,
            {flow, newValue}) {}, // Match the correct function signature
      ),
      child: Consumer<ChurchSideBarViewModel>(
        builder: (context, viewModel, child) {
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.church, size: 30, color: Colors.blue),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Church Admin',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.dashboard),
                  title: const Text('Dashboard'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (_) => ChurchHomePageViewModel(
                            adminData: adminData,
                            onNavigate: (view, {flow, newValue}) {},
                          ),
                          child: ChurchLandingPage(),
                        ),
                      ),
                      (route) => false,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChurchHomepageProfile(
                          adminData: adminData,
                          onUpdateAdminData: onUpdateAdminData,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChurchHomepageSettings(
                          adminData: adminData,
                          onNavigate: (view, {flow, newValue}) => viewModel
                              .onNavigate(view, flow: flow, newValue: newValue),
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bar_chart),
                  title: const Text('Reports'),
                  onTap: () {
                    Navigator.pop(context);
                    viewModel.navigateToReportScreen();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.contact_support),
                  title: const Text('Contact Us'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChurchContactUs(), // Make sure ChurchContactUs is a defined widget in the imported file
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WelcomeScreen(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ChurchSideBarViewModel extends ChangeNotifier {
  final AdminData adminData;
  final void Function(AdminData) onUpdateAdminData;
  final void Function(dynamic view, {dynamic flow, dynamic newValue})
      onNavigate;

  ChurchSideBarViewModel({
    required this.adminData,
    required this.onUpdateAdminData,
    required this.onNavigate,
  });

  void navigateToDashboard() {
    onNavigate(AdminView.dashboard);
  }

  void navigateToReportScreen() {
    onNavigate(AdminView.reports);
  }
}
