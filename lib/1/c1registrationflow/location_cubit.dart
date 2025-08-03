import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'location_service.dart';
import 'search_result_item.dart';

// States
abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final List<SearchResultItem> suggestions;
  
  LocationLoaded(this.suggestions);
}

class LocationError extends LocationState {
  final String message;
  
  LocationError(this.message);
}

class LocationSelected extends LocationState {
  final SearchResultItem selectedLocation;
  
  LocationSelected(this.selectedLocation);
}

// Cubit
class LocationCubit extends Cubit<LocationState> {
  final LocationService _locationService;
  
  LocationCubit(this._locationService) : super(LocationInitial());

  Future<void> searchLocations(String query) async {
    if (query.isEmpty) {
      await loadNearbyChurches();
      return;
    }
    
    emit(LocationLoading());
    try {
      final suggestions = await _locationService.searchPlaces(query);
      emit(LocationLoaded(suggestions));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  Future<void> loadNearbyChurches() async {
    emit(LocationLoading());
    try {
      final position = await _locationService.getCurrentPosition();
      final suggestions = await _locationService.getNearbyChurches(position);
      emit(LocationLoaded(suggestions));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  Future<void> selectLocation(SearchResultItem item) async {
    emit(LocationLoading());
    try {
      SearchResultItem selectedItem = item;
      
      if (item.placeId != null) {
        // Get place details for places with placeId
        final details = await _locationService.getPlaceDetails(item.placeId!);
        if (details != null) {
          selectedItem = details;
        }
      } else if (item.name == "Current location") {
        // For current location, the address should already be fetched in getNearbyChurches
        // But let's make sure we have the latest position and address
        final position = await _locationService.getCurrentPosition();
        final currentAddress = await _locationService.reverseGeocode(
          LatLng(position.latitude, position.longitude)
        );
        
        selectedItem = item.copyWith(
          location: LatLng(position.latitude, position.longitude),
          address: currentAddress, // ✅ Ensure we have the real address
        );
      }
      
      emit(LocationSelected(selectedItem));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  void reset() {
    emit(LocationInitial());
  }
}