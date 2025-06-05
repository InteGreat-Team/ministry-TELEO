import 'package:flutter/material.dart';
import 'dart:typed_data';

class Event {
  final String id; // Added ID for proper identification
  final String? title;
  final String? location;
  final String? date;
  final List<String> tags;
  final int likes;
  final Color color;
  final String text;
  final bool isFeatured;
  final DateTime? startDate;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final String? venueName;
  final String? description;
  final String? contactInfo;
  final bool isOnline;
  final String? eventLink;
  final List<String> speakers;
  final String? dressCode;
  final List<Church> invitedChurches;
  final List<InvitedGuest> invitedGuests;
  final int? expectedCapacity;
  final String? inviteType;
  final Uint8List? imageBytes;
  final String? imageUrl;
  final String? imagePath;
  final bool allowsVolunteers; // Field to indicate if event accepts volunteers
  final List<String>? volunteerRoles; // Available volunteer roles for this event
  final int? volunteersNeeded; // Number of volunteers needed

  Event({
    String? id,
    this.title,
    this.location,
    this.date,
    this.tags = const [],
    this.likes = 0,
    required this.color,
    required this.text,
    this.isFeatured = false,
    this.startDate,
    this.startTime,
    this.endTime,
    this.venueName,
    this.description,
    this.contactInfo,
    this.isOnline = false,
    this.eventLink,
    this.speakers = const [],
    this.dressCode,
    this.invitedChurches = const [],
    this.invitedGuests = const [],
    this.expectedCapacity,
    this.inviteType,
    this.imageBytes,
    this.imageUrl,
    this.imagePath,
    this.allowsVolunteers = false,
    this.volunteerRoles,
    this.volunteersNeeded,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  get venueAddress => null;
}

class InvitedGuest {
  final String fullName;
  
  InvitedGuest({required this.fullName});
}

class Church {
  final String name;
  
  Church({required this.name});
}
