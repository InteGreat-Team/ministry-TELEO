import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'location_service.dart';
import 'loading_overlay.dart';
import 'debounced_search_field.dart';
import 'search_result_item.dart';
import 'c1s6contact_info_screen.dart';
import 'package:teleo_organized_new/mapkey.dart';

class GeolocationScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final DateTime birthday;
  final String gender;
  final String username;
  final String address;
  final double lat;
  final double lng;

  const GeolocationScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.username,
    required this.address,
    required this.lat,
    required this.lng,
  });

  @override
  State<GeolocationScreen> createState() => _GeolocationScreenState();
}

class _GeolocationScreenState extends State<GeolocationScreen> {
  late GoogleMapController _mapController;
  late LatLng _selectedLocation;
  late LatLng _initialLocation;
  String _locationLabel = '';
  bool _showSuggestions = false;
  bool _isLoading = false;
  bool _isReverseGeocoding = false;
  bool _isSearching = false;
  List<SearchResultItem> _suggestions = [];
  bool _hasUserMovedMap = false;
  
  final LocationService _locationService = LocationService();
  final TextEditingController _searchController = TextEditingController();
  Timer? _reverseGeocodeTimer;

  @override
  void initState() {
    super.initState();
    _selectedLocation = LatLng(widget.lat, widget.lng);
    _initialLocation = LatLng(widget.lat, widget.lng);
    _locationLabel = widget.address;
    _searchController.text = widget.address;
  }

  @override
  void dispose() {
    _reverseGeocodeTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  // Handle search input changes
  void _onSearchChanged(String query) {
    // Optional: You can add real-time feedback here if needed
    // For now, we'll only search when submitted
  }

  // Handle search submission
  void _onSearchSubmitted(String query) async {
    if (query.trim().isEmpty) {
      _loadNearbyChurches();
      return;
    }

    setState(() {
      _isSearching = true;
      _showSuggestions = true;
    });

    try {
      final results = await _locationService.searchPlaces(query.trim());
      if (mounted) {
        setState(() {
          _suggestions = results;
          _isSearching = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _suggestions = [];
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Search failed: ${error.toString()}')),
        );
      }
    }
  }

  // Load nearby churches and current location
  void _loadNearbyChurches() async {
    setState(() {
      _isLoading = true;
      _showSuggestions = true;
    });

    try {
      Position position = await _locationService.getCurrentPosition();
      final results = await _locationService.getNearbyChurches(position);
      
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

  // Handle current location button press
  void _onCurrentLocationPressed() async {
    try {
      final position = await _locationService.getCurrentPosition();
      final newLocation = LatLng(position.latitude, position.longitude);
      
      setState(() {
        _selectedLocation = newLocation;
        _hasUserMovedMap = true;
        _showSuggestions = false;
      });
      
      _mapController.animateCamera(
        CameraUpdate.newLatLng(newLocation)
      );
      _reverseGeocode(newLocation);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get current location: ${error.toString()}')),
        );
      }
    }
  }

  // Simple direct reverse geocoding as fallback
  Future<String> _directReverseGeocode(LatLng location) async {
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=$googleApiKey&region=ph'
      );

      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          return data['results'][0]['formatted_address'] as String;
        } else {
          throw Exception('API Status: ${data['status']}');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Direct geocoding failed: $e');
    }
  }

  void _reverseGeocode(LatLng location) {
    _reverseGeocodeTimer?.cancel();
    
    setState(() {
      _isReverseGeocoding = true;
    });
    
    _reverseGeocodeTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        String address;
        try {
          address = await _directReverseGeocode(location);
        } catch (directError) {
          _locationService.clearCache();
          address = await _locationService.reverseGeocode(location);
        }
        
        if (mounted) {
          setState(() {
            _locationLabel = address;
            _isReverseGeocoding = false;
          });
          // Update search field text
          _searchController.text = address;
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _locationLabel = 'Error: ${e.toString()}';
            _isReverseGeocoding = false;
          });
          // Update search field text
          _searchController.text = _locationLabel;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Geocoding failed: ${e.toString()}')),
          );
        }
      }
    });
  }

  void _selectSuggestion(SearchResultItem item) async {
    setState(() {
      _isLoading = true;
      _showSuggestions = false;
    });

    try {
      SearchResultItem selectedItem = item;
      
      if (item.placeId != null) {
        // Get place details for places with placeId
        final details = await _locationService.getPlaceDetails(item.placeId!);
        if (details != null) {
          selectedItem = details;
        }
      }
      
      final newLocation = selectedItem.location;
      if (mounted) {
        setState(() {
          _selectedLocation = newLocation;
          _locationLabel = selectedItem.address.isNotEmpty ? selectedItem.address : selectedItem.name;
          _searchController.text = _locationLabel;
          _hasUserMovedMap = true;
          _isReverseGeocoding = false;
          _isLoading = false;
        });
        
        _reverseGeocodeTimer?.cancel();
        _mapController.animateCamera(CameraUpdate.newLatLng(newLocation));
      }
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
      _showSuggestions = false;
    });
    _reverseGeocode(tapped);
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _selectedLocation = position.target;
    });
    
    if (!_hasUserMovedMap) {
      final distance = _calculateDistance(
        _initialLocation.latitude,
        _initialLocation.longitude,
        position.target.latitude,
        position.target.longitude,
      );
      if (distance > 0.01) {
        _hasUserMovedMap = true;
      }
    }
  }

  void _onCameraIdle() {
    if (_hasUserMovedMap) {
      _reverseGeocode(_selectedLocation);
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    final distanceInMeters = Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
    return distanceInMeters / 1000;
  }

  void _chooseLocation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ContactInfoScreen(
          firstName: widget.firstName,
          lastName: widget.lastName,
          birthday: widget.birthday,
          gender: widget.gender,
          username: widget.username,
          address: _locationLabel,
          lat: _selectedLocation.latitude,
          lng: _selectedLocation.longitude,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
        isLoading: _isLoading,
        loadingText: "Loading...",
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _selectedLocation,
                zoom: 15,
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
                child: DebouncedSearchField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  onSubmitted: _onSearchSubmitted,
                  onCurrentLocationPressed: _onCurrentLocationPressed,
                  hintText: "Search for a location...",
                ),
              ),
            ),

            // Test button - remove this after testing
            Positioned(
              top: 170,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 4)
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () => _reverseGeocode(_selectedLocation),
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
            if (_showSuggestions)
              Positioned(
                top: 110,
                left: 16,
                right: 16,
                child: Material(
                  elevation: 6,
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
                                onPressed: () => setState(() => _showSuggestions = false),
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

            // Bottom sheet
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _chooseLocation,
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
      ),
    );
  }
}