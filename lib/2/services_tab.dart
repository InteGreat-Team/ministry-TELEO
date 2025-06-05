import 'package:flutter/material.dart';
import 'c2spp/c2s2_service_portfolio_page.dart';
import 'c2spp/c2s2_upcoming_services_page.dart';
import 'c2spp/c2s3_service_approval_page.dart';
import 'c2spp/c2s2_edit_service_page.dart';

class ServicesTab extends StatelessWidget {
  const ServicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ), // 24dp horizontal padding as requested
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Service Portfolio section with Add Service button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Service Portfolio',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                // Add Service button - yellow with plus icon
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFAF00), // Yellow color
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Text(
                      'Add Service',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    label: const Icon(Icons.add, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Active Services count and View All
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Services (12)',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ServicePortfolioPage(),
                      ),
                    );
                  },
                  icon: const Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF000233),
                    ),
                  ),
                  label: const Icon(
                    Icons.arrow_forward,
                    size: 14,
                    color: Color(0xFF000233),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Service Portfolio cards - vertical list
            // ONLY keeping the Baptism card, removing Wedding and Funeral cards
            ServiceCard(
              title: 'Baptism',
              description:
                  'Welcomes an individual into Christianity with a water-blessing ceremony.',
              location: 'Church or set location',
              tags: const ['Fast', 'Later', 'P200'],
              cId: '',
              servName: '',
              servId: '',
            ),
            const SizedBox(height: 24),

            // Upcoming Services section
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
                        builder: (context) => const ServiceApprovalPage(),
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
              serviceTime: 'Fast Booking',
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final String location;
  final String cId; // ✅ add this
  final String servName; // ✅ add this
  final String servId;
  final List<String> tags;

  const ServiceCard({
    super.key,
    required this.title,
    required this.description,
    required this.location,
    required this.tags,
    required this.cId, // ✅ add this
    required this.servName, // ✅ add this
    required this.servId, // ✅ Add this
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add print statement for debugging
        print('ServiceCard tapped: $title');
        // Navigate to EditServicePage when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => EditServicePage(
                  title: title,
                  description: description,
                  cId: cId, // ✅ Ensure this is passed
                  servName: servName, // ✅ Ensure this is passed
                  servId: servId, // ✅ Ensure this is passed
                ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left orange border
              Container(
                width: 3, // 3px as requested
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6B00), // #FF6B00 as requested
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Grey image placeholder
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Main content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Title
                                Expanded(
                                  child: Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                ),

                                // Edit icon
                                IconButton(
                                  onPressed: () {
                                    // Add print statement for debugging
                                    print('Edit icon tapped for: $title');
                                    // Also navigate to EditServicePage when edit icon is clicked
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => EditServicePage(
                                              title: title,
                                              description: description,
                                              cId:
                                                  cId, // ✅ Ensure this is passed
                                              servName:
                                                  servName, // ✅ Ensure this is passed
                                              servId:
                                                  servId, // ✅ Ensure this is passed
                                            ),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: const Color(0xFF6E6E6E),
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),

                            // Description
                            Text(
                              description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6E6E6E),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),

                            // Location
                            Row(
                              children: [
                                Icon(
                                  Icons.place_outlined,
                                  size: 16,
                                  color: const Color(0xFF6E6E6E),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  location,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6E6E6E),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Tags
                            Wrap(
                              spacing: 8,
                              children:
                                  tags.map((tag) {
                                    Color bgColor;
                                    Color textColor;

                                    if (tag == 'Fast') {
                                      bgColor = const Color(
                                        0xFFE3F2FD,
                                      ); // Light blue
                                      textColor = const Color(
                                        0xFF2196F3,
                                      ); // Blue
                                    } else if (tag == 'Later') {
                                      bgColor = const Color(
                                        0xFFE1F5FE,
                                      ); // Lighter blue
                                      textColor = const Color(
                                        0xFF03A9F4,
                                      ); // Light blue
                                    } else {
                                      bgColor = const Color(0xFFE0F2F1); // Mint
                                      textColor = const Color(
                                        0xFF009688,
                                      ); // Teal
                                    }

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: bgColor,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        tag,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: textColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final String title;
  final String assignedTo;
  final String location;
  final String time;
  final Color borderColor;
  final Color backgroundColor;

  const AppointmentCard({
    super.key,
    required this.title,
    required this.assignedTo,
    required this.location,
    required this.time,
    required this.borderColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 3.0)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 16,
                color: Color(0xFF6E6E6E),
              ),
              const SizedBox(width: 4),
              Text(
                assignedTo,
                style: const TextStyle(fontSize: 14, color: Color(0xFF6E6E6E)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.place_outlined,
                size: 16,
                color: Color(0xFF6E6E6E),
              ),
              const SizedBox(width: 4),
              Text(
                location,
                style: const TextStyle(fontSize: 14, color: Color(0xFF6E6E6E)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.access_time_outlined,
                size: 16,
                color: Color(0xFF6E6E6E),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  time,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6E6E6E),
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
  final String serviceLocation;
  final String serviceType;
  final String serviceTime;

  const ServiceRequestCard({
    super.key,
    required this.serviceName,
    required this.serviceLocation,
    required this.serviceType,
    required this.serviceTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            serviceName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.place_outlined,
                size: 16,
                color: Color(0xFF6E6E6E),
              ),
              const SizedBox(width: 4),
              Text(
                serviceLocation,
                style: const TextStyle(fontSize: 14, color: Color(0xFF6E6E6E)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            serviceType,
            style: const TextStyle(fontSize: 14, color: Color(0xFF6E6E6E)),
          ),
          const SizedBox(height: 4),
          Text(
            serviceTime,
            style: const TextStyle(fontSize: 14, color: Color(0xFF6E6E6E)),
          ),
        ],
      ),
    );
  }
}
