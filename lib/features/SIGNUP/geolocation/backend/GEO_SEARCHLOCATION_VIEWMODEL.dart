import 'package:flutter/material.dart';
import 'GEO_LOCATIONMODEL.dart';
import '../frontend/GEO_LOCATIONSERVICE.dart';
import '../frontend/GEO_SEARCHRESULTITEM.dart';
import '../frontend/GEO_LOCATIONUTILS.dart';

enum LocationState {
  initial,
  loading,
  loaded,
  error,
  selected,
}

class SearchLocationViewModel extends ChangeNotifier {
  final LocationService _locationService; // FIXED: Changed from GeoLocationService to LocationService

  LocationState _state = LocationState.initial;
  List<SearchResultItem> _suggestions = [];
  String? _errorMessage;
  SearchResultItem? _selectedLocation;
  bool _hasSearched = false;

  SearchLocationViewModel({LocationService? locationService}) // FIXED: Changed parameter type
      : _locationService = locationService ?? LocationService();

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
    _hasSearched = true;
    notifyListeners();

    try {
      _suggestions = await _locationService.getNearbyChurches(await _locationService.getCurrentPosition());
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
    _hasSearched = true;
    notifyListeners();

    try {
      _suggestions = await _locationService.searchPlaces(query);
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
      final detailedItem = await _locationService.getPlaceDetails(item.placeId!);
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