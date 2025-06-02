import 'package:flutter/material.dart';

class DayItem extends StatelessWidget {
  final String weekday;
  final int date;
  final bool isSelected;

  const DayItem({
    super.key,
    required this.weekday,
    required this.date,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 80,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF000233) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            weekday,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : const Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}
