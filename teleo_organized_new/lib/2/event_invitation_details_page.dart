import 'package:flutter/material.dart';

class EventInvitationDetailPage extends StatelessWidget {
  final String churchName;
  final String eventName;

  const EventInvitationDetailPage({
    super.key,
    required this.churchName,
    required this.eventName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E3D), // Dark blue background
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          backgroundColor: const Color(0xFF0A0E3D),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Invitation',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Church profile and invite message
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Church avatar with checkmark
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.grey.shade400,
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF4CAF50),
                                        shape: BoxShape.circle,
                                      ),
                                      child: CustomPaint(
                                        painter: CheckmarkPainter(),
                                        size: const Size(15, 15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      churchName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2196F3),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'This is where the typed out custom invite message goes. You can put as much as 300 words sigkot.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF666666),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Event image and title
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/event_image.jpg',
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 150,
                              width: double.infinity,
                              color: Colors.grey.shade300,
                              child: const Icon(
                                Icons.image,
                                color: Colors.grey,
                                size: 50,
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Event title
                      const Text(
                        'New Beginnings in Life Seminar',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Event details
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Color(0xFF666666),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Christian Church Auditorium',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: Color(0xFF666666),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'April 1, 2025 - 3:00-6:00 PM',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.attach_money,
                            size: 16,
                            color: Color(0xFF666666),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'P 20 /pax',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Event Description
                      const Text(
                        'Event Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Our event focuses on the sly brown fox jumped over the hedge and into a new life. Just as a fox in the wild, this is where you put the event description and every breath you take, every move you make, what am I even saying.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Speaker
                      Row(
                        children: [
                          const Text(
                            'Speaker',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Jean Jungkook',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Dress Code
                      Row(
                        children: [
                          const Text(
                            'Dress Code',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Smart Casual',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Invitation requests
                      const Text(
                        'We request to send out the invitations to the following people in your organization:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Role tags
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildRoleTag('(2) Admin', Colors.blue),
                          _buildRoleTag('(50) Members', Colors.purple),
                          _buildRoleTag('(3) Pastor/Leader', Colors.green),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // People tags
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildPersonTag('@Leon Kennedy'),
                          _buildPersonTag('@Ada Wong'),
                          _buildPersonTag('@Chapelle Roan'),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Comment section
                      const Text(
                        'Comment Feedback',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Write here some requests or revisions...',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF999999),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.send,
                              color: Colors.grey.shade400,
                              size: 20,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Waiting for approval
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Waiting for approval...',
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
                              const Text(
                                '6 hours',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFFFAA00)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text(
                                'Decline',
                                style: TextStyle(
                                  color: Color(0xFFFFAA00),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0A0E3D),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text(
                                'Accept',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Notes
                      const Text(
                        '• The event will automatically be posted on [Target Date].\n• If you don\'t accept, people within your organization will not receive an invite.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Footer - UPDATED
          const FooterSection(),
        ],
      ),
    );
  }

  Widget _buildRoleTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildPersonTag(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFAA00).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFFFFAA00),
        ),
      ),
    );
  }
}

// Custom Painter for the checkmark
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

// Updated FooterSection class with the purple design
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // Footer with dark purple background
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: const BoxDecoration(
            color: Color(0xFF0A0E3D), // Dark purple background
            border: Border(
              top: BorderSide(color: Color(0xFF0A0E3D), width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.home_outlined, 'Home', Colors.white),
              _buildNavItem(Icons.favorite_border, 'Favorite', Colors.white),
              // Prayer icon is positioned separately in the Stack
              const SizedBox(width: 56), // Space for the Prayer icon
              _buildNavItem(Icons.book_outlined, 'Book', Colors.white),
              _buildNavItem(Icons.person_outline, 'Profile', Colors.white),
            ],
          ),
        ),

        // Prayer button - centered and elevated
        Positioned(
          top: -10, // Position it to overlap with the footer
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF8A4FFF), // Purple color for the prayer button
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
    );
  }

  Widget _buildNavItem(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
          ),
        )
      ],
    );
  }
}
