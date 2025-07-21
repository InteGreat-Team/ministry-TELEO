import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/prayer_post.dart';

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
        Uri.parse('http://localhost:3000/api/prayers'),
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
            ? 'http://localhost:3000/api/prayers/$id/like'
            : 'http://localhost:3000/api/prayers/$id/unlike';

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
    final url = 'http://localhost:3000/api/comments';
    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prayer_id': int.parse(prayerId), 'text': comment}),
      );

      if (res.statusCode == 200) {
        _allComments[prayerId] ??= [];
        _allComments[prayerId]!.add({
          'name': 'You',
          'comment': comment,
          'avatar': 'assets/images/avatar.png',
          'time': 'Just now',
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
