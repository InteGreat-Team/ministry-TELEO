import 'package:flutter/material.dart';
import 'c2s2_1ethostedevents.dart'; // Import the event detail page
import '../c2eventscreation/c2s1caeventcreation.dart'; // Import the create event screen
import '../c2eventscreation/services/event_service.dart';

class HostedEventsPage extends StatefulWidget {
  const HostedEventsPage({super.key});

  @override
  State<HostedEventsPage> createState() => _HostedEventsPageState();
}

class _HostedEventsPageState extends State<HostedEventsPage> {
  String? _selectedStatus; // Nullable to represent no selection initially
  final List<String> _statusOptions = [
    'PENDING',
    'UPCOMING',
    'APPROVED',
    'REJECTED',
    'FOR REVISION',
  ];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Use EventService to manage events
  final EventService _eventService = EventService();
  List<Map<String, dynamic>> _allEvents = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });

    // Get initial events
    setState(() {
      _allEvents = List.from(_eventService.events);
    });

    // Listen for changes to events
    _eventService.eventsStream.listen((events) {
      if (mounted) {
        setState(() {
          _allEvents = List.from(events);
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredEvents {
    return _allEvents.where((event) {
      // If no status is selected, show all events
      final matchesStatus =
          _selectedStatus == null || event['status'] == _selectedStatus;
      final matchesSearch =
          event['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event['assignedTo'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          event['location'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesStatus && matchesSearch;
    }).toList();
  }

  // Navigate to EventDetailPage
  void _navigateToEventDetail(Map<String, dynamic> eventData) {
    print("Navigating to event detail with data: $eventData"); // Debug print
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailPage(eventData: eventData),
      ),
    ).then((result) {
      // If we got updated data back, update the state
      if (result != null) {
        if (result is Map<String, dynamic> &&
            result.containsKey('canceled') &&
            result['canceled'] == true) {
          // Event was canceled, remove it from the list
          _eventService.removeEvent(eventData['title']);

          // Show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Event has been canceled successfully'),
            ),
          );
        } else if (result is Map<String, dynamic>) {
          // Event was updated, update the data
          _eventService.updateEvent(eventData['title'], result);

          // Show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Event details updated successfully')),
          );
        }
      }
    });
  }

  // Navigate to CreateEventScreen
  void _navigateToCreateEvent() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateEventScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E3D), // Dark blue background
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          backgroundColor: const Color(0xFF0A0E3D),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Hosted Events',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(
                  0xFF1A1F4D,
                ), // Slightly lighter than background
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search for something...',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),

          // Status filter and Create Event button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Status dropdown
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1F4D),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'STATUS',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Updated dropdown with conditional "All" option
                      PopupMenuButton<String?>(
                        initialValue: _selectedStatus,
                        onSelected: (String? status) {
                          setState(() {
                            // If "All" is selected, set to null to show all events
                            if (status == 'All') {
                              _selectedStatus = null;
                            } else {
                              _selectedStatus = status;
                            }
                          });
                        },
                        offset: const Offset(0, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        itemBuilder: (BuildContext context) {
                          // Create a list to hold menu items
                          List<PopupMenuItem<String?>> items = [];

                          // Only add "All" option if a status is already selected
                          if (_selectedStatus != null) {
                            items.add(
                              const PopupMenuItem<String?>(
                                value: 'All',
                                child: Text('All'),
                              ),
                            );
                          }

                          // Add all status options
                          items.addAll(
                            _statusOptions.map((String status) {
                              return PopupMenuItem<String>(
                                value: status,
                                child: Text(status),
                              );
                            }).toList(),
                          );

                          return items;
                        },
                        // Show "Select Status" as hint text when nothing is selected
                        child: Row(
                          children: [
                            Text(
                              _selectedStatus ?? 'Select Status',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Create Event button - Now connected to the CreateEventScreen
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC107), // Yellow button
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton.icon(
                    onPressed: _navigateToCreateEvent,
                    icon: const Icon(Icons.add, color: Colors.black, size: 16),
                    label: const Text(
                      'Create Event',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Event list
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child:
                  _filteredEvents.isEmpty
                      ? Center(
                        child: Text(
                          'No events found',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredEvents.length,
                        itemBuilder: (context, index) {
                          final event = _filteredEvents[index];
                          return GestureDetector(
                            onTap: () => _navigateToEventDetail(event),
                            child: EventCard(
                              title: event['title'],
                              assignedTo: event['assignedTo'],
                              location: event['location'],
                              time: event['time'],
                              borderColor: _getBorderColorForStatus(
                                event['status'],
                              ),
                              backgroundColor: _getBackgroundColorForStatus(
                                event['status'],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getBorderColorForStatus(String status) {
    switch (status) {
      case 'PENDING':
        return const Color(0xFFFF9800); // Orange
      case 'UPCOMING':
        return const Color(0xFF4CAF50); // Green
      case 'APPROVED':
        return const Color(0xFF2196F3); // Blue
      case 'REJECTED':
        return const Color(0xFFF44336); // Red
      case 'FOR REVISION':
        return const Color(0xFF9C27B0); // Purple
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  Color _getBackgroundColorForStatus(String status) {
    switch (status) {
      case 'PENDING':
        return const Color(0xFFFFF3E0); // Light Orange
      case 'UPCOMING':
        return const Color(0xFFE8F5E9); // Light Green
      case 'APPROVED':
        return const Color(0xFFE3F2FD); // Light Blue
      case 'REJECTED':
        return const Color(0xFFFFEBEE); // Light Red
      case 'FOR REVISION':
        return const Color(0xFFF3E5F5); // Light Purple
      default:
        return const Color(0xFFF5F5F5); // Light Grey
    }
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String assignedTo;
  final String location;
  final String time;
  final Color borderColor;
  final Color backgroundColor;

  const EventCard({
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
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left colored border
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),

            // Thumbnail/icon
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // Assigned to row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Assigned to: ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            assignedTo,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4A90E2),
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Location row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            location,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Time row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            time,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            overflow: TextOverflow.ellipsis,
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
    );
  }
}
