import 'package:flutter/material.dart';
import 'c2s2_2ethostedevents.dart'; // Import the edit event page
import 'c2s3ethostedevents.dart'; // Import the AttendeeDetailPage
// Import the VolunteerDetailPage
import 'c2s4_3ethostedevents.dart'; // Import the EnhancedVolunteersTab
import 'c2s5ethostedevents.dart'; // Import the EventAnalyticsPage

class EventDetailPage extends StatefulWidget {
  final Map<String, dynamic> eventData;

  const EventDetailPage({super.key, required this.eventData});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedStatus = 'ALL';
  
  // Track expanded churches
  final Map<String, bool> _expandedChurches = {};

  final String _selectedVolunteerStatus = 'ALL';
  final TextEditingController _volunteerSearchController = TextEditingController();
  String _volunteerSearchQuery = '';

  // Local copy of event data that can be updated
  late Map<String, dynamic> _eventData;
  
  // Current image index for the image carousel
  int _currentImageIndex = 0;
  
  // Page controller for the image carousel
  late PageController _imagePageController;

  // Sample data for volunteers
  final List<Map<String, dynamic>> dummyVolunteers = [
    {
      'name': 'John Doe',
      'church': 'First Baptist Church',
      'role': 'Usher',
      'status': 'Pending',
      'photo': 'assets/images/volunteer1.jpg',
      'date': 'March 15, 2023',
      'personalInfo': {
        'email': 'john.doe@example.com',
        'phone': '+1 (555) 123-4567',
        'address': '123 Main St, Anytown, USA',
        'age': 28,
        'gender': 'Male',
        'occupation': 'Software Developer',
      },
      'applicationForm': {
        'submissionDate': 'March 10, 2023',
        'positionApplied': 'Usher',
        'previousExperience': 'Served as usher at previous church for 2 years',
        'availability': 'Weekends and evenings',
        'specialSkills': 'People skills, organization',
        'references': 'Pastor Mike (555-1234)',
      },
    },
    // ... other volunteer data (unchanged)
  ];

  // Sample data for churches and attendees
  final List<Map<String, dynamic>> dummyChurches = [
    {
      'name': 'First Baptist Church',
      'attendees': [
        {
          'name': 'John Smith',
          'email': 'john.smith@example.com',
          'phone': '+1 (555) 123-4567',
          'status': 'CONFIRMED',
          'registrationDate': 'March 10, 2023',
        },
        {
          'name': 'Jane Doe',
          'email': 'jane.doe@example.com',
          'phone': '+1 (555) 987-6543',
          'status': 'PENDING',
          'registrationDate': 'March 11, 2023',
        },
      ],
    },
    {
      'name': 'Grace Community Church',
      'attendees': [
        {
          'name': 'Michael Johnson',
          'email': 'michael.j@example.com',
          'phone': '+1 (555) 222-3333',
          'status': 'CONFIRMED',
          'registrationDate': 'March 9, 2023',
        },
        {
          'name': 'Sarah Williams',
          'email': 'sarah.w@example.com',
          'phone': '+1 (555) 444-5555',
          'status': 'CANCELLED',
          'registrationDate': 'March 8, 2023',
        },
      ],
    },
    {
      'name': 'Hope Fellowship',
      'attendees': [
        {
          'name': 'Robert Brown',
          'email': 'robert.b@example.com',
          'phone': '+1 (555) 666-7777',
          'status': 'CONFIRMED',
          'registrationDate': 'March 7, 2023',
        },
      ],
    },
  ];

  // Get filtered volunteers based on search query and selected status
  List<Map<String, dynamic>> get _filteredVolunteers {
    // ... unchanged
    return dummyVolunteers;
  }

  // Navigate to volunteer detail page
  void _navigateToVolunteerDetail(Map<String, dynamic> volunteer) {
    // ... unchanged
  }

