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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;
  bool _isCardView = true; // Toggle between card and list view

  @override
  void initState() {
    super.initState();
    int tabLength = widget.userRole == 'pastor' ? 3 : 2;
    _tabController = TabController(length: tabLength, vsync: this);
    _tabController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
      _fetchHistoryData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
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
        ).showSnackBar(SnackBar(
          content: Text('Error loading history: $e'),
          backgroundColor: Colors.red.shade600,
        ));
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
        ).showSnackBar(SnackBar(
          content: Text('Error loading data: $e'),
          backgroundColor: Colors.red.shade600,
        ));
      }
    }
  }

  List<PrayerPost> _filterPrayers(List<PrayerPost> prayers) {
    if (_searchQuery.isEmpty) return prayers;
    return prayers.where((prayer) =>
        prayer.content.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        prayer.userName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        prayer.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()))
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserPostsViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
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
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isCardView ? Icons.view_list : Icons.view_module,
              color: Colors.white,
            ),
            onPressed: () => setState(() => _isCardView = !_isCardView),
            tooltip: _isCardView ? 'Switch to List View' : 'Switch to Card View',
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => _showSearchOverlay(),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildEnhancedHeader(viewModel),
              _buildEnhancedTabBar(),
              Expanded(
                child: viewModel.isLoading
                    ? _buildSkeletonLoader()
                    : TabBarView(
                        controller: _tabController,
                        children: widget.userRole == 'pastor'
                            ? [
                                _buildPrayersList(_filterPrayers(viewModel.sharedByMe), 'shared'),
                                _buildPrayersList(
                                    _filterPrayers(viewModel.specificRequests), 'specific'),
                                _buildHistoryTab(),
                              ]
                            : [
                                _buildPrayersList(_filterPrayers(viewModel.sharedByMe), 'shared'),
                                _buildHistoryTab(),
                              ],
                      ),
              ),
            ],
          ),
          if (_isSearching) _buildSearchOverlay(),
        ],
      ),
    );
  }

  Widget _buildEnhancedHeader(viewModel) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A0E2D),
            Color(0xFF1A1F3A),
          ],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
            child: _buildStatsRow(viewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatsRow(viewModel) {
    final totalPosts = (viewModel.sharedByMe?.length ?? 0) + 
                     (viewModel.specificRequests?.length ?? 0);
    
    return Consumer<HistoryReadProvider>(
      builder: (context, historyProvider, _) {
        final readPrayers = historyProvider?.readPrayers?.length ?? 0;
        
        bool isHistoryTab = _tabController.index == (_tabController.length - 1);
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCompactStatItem(
                isHistoryTab ? 'Read' : 'Posts',
                isHistoryTab ? '$readPrayers' : '$totalPosts',
                isHistoryTab ? Icons.visibility : Icons.edit_note,
              ),
              Container(
                width: 1,
                height: 24,
                color: Colors.white.withOpacity(0.3),
              ),
              _buildCompactStatItem(
                'Shared',
                '${viewModel.sharedByMe?.length ?? 0}',
                Icons.public,
              ),
              if (widget.userRole == 'pastor') ...[
                Container(
                  width: 1,
                  height: 24,
                  color: Colors.white.withOpacity(0.3),
                ),
                _buildCompactStatItem(
                  'Specific',
                  '${viewModel.specificRequests?.length ?? 0}',
                  Icons.person_outline,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildCompactStatItem(String label, String value, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.8),
          size: 16,
        ),
        const SizedBox(width: 6),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEnhancedTabBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0A0E2D),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
        child: Container(
          height: 40, // Reduced height from 48 to 40
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.white, Color(0xFFF8F9FA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            labelColor: const Color(0xFF0A0E2D),
            unselectedLabelColor: Colors.white.withOpacity(0.8),
            labelStyle: const TextStyle(
              fontSize: 13, // Reduced font size
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 13, // Reduced font size
              fontWeight: FontWeight.w500,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
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
    );
  }

  Widget _buildStatsRow(viewModel) {
    final totalPosts = (viewModel.sharedByMe?.length ?? 0) + 
                     (viewModel.specificRequests?.length ?? 0);
    
    return Consumer<HistoryReadProvider>(
      builder: (context, historyProvider, _) {
        final readPrayers = historyProvider?.readPrayers?.length ?? 0;
        
        String getStatsText() {
          if (_tabController.index == (_tabController.length - 1)) {
            // History tab (always last tab)
            return readPrayers == 1 ? 'I read 1 prayer!' : 'I read $readPrayers prayers!';
          } else {
            // My Posts tab (or Shared by Me for pastor)
            return totalPosts == 1 ? 'I posted 1 prayer!' : 'I posted $totalPosts prayers!';
          }
        }
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _tabController.index == (_tabController.length - 1) 
                      ? Icons.visibility 
                      : Icons.edit_note,
                    color: Colors.white70,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    getStatsText(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(String label, String count, IconData icon, {bool isConversational = false}) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        if (isConversational) ...[
          Text(
            count,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ] else ...[
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSearchOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: Color(0xFF0A0E2D),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Search Posts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A0E2D),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _isSearching = false),
                    icon: const Icon(Icons.close, color: Color(0xFF0A0E2D)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search by content, user, or tags...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF0A0E2D)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF0A0E2D), width: 2),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                          _searchController.clear();
                          _isSearching = false;
                        });
                      },
                      child: const Text(
                        'Clear',
                        style: TextStyle(color: Color(0xFF0A0E2D)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => _isSearching = false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A0E2D),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSearchOverlay() {
    setState(() {
      _isSearching = true;
    });
  }

  Widget _buildSkeletonLoader() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 150,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Consumer<HistoryReadProvider>(
      builder: (context, historyProvider, _) {
        if (historyProvider.isLoading) {
          return _buildSkeletonLoader();
        }

        if (historyProvider.errorMessage != null) {
          return _buildErrorState(historyProvider.errorMessage!);
        }

        if (historyProvider.readPrayers.isEmpty) {
          return _buildEmptyHistoryState();
        }

        return RefreshIndicator(
          onRefresh: _fetchData,
          child: _isCardView 
            ? _buildHistoryCardView(_filterPrayers(historyProvider.readPrayers))
            : _buildHistoryListView(_filterPrayers(historyProvider.readPrayers)),
        );
      },
    );
  }

  Widget _buildHistoryCardView(List<PrayerPost> prayers) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: prayers.length,
      itemExtent: 200,
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
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              _formatDate(prayer.createdAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Read',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Text(
                      prayer.content,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.4,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        size: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${prayer.likes}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.comment,
                        size: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${prayer.comments}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistoryListView(List<PrayerPost> prayers) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: prayers.length,
      itemBuilder: (context, index) {
        final prayer = prayers[index];
        final cardColor = prayer.cardColor;

        return GestureDetector(
          onTap: () => _showPrayerDetails(context, prayer, cardColor),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: cardColor.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                // Color indicator
                Container(
                  width: 3,
                  height: 40,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                // Avatar
                CircleAvatar(
                  backgroundImage: AssetImage(prayer.userAvatar),
                  radius: 16,
                ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              prayer.userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Color(0xFF0A0E2D),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: cardColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Read',
                              style: TextStyle(
                                fontSize: 9,
                                color: cardColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        prayer.content,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            _formatDate(prayer.createdAt),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.favorite,
                            size: 12,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${prayer.likes}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.comment,
                            size: 12,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${prayer.comments}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
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
      },
    );
  }

  Widget _buildEmptyHistoryState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0E2D).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history,
              size: 64,
              color: const Color(0xFF0A0E2D).withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Prayer History Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A0E2D),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Your prayer reading history will appear here. Start reading prayers to build your spiritual journey timeline.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.explore),
            label: const Text('Explore Prayers'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A0E2D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTimeline(List<PrayerPost> prayers) {
    return RefreshIndicator(
      onRefresh: _fetchHistoryData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: prayers.length,
        itemBuilder: (context, index) {
          final prayer = prayers[index];
          final isFirst = index == 0;
          final isLast = index == prayers.length - 1;
          
          return _buildTimelineItem(prayer, isFirst, isLast);
        },
      ),
    );
  }

  Widget _buildTimelineItem(PrayerPost prayer, bool isFirst, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              if (!isFirst)
                Container(
                  width: 2,
                  height: 20,
                  color: const Color(0xFF0A0E2D).withOpacity(0.3),
                ),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0E2D),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFF0A0E2D).withOpacity(0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF0A0E2D).withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
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
                                color: Color(0xFF0A0E2D),
                              ),
                            ),
                            Text(
                              'Read ${DateFormat('MMM d, yyyy • hh:mm a').format(prayer.createdAt)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.check_circle,
                        color: Colors.green[600],
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    prayer.content,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF0A0E2D),
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildHistoryStatIcon(Icons.favorite, prayer.likes.toString(), Colors.red),
                      const SizedBox(width: 16),
                      _buildHistoryStatIcon(Icons.front_hand_outlined, prayer.comments.toString(), Colors.blue),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryStatIcon(IconData icon, String count, Color color) {
    return Row(
      children: [
        Icon(icon, color: color.withOpacity(0.7), size: 16),
        const SizedBox(width: 4),
        Text(
          count,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _fetchData();
              _fetchHistoryData();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A0E2D),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayersList(List<PrayerPost> prayers, String type) {
    if (prayers.isEmpty) {
      return _buildEmptyState(type);
    }

    return RefreshIndicator(
      onRefresh: _fetchData,
      child: _isCardView 
        ? _buildCardView(prayers, type)
        : _buildListView(prayers, type),
    );
  }

  Widget _buildCardView(List<PrayerPost> prayers, String type) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: prayers.length,
      itemExtent: 200,
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
    );
  }

  Widget _buildListView(List<PrayerPost> prayers, String type) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: prayers.length,
      itemBuilder: (context, index) {
        final prayer = prayers[index];
        final cardColor = prayer.cardColor;

        return GestureDetector(
          onTap: () => _showPrayerDetails(context, prayer, cardColor),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cardColor.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Color indicator
                Container(
                  width: 4,
                  height: 60,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 16),
                // Avatar
                CircleAvatar(
                  backgroundImage: AssetImage(prayer.userAvatar),
                  radius: 20,
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              prayer.userName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0A0E2D),
                              ),
                            ),
                          ),
                          if (type == 'specific')
                            Icon(
                              Icons.visibility,
                              color: const Color(0xFF0A0E2D).withOpacity(0.6),
                              size: 16,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        prayer.content,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            DateFormat('MMM d, yyyy').format(prayer.createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.favorite, color: Colors.red.withOpacity(0.7), size: 14),
                          const SizedBox(width: 4),
                          Text(
                            prayer.likes.toString(),
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.front_hand_outlined, color: Colors.blue.withOpacity(0.7), size: 14),
                          const SizedBox(width: 4),
                          Text(
                            prayer.comments.toString(),
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
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
      },
    );
  }

  Widget _buildEmptyState(String type) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0E2D).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              type == 'specific' ? Icons.person_outline : Icons.edit_note,
              size: 64,
              color: const Color(0xFF0A0E2D).withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            type == 'specific' ? 'No Specific Requests Yet' : 'No Posts Yet',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A0E2D),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              type == 'specific'
                  ? 'Prayers specifically addressed to you will appear here. Share your pastoral wisdom to help others in their spiritual journey.'
                  : 'Your prayer posts will appear here. Start sharing your thoughts and connect with the community.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.add),
            label: Text(type == 'specific' ? 'View All Prayers' : 'Create Post'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A0E2D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
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

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }
}
