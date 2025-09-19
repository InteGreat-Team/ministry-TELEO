//nav_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teleo_organized_new/2/eventscreation/frontend/screens/CHURCH_CREATEVENTS_1.dart';

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

  static const highlightColor = Color(0xFF0277BD);
  static const inactiveColor = Colors.grey;
  static const primaryColor =
      Color(0xFF0277BD); // Added for consistency with landingpage.dart
  static const accentColor =
      Color(0xFF29B6F6); // Added for consistency with landingpage.dart

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.r,
            offset: Offset(0, -3.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
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
            width: 40.w,
            height: 40.h,
            decoration: const BoxDecoration(
              color: highlightColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24.sp,
            ),
          )
        : Icon(
            icon,
            color: selected ? highlightColor : inactiveColor,
            size: 28.sp,
          );

    return Expanded(
      child: InkWell(
        onTap: () => _handleNavTap(context, index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconW,
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: selected ? highlightColor : inactiveColor,
                fontSize: 12.sp,
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

  // Enhanced navigation handler with development popups
  void _handleNavTap(BuildContext context, int index) async {
    // Provide haptic feedback
    HapticFeedback.lightImpact();

    switch (index) {
      case 0: // Home - normal navigation
        if (onTap != null) onTap!(index);
        break;
      case 1: // Services - navigate to CreateEventScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateEventScreen(),
          ),
        );
        break;
      case 2: // Connect - normal navigation (working feature)
        if (onTap != null) onTap!(index);
        break;
      case 3: // Read - show development popup
        await _showDevelopmentPopup(
          context: context,
          title: 'Reading Features Coming Soon',
          icon: Icons.menu_book,
          iconColor: Colors.blue,
          message:
              'The Reading section is being crafted with care. Soon you\'ll be able to access devotionals, scriptures, and inspiring content!\n\nWe appreciate your patience.',
        );
        break;
      case 4: // You (Profile) - show development popup
        await _showDevelopmentPopup(
          context: context,
          title: 'Profile Features in Progress',
          icon: Icons.person,
          iconColor: Colors.purple,
          message:
              'Your personal dashboard is under construction. Soon you\'ll have access to your profile, settings, and personalized content!\n\nExciting things are coming.',
        );
        break;
      default:
        if (onTap != null) onTap!(index);
        break;
    }
  }

  // Enhanced development popup with customizable content
  Future<void> _showDevelopmentPopup({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color iconColor,
    required String message,
  }) async {
    // Get responsive values based on screen width
    final screenWidth = MediaQuery.of(context).size.width;

    double getResponsiveValue(double small, double medium, double large) {
      if (screenWidth < 340) return small * 0.9;
      if (screenWidth < 360) return small;
      if (screenWidth < 400) return medium * 0.95;
      if (screenWidth < 430) return medium;
      return large;
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: getResponsiveValue(300, 340, 380),
              minHeight: getResponsiveValue(200, 220, 240),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.blue.shade50.withOpacity(0.3),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(getResponsiveValue(20, 24, 28)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon with animated container
                  Container(
                    width: getResponsiveValue(60, 70, 80),
                    height: getResponsiveValue(60, 70, 80),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: iconColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: getResponsiveValue(30, 35, 40),
                    ),
                  ),
                  SizedBox(height: getResponsiveValue(16, 20, 24)),

                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: getResponsiveValue(18, 20, 22),
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: getResponsiveValue(12, 16, 20)),

                  // Message
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: getResponsiveValue(14, 15, 16),
                      height: 1.5,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: getResponsiveValue(20, 24, 28)),

                  // Action button with gradient
                  Container(
                    width: double.infinity,
                    height: getResponsiveValue(44, 48, 52),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          primaryColor,
                          Colors.blue.shade600,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pop();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Center(
                          child: Text(
                            'Got it!',
                            style: TextStyle(
                              fontSize: getResponsiveValue(16, 17, 18),
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
