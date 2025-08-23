import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/prayer_post.dart';

class HistoryReadProvider with ChangeNotifier {
  List<PrayerPost> _readPrayers = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<PrayerPost> get readPrayers => _readPrayers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchReadPrayers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // ✅ Get Firebase ID token from current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }
      final idToken = await user.getIdToken();

      // ✅ Call API with Authorization header
      final response = await http.get(
        Uri.parse(
          "https://asia-southeast1-teleo-church-application.cloudfunctions.net/prayerwall/api/historyPrayer",
        ),
        headers: {
          "Authorization": "Bearer $idToken",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        _readPrayers = data.map((json) => PrayerPost.fromJson(json)).toList();

        print("✅ Read prayers fetched: ${_readPrayers.length}");
      } else {
        _errorMessage =
            "Failed to load: ${response.statusCode} ${response.reasonPhrase}";
        print("❌ Error response: ${response.body}");
      }
    } catch (e) {
      _errorMessage = "Error: $e";
      print("❌ Exception: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
