import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';

class EventService {
  // Singleton pattern
  static final EventService _instance = EventService._internal();
  factory EventService() => _instance;
  EventService._internal();

  // List of all events
  final List<Map<String, dynamic>> _events = [];

  // Stream controller to broadcast event changes
  final _eventsController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  // Stream getter
  Stream<List<Map<String, dynamic>>> get eventsStream =>
      _eventsController.stream;

  // Get all events
  List<Map<String, dynamic>> get events => List.unmodifiable(_events);

  // Initialize with sample data
  void initialize(List<Map<String, dynamic>> initialEvents) {
    if (_events.isEmpty) {
      _events.addAll(initialEvents);
      _notifyListeners();
    }
  }

  // Add a new event - with duplicate check
  bool addEvent(Map<String, dynamic> event) {
    // Check if an event with the same title already exists
    final existingEventIndex = _events.indexWhere(
      (e) => e['title'] == event['title'],
    );

    if (existingEventIndex == -1) {
      // No duplicate found, add the event
      _events.add(event);
      _notifyListeners();
      return true;
    } else {
      // Duplicate found, don't add
      if (kDebugMode) {
        print(
          'Event with title "${event['title']}" already exists. Not adding duplicate.',
        );
      }
      return false;
    }
  }

  // Update an existing event
  void updateEvent(String title, Map<String, dynamic> updatedData) {
    final index = _events.indexWhere((event) => event['title'] == title);
    if (index != -1) {
      _events[index] = {..._events[index], ...updatedData};
      _notifyListeners();
    }
  }

  // Remove an event
  void removeEvent(String title) {
    _events.removeWhere((event) => event['title'] == title);
    _notifyListeners();
  }

  // Check if an event with a specific title exists
  bool eventExists(String title) {
    return _events.any((event) => event['title'] == title);
  }

  // Convert from Event model to Map
  Map<String, dynamic> convertEventToMap(Event event) {
    try {
      // Format date and time
      String timeStr = '';
      if (event.startDate != null) {
        final months = [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December',
        ];

        String startTimeStr = '';
        if (event.startTime != null) {
          final hour =
              event.startTime!.hourOfPeriod == 0
                  ? 12
                  : event.startTime!.hourOfPeriod;
          final minute = event.startTime!.minute.toString().padLeft(2, '0');
          final period = event.startTime!.period == DayPeriod.am ? 'AM' : 'PM';
          startTimeStr = '$hour:$minute $period';
        }

        String endTimeStr = '';
        if (event.endTime != null) {
          final hour =
              event.endTime!.hourOfPeriod == 0
                  ? 12
                  : event.endTime!.hourOfPeriod;
          final minute = event.endTime!.minute.toString().padLeft(2, '0');
          final period = event.endTime!.period == DayPeriod.am ? 'AM' : 'PM';
          endTimeStr = '$hour:$minute $period';
        }

        timeStr =
            '${months[event.startDate!.month - 1]} ${event.startDate!.day}, ${event.startDate!.year}';
        if (startTimeStr.isNotEmpty && endTimeStr.isNotEmpty) {
          timeStr += ' - $startTimeStr - $endTimeStr';
        }
      }

      // Format location
      String locationStr = '';
      if (event.isOnline) {
        locationStr = 'Online Event';
        if (event.meetingPlatform != null) {
          locationStr += ' via ${event.meetingPlatform}';
        }
      } else if (event.isOutsourcedVenue) {
        locationStr = 'Outsourced Venue';
      } else if (event.venueName != null) {
        locationStr = event.venueName!;

        if (event.venueAddress != null && event.venueAddress!.isNotEmpty) {
          locationStr += ', ${event.venueAddress}';
        }
      }

      // Format invited people count
      int invitedCount = 0;

      // Count people from church invites
      for (var church in event.invitedChurches) {
        for (var roleString in church.roles) {
          final parts = roleString.split(' (');
          if (parts.length == 2) {
            final countStr = parts[1].replaceAll(')', '');
            final count = int.tryParse(countStr) ?? 0;
            invitedCount += count;
          }
        }
      }

      // Add individual guests
      invitedCount += event.invitedGuests.length;

      // Create the event map
      return {
        'title': event.title ?? 'Untitled Event',
        'assignedTo':
            '@${event.title?.split(' ').first ?? 'Admin'}', // Use first word of title as assignee
        'location':
            locationStr.isNotEmpty ? locationStr : 'No location specified',
        'time': timeStr.isNotEmpty ? timeStr : 'Date and time not specified',
        'status': 'PENDING', // New events start as pending
        'description': event.description ?? 'No description provided',
        'eventFee': '0', // Default to free
        'speakers': event.speakers,
        'dressCode': event.dressCode ?? 'Not specified',
        'imageUrl': event.imageUrl,
        'tags': event.tags,
        'isOnline': event.isOnline,
        'contactInfo': event.contactInfo ?? '',
        'inviteType': event.inviteType,
        'expectedCapacity': event.expectedCapacity ?? 0,
        'invitedCount': invitedCount,
        'targetPublishDate':
            event.targetPublishDate != null
                ? '${event.targetPublishDate!.month}/${event.targetPublishDate!.day}/${event.targetPublishDate!.year}'
                : null,
        'venueLatitude': event.venueLatitude,
        'venueLongitude': event.venueLongitude,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error converting event to map: $e');
      }
      // Return a default map if conversion fails
      return {
        'title': 'Untitled Event',
        'assignedTo': '@Admin',
        'location': 'No location specified',
        'time': 'No date specified',
        'status': 'PENDING',
        'description': 'No description provided',
        'eventFee': '0',
        'speakers': <String>[],
        'dressCode': 'Not specified',
      };
    }
  }

  // Notify listeners of changes
  void _notifyListeners() {
    _eventsController.add(_events);
  }

  // Dispose resources
  void dispose() {
    _eventsController.close();
  }
}
