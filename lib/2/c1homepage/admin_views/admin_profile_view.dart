import 'package:flutter/material.dart';
import '../admin_types.dart';

class AdminProfileView extends StatefulWidget {
  final AdminData adminData;
  final Function(AdminData) onUpdateAdminData;

  const AdminProfileView({
    super.key,
    required this.adminData,
    required this.onUpdateAdminData,
  });

  @override
  State<AdminProfileView> createState() => _AdminProfileViewState();
}

class _AdminProfileViewState extends State<AdminProfileView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // TODO: Replace with backend data source
  List<Map<String, String>> get announcements => [
    {
      'title': 'Sunday New Comers Class',
      'description':
          'All those new visitors to STDC are invited to a welcome orientation class to learn about our church, our beliefs, and how to get connected with our church family.',
    },
    {
      'title': 'Evening Choir Ministry Appointment',
      'description':
          'Join us for our weekly choir practice session. All voices welcome! We\'ll be preparing for upcoming worship services and special events.',
    },
    {
      'title': 'Sunday Afternoon Bible Study',
      'description':
          'Come join us for an in-depth study of God\'s word. We meet every Sunday afternoon to dive deeper into scripture and grow in our faith together.',
    },
    {
      'title': 'Sunday Treasures Dental Event',
      'description':
          'Free dental care event for our community members. Professional dental services will be provided by volunteer dentists and hygienists.',
    },
  ];

  // TODO: Replace with backend data source
  List<Map<String, String>> get services => [
    {'title': 'Sunday Service', 'image': 'assets/images/sunday_service.jpg'},
    {'title': 'Evening Service', 'image': 'assets/images/evening_service.jpg'},
    {'title': 'Lectures', 'image': 'assets/images/lectures.jpg'},
    {'title': 'Choir', 'image': 'assets/images/choir.jpg'},
    {'title': 'Bible Study', 'image': 'assets/images/bible_study.jpg'},
    {'title': 'Youth Ministry', 'image': 'assets/images/youth_ministry.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          // Main tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildAnnouncementsTab(),
                _buildServicesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Header section with background, logo, and church name
  Widget _buildHeader() {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          // Background image with gradient overlay
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/church_interior.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Logo and church name overlay
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
              children: [
                _buildLogo(),
                SizedBox(height: 12),
                _buildChurchName(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Color(0xFFFFB800),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.wb_sunny, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildChurchName() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFF1E3A8A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Sunny Detroit Church',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Color(0xFF1E3A8A),
        unselectedLabelColor: Color(0xFF6B7280),
        indicatorColor: Color(0xFF1E3A8A),
        indicatorWeight: 2,
        labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Announcements'),
          Tab(text: 'Services'),
        ],
      ),
    );
  }

  // Overview Tab content
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Services',
            style: TextStyle(
              color: Color(0xFF1E3A8A),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _serviceCard(
                  'Sunday Worship',
                  '8:00 AM',
                  'assets/images/service1.jpg',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _serviceCard(
                  'Midweek Prayer',
                  '6:00 PM',
                  'assets/images/service2.jpg',
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          // Description
          Text(
            'Sunny Treasure Detroit Church is a welcoming faith community dedicated to spreading God\'s love through worship, service, and fellowship. Located in the heart of Detroit, we strive to become inspired spiritual individuals and develop a rooted faith, persistent joy, and a deeper connection with Christ. Join us as we worship, grow, and serve together in faith and love.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
              height: 1.6,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Pastors and Leaders',
            style: TextStyle(
              color: Color(0xFF1E3A8A),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _leaderCard(
                  'Pastor Juan De la Cruz',
                  'assets/images/pastor1.png',
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: _leaderCard(
                  'Pastor Mary Ann Smith',
                  'assets/images/pastor2.png',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Announcements Tab content
  Widget _buildAnnouncementsTab() {
    // When backend is ready, replace announcements getter with API data
    if (announcements.isEmpty) {
      return Center(
        child: Text(
          'No announcements yet.',
          style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: announcements.length,
      itemBuilder: (context, index) {
        final announcement = announcements[index];
        return _announcementCard(
          announcement['title']!,
          announcement['description']!,
        );
      },
    );
  }

  // Services Tab content
  Widget _buildServicesTab() {
    // When backend is ready, replace services getter with API data
    return GridView.builder(
      padding: EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _serviceGridCard(service['title']!, service['image']!);
      },
    );
  }

  // --- Widget Builders ---

  Widget _serviceGridCard(String title, String imagePath) {
    return GestureDetector(
      onTap: () => _showServiceDetails(title),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Color(0xFF1E3A8A),
                    child: Center(
                      child: Icon(Icons.church, size: 40, color: Colors.white),
                    ),
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showServiceDetails(String serviceName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _serviceDetailsDialog(serviceName);
      },
    );
  }

  Widget _serviceDetailsDialog(String serviceName) {
    return AlertDialog(
      title: Text(
        serviceName,
        style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
      ),
      content: Text(
        'Learn more about our $serviceName. Join us for this meaningful time of worship and fellowship.',
        style: TextStyle(color: Color(0xFF6B7280), height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Close',
            style: TextStyle(
              color: Color(0xFF1E3A8A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _announcementCard(String title, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Container(
            height: 32,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFDC2626),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                minimumSize: Size(0, 32),
              ),
              onPressed: () {
                _showAnnouncementDetails(title, description);
              },
              child: Text(
                'Details',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAnnouncementDetails(String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _announcementDetailsDialog(title, description);
      },
    );
  }

  Widget _announcementDetailsDialog(String title, String description) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
      ),
      content: Text(
        description,
        style: TextStyle(color: Color(0xFF6B7280), height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Close',
            style: TextStyle(
              color: Color(0xFF1E3A8A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _serviceCard(String title, String time, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(color: Color(0xFFF3F4F6)),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Color(0xFFF3F4F6),
                    child: Center(
                      child: Icon(
                        Icons.church,
                        size: 30,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E3A8A),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(color: Color(0xFF6B7280), fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _leaderCard(String name, String imagePath) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Color(0xFFF3F4F6),
                  child: Icon(Icons.person, size: 30, color: Color(0xFF1E3A8A)),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF374151),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
