import 'package:flutter/material.dart';

class InvitationsApprovalPage extends StatelessWidget {
  const InvitationsApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    // *** ADJUST THIS VALUE to position the FAB ***
    // Increase the value to move the FAB down, decrease to move it up
    final double fabPositionFromTop = -10.0; // Same value as service_requests_page.dart

    return Scaffold(
      backgroundColor: Colors.white, // White background like service_requests_page
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 1),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Inbox',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Balance the header
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Main content in Expanded to take all available space
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header with count - similar to service_requests_page
                Row(
                  children: [
                    const Text(
                      'Invitations Approval',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2196F3),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '2',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // March 1 invitation - updated to match design
                _buildInvitationCard(
                  date: 'March 1',
                  churchName: 'Church Name',
                  waitingTime: '6 hours',
                ),

                const SizedBox(height: 12), // Space between cards

                // March 2 invitation - updated to match design
                _buildInvitationCard(
                  date: 'March 2',
                  churchName: 'Church Name',
                  waitingTime: '22 hours',
                ),

                // Add extra padding at the bottom to ensure content isn't hidden behind the FAB
                const SizedBox(height: 80),
              ],
            ),
          ),

          // Footer with FAB - Updated to match service_requests_page.dart
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // Footer
              const FooterSection(),

              // FAB positioned to overlap with the footer
              Positioned(
                top: fabPositionFromTop, // ADJUSTABLE POSITION
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8A2BE2), // Changed to purple to match main.dart
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.volunteer_activism,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvitationCard({
    required String date,
    required String churchName,
    required String waitingTime,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header INSIDE the card - moved from outside
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
            child: Text(
              date,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
              ),
            ),
          ),

          // Top section with profile and text
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Church avatar with custom painter checkmark
                Stack(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                        ),
                        child: CustomPaint(
                          painter: CheckmarkPainter(),
                          size: const Size(18, 18),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),

                // Invitation text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        churchName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'has invited your organization, [Church Name], to be part of their "Event Name Event Name Event."',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF333333),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Dashed line separator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomPaint(
              painter: DashedLinePainter(),
              size: const Size(double.infinity, 1),
            ),
          ),

          // Waiting for approval section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Waiting for your approval...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2196F3),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      waitingTime,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for the profile silhouette
class ProfileSilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Paint for the head (white circle)
    final Paint headPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Paint for the body (white curved shape)
    final Paint bodyPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw the head (circle)
    canvas.drawCircle(
      Offset(centerX, centerY - 5), // Slightly above center
      size.width * 0.2, // Head size relative to container
      headPaint,
    );

    // Draw the body (curved shape)
    final Path bodyPath = Path();
    bodyPath.moveTo(centerX - 15, centerY + 5); // Left shoulder
    bodyPath.quadraticBezierTo(
      centerX, centerY + 20, // Control point
      centerX + 15, centerY + 5, // Right shoulder
    );
    bodyPath.close();

    canvas.drawPath(bodyPath, bodyPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// Updated FooterSection to match main.dart
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

// Custom painter for dashed line
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 5, dashSpace = 5, startX = 0;
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Replace the existing CheckmarkPainter class with this one from c2s6_inbox_page.dart
class CheckmarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Define the checkmark path
    final Path checkPath = Path();
    checkPath.moveTo(centerX - 4, centerY);
    checkPath.lineTo(centerX - 1, centerY + 3);
    checkPath.lineTo(centerX + 4, centerY - 2);

    // Paint for the purple/pink checkmark
    final Paint checkPaint = Paint()
      ..color = const Color(0xFFE040FB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Paint for the white outline
    final Paint outlinePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Draw the white outline first (underneath)
    canvas.drawPath(checkPath, outlinePaint);

    // Draw the purple/pink checkmark on top
    canvas.drawPath(checkPath, checkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}