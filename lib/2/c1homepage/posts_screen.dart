import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final List<Map<String, dynamic>> _posts = [
    {
      'title': 'Sunday Service Highlights',
      'content': 'Recap of our wonderful Sunday service...',
      'author': 'Pastor John',
      'date': 'May 15, 2025',
      'likes': 45,
      'comments': 12,
      'type': 'Announcement',
    },
    {
      'title': 'Youth Camp Registration',
      'content': 'Register now for our upcoming youth camp...',
      'author': 'Youth Ministry',
      'date': 'May 14, 2025',
      'likes': 32,
      'comments': 8,
      'type': 'Event',
    },
    {
      'title': 'Weekly Bible Verse',
      'content': 'For God so loved the world...',
      'author': 'Bible Study Group',
      'date': 'May 13, 2025',
      'likes': 67,
      'comments': 15,
      'type': 'Devotional',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildSearchBar(),
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF001A33),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF001A33),
            isScrollable: true,
            tabs: const [
              Tab(text: 'All Posts'),
              Tab(text: 'Announcements'),
              Tab(text: 'Events'),
              Tab(text: 'Devotionals'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPostsList(_posts),
                _buildPostsList(_posts.where((p) => p['type'] == 'Announcement').toList()),
                _buildPostsList(_posts.where((p) => p['type'] == 'Event').toList()),
                _buildPostsList(_posts.where((p) => p['type'] == 'Devotional').toList()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement post creation
        },
        backgroundColor: const Color(0xFF001A33),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search posts...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _isSearching
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _isSearching = false;
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        onChanged: (value) {
          setState(() {
            _isSearching = value.isNotEmpty;
          });
          // TODO: Implement search functionality
        },
      ),
    );
  }

  Widget _buildPostsList(List<Map<String, dynamic>> posts) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF001A33).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        post['type'],
                        style: const TextStyle(
                          color: Color(0xFF001A33),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) {
                        // TODO: Implement menu actions
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  post['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(post['content']),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/profile.jpg'),
                      radius: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(post['author']),
                    const Spacer(),
                    Text(post['date']),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.thumb_up_outlined, size: 20),
                        const SizedBox(width: 4),
                        Text('${post["likes"]}'),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Row(
                      children: [
                        const Icon(Icons.comment_outlined, size: 20),
                        const SizedBox(width: 4),
                        Text('${post["comments"]}'),
                      ],
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        // TODO: Implement share functionality
                      },
                      icon: const Icon(Icons.share_outlined),
                      label: const Text('Share'),
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
}