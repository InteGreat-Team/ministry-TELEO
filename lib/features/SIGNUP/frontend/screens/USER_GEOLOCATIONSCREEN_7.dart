import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../geolocation/frontend/GEO_LOCATIONCUBIT.dart';
import '../../geolocation/frontend/LoadingOverlay.dart'; // UPDATED: Renamed
import '../../geolocation/frontend/GEO_DEBOUNCEDSEARCHFIELD.dart';
import '../../geolocation/frontend/SearchResultItem.dart'; // UPDATED: Renamed
import '../../backend/viewmodels/USER_SIGNUPVIEWMODELS.dart';
import '../../geolocation/frontend/GEO_LOCATIONUTILS.dart'; // For AppConstants and LocationUtils
import '../../geolocation/frontend/GEO_LOCATIONSERVICE.dart'; // For direct service calls

class UserGeolocationScreen7 extends StatefulWidget {
  const UserGeolocationScreen7({super.key});

  @override
  State<UserGeolocationScreen7> createState() => _UserGeolocationScreen7State();
}

class _UserGeolocationScreen7State extends State<UserGeolocationScreen7> {
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  final GeoLocationService _geoLocationService = GeoLocationService(); // Direct service for map interactions

  late LatLng _selectedLocation; // Renamed from _currentMapCenter to match old file's _selectedLocation
  late LatLng _initialLocation; // From old file
  String _locationLabel = '';
  bool _showSuggestions = false;
  bool _isLoading = false; // For overall loading overlay
  bool _isReverseGeocoding = false; // For specific reverse geocoding indicator
  bool _isSearching = false; // For search bar loading state
  List<SearchResultItem> _suggestions = []; // UPDATED: Renamed
  bool _hasUserMovedMap = false; // From old file

  Timer? _reverseGeocodeTimer; // From old file

  @override
  void initState() {
    super.initState();
    final userSignupViewModel = context.read<UserSignupViewModel>();

    // Initialize with signup data's location if available
    if (userSignupViewModel.lat != null && userSignupViewModel.lng != null) {
      _selectedLocation = LatLng(userSignupViewModel.lat!, userSignupViewModel.lng!);
      _initialLocation = _selectedLocation; // Set initial location
      _locationLabel = userSignupViewModel.address ?? 'Selected location';
    } else {
      // If no initial location, try to get current device location
      _selectedLocation = const LatLng(0, 0); // Default before getting current location
      _initialLocation = _selectedLocation;
      _locationLabel = 'Loading location...';
      _getCurrentDeviceLocation();
    }
    _searchController.text = _locationLabel;
  }

