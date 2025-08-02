// lib/sidebar/frontend/CHURCH_SIDE_BAR.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../backend/viewmodels/church_side_bar_viewmodel.dart'; // Adjust import path if necessary
import '../../models/admin_models.dart'; // Import AdminView

class ChurchSideBar extends StatelessWidget {
  final void Function(AdminView) onNavigate;

  const ChurchSideBar({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChurchSideBarViewModel(onNavigate: onNavigate),
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
                    Navigator.pop(context); // Close the drawer
                    viewModel.navigateToDashboard();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    viewModel.navigateToProfile();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    viewModel.navigateToSettings();
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
                    viewModel.navigateToContactUs();
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.pop(context);
                    viewModel.showLogoutDialog(context);
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
