import 'package:flutter/material.dart';
import 'dart:async';
import 'models/event.dart';
import 'c2s2epeventstab.dart';

class EventsSection extends StatefulWidget {
  final ScrollController scrollController;
  final bool isHeaderCollapsed;

  const EventsSection({
    super.key,
    required this.scrollController,
    required this.isHeaderCollapsed,
  });

  @override
  State<EventsSection> createState() => _EventsSectionState();
}

class _EventsSectionState extends State<EventsSection> {
  // Map to track active state of each filter
  final Map<String, bool> _activeFilters = {
    'All': true,
    'Healing': false,
    'Seminar': false,
    'Education': false,
    'Religious Celebrations': false,
    'Music': true,
    'Community': true,
  };

  // Added for automatic sliding
  final PageController _featuredEventController = PageController();
  Timer? _autoSlideTimer;
  int _currentFeaturedEventIndex = 0;

  // Single source of event data
  final List<Event> _allEvents = [
    Event(
      title: 'PRAISE! Youth Worship Charity Concert',
      location: 'Paranaque, 1713',
      date: '10 Mar 2025 - 6:00 PM',
      tags: ['Music', 'Community', 'Charity'],
      likes: 123,
      color: Colors.blue.shade800,
      text: 'PRAISE!',
      isFeatured: true,
      startDate: DateTime(2025, 3, 10),
      startTime: const TimeOfDay(hour: 18, minute: 0),
      endTime: const TimeOfDay(hour: 21, minute: 0),
      description:
          'Join us for an evening of worship and praise as we raise funds for charity. This event will feature performances from various youth groups and solo artists.',
      contactInfo: '09123456789',
      venueName: 'St. Paul Parish Hall',
      speakers: ['Youth Worship Team', 'Guest Worship Leader'],
      dressCode: 'Smart Casual',
      inviteType: 'Open Invite',
      expectedCapacity: 200,
      allowsVolunteers: true, // This event allows volunteers
      volunteerRoles: [
        'Music Team',
        'Hospitality Team',
        'Media & Communications',
        'Event Staff',
      ],
      volunteersNeeded: 15,
    ),
    Event(
      title: 'Healing Prayer Service',
      location: 'St. Paul Church',
      date: '15 May 2025 - 4:00 PM',
      tags: ['Healing', 'Prayer'],
      likes: 56,
      color: Colors.green.shade800,
      text: 'HEALING',
      isFeatured: true,
      startDate: DateTime(2025, 5, 15),
      startTime: const TimeOfDay(hour: 16, minute: 0),
      endTime: const TimeOfDay(hour: 18, minute: 0),
      description:
          'A special prayer service focused on healing. Come and experience the healing power of prayer in community.',
      contactInfo: '09234567890',
      venueName: 'St. Paul Church',
      speakers: ['Fr. John Smith', 'Prayer Ministry Team'],
      dressCode: 'Modest Attire',
      inviteType: 'Open Invite',
      expectedCapacity: 150,
    ),
    Event(
      title: 'Bible Study Workshop',
      location: 'Good Shepherd Cathedral',
      date: '20 Mar 2025 - 2:00 PM',
      tags: ['Education', 'Seminar'],
      likes: 42,
      color: Colors.orange.shade800,
      text: 'STUDY',
      isFeatured: true,
      startDate: DateTime(2025, 3, 20),
      startTime: const TimeOfDay(hour: 14, minute: 0),
      endTime: const TimeOfDay(hour: 16, minute: 30),
      description:
          'Learn effective methods for studying the Bible and deepen your understanding of scripture. This workshop is suitable for all levels.',
      contactInfo: '09345678901',
      venueName: 'Good Shepherd Cathedral Hall',
      speakers: ['Dr. Maria Santos', 'Biblical Studies Professor'],
      dressCode: 'Casual',
      inviteType: 'Open Invite',
      expectedCapacity: 100,
      allowsVolunteers: true, // This event allows volunteers
      volunteerRoles: [
        'Discussion Leader',
        'Hospitality Team',
        'Registration Staff',
      ],
      volunteersNeeded: 8,
    ),
    Event(
      title: 'Youth Fellowship Night',
      location: 'St. Mary\'s Parish',
      date: '25 Mar 2025 - 7:00 PM',
      tags: ['Community', 'Music'],
      likes: 78,
      color: Colors.teal.shade800,
      text: 'YOUTH',
      isFeatured: true,
      startDate: DateTime(2025, 3, 25),
      startTime: const TimeOfDay(hour: 19, minute: 0),
      endTime: const TimeOfDay(hour: 22, minute: 0),
      description:
          'A night of fellowship, games, and worship for young people. Come and connect with other youth from the community.',
      contactInfo: '09456789012',
      venueName: 'St. Mary\'s Parish Hall',
      speakers: ['Youth Ministry Team'],
      dressCode: 'Casual',
      inviteType: 'Open Invite',
      expectedCapacity: 120,
      allowsVolunteers: true, // This event allows volunteers
      volunteerRoles: [
        'Games Coordinator',
        'Worship Team',
        'Food Service',
        'Setup/Cleanup Crew',
      ],
      volunteersNeeded: 12,
    ),
    Event(
      title: 'Chapter Assembly',
      location: 'St. Mary\'s Parish',
      date: '25 Mar 2025 - 7:00 PM',
      tags: ['Community', 'Music'],
      likes: 90,
      color: Colors.teal.shade800,
      text: 'Couples',
      isFeatured: true,
      startDate: DateTime(2025, 3, 25),
      startTime: const TimeOfDay(hour: 19, minute: 0),
      endTime: const TimeOfDay(hour: 21, minute: 0),
      description:
          'Annual chapter assembly for all members. Important updates and planning for the year ahead.',
      contactInfo: '09567890123',
      venueName: 'St. Mary\'s Parish Hall',
      speakers: ['Chapter President', 'Executive Committee'],
      dressCode: 'Smart Casual',
      inviteType: 'Members Only',
      expectedCapacity: 80,
      invitedChurches:
          [
            'St. Paul Parish',
            'Good Shepherd Cathedral',
          ].map((name) => Church(name: name)).toList(),
      invitedGuests:
          [
            'Bishop James Rodriguez',
            'Fr. Peter Williams',
          ].map((name) => InvitedGuest(fullName: name)).toList(),
    ),
  ];

