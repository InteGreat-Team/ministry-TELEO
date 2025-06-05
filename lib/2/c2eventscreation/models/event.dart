import 'package:flutter/material.dart';
import 'dart:typed_data';

class ChurchInvite {
  final String name;
  final int members;
  final List<String> roles;

  ChurchInvite({
    required this.name,
    required this.members,
    this.roles = const [],
  });
}

class GuestInvite {
  final String username;
  final String fullName;
  final String churchName;

  GuestInvite({
    required this.username,
    required this.fullName,
    required this.churchName,
  });
}

class EventImage {
  String? imageUrl;
  String? imagePath;
  Uint8List? imageBytes;

  EventImage({
    this.imageUrl,
    this.imagePath,
    this.imageBytes,
  });
}

class EventDay {
  DateTime? date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  EventDay({this.date, this.startTime, this.endTime});
}

class RegistrationFormConfig {
  Map<String, bool> fieldVisibility;
  bool consentRequired;
  String? consentFormUrl;
  String? consentMessage;
  Map<String, List<String>>? dropdownOptions;
  bool hasReadTerms; // Track if user has read the terms
  bool hasAcceptedTerms; // Track if user has accepted the terms

  RegistrationFormConfig({
    required this.fieldVisibility,
    this.consentRequired = true,
    this.consentFormUrl,
    this.consentMessage,
    this.dropdownOptions,
    this.hasReadTerms = false,
    this.hasAcceptedTerms = false,
  });
}

class Event {
  // Keep original properties for backward compatibility
  String? imageUrl;
  String? imagePath;
  Uint8List? imageBytes;

  // Add new property for multiple images
  List<EventImage> additionalImages;

  String? title;
  List<String> tags;
  String? description;
  String? contactInfo;
  String? churchLandline; // New field for church landline
  String? dressCode;
  List<String> speakers;
  bool isOneDay;
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  List<EventDay>? eventDays; // Store specific event days for multi-day events
  bool isOnline;
  String? eventLink;
  String? meetingPlatform; // Added meeting platform property
  bool isOutsourcedVenue;
  String? venueName;
  String? venueAddress;
  double? venueLatitude;
  double? venueLongitude;
  String inviteType;
  int? expectedCapacity;
  String? customCapacity;
  List<ChurchInvite> invitedChurches;
  List<GuestInvite> invitedGuests; // New property for invited guests
  DateTime? targetPublishDate;
  TimeOfDay? targetPublishTime;
  String? inviteMessage;
  
  // Registration form configuration
  RegistrationFormConfig? registrationFormConfig;

  Event({
    this.imageUrl,
    this.imagePath,
    this.imageBytes,
    this.additionalImages = const [], // Initialize as empty list
    this.title,
    this.tags = const [],
    this.description,
    this.contactInfo,
    this.churchLandline,
    this.dressCode,
    this.speakers = const [],
    this.isOneDay = true,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.eventDays,
    this.isOnline = false,
    this.eventLink,
    this.meetingPlatform, // Added to constructor
    this.isOutsourcedVenue = false,
    this.venueName,
    this.venueAddress,
    this.venueLatitude,
    this.venueLongitude,
    this.inviteType = 'Open Invite',
    this.expectedCapacity,
    this.customCapacity,
    this.invitedChurches = const [],
    this.invitedGuests = const [], // Initialize as empty list
    this.targetPublishDate,
    this.targetPublishTime,
    this.inviteMessage,
    this.registrationFormConfig,
  });
}
