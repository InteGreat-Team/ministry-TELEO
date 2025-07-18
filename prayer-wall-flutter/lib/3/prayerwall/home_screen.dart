import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/prayer_post.dart';
import '../widgets/prayer_homescreen/home_screen_widgets.dart';
import 'package:teleo_organized_new/3/widgets/prayer_homescreen/comments_bottom_sheet.dart';
import 'prayer_request_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 2;
  int _currentCardIndex = 0;
  bool _allCardsSwiped = false;
  bool _isLoading = false;
  final List<PrayerPost> _viewedPrayers = [];
  final List<PrayerPost> _prayerPosts = [];

  final List<Color> _cardColors = [
    const Color(0xFF6A1B9A),
    const Color(0xFF00897B),
    const Color(0xFFD81B60),
    const Color(0xFF1A2A4A),
    const Color(0xFFE67E22),
    const Color(0xFF009688),
  ];

  final Map<String, List<Map<String, String>>> _allComments = {};

  @override
  void initState() {
    super.initState();
    _fetchPrayers();
  }

  Future<void> _fetchPrayers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/prayers'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _prayerPosts.clear();
          _prayerPosts.addAll(
            data.map((json) => PrayerPost.fromJson(json)).toList(),
          );
          for (var item in data) {
            final prayerId = item['id'].toString();
            final comments = item['comments'] as List<dynamic>?;
            if (comments != null) {
              _allComments[prayerId] =
                  comments
                      .map<Map<String, String>>(
                        (c) => {
                          'name': 'Anonymous',
                          'comment': c['text'],
                          'avatar': 'assets/images/avatar.png',
                          'time': 'Just now',
                        },
                      )
                      .toList();
            }
          }
          _currentCardIndex = 0;
          _allCardsSwiped = _prayerPosts.isEmpty;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load prayers: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading prayers: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedNavIndex = index;
    });
    if (index == 2) return;
  }

  void _onAddPrayer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrayerRequestScreen(onPrayerAdded: _addNewPrayer),
      ),
    );
  }

  void _addNewPrayer(PrayerPost newPrayer) {
    setState(() {
      _prayerPosts.insert(0, newPrayer);
      _currentCardIndex = 0;
      _allCardsSwiped = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Prayer request added successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _nextCard() {
    setState(() {
      if (_currentCardIndex < _prayerPosts.length - 1) {
        _currentCardIndex++;
      } else {
        _allCardsSwiped = true;
      }
    });
  }

  void _refreshPrayerWall() {
    _fetchPrayers();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Prayer wall refreshed!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _markPrayerAsViewed(PrayerPost prayer) {
    if (!_viewedPrayers.any((p) => p.id == prayer.id)) {
      final viewedPrayer = PrayerPost(
        id: prayer.id,
        userName: prayer.userName,
        userAvatar: prayer.userAvatar,
        timeAgo: prayer.timeAgo,
        content: prayer.content,
        details: prayer.details,
        likes: prayer.likes,
        prayers: prayer.prayers,
        comments: prayer.comments,
        hasLiked: prayer.hasLiked,
        hasPrayed: prayer.hasPrayed,
        cardColor: prayer.cardColor,
      );
      setState(() {
        _viewedPrayers.add(viewedPrayer);
      });
    }
  }

  Future<void> _toggleLike(int prayerId, bool isLiked) async {
    final url =
        isLiked
            ? 'http://localhost:3000/api/prayers/$prayerId/like'
            : 'http://localhost:3000/api/prayers/$prayerId/unlike';
    try {
      final response = await http.post(Uri.parse(url));
      if (response.statusCode == 200) {
        print('Like status updated for prayer $prayerId');
      } else {
        throw Exception('Failed to update like: ${response.statusCode}');
      }
    } catch (e) {
      print('Error liking/unliking prayer: $e');
    }
  }

  void _showCommentsBottomSheet(PrayerPost post) {
    final Color cardColor = post.cardColor;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => CommentsBottomSheet(
            post: post,
            cardColor: cardColor,
            comments: _allComments[post.id] ?? [],
            onAddComment: (comment) {
              setState(() {
                _allComments[post.id] ??= [];
                _allComments[post.id]!.add({
                  'name': 'You',
                  'comment': comment,
                  'avatar': 'assets/images/avatar.png',
                  'time': 'Just now',
                });
              });
            },
          ),
    );
  }

  void _handleLike() {
    final currentPrayer = _prayerPosts[_currentCardIndex];
    final isLiking = !currentPrayer.hasLiked;
    setState(() {
      currentPrayer.hasLiked = isLiking;
      currentPrayer.likes += isLiking ? 1 : -1;
    });
    _toggleLike(int.parse(currentPrayer.id), isLiking);
  }

  void _handlePray(String? prayerMessage) async {
    if (prayerMessage == null) return;

    final currentPost = _prayerPosts[_currentCardIndex];

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/comments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'prayer_id': int.parse(currentPost.id),
          'text': prayerMessage,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          currentPost.hasPrayed = true;
          currentPost.prayers++;

          _allComments[currentPost.id] ??= [];
          _allComments[currentPost.id]!.add({
            'name': 'You',
            'comment': prayerMessage,
            'avatar': 'assets/images/avatar.png',
            'time': 'Just now',
          });
        });

        _showCommentsBottomSheet(currentPost);
      } else {
        _showErrorSnackBar('Failed to post comment: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackBar('Error posting prayer comment: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _handleComment() {
    _showCommentsBottomSheet(_prayerPosts[_currentCardIndex]);
  }

  void _handleSwipe(direction) {
    _nextCard();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreenWidgets.buildScaffold(
      context: context,
      selectedNavIndex: _selectedNavIndex,
      isLoading: _isLoading,
      prayerPosts: _prayerPosts,
      allCardsSwiped: _allCardsSwiped,
      currentCardIndex: _currentCardIndex,
      cardColors: _cardColors,
      viewedPrayers: _viewedPrayers,
      onNavItemTapped: _onNavItemTapped,
      onAddPrayer: _onAddPrayer,
      refreshPrayerWall: _refreshPrayerWall,
      markPrayerAsViewed: _markPrayerAsViewed,
      onLike: _handleLike,
      onPray: _handlePray,
      onComment: _handleComment,
      onSwipe: _handleSwipe,
    );
  }
}
