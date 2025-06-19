import 'package:flutter/material.dart';
import '../admin_types.dart';

class ContentManagement extends StatelessWidget {
  final Function(AdminView) onNavigate;

  const ContentManagement({Key? key, required this.onNavigate})
    : super(key: key);

  Widget _buildContentButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: color),
      ),
    );
  }

  Widget _buildManagementListItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: const TextStyle(color: Colors.black87)),
      trailing: const Icon(Icons.chevron_right, color: Colors.black45),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),
          const Text(
            'Manage Content',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildContentButton(
                icon: Icons.calendar_today,
                color: Colors.red,
                onTap: () => onNavigate(AdminView.events),
              ),
              _buildContentButton(
                icon: Icons.people,
                color: Colors.amber,
                onTap: () => onNavigate(AdminView.community),
              ),
              _buildContentButton(
                icon: Icons.book,
                color: Colors.green,
                onTap: () => onNavigate(AdminView.posts),
              ),
              _buildContentButton(
                icon: Icons.person,
                color: Colors.blue,
                onTap: () => onNavigate(AdminView.setRoles),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildManagementListItem(
            icon: Icons.calendar_today,
            iconColor: Colors.red,
            title: 'Events',
            onTap: () => onNavigate(AdminView.events),
          ),
          _buildManagementListItem(
            icon: Icons.people,
            iconColor: Colors.amber,
            title: 'Community',
            onTap: () => onNavigate(AdminView.community),
          ),
          _buildManagementListItem(
            icon: Icons.book,
            iconColor: Colors.green,
            title: 'Posts',
            onTap: () => onNavigate(AdminView.posts),
          ),
          _buildManagementListItem(
            icon: Icons.person,
            iconColor: Colors.blue,
            title: 'Set roles',
            onTap: () => onNavigate(AdminView.setRoles),
          ),
          const SizedBox(height: 80), // Extra space for bottom nav
        ],
      ),
    );
  }
}
