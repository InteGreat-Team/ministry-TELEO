import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../BE/models/prayer_post.dart';
import '../../BE/providers/history_prayer_provider.dart';
import '../../BE/providers/history_read_provider.dart';
import 'package:intl/intl.dart';

class UserPostsScreen extends StatefulWidget {
  final String userRole;

  const UserPostsScreen({super.key, required this.userRole});

  @override
  State<UserPostsScreen> createState() => _UserPostsScreenState();
}

class _UserPostsScreenState extends State<UserPostsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Add 1 extra tab for "History"
    int tabLength = widget.userRole == 'pastor' ? 3 : 2;
    _tabController = TabController(length: tabLength, vsync: this);
    _tabController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData(); // ✅ safe, runs after first frame
      _fetchHistoryData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchHistoryData() async {
    final historyProvider =
        Provider.of<HistoryReadProvider>(context, listen: false);
    try {
      await historyProvider.fetchReadPrayers();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading history: $e')));
      }
    }
  }

  Future<void> _fetchData() async {
    final viewModel = Provider.of<UserPostsViewModel>(context, listen: false);
    try {
      await viewModel.fetchData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserPostsViewModel>(context);

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

          // Tab bar for BOTH roles (keeps your original styling)
          Container(
            color: const Color(0xFF0A0E2D),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                  tabs: widget.userRole == 'pastor'
                      ? const [
                          Tab(text: 'Shared by Me'),
                          Tab(text: 'Specific Requests'),
                          Tab(text: 'History'),
                        ]
                      : const [
                          Tab(text: 'My Posts'),
                          Tab(text: 'History'),
                        ],
                ),
              ),
            ),
          ),

          Expanded(
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: widget.userRole == 'pastor'
                        ? [
                            _buildPrayersList(viewModel.sharedByMe, 'shared'),
                            _buildPrayersList(
                                viewModel.specificRequests, 'specific'),
                            _buildHistoryTab(), // empty for now
                          ]
                        : [
                            _buildPrayersList(viewModel.sharedByMe, 'shared'),
                            _buildHistoryTab(), // empty for now
                          ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Consumer<HistoryReadProvider>(
      builder: (context, historyProvider, _) {
        if (historyProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (historyProvider.errorMessage != null) {
          return Center(child: Text(historyProvider.errorMessage!));
        }

        if (historyProvider.readPrayers.isEmpty) {
          return const Center(child: Text("No read prayers found"));
        }

        // ✅ Reuse your existing list builder
        return _buildPrayersList(historyProvider.readPrayers, 'history');
      },
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
            onTap: () => _showPrayerDetails(context, prayer, cardColor),
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
                                DateFormat('MMM d, yyyy • hh:mm a')
                                    .format(prayer.createdAt),
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
                    Row(
                      children: [
                        _buildStatIcon(Icons.favorite, prayer.likes.toString()),
                        const SizedBox(width: 16),
                        _buildStatIcon(
                          Icons.front_hand_outlined,
                          prayer.comments.toString(),
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
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
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
                        prayer.tags.join(', '),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        DateFormat('MMM d, yyyy • hh:mm a')
                            .format(prayer.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '${prayer.likes} likes · ${prayer.comments} prayers',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
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
