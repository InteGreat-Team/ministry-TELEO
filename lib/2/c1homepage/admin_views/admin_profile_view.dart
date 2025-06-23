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
  bool isFollowing = false;

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
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with background image, logo, name, and follow button
            Stack(
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    child: Image.asset(
                      'assets/images/church_interior.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.church,
                              size: 60,
                              color: Colors.orange,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/church_logo.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.white,
                                    child: const Icon(
                                      Icons.church,
                                      size: 40,
                                      color: Color(0xFF1A237E),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2C2C6C),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              widget.adminData.churchName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFAA00),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isFollowing = !isFollowing;
                              });
                            },
                            child: Text(
                              isFollowing ? 'Joined Church' : 'Follow Church',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Tabs
            Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black45,
                indicatorColor: const Color(0xFF1A237E),
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                tabs: const [Tab(text: 'Overview'), Tab(text: 'Announcements')],
              ),
            ),
            // Tab content (no Expanded)
            SizedBox(
              height: 600, // Responsive height
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Overview Tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Upcoming Services',
                          style: TextStyle(
                            color: Color(0xFF1A237E),
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 180,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _serviceCard(
                                'Sunday Worship',
                                '8:00 AM',
                                'assets/images/service1.jpg',
                                'Join us!',
                              ),
                              const SizedBox(width: 16),
                              _serviceCard(
                                'Midweek Prayer',
                                '6:00 PM',
                                'assets/images/service2.jpg',
                                'Pop together',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        const Text(
                          'Sunny Treasure Detroit Church is a welcoming faith community dedicated to spreading God\'s love through worship, service, and fellowship. Located in the heart of Detroit, we strive to become inspired spiritual individuals and develop a rooted faith, persistent joy, and a deeper connection with Christ. Join us as we worship, grow, and serve together in faith and love.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Pastors and Leaders',
                          style: TextStyle(
                            color: Color(0xFF1A237E),
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _leaderCard(
                              'Pastor Juan De la Cruz',
                              'assets/images/pastor1.png',
                            ),
                            const SizedBox(width: 24),
                            _leaderCard(
                              'Pastor Mary Ann Smith',
                              'assets/images/pastor2.png',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Announcements Tab
                  const Center(
                    child: Text(
                      'No announcements yet.',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceCard(
    String title,
    String time,
    String imagePath,
    String? tag,
  ) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
                child: Image.asset(
                  imagePath,
                  height: 100,
                  width: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 100,
                      width: 180,
                      color: const Color(0xFFF5F5F5),
                      child: const Center(
                        child: Icon(
                          Icons.event,
                          size: 36,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (tag != null && tag.isNotEmpty)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    color: Color(0xFF1A237E),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _leaderCard(String name, String imagePath) {
    return Column(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundImage: AssetImage(imagePath),
          backgroundColor: Colors.grey[200],
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.person,
                size: 36,
                color: Color(0xFF1A237E),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 110,
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