  // Derived list for featured events
  late List<Event> _featuredEvents;

  @override
  void initState() {
    super.initState();

    // Get featured events for the carousel - only the first 5 events
    _featuredEvents =
        _allEvents
            .where((event) => event.isFeatured == true)
            .take(5) // Only take the first 5 featured events for the carousel
            .toList();

    // Start automatic sliding with 1.5 second interval
    _startAutoSlide();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _featuredEventController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    // Auto slide every 1.5 seconds
    _autoSlideTimer = Timer.periodic(const Duration(milliseconds: 1500), (
      timer,
    ) {
      if (_featuredEventController.hasClients) {
        if (_currentFeaturedEventIndex < _featuredEvents.length - 1) {
          _currentFeaturedEventIndex++;
        } else {
          _currentFeaturedEventIndex = 0;
        }
        _featuredEventController.animateToPage(
          _currentFeaturedEventIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _toggleFilter(String filter) {
    setState(() {
      // If "All" is clicked
      if (filter == 'All') {
        // If "All" was active, deactivate it and all other filters
        if (_activeFilters['All']!) {
          _activeFilters.forEach((key, value) {
            _activeFilters[key] = false;
          });
          // Activate at least one filter to avoid having all filters off
          _activeFilters['Community'] = true;
        }
        // If "All" was inactive, activate all filters
        else {
          _activeFilters.forEach((key, value) {
            _activeFilters[key] = true;
          });
        }
      }
      // If any other filter is clicked
      else {
        // Before toggling, count how many filters are currently active
        int activeCount = 0;
        _activeFilters.forEach((key, value) {
          if (value && key != 'All') activeCount++;
        });
        // Only allow deactivating if there will still be at least one active filter
        if (!_activeFilters[filter]! || activeCount > 1) {
          // Toggle the selected filter
          _activeFilters[filter] = !_activeFilters[filter]!;
          // Update "All" filter status
          // If all other filters are active, "All" should be active
          bool allOthersActive = true;
          _activeFilters.forEach((key, value) {
            if (key != 'All' && !value) {
              allOthersActive = false;
            }
          });
          // Set "All" status based on other filters
          _activeFilters['All'] = allOthersActive;
        }
      }
    });
  }

  // Helper method to check if an event should be shown based on filters
  bool _shouldShowEvent(Event event) {
    // If "All" filter is active, show all events
    if (_activeFilters['All'] == true) {
      return true;
    }

    // Otherwise, check if any of the event's tags match active filters
    for (String tag in event.tags) {
      if (_activeFilters[tag] == true) {
        return true;
      }
    }

    return false;
  }

  // Navigate to event details page
  void _navigateToEventDetails(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventDetailsScreen(event: event)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Events Header
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
              Row(
                children: [
                  const Icon(
                    Icons.event_available_sharp,
                    size: 20,
                    color: Color(0xFF000233),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Events',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              Row(
                children: [
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
                ],
              ),
            ],
          ),
        ),

        // Events Content
        Expanded(
          child: Container(
            color: Colors.white,
            child: ListView(
              controller: widget.scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const ClampingScrollPhysics(),
              children: [
                const SizedBox(height: 16),

                // Join Popular Events Near You
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Join Popular Events ',
                            style: TextStyle(
                              color: Color(0xFF000233),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'Near You',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // PageView for automatic sliding
                    SizedBox(
                      height: 180,
                      child: PageView.builder(
                        controller: _featuredEventController,
                        itemCount: _featuredEvents.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentFeaturedEventIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap:
                                () => _navigateToEventDetails(
                                  _featuredEvents[index],
                                ),
                            child: _buildEventCard(
                              event: _featuredEvents[index],
                              isCarousel: true,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Browse for Events
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Browse for Events',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Filter buttons - first row
                    SizedBox(
                      height: 36,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () => _toggleFilter('All'),
                                child: _buildFilterButton(
                                  'All',
                                  _activeFilters['All']!,
                                  Icons.grid_4x4,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () => _toggleFilter('Healing'),
                                child: _buildFilterButton(
                                  'Healing',
                                  _activeFilters['Healing']!,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () => _toggleFilter('Seminar'),
                                child: _buildFilterButton(
                                  'Seminar',
                                  _activeFilters['Seminar']!,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () => _toggleFilter('Education'),
                                child: _buildFilterButton(
                                  'Education',
                                  _activeFilters['Education']!,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Filter buttons - second row
                    SizedBox(
                      height: 36,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap:
                                    () =>
                                        _toggleFilter('Religious Celebrations'),
                                child: _buildFilterButton(
                                  'Religious Celebrations',
                                  _activeFilters['Religious Celebrations']!,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () => _toggleFilter('Music'),
                                child: _buildFilterButton(
                                  'Music',
                                  _activeFilters['Music']!,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () => _toggleFilter('Community'),
                                child: _buildFilterButton(
                                  'Community',
                                  _activeFilters['Community']!,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Event cards - now using ListView.builder with filtered events
                    ...List.generate(_allEvents.length, (index) {
                      final event = _allEvents[index];

                      // Check if this event should be shown based on active filters
                      if (_shouldShowEvent(event)) {
                        return Column(
                          children: [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () => _navigateToEventDetails(event),
                                child: _buildEventCard(
                                  event: event,
                                  showProfileIcon: true,
                                  isCarousel: false,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink(); // Don't show filtered events
                      }
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Unified event card builder for both carousel and regular cards
  Widget _buildEventCard({
    required Event event,
    bool showProfileIcon = false,
    bool isCarousel = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Event image
            Container(
              height: isCarousel ? 180 : 160, // Different height based on type
              width: double.infinity,
              color: event.color,
              child: Center(
                child: Text(
                  event.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),

            // Event details overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title ?? 'Untitled Event',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Location and date in a more compact layout with horizontal scroll
                    SizedBox(
                      height: 20,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Location section
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              event.location ?? 'No location',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            // Very minimal spacing between location and time
                            const SizedBox(width: 8),
                            // Clock icon without white circle background
                            const Icon(
                              Icons.access_time,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              event.date ?? 'No date',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Event tags with prominent volunteer badge
                    SizedBox(
                      height: 20,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Show volunteer badge first if event allows volunteers
                            if (event.allowsVolunteers) ...[
                              _buildVolunteerBadge(event.volunteersNeeded ?? 0),
                              const SizedBox(width: 8),
                            ],
                            for (var tag in event.tags) ...[
                              _buildEventTag(tag),
                              const SizedBox(width: 8),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Likes: ${event.likes}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        // Updated profile icon with verification badge
                        if (showProfileIcon && !isCarousel)
                          Container(
                            // Add padding to ensure the badge has room
                            padding: const EdgeInsets.only(bottom: 4, right: 4),
                            child: Stack(
                              children: [
                                // Profile avatar - white circle
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 3,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                // Green verification badge
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 13,
                                    height: 13,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF2ECC71),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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

  Widget _buildFilterButton(String text, bool isActive, [IconData? icon]) {
    // Define gradient colors for active buttons
    final Gradient activeGradient = const LinearGradient(
      colors: [Color(0xFFFFAF00), Color(0xFFFFAF00)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        gradient: isActive ? activeGradient : null,
        color: isActive ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? Colors.transparent : const Color(0xFF000233),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isActive ? Colors.white : Colors.grey.shade700,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              text,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVolunteerBadge(int volunteersNeeded) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.green.shade600,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.volunteer_activism, color: Colors.white, size: 12),
          const SizedBox(width: 3),
          Text(
            '$volunteersNeeded Volunteers Needed',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 0.5),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
    );
  }
}
