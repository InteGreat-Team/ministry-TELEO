import 'package:flutter/material.dart';

// Data Models
class UserData {
  final String name;
  final String greeting;

  const UserData({required this.name, required this.greeting});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'] ?? 'User',
      greeting: json['greeting'] ?? 'What\'s the agenda for today?',
    );
  }
}

class StatCard {
  final String title;
  final String value;
  final String change;
  final Color changeColor;
  final bool isPositive;

  const StatCard({
    required this.title,
    required this.value,
    required this.change,
    required this.changeColor,
    required this.isPositive,
  });

  factory StatCard.fromJson(Map<String, dynamic> json) {
    final changeValue = json['change'] ?? '+0%';
    final isPositive = !changeValue.startsWith('-');
    return StatCard(
      title: json['title'] ?? '',
      value: json['value'] ?? '0',
      change: changeValue,
      changeColor: isPositive ? Colors.green : Colors.red,
      isPositive: isPositive,
    );
  }
}

class CategoryItem {
  final int id;
  final String label;
  final IconData icon;
  final bool isHome;

  const CategoryItem({
    required this.id,
    required this.label,
    required this.icon,
    this.isHome = false,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id'] ?? 0,
      label: json['label'] ?? '',
      icon: _getIconFromString(json['icon'] ?? 'home'),
      isHome: json['isHome'] ?? false,
    );
  }

  static IconData _getIconFromString(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'home':
        return Icons.home;
      case 'calendar':
        return Icons.calendar_today_outlined;
      case 'event':
        return Icons.event_outlined;
      case 'book':
        return Icons.menu_book_outlined;
      case 'appointment':
        return Icons.calendar_today_outlined;
      case 'reading':
        return Icons.menu_book_outlined;
      default:
        return Icons.home;
    }
  }
}

class AppConfig {
  static const Color primaryColor = Color(0xFF000233);
  static const Color secondaryColor = Color(0xFF1F2156);
  static const Color accentColor = Color(0xFFFFB74D);
  static const Color buttonColor = Color(0xFF3949ab);
  static const Color backgroundColor = Colors.white;
  static const Duration animationDuration = Duration(milliseconds: 400);
  static const Duration quickAnimationDuration = Duration(milliseconds: 50);
  static const double maxHeaderHeight = 300.0;
  static const double minHeaderHeight = 220.0;
  static const double headerHeightRatio = 0.28;
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve quickCurve = Curves.easeInOut;
}
