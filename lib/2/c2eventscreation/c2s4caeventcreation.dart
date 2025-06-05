import 'package:flutter/material.dart';
import 'models/event.dart';
import 'c2s5caeventcreation.dart';
import 'widgets/event_app_bar.dart';

class EventMapScreen extends StatefulWidget {
  final Event event;

  const EventMapScreen({super.key, required this.event});

  @override
  State<EventMapScreen> createState() => _EventMapScreenState();
}

class _EventMapScreenState extends State<EventMapScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _venueName = 'Sample Street 12, Brgy. 222, City, City, Bla Bla, 1011';
  final List<String> _recentLocations = [
    'Our Church',
    'Sample Street 12, Brgy. 222, City, City, Bla Bla, 1011',
    'On-Haul Venue',
    'Studio Hall',
    'Last used address',
    'Last used address',
    'Last used address',
  ];
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EventAppBar(
        onBackPressed: () => Navigator.pop(context), title: '',
      ),
      body: Column(
        children: [
          // Map Area (Placeholder for now)
          Expanded(
            child: Stack(
              children: [
                // Map Placeholder
                Container(
                  color: Colors.grey[300],
                  width: double.infinity,
                  child: const Center(
                    child: Text(
                      'Map will be integrated here',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                
                // Search Bar
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Select Location',
                        prefixIcon: const Icon(Icons.menu),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            setState(() {
                              _isSearching = !_isSearching;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onTap: () {
                        setState(() {
                          _isSearching = true;
                        });
                      },
                    ),
                  ),
                ),
                
                // Search Results
                if (_isSearching)
                  Positioned(
                    top: 70,
                    left: 16,
                    right: 16,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        itemCount: _recentLocations.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(
                              index == 0 ? Icons.home : (index == 1 ? Icons.location_on : Icons.history),
                              color: index < 2 ? const Color.fromARGB(255, 6, 6, 118) : Colors.grey,
                            ),
                            title: Text(_recentLocations[index]),
                            onTap: () {
                              setState(() {
                                _venueName = _recentLocations[index];
                                _isSearching = false;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                
                // Location Pin
                if (!_isSearching)
                  const Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Icon(
                        Icons.location_on,
                        color: Color.fromARGB(255, 2, 17, 91),
                        size: 40,
                      ),
                    ),
                  ),
                
                // Venue Info Card
                if (!_isSearching)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Venue Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(_venueName),
                          const SizedBox(height: 4),
                          const Text('0.0km'),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity, // Make button full width
                            height: 48, // Fixed height for button
                            child: ElevatedButton(
                              onPressed: () {
                                // Save venue information
                                widget.event.venueName = _venueName;
                                widget.event.venueAddress = _venueName;
                                
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EventSummaryScreen(event: widget.event),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0A0A4A),
                                foregroundColor: Colors.white, // Set text color to white
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4), // Less rounded corners
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text(
                                'Choose this location',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white, // Explicitly set text color to white
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
