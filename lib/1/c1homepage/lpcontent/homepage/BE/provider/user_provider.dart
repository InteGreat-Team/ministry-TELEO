import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/landing_page_models.dart';

class UserProvider with ChangeNotifier {
  UserData? _userData;
  bool _isLoading = false;
  String? _errorMessage;

  UserData? get userData => _userData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserData(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final url = Uri.parse(
        'https://asia-southeast1-teleo-church-application.cloudfunctions.net/emailrole/api/username?email=$email');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Map the username to the greeting
        _userData = UserData(
          name: data['username'] ?? 'User',
          greeting: "What's the agenda for today?",
        );
      } else {
        _errorMessage = 'Failed to load user data';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
