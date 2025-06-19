import 'package:flutter/material.dart';
import '../admin_types.dart';
import '../authenticator_flow.dart';

class NotificationSettingsView extends StatefulWidget {
  final Function(AdminView, {AuthenticatorFlow? flow, String? newValue})
  onNavigate;

  const NotificationSettingsView({super.key, required this.onNavigate});

  @override
  State<NotificationSettingsView> createState() =>
      _NotificationSettingsViewState();
}

class _NotificationSettingsViewState extends State<NotificationSettingsView> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;

  Widget _buildNotificationToggle(String title, String subtitle, bool value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) {
              setState(() {
                if (title == 'Push Notifications') {
                  _pushNotifications = newValue;
                } else if (title == 'Email Notifications') {
                  _emailNotifications = newValue;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNotificationToggle(
              'Push Notifications',
              'Receive push notifications for important updates',
              _pushNotifications,
            ),
            const SizedBox(height: 16),
            _buildNotificationToggle(
              'Email Notifications',
              'Receive email notifications for important updates',
              _emailNotifications,
            ),
          ],
        ),
      ),
    );
  }
}
