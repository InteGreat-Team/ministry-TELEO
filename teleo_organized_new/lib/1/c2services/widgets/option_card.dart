import 'package:flutter/material.dart';

class OptionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  State<OptionCard> createState() => _OptionCardState();
}

class _OptionCardState extends State<OptionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Briefly show the pressed state before executing onTap
        setState(() => _isPressed = true);
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) {
            setState(() => _isPressed = false);
            widget.onTap();
          }
        });
      },
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: Container(
        width: double.infinity, // Make the card full width
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: _isPressed ? const Color(0xFFFFC107) : Colors.white,
          border: Border.all(color: const Color.fromARGB(255, 186, 142, 10), width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: const Color(0xFF0A0A4A), // Changed to navy blue
              size: 28,
            ),
            const SizedBox(height: 12),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: _isPressed ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
