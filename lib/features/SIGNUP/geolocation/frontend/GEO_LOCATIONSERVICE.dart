import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:teleo_organized_new/mapkey.dart'; // Assuming this path is correct for your API key
import '../backend/GEO_LOCATIONMODEL.dart'; // UPDATED: Path to GEO_LOCATIONMODEL.dart
import 'GEO_SEARCHRESULTITEM.dart'; 
import 'GEO_LOCATIONUTILS.dart'; // UPDATED: Moved to frontend
import '../../constants/app_constants.dart'; // NEW: Import AppConstants


class GeoLocationService {
  static final GeoLocationService _instance = GeoLocationService._internal();
  factory GeoLocationService() => _instance;
  GeoLocationService._internal();

  final GooglePlace _googlePlace = GooglePlace(googleApiKey);
  final Map<String, CachedResult<List<GEO_SearchResultItem>>> _searchCache = {};
  final Map<String, CachedResult<String>> _geocodeCache = {};
  
  static const Duration _searchCacheExpiration = AppConstants.searchCacheExpiration; // UPDATED: Use AppConstants
  static const Duration _geocodeCacheExpiration = AppConstants.geocodeCacheExpiration; // UPDATED: Use AppConstants

  // Debounced search with caching
  Future<List<GEO_SearchResultItem>> searchPlaces(String query) async {
    if (query.isEmpty) return [];

    final cacheKey = query.toLowerCase().trim();
    
    // Check cache first
    if (_searchCache.containsKey(cacheKey)) {
      final cached = _searchCache[cacheKey]!;
      if (!cached.isExpired) {
        return cached.data;
      }
    }

    try {
      final result = await _googlePlace.autocomplete.get(
        query,
        components: [Component("country", "ph")],
      );

      final suggestions = result?.predictions?.map((p) => GEO_SearchResultItem(
        name: p.description ?? '',
        address: '',
        placeId: p.placeId,
        icon: Icons.location_on,
        location: const LatLng(0,0), // Default value, will be updated with details
      )).toList() ?? [];

      // Cache the result
      _searchCache[cacheKey] = CachedResult(suggestions, DateTime.now());
      
      return suggestions;
    } catch (e) {
      throw LocationServiceException('Failed to search places: ${e.toString()}');
    }
  }

  // Get nearby Christian churches with caching
  Future<List<GEO_SearchResultItem>> getNearbyChurches(Position position) async {
    final cacheKey = '${position.latitude.toStringAsFixed(4)},${position.longitude.toStringAsFixed(4)}_churches';
    
    if (_searchCache.containsKey(cacheKey)) {
      final cached = _searchCache[cacheKey]!;
      if (!cached.isExpired) {
        return cached.data;
      }
    }

    try {
      // Get the actual address for current location
      String currentAddress;
      try {
        currentAddress = await reverseGeocode(LatLng(position.latitude, position.longitude));
      } catch (e) {
        // Fallback to generic message if reverse geocoding fails
        currentAddress = "Current GPS location";
      }

      final response = await _googlePlace.search.getNearBySearch(
        Location(lat: position.latitude, lng: position.longitude),
        AppConstants.nearbySearchRadius, // UPDATED: Use AppConstants
        keyword: "Christian Church",
      );

      final suggestions = <GEO_SearchResultItem>[
        GEO_SearchResultItem(
          name: "Current location",
          address: currentAddress, // ✅ Now shows actual address
          icon: Icons.my_location,
          location: LatLng(position.latitude, position.longitude),
          distance: 0,
        ),
      ];

      if (response?.results != null) {
        suggestions.addAll(response!.results!.map((r) {
          final loc = r.geometry?.location;
          return GEO_SearchResultItem(
            name: r.name ?? '',
            address: r.vicinity ?? '',
            icon: Icons.location_on_outlined,
            location: LatLng(loc?.lat ?? 0, loc?.lng ?? 0),
            distance: LocationUtils.calculateDistance( // UPDATED: Use LocationUtils
              LatLng(position.latitude, position.longitude),
              LatLng(loc?.lat ?? 0, loc?.lng ?? 0),
            ),
          );
        }));
      }

      _searchCache[cacheKey] = CachedResult(suggestions, DateTime.now());
      return suggestions;
    } catch (e) {
      throw LocationServiceException('Failed to get nearby churches: ${e.toString()}');
    }
  }

  // Reverse geocoding with caching
  Future<String> reverseGeocode(LatLng location) async {
    final cacheKey = '${location.latitude.toStringAsFixed(5)},${location.longitude.toStringAsFixed(5)}';
    
    if (_geocodeCache.containsKey(cacheKey)) {
      final cached = _geocodeCache[cacheKey]!;
      if (!cached.isExpired) {
        return cached.data;
      }
    }

    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=$googleApiKey&region=ph'
      );

      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data['status'] == 'OK' &&
          data['results'].isNotEmpty) {
        final address = data['results'][0]['formatted_address'] as String;
        _geocodeCache[cacheKey] = CachedResult(address, DateTime.now());
        return address;
      } else {
        throw LocationServiceException('Geocoding failed: ${data['status']}');
      }
    } catch (e) {
      throw LocationServiceException('Failed to reverse geocode: ${e.toString()}');
    }
  }

  // Get place details
  Future<GEO_SearchResultItem?> getPlaceDetails(String placeId) async {
    try {
      final details = await _googlePlace.details.get(placeId);
      if (details?.result != null) {
        final location = details!.result!.geometry!.location!;
        return GEO_SearchResultItem(
          name: details.result!.name ?? '',
          address: details.result!.formattedAddress ?? '',
          location: LatLng(location.lat!, location.lng!),
          placeId: placeId,
          icon: Icons.location_on,
        );
      }
      return null;
    } catch (e) {
      throw LocationServiceException('Failed to get place details: ${e.toString()}');
    }
  }

  // Location permissions
  Future<LocationPermissionResult> requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermissionResult.serviceDisabled;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationPermissionResult.denied;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationPermissionResult.deniedForever;
    }

    return LocationPermissionResult.granted;
  }

  // Get current position
  Future<Position> getCurrentPosition() async {
    final permissionResult = await requestLocationPermission();
    
    switch (permissionResult) {
      case LocationPermissionResult.serviceDisabled:
        throw LocationServiceException('Location services are disabled');
      case LocationPermissionResult.denied:
        throw LocationServiceException('Location permissions denied');
      case LocationPermissionResult.deniedForever:
        throw LocationServiceException('Location permissions permanently denied');
      case LocationPermissionResult.granted:
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
    }
  }

  // Clear cache
  void clearCache() {
    _searchCache.clear();
    _geocodeCache.clear();
  }

  // Clean expired cache entries
  void cleanExpiredCache() {
    _searchCache.removeWhere((key, value) => !value.isExpired); // Corrected logic: remove if NOT expired
    _geocodeCache.removeWhere((key, value) => !value.isExpired); // Corrected logic: remove if NOT expired
  }
}
