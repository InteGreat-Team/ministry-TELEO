import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final List<Map<String, dynamic>> _members = [
    {
      'name': 'John Smith',
      'role': 'Youth Leader',
      'joinDate': 'Jan 2023',
      'status': 'Active',
      'avatar': 'assets/images/profile.jpg',
    },
    {
      'name': 'Mary Johnson',
      'role': 'Choir Member',
      'joinDate': 'Mar 2023',
      'status': 'Active',
      'avatar': 'assets/images/profile.jpg',
    },
    {
      'name': 'David Wilson',
      'role': 'Bible Study Leader',
      'joinDate': 'Feb 2023',
      'status': 'Active',
      'avatar': 'assets/images/profile.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
            tabs: const [
              Tab(text: 'All Members'),
              Tab(text: 'Leaders'),
              Tab(text: 'Groups'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMembersList(_members),
                _buildMembersList(
                  _members
                      .where((m) => m['role'].toString().contains('Leader'))
                      .toList(),
                ),
                _buildGroupsList(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement member/group creation
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
          hintText: 'Search community...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon:
              _isSearching
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

  Widget _buildMembersList(List<Map<String, dynamic>> members) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundImage: AssetImage(member['avatar']),
              radius: 30,
            ),
            title: Text(
              member['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  member['role'],
                  style: const TextStyle(color: Color(0xFF001A33)),
                ),
                const SizedBox(height: 4),
                Text('Member since ${member["joinDate"]}'),
              ],
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                // TODO: Implement menu actions
              },
              itemBuilder:
                  (context) => [
                    const PopupMenuItem(
                      value: 'view',
                      child: Text('View Profile'),
                    ),
                    const PopupMenuItem(
                      value: 'message',
                      child: Text('Send Message'),
                    ),
                    const PopupMenuItem(
                      value: 'remove',
                      child: Text('Remove Member'),
                    ),
                  ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGroupsList() {
    final groups = [
      {
        'name': 'Youth Ministry',
        'members': 45,
        'description': 'Group for youth activities and fellowship',
      },
      {
        'name': 'Choir',
        'members': 25,
        'description': 'Church choir and music ministry',
      },
      {
        'name': 'Bible Study',
        'members': 30,
        'description': 'Weekly Bible study and discussion group',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF001A33),
              child: Text(
                group['name'] as String,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              group['name'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(group['description'] as String),
                const SizedBox(height: 4),
                Text('${group["members"]} members'),
              ],
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                // TODO: Implement menu actions
              },
              itemBuilder:
                  (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit Group'),
                    ),
                    const PopupMenuItem(
                      value: 'members',
                      child: Text('Manage Members'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete Group'),
                    ),
                  ],
            ),
          ),
        );
      },
    );
  }
}
