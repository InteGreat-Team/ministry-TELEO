// lib/widgets/nav_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap; // now nullable, since we might not use it
  final bool useCircularHighlight;

  const NavBar({
    Key? key,
    this.currentIndex = 0,
    this.onTap, // make optional
    this.useCircularHighlight = true,
  }) : super(key: key);

  static const _highlightColor = Color(0xFF0277BD);
  static const _inactiveColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    print('NavBar build called');
    return Container(
      height: 48.h, // Smaller responsive height
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2.r, // Smaller blur radius
            offset: Offset(0, -1.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 4.w,
        ), // Less horizontal padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _item(context, Icons.home_outlined, 'Home', 0),
            _item(context, Icons.favorite_outline, 'Service', 1),
            _item(context, Icons.campaign_outlined, 'Connect', 2),
            _item(context, Icons.menu_book_outlined, 'Read', 3),
            _item(context, Icons.person_outline, 'You', 4),
          ],
        ),
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String label, int index) {
    final bool selected = currentIndex == index;

    final Widget iconW =
        selected && useCircularHighlight
            ? Container(
              width: 28.w, // Smaller responsive width
              height: 28.h, // Smaller responsive height
              decoration: BoxDecoration(
                color: _highlightColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 16.sp, // Smaller responsive icon size
              ),
            )
            : Icon(
              icon,
              color: selected ? _highlightColor : _inactiveColor,
              size: 20.sp, // Smaller responsive icon size
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
            SizedBox(height: 2.h), // Smaller responsive spacing
            Text(
              label,
              style: TextStyle(
                color: selected ? _highlightColor : _inactiveColor,
                fontSize: 9.sp, // Smaller responsive font size
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
