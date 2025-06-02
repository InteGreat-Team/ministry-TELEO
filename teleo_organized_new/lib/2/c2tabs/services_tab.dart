import 'package:flutter/material.dart';
import '../c2spp/c2s2_service_portfolio_page.dart';
import '../c2spp/c2s2_upcoming_services_page.dart';
import '../c2spp/c2s3_service_request_list.dart';
import '../widgets/appointment_card.dart';
import '../widgets/service_portfolio_card.dart';

class ServicesTab extends StatelessWidget {
  const ServicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16), // Reduced padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16), // Reduced spacing
            // Service Portfolio section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Service Portfolio',
                  style: TextStyle(
                    fontSize: 20, // Smaller heading
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ServicePortfolioPage(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, // Remove padding
                    minimumSize: Size.zero, // Remove minimum size
                    tapTargetSize:
                        MaterialTapTargetSize.shrinkWrap, // Reduce tap target
                  ),
                  child: Row(
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 14, // Smaller text
                          fontWeight: FontWeight.w500,
                          color: const Color(
                            0xFF000233,
                          ), // Updated to dark navy
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        size: 14, // Smaller icon
                        color: Color(0xFF000233), // Updated to dark navy
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2), // Reduced spacing
            Text(
              'Active Services (12)',
              style: TextStyle(
                fontSize: 14, // Smaller text
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12), // Reduced spacing
            // Service Portfolio - just one Baptism card instead of the horizontal scrolling row
            ServicePortfolioCard(
              title: 'Baptism',
              description:
                  'Welcomes an individual into Christianity with a water-blessing ceremony.',
              location: 'Church or set location',
              tags: ['Fast', 'Later', 'P200'],
              cId: '',
              servName: '',
              servId: '',
            ),
            const SizedBox(height: 20), // Reduced spacing
            // Upcoming Services section - ONLY CHANGED THIS SECTION
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Upcoming Services',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF6B35), // Changed to orange
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '8', // Updated to 8
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
                GestureDetector(
                  onTap: () {
                    // Navigate to the UpcomingServicesPage when "View All" is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UpcomingServicesPage(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      const Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF000233), // Updated to dark navy
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: Color(0xFF000233), // Updated to dark navy
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Showing (2/8)',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),

            // Upcoming Services cards
            AppointmentCard(
              title: 'Baptism',
              assignedTo: '@Pastor John',
              location: 'P. Sherman, 42 Wallaby Way',
              time: 'February 14, 2025 - 3:00 PM - 6:00 PM',
              borderColor: const Color(0xFFFF6B35), // Changed to orange
              backgroundColor: const Color(
                0xFFFFF5F0,
              ), // Lighter peach  // Changed to orange
            ),
            AppointmentCard(
              title: 'Baptism',
              assignedTo: '@Pastor John',
              location: 'P. Sherman, 42 Wallaby Way',
              time: 'February 14, 2025 - 3:00 PM - 6:00 PM',
              borderColor: const Color(0xFFFF6B35), // Changed to orange
              backgroundColor: const Color(
                0xFFFFF5F0,
              ), // Lighter peach background
            ),

            const SizedBox(height: 24),

            // Service Requests section - UPDATED WITH NAVIGATION TO SERVICE APPROVAL PAGE
            Row(
              children: [
                const Text(
                  'Service Requests',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF6B35), // Orange
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '8',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Service requests waiting for acceptance',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to the ServiceApprovalPage when "View All" is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ServiceRequestListPage(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      const Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF000233), // Updated to dark navy
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: Color(0xFF000233), // Updated to dark navy
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Service Request card - UPDATED
            ServiceRequestCard(
              serviceName: 'Service Requestor Name',
              serviceLocation: 'Default location where they\'re booking from',
              serviceType: 'Baptism and Dedication',
              timeType: 'fast',
              timeText: 'Fast Booking',
              destination: 'To your location',
              countdown: '',
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
