import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../1/c1home/landingpage.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final bool useCircularHighlight;

  const NavBar({
    Key? key,
    this.currentIndex = 0,
    this.onTap,
    this.useCircularHighlight = true,
  }) : super(key: key);

  static const _highlightColor = Color(0xFF0277BD);
  static const _inactiveColor = Colors.grey;

  void _handleNavigation(BuildContext context, int index) {
    // Handle custom navigation logic
    switch (index) {
      case 0: // Home - Navigate to landing page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1: // Service
        // TODO: Navigate to Service page
        break;
      case 2: // Connect
        // TODO: Navigate to Connect page
        break;
      case 3: // Read
        // TODO: Navigate to Read page
        break;
      case 4: // You (Profile)
        // TODO: Navigate to Profile page
        break;
    }

    // Call the optional onTap callback
    if (onTap != null) onTap!(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4.r,
            offset: Offset(0, -2.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(context, Icons.home_outlined, 'Home', 0),
            _buildNavItem(context, Icons.favorite_outline, 'Service', 1),
            _buildNavItem(context, Icons.campaign_outlined, 'Connect', 2),
            _buildNavItem(context, Icons.menu_book_outlined, 'Read', 3),
            _buildNavItem(context, Icons.person_outline, 'You', 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
  ) {
    final bool isSelected = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _handleNavigation(context, index),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with circular highlight for selected state
              Container(
                width: isSelected && useCircularHighlight ? 32.w : null,
                height: isSelected && useCircularHighlight ? 32.h : null,
                decoration:
                    isSelected && useCircularHighlight
                        ? BoxDecoration(
                          color: _highlightColor,
                          shape: BoxShape.circle,
                        )
                        : null,
                child: Icon(
                  icon,
                  color:
                      isSelected
                          ? (useCircularHighlight
                              ? Colors.white
                              : _highlightColor)
                          : _inactiveColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(height: 4.h),
              // Label
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? _highlightColor : _inactiveColor,
                  fontSize: 10.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
