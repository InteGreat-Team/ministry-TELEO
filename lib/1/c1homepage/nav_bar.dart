import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final bool useCircularHighlight;

  const NavBar({
    super.key,
    this.currentIndex = 0,
    this.onTap,
    this.useCircularHighlight = true,
  });

  static const _highlightColor = Color(0xFF0277BD);
  static const _inactiveColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h, // Increased height for a bigger nav bar
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.r, // Increased blur radius
            offset: Offset(0, -3.h), // Adjusted offset
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w, // Increased horizontal padding
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _item(context, Icons.home_rounded, 'Home', 0),
            _item(context, Icons.favorite_rounded, 'Service', 1),
            _item(context, Icons.campaign_rounded, 'Connect', 2),
            _item(context, Icons.menu_book_rounded, 'Read', 3),
            _item(context, Icons.person_rounded, 'You', 4),
          ],
        ),
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String label, int index) {
    final bool selected = currentIndex == index;
    final Widget iconW = selected && useCircularHighlight
        ? Container(
            // Changed from AnimatedContainer to Container
            width: 40.w, // Increased responsive width
            height: 40.h, // Increased responsive height
            decoration: BoxDecoration(
              color: _highlightColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24.sp, // Increased responsive icon size
            ),
          )
        : Icon(
            icon,
            color: selected ? _highlightColor : _inactiveColor,
            size: 28.sp, // Increased responsive icon size
          );
    return Expanded(
      child: InkWell(
        onTap: () {
          if (onTap != null) onTap!(index);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconW,
            SizedBox(height: 4.h), // Increased responsive spacing
            Text(
              label,
              style: TextStyle(
                color: selected ? _highlightColor : _inactiveColor,
                fontSize: 12.sp, // Increased responsive font size
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
