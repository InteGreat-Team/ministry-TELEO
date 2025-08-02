// lib/features/SIGNUP/geolocation/backend/GEO_LOCATIONMODEL.dart

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart'; // For IconData

// This file contains data models related to geolocation.

// Data model for a cached search result or geocoded address.
class CachedResult<T> {
  final T data;
  final DateTime timestamp;

  CachedResult(this.data, this.timestamp);

  bool get isExpired => DateTime.now().difference(timestamp) > const Duration(minutes: 30); // Default cache expiration
}

// Enum for location permission results.
enum LocationPermissionResult {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
}

// Custom exception for location service errors.
class LocationServiceException implements Exception {
  final String message;
  LocationServiceException(this.message);

  @override
  String toString() => 'LocationServiceException: $message';
}
