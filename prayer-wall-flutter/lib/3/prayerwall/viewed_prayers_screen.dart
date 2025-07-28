import 'package:flutter/material.dart';
import '../models/prayer_post.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserPostsScreen extends StatefulWidget {
  final String userRole;

  const UserPostsScreen({super.key, required this.userRole});

  @override
  State<UserPostsScreen> createState() => _UserPostsScreenState();
}

class _UserPostsScreenState extends State<UserPostsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<PrayerPost> _sharedByMe = [];
  List<PrayerPost> _specificRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Set tab length based on user role
    int tabLength = widget.userRole == 'pastor' ? 2 : 1;
    _tabController = TabController(length: tabLength, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Always fetch user's own posts
      await _fetchSharedByMe();

      // Only fetch specific requests if user is a pastor
      if (widget.userRole == 'pastor') {
        await _fetchSpecificRequests();
      }
    } catch (e) {
      print('Error fetching data: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchSharedByMe() async {
    try {
      // Placeholder API call - replace with actual endpoint
      // final response = await http.get(Uri.parse('/api/my-posts'));
      // if (response.statusCode == 200) {
      //   final List<dynamic> data = json.decode(response.body);
      //   _sharedByMe = data.map((json) => PrayerPost.fromJson(json)).toList();
      // }

      // Mock data for testing
      await Future.delayed(const Duration(milliseconds: 500));
      _sharedByMe = [];
    } catch (e) {
      print('Error fetching shared by me: $e');
    }
  }

  Future<void> _fetchSpecificRequests() async {
    try {
      // Placeholder API call for pastor-specific requests
      // final response = await http.get(Uri.parse('/api/pastor-specific-prayers'));
      // if (response.statusCode == 200) {
      //   final List<dynamic> data = json.decode(response.body);
      //   _specificRequests = data.map((json) => PrayerPost.fromJson(json)).toList();
      // }

      // Mock data for testing
      await Future.delayed(const Duration(milliseconds: 500));
      _specificRequests = [];
    } catch (e) {
      print('Error fetching specific requests: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E2D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.userRole == 'pastor' ? 'Pastor Posts' : 'My Posts',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Info text
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF0A0E2D),
            child: Text(
              widget.userRole == 'pastor'
                  ? 'Manage your posts and specific prayer requests'
                  : 'View and manage all your prayer posts',
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          // Tab bar (only show if pastor has multiple tabs)
          if (widget.userRole == 'pastor')
            Container(
              color: const Color(0xFF0A0E2D),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: const Color(0xFF0A0E2D),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white.withOpacity(0.7),
                    tabs: const [
                      Tab(text: 'Shared by Me'),
                      Tab(text: 'Specific Requests'),
                    ],
                  ),
                ),
              ),
            ),
          // Content
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : widget.userRole == 'pastor'
                    ? TabBarView(
                      controller: _tabController,
                      children: [
                        // Shared by Me tab
                        _buildPrayersList(_sharedByMe, 'shared'),
                        // Specific Requests tab
                        _buildPrayersList(_specificRequests, 'specific'),
                      ],
                    )
                    : _buildPrayersList(
                      _sharedByMe,
                      'shared',
                    ), // User only sees their posts
          ),
        ],
      ),
    );
  }

  Widget _buildPrayersList(List<PrayerPost> prayers, String type) {
    if (prayers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              type == 'specific' ? Icons.person_outline : Icons.edit_note,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              type == 'specific' ? 'No specific requests yet' : 'No posts yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              type == 'specific'
                  ? 'Prayers specifically addressed to you will appear here'
                  : 'Your prayer posts will appear here',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: prayers.length,
        itemBuilder: (context, index) {
          final prayer = prayers[index];
          final cardColor = prayer.cardColor;

          return GestureDetector(
            onTap: () {
              _showPrayerDetails(context, prayer, cardColor);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User info row
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(prayer.userAvatar),
                          radius: 16,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prayer.userName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                timeago.format(prayer.createdAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (type == 'specific')
                          const Icon(
                            Icons.visibility,
                            color: Colors.white,
                            size: 16,
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Prayer content
                    Text(
                      prayer.content,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Stats row
                    Row(
                      children: [
                        _buildStatIcon(Icons.favorite, prayer.likes.toString()),
                        const SizedBox(width: 16),
                        _buildStatIcon(
                          Icons.front_hand_outlined,
                          prayer.prayers.toString(),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Your original prayer details design
  void _showPrayerDetails(
    BuildContext context,
    PrayerPost prayer,
    Color cardColor,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder:
                (context, scrollController) => Column(
                  children: [
                    // Handle
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(prayer.userAvatar),
                            radius: 20,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prayer.userName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                timeago.format(prayer.createdAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            '${prayer.likes} likes · ${prayer.prayers} prayers',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Prayer content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              prayer.content,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              prayer.details,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Like functionality
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.1),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              icon: Icon(
                                prayer.hasLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    prayer.hasLiked ? Colors.red : Colors.white,
                              ),
                              label: const Text('Like'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Pray functionality
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.1),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              icon: const Icon(Icons.front_hand_outlined),
                              label: const Text('Pray'),
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

  Widget _buildStatIcon(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 4),
        Text(
          count,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
        ),
      ],
    );
  }
}
