// This file contains all data models (variables) for the sign-up feature.

import 'package:flutter/material.dart'; // For IconData
import 'package:google_maps_flutter/google_maps_flutter.dart'; // For LatLng

class Person {
  String name;
  int age;

  Person({required this.name, required this.age});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'],
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
    };
  }
}

// Model for search results from Google Places API
class SearchResultItem {
  final String name;
  final String address;
  final IconData icon;
  final double distance;
  final LatLng location;
  final String? placeId;

  SearchResultItem({
    required this.name,
    required this.address,
    required this.icon,
    this.distance = 0,
    this.placeId,
    this.location = const LatLng(0, 0),
  });
}

// New model to encapsulate user sign-up data
class UserProfile {
  String firstName;
  String lastName;
  DateTime birthday;
  String gender;
  String username;
  String? address;
  LatLng? location;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.username,
    this.address,
    this.location,
  });

  // You can add methods for JSON serialization/deserialization here if needed for persistence
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'birthday': birthday.toIso8601String(),
      'gender': gender,
      'username': username,
      'address': address,
      'latitude': location?.latitude,
      'longitude': location?.longitude,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['firstName'],
      lastName: json['lastName'],
      birthday: DateTime.parse(json['birthday']),
      gender: json['gender'],
      username: json['username'],
      address: json['address'],
      location: (json['latitude'] != null && json['longitude'] != null)
          ? LatLng(json['latitude'], json['longitude'])
          : null,
    );
  }
}
