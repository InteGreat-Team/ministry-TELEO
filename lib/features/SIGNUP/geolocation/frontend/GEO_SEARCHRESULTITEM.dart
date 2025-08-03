// lib/features/SIGNUP/geolocation/frontend/GEO_SEARCHRESULTITEM.dart
// This file is assumed to be correct and does not need modifications.
// Placeholder content for brevity, replace with actual content if available.
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchResultItem &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          address == other.address &&
          placeId == other.placeId;

  @override
  int get hashCode => name.hashCode ^ address.hashCode ^ placeId.hashCode;

  SearchResultItem copyWith({
    String? name,
    String? address,
    IconData? icon,
    double? distance,
    LatLng? location,
    String? placeId,
  }) {
    return SearchResultItem(
      name: name ?? this.name,
      address: address ?? this.address,
      icon: icon ?? this.icon,
      distance: distance ?? this.distance,
      location: location ?? this.location,
      placeId: placeId ?? this.placeId,
    );
  }
}