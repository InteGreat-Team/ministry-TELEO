import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PrayerReadProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> markPrayerAsRead(String prayerId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    print("📤 Sending request to mark prayer as read... ID: $prayerId");

    try {
      final response = await http.post(
        Uri.parse(
          "https://asia-southeast1-teleo-church-application.cloudfunctions.net/prayerwall/api/readPrayer",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "prayerId": prayerId,
          "readStatus": "Y",
        }),
      );

      print("📥 Response status: ${response.statusCode}");
      print("📥 Response body: ${response.body}");

      if (response.statusCode == 200) {
        print("✅ Prayer $prayerId marked as read successfully.");
      } else {
        throw Exception("❌ Failed to update prayer: ${response.body}");
      }
    } catch (e) {
      _errorMessage = e.toString();
      print("🔥 Error while marking prayer as read: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
      print("🔄 markPrayerAsRead completed for ID: $prayerId");
    }
  }
}