  Future<void> _getCurrentDeviceLocation() async {
    setState(() {
      _isLoading = true; // Show overall loading
      _isReverseGeocoding = true; // Show specific geocoding indicator
      _locationLabel = 'Getting current location...';
    });
    try {
      final position = await _geoLocationService.getCurrentPosition();
      final address = await _geoLocationService.reverseGeocode(
        LatLng(position.latitude, position.longitude),
      );
      if (mounted) {
        setState(() {
          _selectedLocation = LatLng(position.latitude, position.longitude);
          _initialLocation = _selectedLocation; // Update initial location
          _locationLabel = address;
          _searchController.text = address;
        });
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(_selectedLocation, AppConstants.defaultZoom),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _locationLabel = 'Error getting location: ${e.toString()}';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting current location: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isReverseGeocoding = false;
        });
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // Ensure camera moves to initial location after map is created
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_selectedLocation, AppConstants.defaultZoom),
    );
  }

  // Handle search input changes (debounced in GeoDebouncedSearchField)
  void _onSearchChanged(String query) {
    // This is called by GeoDebouncedSearchField's onChanged (debounced)
    // It will trigger the cubit's searchLocations, which will update _suggestions
    if (query.isEmpty) {
      setState(() {
        _showSuggestions = false;
        _suggestions = [];
      });
      return;
    }
    setState(() {
      _isSearching = true;
      _showSuggestions = true;
    });
    context.read<LocationCubit>().searchLocations(query);
  }

  // Handle search submission (explicit search button or keyboard enter)
  void _onSearchSubmitted(String query) {
    // When user explicitly submits, hide suggestions and perform search
    setState(() {
      _showSuggestions = false;
      _isSearching = true;
    });
    context.read<LocationCubit>().searchLocations(query);
  }

  // Load nearby churches and current location (from old file)
  void _loadNearbyChurches() async {
    setState(() {
      _isLoading = true;
      _showSuggestions = true;
    });
    try {
      Position position = await _geoLocationService.getCurrentPosition();
      final results = await _geoLocationService.getNearbyChurches(position);
      if (mounted) {
        setState(() {
          _suggestions = results;
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _suggestions = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load suggestions: ${error.toString()}')),
        );
      }
    }
  }

  // Handle current location button press (from old file)
  void _onCurrentLocationPressed() async {
    try {
      final position = await _geoLocationService.getCurrentPosition();
      final newLocation = LatLng(position.latitude, position.longitude);
      if (mounted) {
        setState(() {
          _selectedLocation = newLocation;
          _hasUserMovedMap = true;
          _showSuggestions = false;
        });
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(newLocation, AppConstants.defaultZoom),
        );
        _reverseGeocode(newLocation);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get current location: ${error.toString()}')),
        );
      }
    }
  }

  // Reverse geocoding (from old file, adapted to use GeoLocationService)
  void _reverseGeocode(LatLng location) {
    _reverseGeocodeTimer?.cancel();
    setState(() {
      _isReverseGeocoding = true;
      _locationLabel = 'Getting address...';
    });
    _reverseGeocodeTimer = Timer(AppConstants.geocodeDebounceDelay, () async {
      try {
        final address = await _geoLocationService.reverseGeocode(location);
        if (mounted) {
          setState(() {
            _locationLabel = address;
            _isReverseGeocoding = false;
          });
          _searchController.text = address;
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _locationLabel = 'Address not found';
            _isReverseGeocoding = false;
          });
          _searchController.text = _locationLabel;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Geocoding failed: ${e.toString()}')),
          );
        }
      }
    });
  }

  // Handle suggestion selection (from old file, adapted to use Cubit)
  void _selectSuggestion(SearchResultItem item) async { // UPDATED: Renamed
    setState(() {
      _isLoading = true;
      _showSuggestions = false;
    });
    try {
      // Let the Cubit handle getting details if placeId exists
      context.read<LocationCubit>().selectLocation(item);
      // The listener will handle the LocationSelected state and update UI
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to select location: ${error.toString()}')),
        );
      }
    }
  }

  void _onMapTap(LatLng tapped) {
    setState(() {
      _selectedLocation = tapped;
      _hasUserMovedMap = true;
      _showSuggestions = false; // Hide suggestions on map tap
    });
    _reverseGeocode(tapped);
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _selectedLocation = position.target;
    });
    if (!_hasUserMovedMap) {
      final distance = LocationUtils.calculateDistance( // Use LocationUtils
        _initialLocation,
        position.target,
      );
      if (distance > 0.01) { // If moved more than 10 meters
        _hasUserMovedMap = true;
      }
    }
  }

  void _onCameraIdle() {
    if (_hasUserMovedMap) {
      _reverseGeocode(_selectedLocation);
    }
  }

  void _hideSuggestions() {
    setState(() {
      _showSuggestions = false;
    });
  }

  @override
  void dispose() {
    _reverseGeocodeTimer?.cancel();
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
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
            setState(() {
              _isSearching = false;
              _isLoading = false;
            });
          } else if (state is LocationLoaded) {
            setState(() {
              _suggestions = state.suggestions;
              _isSearching = false;
              _isLoading = false;
              _showSuggestions = true; // Show suggestions after loading
            });
          } else if (state is LocationSelected) {
            // Update map and label based on selected item from Cubit
            if (mounted) {
              setState(() {
                _selectedLocation = state.selectedLocation.location;
                _locationLabel = state.selectedLocation.address.isNotEmpty
                    ? state.selectedLocation.address
                    : state.selectedLocation.name;
                _searchController.text = _locationLabel;
                _hasUserMovedMap = true; // Mark as user-selected
                _isLoading = false;
                _isReverseGeocoding = false;
                _showSuggestions = false;
              });
              _mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(_selectedLocation, AppConstants.defaultZoom),
              );
            }
          } else if (state is LocationLoading) {
            setState(() {
              _isSearching = true;
              _isLoading = true;
            });
          }
        },
        builder: (context, state) {
          return LoadingOverlay( // UPDATED: Renamed
            isLoading: _isLoading,
            loadingText: _isReverseGeocoding ? "Getting address..." : "Searching...",
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation,
                    zoom: AppConstants.defaultZoom,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  onTap: _onMapTap,
                  onCameraIdle: _onCameraIdle,
                  onCameraMove: _onCameraMove,
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
                      onChanged: _onSearchChanged,
                      onSubmitted: _onSearchSubmitted,
                      onCurrentLocationPressed: _onCurrentLocationPressed,
                      hintText: "Search for a location...",
                    ),
                  ),
                ),
                // Center pin indicator
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isReverseGeocoding)
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
                        color: _isReverseGeocoding ? Colors.orange : Colors.red,
                      ),
                    ],
                  ),
                ),
                // Suggestions dropdown
                if (_showSuggestions && _suggestions.isNotEmpty)
                  Positioned(
                    top: 110,
                    left: 16,
                    right: 16,
                    child: Material(
                      elevation: AppConstants.cardElevation,
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
                                    _isSearching ? 'Searching...' : 'Suggestions',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: _hideSuggestions,
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),
                            // Content
                            if (_isSearching)
                              const Padding(
                                padding: EdgeInsets.all(32),
                                child: CircularProgressIndicator(),
                              )
                            else if (_suggestions.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(32),
                                child: Text('No results found'),
                              )
                            else
                              Flexible(
                                child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  shrinkWrap: true,
                                  itemCount: _suggestions.length,
                                  separatorBuilder: (_, __) => const Divider(height: 1),
                                  itemBuilder: (context, index) {
                                    final item = _suggestions[index];
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
                                      onTap: () => _selectSuggestion(item),
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
                      borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.bottomSheetRadius)),
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
                                child: _isReverseGeocoding
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
                                        _locationLabel,
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
                            height: AppConstants.searchBarHeight,
                            child: ElevatedButton(
                              onPressed: () {
                                userSignupViewModel.finalizeLocationFromMap(
                                  _locationLabel,
                                  _selectedLocation.latitude,
                                  _selectedLocation.longitude,
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
