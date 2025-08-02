import 'package:flutter/material.dart';
import '../admin_types.dart';
import 'admin_profile_view.dart';
import '../../../3/nav_bar.dart';
import '../home_page.dart';
import '../../c2homepage/schedule_tab.dart' as admin_home;

class AdminProfileScreen extends StatelessWidget {
  final AdminData adminData;
  final Function(AdminData) onUpdateAdminData;

  const AdminProfileScreen({
    super.key,
    required this.adminData,
    required this.onUpdateAdminData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AdminProfileView(
        adminData: adminData,
        onUpdateAdminData: onUpdateAdminData,
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 4,
        onTap: (index) {
          if (index == 0) {
            // Home
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const AdminHomePage()),
            );
          } else if (index == 1) {
            // Service
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const admin_home.ScheduleTab(),
              ),
            );
          } else if (index == 4) {
            // You (Profile) - already here, do nothing
          }
          // Do nothing for other indices (Connect, Read)
        },
      ),
    );
  }
}
