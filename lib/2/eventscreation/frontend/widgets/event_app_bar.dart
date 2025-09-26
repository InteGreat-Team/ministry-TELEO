import 'package:flutter/material.dart';

class EventAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackPressed;
  
  const EventAppBar({
    super.key,
    required this.onBackPressed, required String title,
  });
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Create Event'),
      centerTitle: true, // Center the title
      backgroundColor: const Color(0xFF0A0A4A), // Changed to navy blue
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A4A), Color(0xFF0A0A4A)], // Changed to navy blue
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
      leading: TextButton.icon(
        onPressed: onBackPressed,
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 16,
        ),
        label: const Text(
          'Back',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 8),
        ),
      ),
      leadingWidth: 80, // Adjust width to fit "← Back" text
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
