import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../geolocation/frontend/GEO_LOCATIONCUBIT.dart'; 
import '../../geolocation/frontend/GEO_LOADINGOVERLAY.dart'; 
import '../../geolocation/frontend/GEO_DEBOUNCEDSEARCHFIELD.dart'; 
import '../../geolocation/frontend/GEO_SEARCHRESULTITEM.dart'; 
import '../../../SIGNUP/backend/viewmodels/USER_SIGNUPVIEWMODELS.dart';
import '../../../constants/app_constants.dart'; // NEW: Import AppConstants

class UserGeolocationScreen7 extends StatefulWidget {
  const UserGeolocationScreen7({super.key});

  @override
  State<UserGeolocationScreen7> createState() => _UserGeolocationScreen7State();
}

class _UserGeolocationScreen7State extends State<UserGeolocationScreen7> {
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final locationCubit = context.read<LocationCubit>();
    // Initialize search controller text with the current location label from cubit
    _searchController.text = (locationCubit.state as LocationLoaded).locationLabel;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    final locationCubit = context.read<LocationCubit>();
    // Animate camera to initial location if it's not already there
    if (locationCubit.state is LocationLoaded) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLng((locationCubit.state as LocationLoaded).selectedLocation),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userSignupViewModel = context.read<UserSignupViewModel>();

    return Scaffold(
      body: BlocConsumer<LocationCubit, LocationState>(
        listener: (context, state) {
          if (state is LocationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is LocationLoaded) {
            // Update search controller text when location label changes
            _searchController.text = state.locationLabel;
            // Animate map to new location if it's different
            if (_mapController != null && state.selectedLocation != _mapController!.camera.target) {
              _mapController!.animateCamera(
                CameraUpdate.newLatLng(state.selectedLocation),
              );
            }
          }
        },
        builder: (context, state) {
          LatLng selectedLocation = const LatLng(0, 0);
          String locationLabel = 'Loading location...';
          bool isLoading = false;
          bool isReverseGeocoding = false;
          bool isSearching = false;
          List<SearchResultItem> suggestions = [];
          bool showSuggestions = false;

          if (state is LocationLoaded) {
            selectedLocation = state.selectedLocation;
            locationLabel = state.locationLabel;
            suggestions = state.suggestions;
            showSuggestions = state.showSuggestions;
            isSearching = state.isSearching;
            isReverseGeocoding = state.isReverseGeocoding;
          } else if (state is LocationLoading) {
            isLoading = true;
            locationLabel = state.message;
          } else if (state is LocationError) {
            locationLabel = 'Error: ${state.message}';
          }

          return GeoLoadingOverlay(
            isLoading: isLoading,
            loadingText: "Loading...",
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: selectedLocation,
                    zoom: AppConstants.defaultZoom, // Use AppConstants
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  onTap: (tapped) => context.read<LocationCubit>().onMapTap(tapped),
                  onCameraIdle: () => context.read<LocationCubit>().onCameraIdle(),
                  onCameraMove: (position) => context.read<LocationCubit>().onCameraMove(position.target),
                  zoomGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                ),
                // Back button
                Positioned(
                  top: 50,
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 4)
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                // Functional search bar
                Positioned(
                  top: 50,
                  left: 70,
                  right: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 5)
                      ],
                    ),
                    child: GeoDebouncedSearchField(
                      controller: _searchController,
                      onChanged: (query) => context.read<LocationCubit>().searchPlaces(query),
                      onSubmitted: (query) => context.read<LocationCubit>().searchPlaces(query),
                      onCurrentLocationPressed: () => context.read<LocationCubit>().getCurrentLocation(),
                      hintText: "Search for a location...",
                    ),
                  ),
                ),
                // Center pin indicator
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isReverseGeocoding)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Getting address...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      Icon(
                        Icons.location_pin,
                        size: 50,
                        color: isReverseGeocoding ? Colors.orange : Colors.red,
                      ),
                    ],
                  ),
                ),
                // Suggestions dropdown
                if (showSuggestions)
                  Positioned(
                    top: 110,
                    left: 16,
                    right: 16,
                    child: Material(
                      elevation: AppConstants.cardElevation, // Use AppConstants
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 300),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Title bar
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    isSearching ? 'Searching...' : 'Suggestions',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => context.read<LocationCubit>().hideSuggestions(),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),
                            // Content
                            if (isSearching)
                              const Padding(
                                padding: EdgeInsets.all(32),
                                child: CircularProgressIndicator(),
                              )
                            else if (suggestions.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(32),
                                child: Text('No results found'),
                              )
                            else
                              Flexible(
                                child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  shrinkWrap: true,
                                  itemCount: suggestions.length,
                                  separatorBuilder: (_, __) => const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    final item = suggestions[index];
                                    return ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      leading: Icon(item.icon, size: 20),
                                      title: Text(
                                        item.name,
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                      subtitle: item.address.isNotEmpty
                                          ? Text(item.address)
                                          : null,
                                      trailing: item.distance > 0
                                          ? Text(
                                              '${item.distance.toStringAsFixed(1)}km',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            )
                                          : null,
                                      onTap: () => context.read<LocationCubit>().selectSuggestion(item),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Bottom sheet
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.bottomSheetRadius)), // Use AppConstants
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: isReverseGeocoding
                                    ? Row(
                                        children: [
                                          SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Getting address...',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        locationLabel,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: AppConstants.searchBarHeight, // Use AppConstants
                            child: ElevatedButton(
                              onPressed: () {
                                userSignupViewModel.finalizeLocationFromMap(
                                  locationLabel,
                                  selectedLocation.latitude,
                                  selectedLocation.longitude,
                                  context,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text("Choose this location"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
