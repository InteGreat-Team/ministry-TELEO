import 'package:flutter/material.dart';
import 'dart:math';
import 'baptism_form/c2s10bsbaptismform.dart' as baptism;
import 'home_blessing_and_cleansing/c2s10bshomeblessing.dart' as home_blessing;
import 'hospital_and_sick_visitation/c2s10bshospitalsickvisit.dart'
    as hospital_visit;
import 'prayer_request/c2s10bsprayerrequest.dart' as prayer;
import 'funeral_service/c2s10bsfuneralservice.dart' as funeral;
import 'wedding_service/c2s10bsweddingform.dart' as wedding;

class ServicesSection extends StatelessWidget {
  final ScrollController? scrollController;
  final bool isHeaderCollapsed;
  final bool isSignedUp;
  final VoidCallback onSignUp;
  final Random _random = Random();

  // List of possible tags for services
  final List<Map<String, dynamic>> _fastTags = [
    {
      'text': 'Fast',
      'bgColor': const Color(0xFFE3F2FD),
      'textColor': Colors.blue,
    },
    {
      'text': 'Quick',
      'bgColor': const Color(0xFFE1F5FE),
      'textColor': Colors.blue,
    },
    {
      'text': 'Express',
      'bgColor': const Color(0xFFE0F7FA),
      'textColor': Colors.cyan,
    },
    {
      'text': 'Urgent',
      'bgColor': const Color(0xFFFFEBEE),
      'textColor': Colors.red,
    },
  ];

  final List<Map<String, dynamic>> _timingTags = [
    {
      'text': 'Later',
      'bgColor': const Color(0xFFE3F2FD),
      'textColor': Colors.blue,
    },
    {
      'text': 'Scheduled',
      'bgColor': const Color(0xFFE8F5E9),
      'textColor': Colors.green,
    },
    {
      'text': 'Flexible',
      'bgColor': const Color(0xFFF3E5F5),
      'textColor': Colors.purple,
    },
  ];

  final List<Map<String, dynamic>> _priceTags = [
    {
      'text': 'Free - ₱200',
      'bgColor': const Color(0xFFE8F5E9),
      'textColor': Colors.green,
    },
    {
      'text': 'Donation',
      'bgColor': const Color(0xFFE8F5E9),
      'textColor': Colors.green,
    },
    {
      'text': '₱100 - ₱500',
      'bgColor': const Color(0xFFE8F5E9),
      'textColor': Colors.green,
    },
  ];

  ServicesSection({
    super.key,
    this.scrollController,
    this.isHeaderCollapsed = false,
    required this.isSignedUp,
    required this.onSignUp,
  });

