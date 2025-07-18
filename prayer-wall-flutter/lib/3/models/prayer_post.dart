import 'package:flutter/material.dart';

class PrayerPost {
  final String id;
  final String userName;
  final String userAvatar;
  final String timeAgo;
  final String content;
  final String details;
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
    required this.timeAgo,
    required this.content,
    required this.likes,
    required this.prayers,
    required this.comments,
    required this.hasLiked,
    required this.hasPrayed,
    required this.details,
    required this.cardColor,
  });
  factory PrayerPost.fromJson(Map<String, dynamic> json) {
    String? themeColorHex = json['theme_color'];
    Color parsedColor =
        themeColorHex != null
            ? _hexToColor(themeColorHex)
            : Colors.blue; // default fallback
    return PrayerPost(
      id: json['id']?.toString() ?? '',
      userName: json['userName']?.toString() ?? 'Anonymous',
      userAvatar: json['userAvatar'] ?? 'assets/images/default_avatar.png',
      timeAgo: json['timeAgo']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      details: json['details']?.toString() ?? '',
      likes: json['likes'] ?? 0,
      prayers: json['prayers'] ?? 0,
      comments: (json['comments'] as List?)?.length ?? 0,
      hasLiked: json['hasLiked'] ?? false,
      hasPrayed: json['hasPrayed'] ?? false,
      cardColor: parsedColor, // Assuming cardColor is not coming from API
    );
  }

  static Color _hexToColor(String hex) {
    hex = hex.toUpperCase().replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex"; // Add alpha if missing
    }
    return Color(int.parse(hex, radix: 16));
  }
}
