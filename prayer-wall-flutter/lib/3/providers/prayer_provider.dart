import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/prayer_post.dart';
import 'package:timeago/timeago.dart' as timeago;

class PrayerProvider with ChangeNotifier {
  final List<PrayerPost> _prayers = [];
  final Map<String, List<Map<String, String>>> _allComments = {};
  bool _isLoading = false;

  List<PrayerPost> get prayers => _prayers;
  bool get isLoading => _isLoading;
  Map<String, List<Map<String, String>>> get allComments => _allComments;

  Future<void> fetchPrayers() async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await http.get(
        Uri.parse(
          'https://asia-southeast1-teleo-church-application.cloudfunctions.net/prayerwall/api/prayers/getPrayers',
        ),
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
                comments.map<Map<String, String>>((c) {
                  final String createdAt = c['created_at'];
                  final DateTime createdAtDate =
                      DateTime.parse(createdAt).toLocal();
                  return {
                    'name': 'Anonymous',
                    'comment': c['text'],
                    'avatar': "assets/images/profile.jpg",
                    'time': timeago.format(createdAtDate),
                  };
                }).toList();
          }
        }
      } else {
        throw Exception('Failed to load prayers: ${res.statusCode}');
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleLike(String id, bool isLiked) async {
    final url =
        isLiked
            ? 'https://asia-southeast1-teleo-church-application.cloudfunctions.net/prayerwall/api/prayers/$id/likePrayer'
            : 'https://asia-southeast1-teleo-church-application.cloudfunctions.net/prayerwall/api/prayers/$id/unlikePrayer';

    try {
      final res = await http.post(Uri.parse(url));
      if (res.statusCode != 200) {
        throw Exception('Failed to like/unlike prayer');
      }
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  Future<bool> addComment(String prayerId, String comment) async {
    const url =
        'https://asia-southeast1-teleo-church-application.cloudfunctions.net/prayerwall/api/comments';
    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prayerId': int.parse(prayerId), 'text': comment}),
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = jsonDecode(res.body);

        final String createdAt = data['created_at'];
        final DateTime createdAtDate = DateTime.parse(createdAt).toLocal();

        _allComments[prayerId] ??= [];
        _allComments[prayerId]!.add({
          'name': 'You',
          'comment': comment,
          'avatar': 'assets/images/profile.jpg',
          'time': timeago.format(createdAtDate), // 👈 Use timeago here
        });

        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Comment error: $e');
    }
    return false;
  }

  void addNewPrayer(PrayerPost post) {
    _prayers.insert(0, post);
    notifyListeners();
  }

  void refresh() => fetchPrayers();
}
