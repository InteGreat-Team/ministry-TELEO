import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationUtils {
  // Calculate distance between two points
  static double calculateDistance(LatLng point1, LatLng point2) {
    return Geolocator.distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    ) / 1000; // Convert to kilometers
  }

  // Format distance for display
  static String formatDistance(double distanceKm) {
    if (distanceKm < 1) {
      return "${(distanceKm * 1000).round()}m";
    } else {
      return "${distanceKm.toStringAsFixed(1)}km";
    }
  }

  // Check if location is valid
  static bool isValidLocation(LatLng location) {
    return location.latitude.abs() <= 90 && location.longitude.abs() <= 180;
  }

  // Get bounds for multiple locations
  static LatLngBounds getBounds(List<LatLng> locations) {
    if (locations.isEmpty) {
      throw ArgumentError('Cannot create bounds from empty location list');
    }
    double minLat = locations.first.latitude;
    double maxLat = locations.first.latitude;
    double minLng = locations.first.longitude;
    double maxLng = locations.first.longitude;
    for (final location in locations) {
      minLat = minLat < location.latitude ? minLat : location.latitude;
      maxLat = maxLat > location.latitude ? maxLat : location.latitude;
      minLng = minLng < location.longitude ? minLng : location.longitude;
      maxLng = maxLng > location.longitude ? maxLng : location.longitude;
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }
}
