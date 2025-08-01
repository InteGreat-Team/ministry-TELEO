import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PrayerRequestProvider extends ChangeNotifier {
  final subjectController = TextEditingController();
  final requestController = TextEditingController();

  Color selectedColor = const Color(0xFF1A2A4A);
  List<String> selectedHashtags = [];
  List<String> availableTags = [];

  String selectedPostType = 'public';
  String? selectedChurch;
  List<String> selectedPastors = [];

  bool isLoading = false;
  bool isTagsLoading = true;
  bool isChurchDropdownOpen = false;
  bool isPastorDropdownOpen = false;

  String? errorMessage;

  bool _isHashtagDropdownOpen = false;
  bool get isHashtagDropdownOpen => _isHashtagDropdownOpen;

  // Static data (replace with API later)
  final List<Map<String, String>> availableChurches = [
    {'id': '1', 'name': 'Grace Community Church'},
    {'id': '2', 'name': 'Hope Fellowship'},
    {'id': '3', 'name': 'Faith Chapel'},
  ];

  final List<Map<String, String>> availablePastors = [
    {'id': '1', 'name': 'Pastor John'},
    {'id': '2', 'name': 'Pastor Sarah'},
    {'id': '3', 'name': 'Pastor Michael'},
  ];

  void toggleHashtagDropdown() {
    _isHashtagDropdownOpen = !_isHashtagDropdownOpen;
    notifyListeners();
  }

  void setSelectedColor(Color color) {
    selectedColor = color;
    notifyListeners();
  }

  void setSelectedChurch(String church) {
    selectedChurch = church;
    notifyListeners();
  }

  void toggleTag(String tag) {
    if (selectedHashtags.contains(tag)) {
      selectedHashtags.remove(tag);
    } else {
      selectedHashtags.add(tag);
    }
    notifyListeners();
  }

  void toggleHashtag(String tag) {
    selectedHashtags.contains(tag)
        ? selectedHashtags.remove(tag)
        : selectedHashtags.add(tag);
    notifyListeners();
  }

  void setPostType(String type) {
    selectedPostType = type;
    if (type != 'church_community') {
      selectedChurch = null;
      selectedPastors.clear();
    }
    notifyListeners();
  }

  void setChurch(String church) {
    selectedChurch = church;
    notifyListeners();
  }

  void togglePastor(String pastor) {
    selectedPastors.contains(pastor)
        ? selectedPastors.remove(pastor)
        : selectedPastors.add(pastor);
    notifyListeners();
  }

  void toggleChurchDropdown() {
    isChurchDropdownOpen = !isChurchDropdownOpen;
    notifyListeners();
  }

  void togglePastorDropdown() {
    isPastorDropdownOpen = !isPastorDropdownOpen;
    notifyListeners();
  }

  Future<void> fetchTags() async {
    isTagsLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final res = await http.get(
        Uri.parse(
          'https://asia-southeast1-teleo-church-application.cloudfunctions.net/prayerwall/api/tags',
        ),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        availableTags =
            (data as List)
                .whereType<Map>()
                .map((e) => e['name'].toString().trim())
                .toSet()
                .toList()
              ..sort();
      } else {
        errorMessage = 'Failed to load tags: ${res.statusCode}';
      }
    } catch (e) {
      errorMessage = 'Error loading tags: $e';
    }

    isTagsLoading = false;
    notifyListeners();
  }

  void clearForm() {
    subjectController.clear();
    requestController.clear();
    selectedColor = const Color(0xFF1A2A4A);
    selectedHashtags.clear();
    selectedPostType = 'public';
    selectedChurch = null;
    selectedPastors.clear();
    errorMessage = null;
    _isHashtagDropdownOpen = false;
    isChurchDropdownOpen = false;
    isPastorDropdownOpen = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> submitPrayer() async {
    final subject = subjectController.text.trim();
    final details = requestController.text.trim();

    if (subject.isEmpty || details.isEmpty) {
      return {
        'success': false,
        'message': 'Please fill in all required fields',
      };
    }

    if (selectedHashtags.isEmpty) {
      return {'success': false, 'message': 'Please select at least one tag'};
    }

    if (selectedPostType == 'church_community' &&
        (selectedChurch == null || selectedPastors.isEmpty)) {
      return {'success': false, 'message': 'Please select church and pastors'};
    }

    isLoading = true;
    notifyListeners();

    final payload = {
      'content': subject,
      'details': details,
      'tags': selectedHashtags,
      'postType': selectedPostType,
      if (selectedPostType == 'church_community') ...{
        'church': selectedChurch,
        'pastors': selectedPastors,
      },
      'themeColor':
          '#${selectedColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}',
    };

    try {
      final res = await http.post(
        Uri.parse(
          'https://asia-southeast1-teleo-church-application.cloudfunctions.net/prayerwall/api/prayers/addPrayer',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        return {'success': true, 'message': 'Prayer posted successfully'};
      } else {
        return {
          'success': false,
          'message': 'Failed to post: ${res.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
