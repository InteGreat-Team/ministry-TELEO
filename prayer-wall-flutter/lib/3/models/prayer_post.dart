import 'package:flutter/material.dart';

class PrayerPost {
  final String id;
  final String userName;
  final String userAvatar;
  final String content;
  final String details;
  final DateTime createdAt;
  int likes;
  int prayers;
  int comments;
  bool hasLiked;
  bool hasPrayed;
  final Color cardColor;

  PrayerPost({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.details,
    required this.createdAt,
    required this.likes,
    required this.prayers,
    required this.comments,
    required this.hasLiked,
    required this.hasPrayed,
    required this.cardColor,
  });

  factory PrayerPost.fromJson(Map<String, dynamic> json) {
    String? themeColorHex = json['theme_color'];
    Color parsedColor =
        themeColorHex != null ? _hexToColor(themeColorHex) : Colors.blue;

    return PrayerPost(
      id: json['id']?.toString() ?? '',
      userName: json['userName']?.toString() ?? 'Anonymous',
      userAvatar: json['userAvatar'] ?? 'assets/images/profile.jpg',
      content: json['content']?.toString() ?? '',
      details: json['details']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      likes: json['likes'] ?? 0,
      prayers: json['prayers'] ?? 0,
      comments: (json['comments'] as List?)?.length ?? 0,
      hasLiked: json['hasLiked'] ?? false,
      hasPrayed: json['hasPrayed'] ?? false,
      cardColor: parsedColor,
    );
  }

  static Color _hexToColor(String hex) {
    hex = hex.toUpperCase().replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse(hex, radix: 16));
  }
}
