import 'package:flutter/material.dart';
import '../c2events/models/registered_event.dart';
import '../c2appointments/appointment_details_screen.dart';

class ServiceRequestsPage extends StatefulWidget {
  const ServiceRequestsPage({super.key});

  @override
  State<ServiceRequestsPage> createState() => _ServiceRequestsPageState();
}

class _ServiceRequestsPageState extends State<ServiceRequestsPage> {
  bool _isAscending = false;
  final String _sortBy = 'Date';
  
  // List to store service requests
  late List<RegisteredEvent> _serviceRequests;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  // Load data from the managers
  void _loadData() {
    // Get all registered events
    final allEvents = RegisteredEventManager.getRegisteredEvents();
    
    // Filter to get only service requests
    _serviceRequests = allEvents.where((event) => 
      event.event.tags.contains('Service') && 
      !event.isCancelled
    ).toList();
    
    _sortData();
  }
  
  // Check if there are any service requests
  bool get hasServiceRequests => _serviceRequests.isNotEmpty;

  void _toggleSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
      _sortData();
    });
  }
  
  // Sort the data based on date
  void _sortData() {
    // Sort service requests by start date
    _serviceRequests.sort((a, b) {
      // Handle null dates (place them at the end)
      if (a.event.startDate == null && b.event.startDate == null) {
        return 0;
      } else if (a.event.startDate == null) {
        return _isAscending ? 1 : -1;
      } else if (b.event.startDate == null) {
        return _isAscending ? -1 : 1;
      }
      
      // Compare dates
      final dateComparison = _isAscending
          ? a.event.startDate!.compareTo(b.event.startDate!)
          : b.event.startDate!.compareTo(a.event.startDate!);
      
      // If dates are the same, compare times
      if (dateComparison == 0 && a.event.startTime != null && b.event.startTime != null) {
        final aMinutes = a.event.startTime!.hour * 60 + a.event.startTime!.minute;
        final bMinutes = b.event.startTime!.hour * 60 + b.event.startTime!.minute;
        
        return _isAscending ? aMinutes.compareTo(bMinutes) : bMinutes.compareTo(aMinutes);
      }
      
      return dateComparison;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(width: 40), // Balance the header
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Sort option
          GestureDetector(
            onTap: _toggleSortOrder,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 18,
                    color: const Color(0xFF333333),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Sort: $_sortBy ${_isAscending ? '(Oldest first)' : '(Newest first)'}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Content area - either service requests or empty state
          Expanded(
            child: !hasServiceRequests 
                ? _buildEmptyState()
                : _buildServiceRequestsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceRequestsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _serviceRequests.length,
      itemBuilder: (context, index) {
        return _buildServiceRequestCard(_serviceRequests[index]);
      },
    );
  }
  
  Widget _buildServiceRequestCard(RegisteredEvent service) {
    // Format date and time
    String formattedDate = '';
    String formattedTime = '';
    
    if (service.event.startDate != null) {
      formattedDate = "${service.event.startDate!.day}/${service.event.startDate!.month}/${service.event.startDate!.year}";
    }
    
    if (service.event.startTime != null) {
      final hour = service.event.startTime!.hourOfPeriod == 0 ? 12 : service.event.startTime!.hourOfPeriod;
      final minute = service.event.startTime!.minute.toString().padLeft(2, '0');
      final period = service.event.startTime!.period == DayPeriod.am ? 'AM' : 'PM';
      formattedTime = '$hour:$minute $period';
    }
    
    // Get service type from event tags
    String serviceType = 'Service';
    if (service.event.tags.length > 1) {
      serviceType = service.event.tags[1];
    }
    
    return GestureDetector(
      onTap: () {
        // Navigate to event appointment details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventAppointmentDetailsScreen(
              registeredEvent: service,
            ),
          ),
        ).then((_) {
          // Refresh the list when returning from details
          setState(() {
            _loadData();
          });
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFDE1738),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.purple.shade800,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        _getServiceIcon(serviceType),
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Service details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          serviceType,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2196F3),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Scheduled for $formattedTime at ${service.event.location ?? "Church"}',
                          style: const TextStyle(
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

            // Dashed divider line
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: List.generate(
                  30, // Number of dashes
                  (index) => Expanded(
                    child: Container(
                      height: 1,
                      color: index.isEven ? Colors.grey.shade300 : Colors.transparent,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                    ),
                  ),
                ),
              ),
            ),

            // Status section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Confirmed',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.church,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        service.event.venueName ?? 'Church',
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
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Service icon in a circle
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.purple.shade100.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.church,
                size: 50,
                color: Colors.purple.shade300,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Empty state text
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.purple.shade200,
                width: 1,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Text(
                  'No service requests',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'You haven\'t requested any services yet.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to get service icon
  IconData _getServiceIcon(String serviceType) {
    switch (serviceType) {
      case 'Wedding':
      case 'Wedding Service':
        return Icons.favorite;
      case 'Funeral Service':
        return Icons.church;
      case 'Prayer Request':
        return Icons.volunteer_activism;
      case 'Baptism':
        return Icons.child_care;
      case 'Hospital Visit':
        return Icons.local_hospital;
      case 'Home Blessing':
        return Icons.home;
      default:
        return Icons.church;
    }
  }
}