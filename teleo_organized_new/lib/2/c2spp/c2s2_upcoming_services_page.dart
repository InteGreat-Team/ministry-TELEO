import 'package:flutter/material.dart';
import 'booking_details_page.dart';

class UpcomingServicesPage extends StatelessWidget {
  const UpcomingServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the exact color to ensure consistency
    const Color navyBlue = Color(0xFF000233);

    return Scaffold(
      backgroundColor: Colors.white,
      // Use a PreferredSize to have more control over the AppBar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          color: navyBlue, // Fixed color that won't change
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Upcoming Services',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the header
                ],
              ),
            ),
          ),
        ),
      ),
      // Disable the scroll effect that might be causing color changes
      body: NotificationListener<ScrollNotification>(
        onNotification: (_) => true, // Intercept scroll notifications
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for something...',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    suffixIcon: Icon(Icons.search, color: const Color(0xFFFF6B35)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
              ),
            ),

            // Upcoming Services count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Upcoming Services (8)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Service cards list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                physics: const ClampingScrollPhysics(), // Prevents overscroll effects
                itemCount: 8,
                itemBuilder: (context, index) {
                  // Sample data for each card
                  final Map<String, String> serviceData = {
                    'title': 'Baptism',
                    'location': 'P. Sherman, 42 Wallaby Way',
                    'date': 'February 14, 2025',
                    'time': '3:00 PM - 6:00 PM',
                    'assignedTo': '@Pastor John',
                    'reference': 'AJSNDFB934U9382RFIWB',
                  };

                  return BaptismServiceCard(
                    serviceData: serviceData,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingDetailsPage(
                            reference: serviceData['reference']!,
                            requesterName: 'Service Requester Name',
                            location: 'Default location where they\'re booking from',
                            serviceType: 'Baptism and Dedication',
                            date: serviceData['date']!,
                            time: '3:00 PM',
                            isScheduledForLater: true,
                            venue: 'To the church',
                            assignedTo: '@Lebron James',
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BaptismServiceCard extends StatelessWidget {
  final Map<String, String> serviceData;
  final VoidCallback onTap;

  const BaptismServiceCard({
    super.key,
    required this.serviceData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5F0), // Light peach background
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
                width: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6B35), // Orange border
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        serviceData['title'] ?? 'Baptism',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Location with icon
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              serviceData['location'] ?? 'P. Sherman, 42 Wallaby Way',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Time with icon
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${serviceData['date'] ?? 'February 14, 2025'} - ${serviceData['time'] ?? '3:00 PM - 6:00 PM'}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Assigned to with icon
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Assigned to: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            serviceData['assignedTo'] ?? '@Pastor John',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4A90E2),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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
