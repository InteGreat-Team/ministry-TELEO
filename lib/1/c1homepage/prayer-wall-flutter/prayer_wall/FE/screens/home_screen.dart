import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../BE/models/prayer_post.dart';
import '../widgets/prayer_homescreen/home_screen_widgets.dart';
import '../widgets/prayer_homescreen/comments_bottom_sheet.dart';
import '../../BE/providers/prayer_provider.dart';
import '../../BE/providers/history_prayer_provider.dart';
import 'prayer_request_screen.dart';
import 'history_prayer.dart';
import '../widgets/prayer_homescreen/prayer_card.dart'; // Ensure this is imported for SwipeDirection

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 2;
  int _currentCardIndex = 0;
  bool _allCardsSwiped = false;

  final List<Color> _cardColors = [
    const Color(0xFF6A1B9A),
    const Color(0xFF00897B),
    const Color(0xFFD81B60),
    const Color(0xFF1A2A4A),
    const Color(0xFFE67E22),
    const Color(0xFF059669),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<PrayerProvider>(context, listen: false).fetchPrayers();
        Provider.of<UserPostsViewModel>(context, listen: false).fetchData();
      }
    });
  }

  void _onNavItemTapped(int index) {
    setState(() => _selectedNavIndex = index);
  }

  void _onAddPrayer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrayerRequestScreen(
          onPrayerAdded: (newPrayer) {
            if (mounted) {
              Provider.of<PrayerProvider>(
                context,
                listen: false,
              ).addNewPrayer(newPrayer);
              setState(() {
                _currentCardIndex = 0;
                _allCardsSwiped = false;
              });
            }
          },
        ),
      ),
    );
  }

  void _onHistoryTapped() {
    final userPostsProvider = context.read<UserPostsViewModel>();
    final userRole = userPostsProvider.userRole;

    if (userRole != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserPostsScreen(userRole: userRole),
        ),
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User role not available yet.')),
        );
      }
    }
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
      builder: (context) => CommentsBottomSheet(
        post: post,
        cardColor: post.cardColor,
        comments: _convertCommentsToCommentObjects(
          provider.allComments[post.id] ?? []
        ),
        onAddComment: (comment) async {
          final success = await provider.addComment(post.id, comment);
          if (!success && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to post comment")),
            );
          }
        },
      ),
    );
  }

  List<Comment> _convertCommentsToCommentObjects(List<dynamic> comments) {
    return comments.map((comment) {
      if (comment is Comment) {
        return comment;
      } else if (comment is Map<String, dynamic>) { // Changed to dynamic to match json
        return Comment(
          id: comment['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
          text: comment['text']?.toString() ?? '',
          userName: comment['userName']?.toString() ?? 'Anonymous',
          userAvatar: comment['userAvatar']?.toString() ?? '',
          createdAt: DateTime.tryParse(comment['createdAt']?.toString() ?? '') ?? DateTime.now(),
        );
      } else {
        return Comment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: comment.toString(),
          userName: 'Anonymous',
          userAvatar: '',
          createdAt: DateTime.now(),
        );
      }
    }).toList();
  }

  void _handleLike() {
    final provider = Provider.of<PrayerProvider>(context, listen: false);
    final prayers = provider.prayers;

    if (_currentCardIndex >= prayers.length) return;

    final prayer = prayers[_currentCardIndex];
    final isLiking = !prayer.hasLiked;

    final previousLiked = prayer.hasLiked;
    final previousLikes = prayer.likes;

    setState(() {
      prayer.hasLiked = isLiking;
      prayer.likes += isLiking ? 1 : -1;
    });

    provider.toggleLike(prayer.id, isLiking).catchError((e) {
      if (mounted) {
        setState(() {
          prayer.hasLiked = previousLiked;
          prayer.likes = previousLikes;
        });
      }
    });
  }

  void _handlePray(String? prayerMessage) async {
    if (prayerMessage == null) return;

    final provider = Provider.of<PrayerProvider>(context, listen: false);
    final prayers = provider.prayers;

    if (_currentCardIndex >= prayers.length) return;

    final post = prayers[_currentCardIndex];
    final success = await provider.addComment(post.id, prayerMessage);

    if (!mounted) return;

    if (success) {
      setState(() {
        post.hasPrayed = true;
        post.prayers++;
      });
      _showComments(post);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to pray"))
      );
    }
  }

  void _handleComment() {
    final provider = Provider.of<PrayerProvider>(context, listen: false);
    final prayers = provider.prayers;

    if (_currentCardIndex < prayers.length) {
      _showComments(prayers[_currentCardIndex]);
    }
  }

  void _handleSwipe(SwipeDirection direction) {
    final provider = Provider.of<PrayerProvider>(context, listen: false);

    setState(() {
      if (_currentCardIndex < provider.prayers.length - 1) {
        _currentCardIndex++;
      } else {
        _allCardsSwiped = true;
      }
    });
  }

  void _refreshPrayerWall() async {
    final provider = Provider.of<PrayerProvider>(context, listen: false);
    provider.refresh();

    setState(() {
      _currentCardIndex = 0;
      _allCardsSwiped = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Prayer wall refreshed!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PrayerProvider>(
      builder: (context, provider, child) {
        return HomeScreenWidgets.buildScaffold(
          context: context,
          selectedNavIndex: _selectedNavIndex,
          isLoading: provider.isLoading,
          prayerPosts: provider.prayers,
          allCardsSwiped: _allCardsSwiped,
          currentCardIndex: _currentCardIndex,
          cardColors: _cardColors,
          onNavItemTapped: _onNavItemTapped,
          onAddPrayer: _onAddPrayer,
          refreshPrayerWall: _refreshPrayerWall,
          onLike: _handleLike,
          onPray: _handlePray,
          onComment: _handleComment,
          onSwipe: _handleSwipe,
          onHistoryTapped: _onHistoryTapped,
        );
      },
    );
  }
}
