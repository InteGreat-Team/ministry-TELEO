import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/prayer_post.dart';
import '../widgets/prayer_homescreen/home_screen_widgets.dart';
import '../widgets/prayer_homescreen/comments_bottom_sheet.dart';
import '../providers/prayer_provider.dart';
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
  final List<PrayerPost> _viewedPrayers = [];

  final List<Color> _cardColors = [
    const Color(0xFF6A1B9A),
    const Color(0xFF00897B),
    const Color(0xFFD81B60),
    const Color(0xFF1A2A4A),
    const Color(0xFFE67E22),
    const Color(0xFF009688),
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<PrayerProvider>(context, listen: false).fetchPrayers();
  }

  void _onNavItemTapped(int index) {
    setState(() => _selectedNavIndex = index);
  }

  void _onAddPrayer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PrayerRequestScreen(
              onPrayerAdded: (newPrayer) {
                Provider.of<PrayerProvider>(
                  context,
                  listen: false,
                ).addNewPrayer(newPrayer);
                _currentCardIndex = 0;
                _allCardsSwiped = false;
              },
            ),
      ),
    );
  }

  void _showComments(PrayerPost post) {
    final provider = Provider.of<PrayerProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: post.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => CommentsBottomSheet(
            post: post,
            cardColor: post.cardColor,
            comments: provider.allComments[post.id] ?? [],
            onAddComment: (comment) async {
              final success = await provider.addComment(post.id, comment);
              if (!success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to post comment")),
                );
              }
            },
          ),
    );
  }

  void _handleLike() {
    final provider = Provider.of<PrayerProvider>(context, listen: false);
    final prayer = provider.prayers[_currentCardIndex];
    final isLiking = !prayer.hasLiked;

    setState(() {
      prayer.hasLiked = isLiking;
      prayer.likes += isLiking ? 1 : -1;
    });

    provider.toggleLike(prayer.id, isLiking);
  }

  void _handlePray(String? prayerMessage) async {
    if (prayerMessage == null) return;

    final provider = Provider.of<PrayerProvider>(context, listen: false);
    final post = provider.prayers[_currentCardIndex];

    final success = await provider.addComment(post.id, prayerMessage);
    if (success) {
      setState(() {
        post.hasPrayed = true;
        post.prayers++;
      });
      _showComments(post);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to pray")));
    }
  }

  void _handleComment() {
    final provider = Provider.of<PrayerProvider>(context, listen: false);
    _showComments(provider.prayers[_currentCardIndex]);
  }

  void _handleSwipe(_) {
    setState(() {
      if (_currentCardIndex <
          Provider.of<PrayerProvider>(context, listen: false).prayers.length -
              1) {
        _currentCardIndex++;
      } else {
        _allCardsSwiped = true;
      }
    });
  }

  void _refreshPrayerWall() {
    Provider.of<PrayerProvider>(context, listen: false).refresh();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Prayer wall refreshed!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _markPrayerAsViewed(PrayerPost prayer) {
    if (!_viewedPrayers.any((p) => p.id == prayer.id)) {
      _viewedPrayers.add(prayer);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PrayerProvider>(context);
    return HomeScreenWidgets.buildScaffold(
      context: context,
      selectedNavIndex: _selectedNavIndex,
      isLoading: provider.isLoading,
      prayerPosts: provider.prayers,
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
