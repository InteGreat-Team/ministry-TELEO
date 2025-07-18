import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../1/c1home/landingpage.dart'; // Import LandingPage

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

  // Pre-built nav items data for better performance
  static const List<NavItem> _navItems = [
    NavItem(Icons.home_outlined, 'Home'),
    NavItem(Icons.favorite_outline, 'Service'),
    NavItem(Icons.campaign_outlined, 'Connect'),
    NavItem(Icons.menu_book_outlined, 'Read'),
    NavItem(Icons.person_outline, 'You'),
  ];

  void _handleNavigation(BuildContext context, int index) {
    // Only navigate if it's a different index to avoid unnecessary rebuilds
    if (index == currentIndex) return;

    switch (index) {
      case 0: // Home - Navigate to landing page
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    const LandingPage(), // Corrected to LandingPage
            transitionDuration: Duration.zero, // Instant transition
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return child; // No animation, just return the child directly
            },
          ),
        );
        break;
      case 1: // Service
        // TODO: Navigate to Service page
        // For now, just trigger onTap callback
        break;
      case 2: // Connect
        // TODO: Navigate to Connect page
        // For now, just trigger onTap callback
        break;
      case 3: // Read
        // TODO: Navigate to Read page
        // For now, just trigger onTap callback
        break;
      case 4: // You (Profile)
        // TODO: Navigate to Profile page
        // For now, just trigger onTap callback
        break;
    }
    // Call the optional onTap callback
    onTap?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.r,
            offset: Offset(0, -2.h),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _navItems.length,
              (index) => _buildNavItem(context, _navItems[index], index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, NavItem item, int index) {
    final bool isSelected = currentIndex == index;
    final Color iconColor =
        isSelected
            ? (useCircularHighlight ? Colors.white : _highlightColor)
            : _inactiveColor;
    final Color textColor = isSelected ? _highlightColor : _inactiveColor;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleNavigation(context, index),
          borderRadius: BorderRadius.circular(12.r),
          splashColor: _highlightColor.withOpacity(0.2),
          highlightColor: _highlightColor.withOpacity(0.1),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with circular highlight for selected state
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isSelected && useCircularHighlight ? 30.w : 20.w,
                  height: isSelected && useCircularHighlight ? 30.h : 20.h,
                  decoration:
                      isSelected && useCircularHighlight
                          ? const BoxDecoration(
                            color: _highlightColor,
                            shape: BoxShape.circle,
                          )
                          : null,
                  child: Icon(item.icon, color: iconColor, size: 20.sp),
                ),
                SizedBox(height: 4.h),
                // Label with animation
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 10.sp,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Helper class for nav item data
class NavItem {
  final IconData icon;
  final String label;
  const NavItem(this.icon, this.label);
}
