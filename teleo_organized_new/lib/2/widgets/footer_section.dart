import 'package:flutter/material.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF000233), // Dark navy blue background
        // Remove the border since it's not needed with the dark background
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.chat_bubble_outline, 'Chat'),
          _buildNavItem(Icons.favorite_border, 'Favorite'),
          // Prayer icon is positioned separately in the Stack
          const SizedBox(width: 56), // Space for the Prayer icon
          _buildNavItem(Icons.book_outlined, 'Book'),
          _buildNavItem(Icons.person_outline, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white, // Changed to white
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white, // Changed to white
            fontSize: 12,
          ),
        )
      ],
    );
  }
}
