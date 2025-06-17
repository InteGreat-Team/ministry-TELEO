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
      height: 70.h, // Use height with ScreenUtil
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.r, // Make blur radius responsive
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
          ), // Add horizontal padding
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
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, String label, int index) {
    final bool selected = currentIndex == index;

    final Widget iconW =
        selected && useCircularHighlight
            ? Container(
              width: 40.w, // Make width responsive
              height: 40.h, // Make height responsive
              decoration: BoxDecoration(
                color: _highlightColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20.sp, // Make icon size responsive
              ),
            )
            : Icon(
              icon,
              color: selected ? _highlightColor : _inactiveColor,
              size: 24.sp, // Make icon size responsive
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
            SizedBox(height: 4.h), // Make spacing responsive
            Text(
              label,
              style: TextStyle(
                color: selected ? _highlightColor : _inactiveColor,
                fontSize: 11.sp, // Make font size responsive
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
