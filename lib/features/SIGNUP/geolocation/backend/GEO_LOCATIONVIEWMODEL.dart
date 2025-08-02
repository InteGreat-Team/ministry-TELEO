import 'package:flutter/material.dart';
import 'GEO_LOCATIONMODEL.dart'; // UPDATED: Path to GEO_LOCATIONMODEL.dart
import '../frontend/GEO_LOCATIONSERVICE.dart'; // UPDATED: Path to GEO_LOCATIONSERVICE.dart
import '../frontend/GEO_SEARCHRESULTITEM.dart'; // UPDATED: Import GEO_SEARCHRESULTITEM.dart

enum LocationState {
  initial,
  loading,
  loaded,
  error,
  selected,
}

class LocationViewModel extends ChangeNotifier {
  final GeoLocationService _geoLocationService; // UPDATED: Use GeoLocationService

  LocationState _state = LocationState.initial;
  List<SearchResultItem> _suggestions = [];
  String? _errorMessage;
  SearchResultItem? _selectedLocation;
  bool _hasSearched = false; // Tracks if a search has been performed or nearby churches loaded

  LocationViewModel({GeoLocationService? geoLocationService}) // UPDATED: Use GeoLocationService
      : _geoLocationService = geoLocationService ?? GeoLocationService(); // UPDATED: Use GeoLocationService

  // Getters for UI consumption
  LocationState get state => _state;
  List<SearchResultItem> get suggestions => _suggestions;
  String? get errorMessage => _errorMessage;
  SearchResultItem? get selectedLocation => _selectedLocation;
  bool get hasSearched => _hasSearched;
  bool get isLoading => _state == LocationState.loading;
  bool get isLocationSelected => _selectedLocation != null;

  // Initialize by loading nearby churches
  Future<void> loadNearbyChurches() async {
    _state = LocationState.loading;
    _errorMessage = null;
    _hasSearched = true; // Mark as searched/loaded
    notifyListeners();

    try {
      _suggestions = await _geoLocationService.getNearbyChurches(await _geoLocationService.getCurrentPosition()); // UPDATED: Use _geoLocationService
      _state = LocationState.loaded;
    } catch (e) {
      _errorMessage = 'Failed to load nearby churches: ${e.toString()}';
      _state = LocationState.error;
    } finally {
      notifyListeners();
    }
  }

  // Search for locations based on query
  Future<void> searchLocations(String query) async {
    _state = LocationState.loading;
    _errorMessage = null;
    _hasSearched = true; // Mark as searched
    notifyListeners();

    try {
      _suggestions = await _geoLocationService.searchPlaces(query); // UPDATED: Use _geoLocationService
      _state = LocationState.loaded;
      if (_suggestions.isEmpty) {
        _errorMessage = 'No locations found for "$query". Try a different search term.';
      }
    } catch (e) {
      _errorMessage = 'Failed to search locations: ${e.toString()}';
      _state = LocationState.error;
    } finally {
      notifyListeners();
    }
  }

  // Select a location from suggestions
  void selectLocation(SearchResultItem item) {
    _selectedLocation = item;
    _state = LocationState.selected;
    notifyListeners();
  }

  // Clear the selected location
  void clearSelection() {
    _selectedLocation = null;
    _state = LocationState.loaded; // Go back to loaded state if there are suggestions
    if (_suggestions.isEmpty && _hasSearched) {
      _state = LocationState.initial; // Or back to initial if no suggestions and already searched
    }
    notifyListeners();
  }

  // Fetch detailed place information if needed (e.g., from placeId)
  Future<void> fetchPlaceDetails(SearchResultItem item) async {
    if (item.placeId == null) {
      selectLocation(item); // If no placeId, it's already a complete item
      return;
    }

    _state = LocationState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final detailedItem = await _geoLocationService.getPlaceDetails(item.placeId!); // UPDATED: Use _geoLocationService
      if (detailedItem != null) {
        selectLocation(detailedItem);
      } else {
        _errorMessage = 'Failed to get place details: No details found.';
        _state = LocationState.error;
      }
    } catch (e) {
      _errorMessage = 'Failed to get place details: ${e.toString()}';
      _state = LocationState.error;
    } finally {
      notifyListeners();
    }
  }

  // Reset the view model state
  void reset() {
    _state = LocationState.initial;
    _suggestions = [];
    _errorMessage = null;
    _selectedLocation = null;
    _hasSearched = false;
    notifyListeners();
  }
}

