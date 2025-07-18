import 'package:flutter/material.dart';

class AppStateProvider with ChangeNotifier {
  bool _splitScreenMode = false;
  final List<String> _bookmarkedItems = [];

  bool get splitScreenMode => _splitScreenMode;
  set splitScreenMode(bool value) {
    _splitScreenMode = value;
    notifyListeners();
  }

  bool isBookmarked(String title) {
    return _bookmarkedItems.contains(title);
  }

  void toggleBookmark(String title) {
    if (_bookmarkedItems.contains(title)) {
      _bookmarkedItems.remove(title);
    } else {
      _bookmarkedItems.add(title);
    }
    notifyListeners();
  }
}
