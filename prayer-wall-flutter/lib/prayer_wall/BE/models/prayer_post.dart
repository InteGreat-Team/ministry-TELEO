import 'package:flutter/material.dart';

class Comment {
  final String id;
  final String text;
  final String userName;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.text,
    required this.userName,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      userName: json['first_name']?.toString() ?? 'Anonymous',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

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
  final List<Comment> commentList;

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
    required this.commentList,
  });

  factory PrayerPost.fromJson(Map<String, dynamic> json) {
    String? themeColorHex = json['theme_color'];
    Color parsedColor =
        themeColorHex != null ? _hexToColor(themeColorHex) : Colors.blue;

    final List<Comment> parsedComments =
        (json['comments'] as List<dynamic>?)
            ?.map((commentJson) => Comment.fromJson(commentJson))
            .toList() ??
        [];

    return PrayerPost(
      id: json['id']?.toString() ?? '',
      userName: json['first_name']?.toString() ?? 'Anonymous',
      userAvatar: json['userAvatar'] ?? 'assets/images/profile.jpg',
      content: json['content']?.toString() ?? '',
      details: json['details']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['created_at'] ?? '')?.toLocal() ??
          DateTime.now(),
      likes: int.tryParse(json['likes'].toString()) ?? 0,
      prayers: json['prayers'] ?? 0,
      comments: parsedComments.length,
      hasLiked: json['hasLiked'] ?? false,
      hasPrayed: json['hasPrayed'] ?? false,
      cardColor: parsedColor,
      commentList: parsedComments,
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
