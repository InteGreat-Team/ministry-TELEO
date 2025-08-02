// lib/models/admin_models.dart

import 'package:flutter/material.dart';

enum AdminView {
  home,
  profile,
  settings,
  accountSettings,
  securitySettings,
  changeEmail,
  changePassword,
  changePhone,
  authenticator,
  events,
  community,
  posts,
  setRoles,
  faqs,
  notificationSettings,
  massSchedule,
  reportIssue,
  termsConditions,
  contactUs,
  reports,
  donate,
  dashboard,
}

enum AuthenticatorFlow {
  email,
  password,
  phone,
}

class AdminData {
  final String churchName;
  final List<dynamic> posts;
  final int following;
  final int followers;
  final String loginActivity;
  final String loginActivityPercentage;
  final String dailyFollows;
  final String dailyFollowsPercentage;
  final String dailyVisits;
  final String dailyVisitsPercentage;
  final String bookings;
  final String bookingsPercentage;
  final String currentEmail;
  final String currentPhoneNumber;
  final String password;
  final String location;
  final String description;
  final String schedule;
  final String gcash;
  final String maya;
  final String bdo;
  final String bpi;

  AdminData({
    required this.churchName,
    required this.posts,
    required this.following,
    required this.followers,
    required this.loginActivity,
    required this.loginActivityPercentage,
    required this.dailyFollows,
    required this.dailyFollowsPercentage,
    required this.dailyVisits,
    required this.dailyVisitsPercentage,
    required this.bookings,
    required this.bookingsPercentage,
    required this.currentEmail,
    required this.currentPhoneNumber,
    required this.password,
    required this.location,
    required this.description,
    required this.schedule,
    required this.gcash,
    required this.maya,
    required this.bdo,
    required this.bpi,
  });

  AdminData copyWith({
    String? churchName,
    List<dynamic>? posts,
    int? following,
    int? followers,
    String? loginActivity,
    String? loginActivityPercentage,
    String? dailyFollows,
    String? dailyFollowsPercentage,
    String? dailyVisits,
    String? dailyVisitsPercentage,
    String? bookings,
    String? bookingsPercentage,
    String? currentEmail,
    String? currentPhoneNumber,
    String? password,
    String? location,
    String? description,
    String? schedule,
    String? gcash,
    String? maya,
    String? bdo,
    String? bpi,
  }) {
    return AdminData(
      churchName: churchName ?? this.churchName,
      posts: posts ?? this.posts,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      loginActivity: loginActivity ?? this.loginActivity,
      loginActivityPercentage:
          loginActivityPercentage ?? this.loginActivityPercentage,
      dailyFollows: dailyFollows ?? this.dailyFollows,
      dailyFollowsPercentage:
          dailyFollowsPercentage ?? this.dailyFollowsPercentage,
      dailyVisits: dailyVisits ?? this.dailyVisits,
      dailyVisitsPercentage:
          dailyVisitsPercentage ?? this.dailyVisitsPercentage,
      bookings: bookings ?? this.bookings,
      bookingsPercentage: bookingsPercentage ?? this.bookingsPercentage,
      currentEmail: currentEmail ?? this.currentEmail,
      currentPhoneNumber: currentPhoneNumber ?? this.currentPhoneNumber,
      password: password ?? this.password,
      location: location ?? this.location,
      description: description ?? this.description,
      schedule: schedule ?? this.schedule,
      gcash: gcash ?? this.gcash,
      maya: maya ?? this.maya,
      bdo: bdo ?? this.bdo,
      bpi: bpi ?? this.bpi,
    );
  }
}

class MassScheduleItem {
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  MassScheduleItem({
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MassScheduleItem &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          startTime == other.startTime &&
          endTime == other.endTime;

  @override
  int get hashCode => date.hashCode ^ startTime.hashCode ^ endTime.hashCode;
}

class FaqItem {
  FaqItem({
    required this.headerValue,
    required this.expandedValue,
    this.isExpanded = false,
  });
  String headerValue;
  String expandedValue;
  bool isExpanded;
}

class FaqCategory {
  FaqCategory({
    required this.title,
    required this.questions,
    this.isExpanded = false,
  });
  String title;
  List<FaqItem> questions;
  bool isExpanded;
}
