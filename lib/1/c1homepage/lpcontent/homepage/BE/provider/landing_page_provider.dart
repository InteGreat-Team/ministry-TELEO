import 'package:flutter/material.dart';
import '../models/landing_page_models.dart';

class LandingPageViewModel extends ChangeNotifier {
  // State variables
  int _selectedCategory = 0;
  int _currentNavIndex = 0;

  // Hardcoded data - no backend calls
  UserData _userData =
      const UserData(name: 'User', greeting: 'What\'s the agenda for today?');

  List<StatCard> _statCards = [
    const StatCard(
      title: 'Daily Streak',
      value: '7 days',
      change: '+100%',
      changeColor: Colors.green,
      isPositive: true,
    ),
    const StatCard(
      title: 'Lives Reached',
      value: '3,671',
      change: '-0.03%',
      changeColor: Colors.red,
      isPositive: false,
    ),
  ];

  List<CategoryItem> _categories = [
    const CategoryItem(
      id: 0,
      label: 'Home',
      icon: Icons.home,
      isHome: true,
    ),
    const CategoryItem(
      id: 1,
      label: 'Appointment',
      icon: Icons.calendar_today_outlined,
      isHome: false,
    ),
    const CategoryItem(
      id: 2,
      label: 'Events',
      icon: Icons.event_outlined,
      isHome: false,
    ),
    const CategoryItem(
      id: 3,
      label: 'Reading',
      icon: Icons.menu_book_outlined,
      isHome: false,
    ),
  ];

  // Getters
  int get selectedCategory => _selectedCategory;
  int get currentNavIndex => _currentNavIndex;
  UserData get userData => _userData;
  List<StatCard> get statCards => _statCards;
  List<CategoryItem> get categories => _categories;

  // Methods
  void selectCategory(int index) {
    if (_selectedCategory != index) {
      _selectedCategory = index;
      notifyListeners();
    }
  }

  void selectNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  CategoryItem? getCategoryById(int id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  String getCategoryTitle() {
    final category = getCategoryById(_selectedCategory);
    return category?.label ?? 'Home';
  }

  IconData getCategoryIcon() {
    final category = getCategoryById(_selectedCategory);
    return category?.icon ?? Icons.home;
  }
}
