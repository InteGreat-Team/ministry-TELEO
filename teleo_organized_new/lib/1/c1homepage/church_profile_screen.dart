import 'package:flutter/material.dart';

class ChurchProfileScreen extends StatefulWidget {
  final Map<String, dynamic> churchData;

  const ChurchProfileScreen({super.key, required this.churchData});

  @override
  State<ChurchProfileScreen> createState() => _ChurchProfileScreenState();
}

class _ChurchProfileScreenState extends State<ChurchProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFollowing = false;

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF3E9BFF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Joined 08/12/23',
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
      body: Column(
        children: [
          // Header with church background, logo and name
          _buildHeader(),

          // Tab bar
          Container(
            color: const Color(0xFF001A33),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.7),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Announcements'),
                Tab(text: 'Services'),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: Container(
              color: const Color(0xFF001A33),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildAnnouncementsTab(),
                  _buildServicesTab(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        // Church interior background image
        Image.asset(
          'assets/images/church_interior.png',
          height: 300,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[800],
              child: const Icon(Icons.church, color: Colors.white54, size: 80),
            );
          },
        ),

        // Add a visible app bar with back button
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.only(
              top: 40,
              left: 8,
              right: 16,
              bottom: 8,
            ),
            child: Row(
              children: [
                // Prominent back button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // Joined date tag
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3E9BFF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Joined 08/12/23',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Dark overlay for bottom part
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xFF001A33)],
              ),
            ),
          ),
        ),

        // Church info card
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.only(top: 120),
            decoration: const BoxDecoration(
              color: Color(0xFF002642),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                // Church logo
                Container(
                  width: 120,
                  height: 120,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/church_logo.png',
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.white,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.wb_sunny,
                                  color: Colors.orange,
                                  size: 40,
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: 60,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.book,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Church name
                Text(
                  widget.churchData['name'] ?? 'Sunny Detroit Church',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Follow button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isFollowing = !_isFollowing;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _isFollowing
                                  ? 'You are now following ${widget.churchData['name'] ?? 'Sunny Detroit Church'}'
                                  : 'You have unfollowed ${widget.churchData['name'] ?? 'Sunny Detroit Church'}',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3E9BFF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        _isFollowing ? 'Following' : 'Follow Church',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Featured services section
        const Text(
          'Featured Services',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Featured service cards
        _buildServiceCard(
          'Sunday Mass',
          'assets/images/church_interior.jpg',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sunday Mass details coming soon')),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildServiceCard(
          'Bible Study',
          'assets/images/bible_study.jpg',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Bible Study details coming soon')),
            );
          },
        ),

        const SizedBox(height: 24),

        // Church description
        const Text(
          'About Our Church',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Welcome to our vibrant church community! We are dedicated to spreading God\'s love and fostering spiritual growth through worship, fellowship, and service.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 16,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 24),

        // Church statistics
        const Text(
          'Church Statistics',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildStatsRow(),

        const SizedBox(height: 24),

        // Church leadership
        const Text(
          'Church Leadership',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildPastorCard(
                'Fr. John Smith',
                'Parish Priest',
                'assets/images/profile.jpg',
              ),
              const SizedBox(width: 16),
              _buildPastorCard(
                'Fr. Michael Brown',
                'Assistant Priest',
                'assets/images/profile.jpg',
              ),
              const SizedBox(width: 16),
              _buildPastorCard(
                'Fr. David Wilson',
                'Assistant Priest',
                'assets/images/profile.jpg',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnnouncementsTab() {
    final List<Map<String, dynamic>> announcements = [
      {
        'title': 'Sunday Mass Cancelled',
        'type': 'Mass',
        'content':
            'Brothers and Sisters in Christ, we regret to inform you that Sunday mass on the 27th of April is cancelled due to extreme weather forecasts.',
      },
      {
        'title': 'Leader Coco Martin Appointed!',
        'type': 'News',
        'content':
            'Brothers and Sisters in Christ, we are delighted to inform you that our brother, Coco Martin, has been appointed as church leader!',
      },
      {
        'title': 'Sunny Treasure Detroit Feast',
        'type': 'News',
        'content':
            'Brothers and Sisters in Christ, we are elated to host a church feast to be held at Sunny Treasure Mess Hall on the 21st of May, 10:00 AM to 2:00 PM.',
      },
      {
        'title': 'Sunny Treasure Detroit Feast',
        'type': 'News',
        'content':
            'Brothers and Sisters in Christ, we are elated to host a church feast to be held at Sunny Treasure Mess Hall on the 21st of May, 10:00 AM to 2:00 PM.',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: announcements.length,
      itemBuilder: (context, index) {
        final announcement = announcements[index];
        return _buildAnnouncementCard(
          announcement['title'],
          announcement['type'],
          announcement['content'],
        );
      },
    );
  }

  Widget _buildServicesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildServiceCard(
          'Wedding Service',
          'assets/images/wedding_service.jpg',
          onTap: () {
            // TODO: Implement wedding service detail navigation
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Wedding Service details coming soon'),
              ),
            );
          },
        ),
        _buildServiceCard(
          'Funeral Services',
          'assets/images/funeral_service.jpg',
          onTap: () {
            // TODO: Implement funeral service detail navigation
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Funeral Service details coming soon'),
              ),
            );
          },
        ),
        _buildServiceCard(
          'Baptism',
          'assets/images/baptism.jpg',
          onTap: () {
            // TODO: Implement baptism detail navigation
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Baptism details coming soon')),
            );
          },
        ),
        _buildServiceCard(
          'Youth',
          'assets/images/youth.jpg',
          onTap: () {
            // TODO: Implement youth group detail navigation
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Youth group details coming soon')),
            );
          },
        ),
        _buildServiceCard(
          'Outreach',
          'assets/images/outreach.jpg',
          onTap: () {
            // TODO: Implement outreach detail navigation
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Outreach details coming soon')),
            );
          },
        ),
        _buildServiceCard(
          'Bible Study',
          'assets/images/bible_study.jpg',
          onTap: () {
            // TODO: Implement bible study detail navigation
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Bible study details coming soon')),
            );
          },
        ),
        _buildServiceCard(
          'Ordination',
          'assets/images/ordination.jpg',
          onTap: () {
            // TODO: Implement ordination detail navigation
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ordination details coming soon')),
            );
          },
        ),
        _buildServiceCard(
          'Blaine',
          'assets/images/blaine.jpg',
          onTap: () {
            // TODO: Implement Blaine detail navigation
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Blaine details coming soon')),
            );
          },
        ),
        _buildServiceCard(
          'Other Services',
          'assets/images/other_services.jpg',
          onTap: () {
            // TODO: Implement other services detail navigation
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Other services details coming soon'),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildServiceCard(
    String title,
    String imagePath, {
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF002642),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Stack(
              children: [
                Image.asset(
                  imagePath,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120,
                      width: double.infinity,
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.church,
                        color: Colors.white54,
                        size: 40,
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Join',
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
          ),

          // Service details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Every Sunday',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Every Sunday',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPastorCard(String name, String role, String imagePath) {
    return Column(
      children: [
        // Pastor image
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.person, color: Colors.grey, size: 60),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Pastor name and role
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),

        Text(
          role,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAnnouncementCard(String title, String type, String content) {
    Color tagColor;

    switch (type.toLowerCase()) {
      case 'mass':
        tagColor = const Color(0xFFD14836);
        break;
      case 'news':
        tagColor = const Color(0xFFD14836);
        break;
      default:
        tagColor = Colors.blue;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and tag
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF001A33),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: tagColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    type,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Content
            Text(
              content,
              style: const TextStyle(
                color: Color(0xFF001A33),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF001A33),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                'assets/images/home_icon.png',
                'Home',
                isSelected: false,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _buildNavItem(
                context,
                'assets/images/heart_icon.png',
                'Favorites',
                isSelected: false,
                onTap: () {
                  // Favorites functionality
                },
              ),
              _buildPrayButton(
                onTap: () {
                  // Pray functionality
                },
              ),
              _buildNavItem(
                context,
                'assets/images/bible_icon.png',
                'Bible',
                isSelected: false,
                onTap: () {
                  // Bible functionality
                },
              ),
              _buildNavItem(
                context,
                'assets/images/profile_icon.png',
                'Profile',
                isSelected: false,
                onTap: () {
                  // Navigate to profile
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 4. Add helper methods for the bottom navigation bar
  Widget _buildNavItem(
    BuildContext context,
    String iconPath,
    String label, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            width: 24,
            height: 24,
            color: isSelected ? const Color(0xFF3E9BFF) : Colors.white,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                label == 'Home'
                    ? Icons.home_outlined
                    : label == 'Favorites'
                    ? Icons.favorite_border
                    : label == 'Bible'
                    ? Icons.book_outlined
                    : Icons.person_outline,
                color: isSelected ? const Color(0xFF3E9BFF) : Colors.white,
                size: 24,
              );
            },
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color:
                  isSelected
                      ? const Color(0xFF3E9BFF)
                      : Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFF3E9BFF),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3E9BFF).withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            'assets/images/pray_icon.png',
            width: 32,
            height: 32,
            color: Colors.white,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.volunteer_activism,
                color: Colors.white,
                size: 32,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('Members', '500+'),
        _buildStatItem('Services', '10+'),
        _buildStatItem('Years', '25+'),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
        ),
      ],
    );
  }
}
