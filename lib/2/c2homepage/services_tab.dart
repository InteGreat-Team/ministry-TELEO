import 'package:flutter/material.dart';
import '../c2spp/c2s2_edit_service_page.dart';
import '../c2spp/c2s2_service_portfolio_page.dart';
import '../c2spp/c2s2_upcoming_services_page.dart';
import '../c2spp/c2s3_service_request_list.dart';
import '../c2spp/booking_details_page.dart';
import '../c2spp/c2s3_service_approval_page.dart';
import '../widgets/service_portfolio_card.dart';
import '../widgets/appointment_card.dart';
import '../widgets/service_request_card.cart.dart' as service_request_card;
import '../c2spp/models/booking_model.dart';

class ServicesTab extends StatelessWidget {
  const ServicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Portfolio section
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
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditServicePage(
                        title: 'New Service',
                        description: '',
                        cId: '',
                        servName: '',
                        servId: '',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                label: const Text(
                  'Add Service',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFAF00),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Active Services (12)',
                style: TextStyle(fontSize: 14, color: Colors.grey),
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
                child: const Row(
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF000233),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: Color(0xFF000233),
                    ),
                  ],
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Service Portfolio Cards
          ServicePortfolioCard(
            title: 'Baptism',
            description:
                'Welcomes an individual into Christianity with a water-blessing ceremony.',
            location: 'Church or set location',
            tags: const ['Fast', 'Later', 'P200'],
            cId: 'church123',
            servName: 'Baptism',
            servId: 'service456',
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
                  _Badge(count: 8),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UpcomingServicesPage(),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF000233),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: Color(0xFF000233),
                    ),
                  ],
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Showing (2/8)',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          // Upcoming Services cards
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingDetailsPage(
                    booking: Booking(
                      reference: 'AJSNDFB934U9382RFIWB',
                      requesterName: 'Service Requester Name',
                      location: 'P. Sherman, 42 Wallaby Way',
                      serviceType: 'Baptism',
                      date: 'February 14, 2025',
                      time: '3:00 PM - 6:00 PM',
                      isScheduledForLater: true,
                      venue: 'To the church',
                      assignedTo: '@Pastor John',
                    ),
                  ),
                ),
              );
            },
            child: AppointmentCard(
              title: 'Baptism',
              assignedTo: '@Pastor John',
              location: 'P. Sherman, 42 Wallaby Way',
              time: 'February 14, 2025 – 3:00 PM – 6:00 PM',
              borderColor: const Color(0xFFFF6B35),
              backgroundColor: const Color(0xFFFFF8F5),
            ),
          ),
          const SizedBox(height: 24),
          // Service Requests section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                  _Badge(count: 8),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ServiceRequestListPage(),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF000233),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: Color(0xFF000233),
                    ),
                  ],
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Service requests waiting for acceptance',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          // Service Request Card
          service_request_card.ServiceRequestCard(
            serviceName: 'Service Requestor Name',
            serviceLocation: 'Default location where they\'re booking from',
            serviceType: 'Anointment & Healing Service',
            serviceTime: 'Fast Booking (ASAP)',
            onViewDetails: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ServiceApprovalPage()),
              );
            },
            onAccept: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ServiceApprovalPage()),
              );
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;
  const _Badge({required this.count});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        color: Color(0xFFFF6B35),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$count',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
