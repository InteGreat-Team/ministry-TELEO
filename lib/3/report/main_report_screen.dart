import 'package:flutter/material.dart';
import 'report_user_screen.dart';
import 'report_bug_screen.dart';

class MainReportScreen extends StatelessWidget {
  final VoidCallback? onBack;
  const MainReportScreen({Key? key, this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildReportOption(
              context,
              icon: Icons.person_outline,
              title: 'Report a User',
              subtitle: 'Report a user',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportUserScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildReportOption(
              context,
              icon: Icons.bug_report_outlined,
              title: 'Report a Bug',
              subtitle: 'Report issues within the app',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportBugScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.grey[600], size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[400],
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}