  // Navigate to edit event page
  void _navigateToEditEvent() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEventPage(eventData: _eventData),
      ),
    );
    
    // If we got updated data back, update the state
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        // Update the local event data with the new values
        _eventData = Map<String, dynamic>.from(result);
        
        // Reset image carousel to first image
        _currentImageIndex = 0;
        _imagePageController.jumpToPage(0);
        
        // Debug print to verify image data
        print("Updated event data: ${_eventData['eventImages']}");
      });
      
      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event details updated successfully')),
      );
      
      // Pass the updated data back to the previous screen
      Navigator.pop(context, _eventData);
    }
  }

  // Show cancel event confirmation dialog with updated UI
  void _showCancelEventDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF2196F3), width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with icon and title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.warning_rounded,
                        color: Color(0xFF2196F3),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Cancel Event',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Message
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Are you sure you want to cancel this event? This action cannot be undone.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('No'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                          
                          // Create a canceled event data object with minimal required fields
                          final canceledEventData = {
                            'canceled': true,
                            'title': _eventData['title'] ?? 'Canceled Event',
                            'imageUrl': _eventData['imageUrl'],
                            // Add any other required fields with default values
                            'eventImages': [], // Empty list to prevent RangeError
                            'selectedImages': [], // Empty list to prevent RangeError
                          };
                          
                          // Return to previous screen with canceled event data
                          Navigator.pop(context, canceledEventData);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Yes, Cancel Event'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    print("EventDetailPage initialized with data: ${widget.eventData}"); // Debug print
    
    // Create a local copy of the event data
    _eventData = Map<String, dynamic>.from(widget.eventData);
    
    // Initialize page controller for image carousel
    _imagePageController = PageController();
    
    _tabController = TabController(length: 4, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
    _volunteerSearchController.addListener(() {
      setState(() {
        _volunteerSearchQuery = _volunteerSearchController.text;
      });
    });
    
    // Initially expand all churches
    for (var church in dummyChurches) {
      _expandedChurches[church['name']] = true;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _volunteerSearchController.dispose();
    _imagePageController.dispose();
    super.dispose();
  }

  // Get filtered churches based on search query and selected status
  List<Map<String, dynamic>> get _filteredChurches {
    return dummyChurches.map((church) {
      final Map<String, dynamic> filteredChurch = Map<String, dynamic>.from(church);
      
      // Filter attendees based on search query and selected status
      final List<Map<String, dynamic>> filteredAttendees = (church['attendees'] as List)
          .cast<Map<String, dynamic>>()
          .where((attendee) {
            final matchesSearch = attendee['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
                                 attendee['email'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
                                 attendee['phone'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
            
            final matchesStatus = _selectedStatus == 'ALL' || attendee['status'] == _selectedStatus;
            
            return matchesSearch && matchesStatus;
          })
          .toList();
      
      filteredChurch['attendees'] = filteredAttendees;
      return filteredChurch;
    }).where((church) => (church['attendees'] as List).isNotEmpty).toList();
  }

  // Navigate to attendee detail page
  void _navigateToAttendeeDetail(Map<String, dynamic> attendee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendeeDetailPage(
          attendeeData: attendee,
          eventData: _eventData, attendee: {},
        ),
      ),
    );
  }
  
  // Get event images
  List<Map<String, dynamic>> get _eventImages {
    if (_eventData.containsKey('eventImages') && 
        _eventData['eventImages'] is List && 
        (_eventData['eventImages'] as List).isNotEmpty) {
      return List<Map<String, dynamic>>.from(_eventData['eventImages']);
    } else {
      // Fallback to single image if no eventImages array
      return [
        {
          'url': _eventData['imageUrl'] ?? 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-5ie8lHl9F4eq57TmKSu8zKV6fzmIHK.png',
          'label': 'Main Event Image',
          'isDefault': true
        }
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFF0A0E3D),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  _eventData['title'] ?? 'Event Details',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image carousel
                    PageView.builder(
                      controller: _imagePageController,
                      itemCount: _eventImages.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final image = _eventImages[index];
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            // Background image
                            image.containsKey('file') && image['file'] != null
                                ? Image.file(
                                    image['file'],
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    image['url'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      print("Error loading image: $error");
                                      return _buildDefaultEventBackground();
                                    },
                                  ),
                            // Image label
                            Positioned(
                              top: 40,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  image['label'] ?? 'Image ${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    // Gradient overlay for better text visibility
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    // Image indicators
                    if (_eventImages.length > 1)
                      Positioned(
                        bottom: 60,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_eventImages.length, (index) {
                            return Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentImageIndex == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                              ),
                            );
                          }),
                        ),
                      ),
                  ],
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(_eventData),
              ),
              actions: [
                if (_eventImages.length > 1)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Image ${_currentImageIndex + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFF0A0E3D),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: const Color(0xFF0A0E3D),
                  labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: const TextStyle(fontSize: 11),
                  tabs: const [
                    Tab(text: 'OVERVIEW'),
                    Tab(text: 'ATTENDEE'),
                    Tab(text: 'VOLUNTEER'),
                    Tab(text: 'ANALYTICS'),
                  ],
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Overview Tab
            _buildOverviewTab(),
            
            // Attendees Tab
            _buildAttendeesTab(),
            
            // Volunteers Tab - Use the enhanced version
            EnhancedVolunteersTab(eventData: _eventData),
            
            // Analytics Tab
            _buildAnalyticsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultEventBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF6A1B9A),
            Color(0xFF0A0E3D),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SIGNIFICANT',
              style: TextStyle(
                color: Colors.orange[300],
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'MARRIAGE',
              style: TextStyle(
                color: Colors.orange[300],
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'FEB 14, 7PM',
              style: TextStyle(
                color: Colors.orange[100],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event organization info
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 16,
                child: Icon(Icons.church, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              const Text(
                'Church Name Organization',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Date, Time, Location, Fee sections
          _buildInfoRow(
            icon: Icons.calendar_today,
            title: 'Date',
            content: _eventData['time']?.toString().split(' - ')[0] ?? 'Sunday, March 30',
            color: Colors.blue,
          ),
          
          _buildInfoRow(
            icon: Icons.access_time,
            title: 'Time',
            content: _eventData['time']?.toString().split(' - ')[1] ?? '5:00 PM - 8:00 PM',
            color: Colors.orange,
          ),
          
          _buildInfoRow(
            icon: Icons.location_on,
            title: 'Location',
            content: _eventData['location'] ?? 'Serraplique, Paranaque\nComplete address with google maps link',
            color: Colors.red,
          ),
          
          _buildInfoRow(
            icon: Icons.attach_money,
            title: 'Event Fee',
            content: _eventData['eventFee'] != null ? 'P${_eventData['eventFee']}/pax' : 'P200.00 /pax',
            color: Colors.green,
          ),
          
          const SizedBox(height: 24),
          
          // About Event section
          const Text(
            'About Event',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            _eventData['description'] ?? 'Our event focuses on the sly brown fox jumped over the hedge and into a new life. Just as a fox in the wild, this is where you put the event description and every breath you take, every move you make, what am I even saying.\n\nI don\'t know what to put here so just let me ramble on about the event. Indeed. Let us be glad, let us be grateful, let us rectify that needless little outburst.\n\nMore more I say yet I need so I like my girls pretty so fine one plus one equals two I like my girls pretty so fine one plus one equals two I like my girls pretty so fine activity in the...',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 8),
          
          TextButton(
            onPressed: () {
              // Show full description
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('See Less'),
          ),
          
          const SizedBox(height: 24),
          
          // Organizers section
          const Text(
            'Organizers',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          
          const SizedBox(height: 8),
          
          const Text(
            'Church Name Organization\nSpecial Thanks to the people\nSPECIAL',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Speakers/Guests section
          const Text(
            'Speakers/Guests',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            _eventData['speakers'] != null 
                ? (_eventData['speakers'] as List).join('\n')
                : 'Christian Tuan Guia\nPastor Jean Jungkook',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Participants section
          const Text(
            'Participants',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          
          const SizedBox(height: 8),
          
          const Text(
            'Couple Attendees',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Dress code section
          const Text(
            'Dress code',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            _eventData['dressCode'] ?? 'Semi-formal',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _showCancelEventDialog, // Connect to the cancel event dialog
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xFF0A0A4A)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Cancel Event',
                    style: TextStyle(
                      color: Color(0xFF0A0A4A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _navigateToEditEvent, // Connect to the edit event method
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: const Color(0xFF0A0E3D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Edit Event Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendeesTab() {
    return Column(
      children: [
        // Search and filter bar
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search attendees...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Status filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildStatusFilterChip('ALL', 'All'),
                    _buildStatusFilterChip('CONFIRMED', 'Confirmed'),
                    _buildStatusFilterChip('PENDING', 'Pending'),
                    _buildStatusFilterChip('CANCELLED', 'Cancelled'),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Attendees list
        Expanded(
          child: _filteredChurches.isEmpty
              ? Center(
                  child: Text(
                    'No attendees found',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: _filteredChurches.length,
                  itemBuilder: (context, churchIndex) {
                    final church = _filteredChurches[churchIndex];
                    final isExpanded = _expandedChurches[church['name']] ?? false;
                    final attendees = church['attendees'] as List;
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Church header
                        InkWell(
                          onTap: () {
                            setState(() {
                              _expandedChurches[church['name']] = !isExpanded;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                const Icon(Icons.church, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${church['name']} (${attendees.length})',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Icon(
                                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // Attendees list for this church
                        if (isExpanded)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: attendees.length,
                            itemBuilder: (context, attendeeIndex) {
                              final attendee = attendees[attendeeIndex] as Map<String, dynamic>;
                              return InkWell(
                                onTap: () => _navigateToAttendeeDetail(attendee),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.grey[200]!),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Profile circle
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            attendee['name'].toString().substring(0, 1).toUpperCase(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      
                                      // Attendee info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              attendee['name'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              attendee['email'],
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      // Status badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(attendee['status']).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          attendee['status'],
                                          style: TextStyle(
                                            color: _getStatusColor(attendee['status']),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        
                        // Divider between churches
                        Divider(height: 1, thickness: 1, color: Colors.grey[300]),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatusFilterChip(String status, String label) {
    final isSelected = _selectedStatus == status;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = status;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0A0E3D) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF0A0E3D) : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return EventAnalyticsContent(eventData: _eventData);
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'CONFIRMED':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
