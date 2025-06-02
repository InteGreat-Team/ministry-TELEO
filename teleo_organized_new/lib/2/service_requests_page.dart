import 'package:flutter/material.dart';

class ServiceRequestsPage extends StatelessWidget {
  const ServiceRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // *** ADJUST THIS VALUE to position the FAB ***
    // Increase the value to move the FAB down, decrease to move it up
    final double fabPositionFromTop = -10.0; // Same value as other pages

    return Scaffold(
      backgroundColor: Colors.white,
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
                        'Service Requests',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Notification bell icon removed
                  const SizedBox(width: 40), // To keep the title centered
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                // Header with count
                Row(
                  children: [
                    const Text(
                      'Service Requests',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF6B35),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '8',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Fast service request cards
                ServiceRequestCard(
                  date: 'March 2',
                  serviceName: 'Anointment & Healing Service',
                  requesterName: 'Requester\'s Name',
                  location: 'To their location',
                  distance: '1.8km away',
                  isFast: true,
                  countdown: '1:23',
                ),

                ServiceRequestCard(
                  date: 'March 2',
                  serviceName: 'Anointment & Healing Service',
                  requesterName: 'Requester\'s Name',
                  location: 'To their location',
                  distance: '1.8km away',
                  isFast: true,
                  countdown: '1:23',
                ),

                // Later service request cards
                ServiceRequestCard(
                  date: 'March 2',
                  serviceName: 'Anointment & Healing Service',
                  requesterName: 'Requester\'s Name',
                  location: 'To their location',
                  distance: '1.8km away',
                  isFast: false,
                  scheduledTime: 'May 5, 3:00 PM',
                  countdown: '1:23',
                ),

                ServiceRequestCard(
                  date: 'March 2',
                  serviceName: 'Anointment & Healing Service',
                  requesterName: 'Requester\'s Name',
                  location: 'To their location',
                  distance: '1.8km away',
                  isFast: false,
                  scheduledTime: 'May 5, 3:00 PM',
                  countdown: '1:23',
                ),

                ServiceRequestCard(
                  date: 'March 2',
                  serviceName: 'Anointment & Healing Service',
                  requesterName: 'Requester\'s Name',
                  location: 'To their location',
                  distance: '1.8km away',
                  isFast: false,
                  scheduledTime: 'May 5, 3:00 PM',
                  countdown: '1:23',
                ),

                // Add extra padding at the bottom to ensure content isn't hidden behind the FAB
                const SizedBox(height: 80),
              ],
            ),
          ),

          // Footer with FAB
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
}

class ServiceRequestCard extends StatelessWidget {
  final String serviceName;
  final String requesterName;
  final String location;
  final String distance;
  final bool isFast;
  final String? scheduledTime;
  final String countdown;
  final String date;

  const ServiceRequestCard({
    super.key,
    required this.serviceName,
    required this.requesterName,
    required this.location,
    required this.distance,
    required this.isFast,
    this.scheduledTime,
    required this.countdown,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header
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

          // Service details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service image placeholder
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),

                // Service details - Wrap in Expanded to prevent overflow
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Service name
                      Text(
                        serviceName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Requester info with Fast/Later tag - Fix overflow with Wrap
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4, // horizontal spacing
                        runSpacing: 4, // vertical spacing
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.person_outline,
                                size: 16,
                                color: Color(0xFF666666),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  requesterName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF666666),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          const Text(
                            '•',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                            ),
                          ),

                          if (scheduledTime != null)
                            Text(
                              scheduledTime!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),

                          if (scheduledTime != null)
                            const Text(
                              '•',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                            ),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isFast
                                  ? const Color(0xFFE6F4FF)
                                  : const Color(0xFFE1F5FE),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isFast ? 'Fast' : 'Later',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isFast
                                    ? const Color(0xFF0078D4)
                                    : const Color(0xFF039BE5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Location info - Fix overflow with Wrap
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: Color(0xFF666666),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  location,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF666666),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          const Text(
                            '•',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                            ),
                          ),

                          Text(
                            distance,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              color: Color(0xFFEEEEEE),
              height: 1,
            ),
          ),

          // View in Services Page with countdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'View in Services Page',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFF6B35),
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Color(0xFF666666),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      countdown,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
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
          _buildNavItem(Icons.chat_bubble_outline, 'Chat'), // Keep chat icon for this page
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