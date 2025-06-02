import 'package:flutter/material.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _upcomingEvents = [
    {
      'title': 'Sunday Service',
      'date': 'Sun, May 19, 2025',
      'time': '10:00 AM - 12:00 PM',
      'location': 'Main Sanctuary',
      'image': 'assets/images/sunday_service.jpg',
      'description': 'Weekly worship service with praise, prayer, and sermon.',
    },
    {
      'title': 'Youth Fellowship',
      'date': 'Fri, May 24, 2025',
      'time': '6:00 PM - 8:00 PM',
      'location': 'Youth Center',
      'image': 'assets/images/youth_fellowship.jpg',
      'description':
          'Weekly gathering for teens and young adults with games, worship, and Bible study.',
    },
    {
      'title': 'Community Outreach',
      'date': 'Sat, May 25, 2025',
      'time': '9:00 AM - 1:00 PM',
      'location': 'Downtown Area',
      'image': 'assets/images/community_outreach.jpg',
      'description':
          'Monthly service project to help those in need in our community.',
    },
    {
      'title': 'Prayer Meeting',
      'date': 'Wed, May 22, 2025',
      'time': '7:00 PM - 8:30 PM',
      'location': 'Prayer Room',
      'image': 'assets/images/prayer_meeting.jpg',
      'description':
          'Midweek prayer gathering for intercession and spiritual renewal.',
    },
  ];

  final List<Map<String, dynamic>> _myEvents = [
    {
      'title': 'Sunday Service',
      'date': 'Sun, May 19, 2025',
      'time': '10:00 AM - 12:00 PM',
      'location': 'Main Sanctuary',
      'image': 'assets/images/sunday_service.jpg',
      'description': 'Weekly worship service with praise, prayer, and sermon.',
    },
    {
      'title': 'Prayer Meeting',
      'date': 'Wed, May 22, 2025',
      'time': '7:00 PM - 8:30 PM',
      'location': 'Prayer Room',
      'image': 'assets/images/prayer_meeting.jpg',
      'description':
          'Midweek prayer gathering for intercession and spiritual renewal.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001A33),
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: const Color(0xFF001A33),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF3E9BFF),
          tabs: const [Tab(text: 'Upcoming Events'), Tab(text: 'My Events')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Upcoming Events Tab
          _buildEventsList(_upcomingEvents),

          // My Events Tab
          _buildEventsList(_myEvents),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to event search or filter
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Event search coming soon!')),
          );
        },
        backgroundColor: const Color(0xFF3E9BFF),
        child: const Icon(Icons.search),
      ),
    );
  }

  Widget _buildEventsList(List<Map<String, dynamic>> events) {
    return events.isEmpty
        ? const Center(
          child: Text(
            'No events to display',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return _buildEventCard(event);
          },
        );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    return GestureDetector(
      onTap: () {
        _showEventDetails(event);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF002642),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.asset(
                event['image'],
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.event,
                      color: Colors.white54,
                      size: 50,
                    ),
                  );
                },
              ),
            ),

            // Event details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['title'],
                    style: const TextStyle(
                      color: Color(0xFF3E9BFF),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Date and time
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        event['date'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Time
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        event['time'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        event['location'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Join button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Join event logic
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'You\'ve joined ${event['title']}!',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3E9BFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Join Event'),
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

  void _showEventDetails(Map<String, dynamic> event) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF002642),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event title
              Text(
                event['title'],
                style: const TextStyle(
                  color: Color(0xFF3E9BFF),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Date and time
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.white70,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${event['date']} • ${event['time']}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Location
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.white70,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    event['location'],
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description
              const Text(
                'Description',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                event['description'],
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Add to calendar
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to calendar')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Add to Calendar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Join event
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('You\'ve joined ${event['title']}!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3E9BFF),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Join Event'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