  // Method to get random tags for each service
  List<Map<String, dynamic>> _getRandomTags() {
    return [
      _fastTags[_random.nextInt(_fastTags.length)],
      _timingTags[_random.nextInt(_timingTags.length)],
      _priceTags[_random.nextInt(_priceTags.length)],
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Services Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side with preference vertical icon and Services text
              Row(
                children: [
                  // Modern preference vertical icon
                  const PreferenceVerticalIcon(
                    color: Color(0xFF000233),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Services',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
              // Right side with pagination dots
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF000233),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Service Cards
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const ClampingScrollPhysics(),
            children: [
              const SizedBox(height: 20),
              _buildBaptismCard(context),
              const SizedBox(height: 24),
              _buildHomeBlessingCard(context),
              const SizedBox(height: 24),
              _buildHospitalVisitCard(context),
              const SizedBox(height: 24),
              _buildPrayerRequestCard(context),
              const SizedBox(height: 24),
              _buildFuneralServiceCard(context),
              const SizedBox(height: 24),
              _buildWeddingServiceCard(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBaptismCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const baptism.SuccessScreen(allDetails: {}),
          ),
        );
      },
      child: _buildServiceCard(
        title: 'Baptism',
        description:
            'Welcomes an individual into Christianity with a water-blessing ceremony.',
        location: 'Church or set location',
        serviceType: 'baptism',
        tags: _getRandomTags(),
        color: Colors.blue.shade700,
        icon: Icons.water_drop,
        imagePath: 'assets/baptism.png',
      ),
    );
  }

  Widget _buildHomeBlessingCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => const home_blessing.SuccessScreen(allDetails: {}),
          ),
        );
      },
      child: _buildServiceCard(
        title: 'Home Blessing and Cleansing',
        description:
            'A ritual to bless and cleanse a home, bringing peace and spiritual protection.',
        location: 'Your home or residence',
        serviceType: 'homeblessing',
        tags: _getRandomTags(),
        color: Colors.green.shade700,
        icon: Icons.home,
        imagePath: 'assets/home_blessing.png',
      ),
    );
  }

  Widget _buildHospitalVisitCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => const hospital_visit.SuccessScreen(allDetails: {}),
          ),
        );
      },
      child: _buildServiceCard(
        title: 'Hospital and Sick Visitation',
        description:
            'Spiritual support and prayer for those who are ill or hospitalized.',
        location: 'Hospital or home',
        serviceType: 'hospitalvisitation',
        tags: _getRandomTags(),
        color: Colors.red.shade700,
        icon: Icons.local_hospital,
        imagePath: 'assets/hospital_visit.png',
      ),
    );
  }

  Widget _buildPrayerRequestCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const prayer.SuccessScreen(allDetails: {}),
          ),
        );
      },
      child: _buildServiceCard(
        title: 'Prayer Request',
        description:
            'Submit your prayer needs to be lifted up by our prayer team.',
        location: 'Online or in person',
        serviceType: 'prayerrequest',
        tags: _getRandomTags(),
        color: Colors.amber.shade700,
        icon: Icons.volunteer_activism,
        imagePath: 'assets/prayer.png',
      ),
    );
  }

  Widget _buildFuneralServiceCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const funeral.SuccessScreen(allDetails: {}),
          ),
        );
      },
      child: _buildServiceCard(
        title: 'Funeral Service',
        description:
            'Compassionate support and guidance for memorial services and funeral arrangements.',
        location: 'Church, funeral home, or cemetery',
        serviceType: 'funeralservice',
        tags: _getRandomTags(),
        color: Colors.indigo.shade900,
        icon: Icons.church,
        imagePath: 'assets/funeral.png',
      ),
    );
  }

  Widget _buildWeddingServiceCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const wedding.SuccessScreen(allDetails: {}),
          ),
        );
      },
      child: _buildServiceCard(
        title: 'Wedding Service',
        description:
            'Sacred ceremony to unite couples in marriage with spiritual blessing and guidance.',
        location: 'Church sanctuary or garden',
        serviceType: 'wedding',
        tags: _getRandomTags(),
        color: Colors.pink.shade700,
        icon: Icons.favorite,
        imagePath: 'assets/wedding.png',
      ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String description,
    required String location,
    required String serviceType,
    required List<Map<String, dynamic>> tags,
    required Color color,
    required IconData icon,
    required String imagePath,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF000233), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Try to load image first, fall back to colored container with icon
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width: 80,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading image: $imagePath - $error');
                  // Fallback to colored container with icon
                  return Container(
                    width: 80,
                    height: 110,
                    color: color,
                    child: Center(
                      child: Icon(icon, color: Colors.white, size: 40),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFF757575),
                      fontSize: 12,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.done_all, color: Colors.grey, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Randomized Tags/Buttons
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .end, // This aligns children to the right
                    children: [
                      _buildPillButton(
                        tags[0]['text'],
                        tags[0]['bgColor'],
                        tags[0]['textColor'],
                      ),
                      const SizedBox(width: 6),
                      _buildPillButton(
                        tags[1]['text'],
                        tags[1]['bgColor'],
                        tags[1]['textColor'],
                      ),
                      const SizedBox(width: 6),
                      _buildPillButton(
                        tags[2]['text'],
                        tags[2]['bgColor'],
                        tags[2]['textColor'],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPillButton(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class PreferenceVerticalIcon extends StatelessWidget {
  final Color color;
  final double size;

  const PreferenceVerticalIcon({
    super.key,
    required this.color,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PreferenceVerticalPainter(color),
        size: Size(size, size),
      ),
    );
  }
}

class _PreferenceVerticalPainter extends CustomPainter {
  final Color color;
  _PreferenceVerticalPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.08
          ..strokeCap = StrokeCap.round;
    final Paint circlePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    // Top line
    final double topY = size.height * 0.2;
    canvas.drawLine(
      Offset(size.width * 0.2, topY),
      Offset(size.width * 0.8, topY),
      linePaint,
    );

    // Top circle/handle (positioned at 30% from left)
    canvas.drawCircle(
      Offset(size.width * 0.3, topY),
      size.width * 0.12,
      circlePaint,
    );

    // Middle line
    final double middleY = size.height * 0.5;
    canvas.drawLine(
      Offset(size.width * 0.2, middleY),
      Offset(size.width * 0.8, middleY),
      linePaint,
    );
    // Middle circle/handle (positioned at 60% from left)
    canvas.drawCircle(
      Offset(size.width * 0.6, middleY),
      size.width * 0.12,
      circlePaint,
    );

    // Bottom line
    final double bottomY = size.height * 0.8;
    canvas.drawLine(
      Offset(size.width * 0.2, bottomY),
      Offset(size.width * 0.8, bottomY),
      linePaint,
    );

    // Bottom circle/handle (positioned at 70% from left)
    canvas.drawCircle(
      Offset(size.width * 0.7, bottomY),
      size.width * 0.12,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
