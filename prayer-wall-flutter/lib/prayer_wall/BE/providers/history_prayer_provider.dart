import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/prayer_post.dart';

class UserPostsViewModel extends ChangeNotifier {
  String? _userRole;
  String? get userRole => _userRole;

  List<PrayerPost> sharedByMe = [];
  List<PrayerPost> specificRequests = [];
  bool isLoading = false;

  Future<void> fetchData() async {
    isLoading = true;
    notifyListeners();

    try {
      // Step 1: Fetch user profile to get role
      final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      final res = await http.get(
        Uri.parse(
          'https://asia-southeast1-teleo-church-application.cloudfunctions.net/getUserProfile',
        ),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        final profile = jsonDecode(res.body);
        _userRole = profile['role'];

        // Step 2: Fetch shared prayers (available to all users)
        await _fetchSharedByMe();

        // Step 3: Fetch additional data for pastors
        if (_userRole == 'pastor') {
          await _fetchSpecificRequests();
        }
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchSharedByMe() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final token = await user?.getIdToken();

      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.get(
        Uri.parse(
          'https://asia-southeast1-teleo-church-application.cloudfunctions.net/prayerwall/api/getMyPrayers',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        sharedByMe = data.map((json) => PrayerPost.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load my posts (${response.statusCode})');
      }
    } catch (e) {
      print('Error fetching shared by me: $e');
      rethrow;
    }
  }

  Future<void> _fetchSpecificRequests() async {
    await Future.delayed(const Duration(milliseconds: 500));
    specificRequests = []; // Replace later with actual API call
  }
}
