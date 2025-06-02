import 'package:flutter/material.dart';
import '../../c3theme/c3atchurchadpendingsub.dart';

class ExploreTab extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const ExploreTab({
    Key? key,
    required this.title,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppTheme.primaryColor : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[700],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
