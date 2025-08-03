import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/prayer_post.dart'; // Changed to relative import
import 'package:timeago/timeago.dart' as timeago;
import 'package:firebase_auth/firebase_auth.dart';

class PrayerProvider with ChangeNotifier {
  final List<PrayerPost> _prayers = [];
  final Map<String, List<Comment>> _allComments = {};
  bool _isLoading = false;

  List<PrayerPost> get prayers => _prayers;
  bool get isLoading => _isLoading;
  Map<String, List<Comment>> get allComments => _allComments;

  Future<void> fetchPrayers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      final idToken = await user.getIdToken();

      final res = await http.get(
        Uri.parse(
          'https://asia-southeast1-teleo-church-application.cloudfunctions.net/prayerwall/api/getPrayers',
        ),
        headers: {'Authorization': 'Bearer $idToken'},
      );

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        _prayers.clear();
        _prayers.addAll(data.map((json) => PrayerPost.fromJson(json)).toList());

        for (var item in data) {
          final prayerId = item['id'].toString();
          final comments = item['comments'] as List<dynamic>?;

          if (comments != null) {
            _allComments[prayerId] =
                comments.map((c) => Comment.fromJson(c)).toList();
          }
        }
      } else {
        throw Exception('Failed to load prayers: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('FetchPrayers error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleLike(String id, bool isLiked) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint("User not logged in");
      return;
    }

    final idToken = await user.getIdToken();
    final url =
        isLiked
            ? 'https://asia-southeast1-teleo-church-application.cloudfunctions.net/prayerwall/api/prayerLikes/$id/likePrayer'
            : 'https://asia-southeast1-teleo-church-application.cloudfunctions.net/prayerwall/api/prayerLikes/$id/unlikePrayer';

    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
      );

      if (res.statusCode != 200) {
        throw Exception('Failed to like/unlike prayer');
      }
    } catch (e) {
      debugPrint('Error toggling like: $e');
    }
  }

  Future<bool> addComment(String prayerId, String commentText) async {
    const url =
        'https://asia-southeast1-teleo-church-application.cloudfunctions.net/prayerwall/api/comments';

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final idToken = await user.getIdToken();

      final res = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({'prayerId': int.parse(prayerId), 'text': commentText}),
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = jsonDecode(res.body);

        final newComment = Comment(
          id: data['id']?.toString() ?? '',
          text: data['text'] ?? commentText,
          userName: data['first_name'] ?? 'You',
          createdAt: DateTime.tryParse(data['created_at'] ?? '') ?? DateTime.now(),
          userAvatar: 'assets/images/profile.jpg',
        );

        _allComments[prayerId] ??= [];
        _allComments[prayerId]!.add(newComment);

        notifyListeners();
        return true;
      } else {
        throw Exception("Failed to post comment: ${res.statusCode}");
      }
    } catch (e) {
      debugPrint('Comment error: $e');
      return false;
    }
  }

  void addNewPrayer(PrayerPost post) {
    _prayers.insert(0, post);
    notifyListeners();
  }

  void refresh() => fetchPrayers();
}
