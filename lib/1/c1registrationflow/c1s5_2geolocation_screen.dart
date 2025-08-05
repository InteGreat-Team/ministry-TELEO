import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
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
import '../../3/c1widgets/back_button.dart';

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
  
  // Bottom sheet controller - make it nullable to avoid late initialization error
  DraggableScrollableController? _bottomSheetController;
  double _bottomSheetSize = 0.15; // Start at minimal size
    
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
    _bottomSheetController = DraggableScrollableController(); // Initialize here
  }

  @override
  void dispose() {
    _reverseGeocodeTimer?.cancel();
    _searchController.dispose();
    _bottomSheetController?.dispose(); // Add null check
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
          // Update search field text with current location
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
          _searchController.text = _locationLabel; // Update search bar text
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
            // Full screen map
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

            // Top search bar with current location text
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 12,
              right: 12,
              child: Row(
                children: [
                  // Back button
                  Container(
                    width: MediaQuery.of(context).size.width > 600 ? 50 : 44,
                    height: MediaQuery.of(context).size.width > 600 ? 50 : 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back, 
                        size: MediaQuery.of(context).size.width > 600 ? 24 : 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Search field with current location text
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.width > 600 ? 50 : 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width > 600 ? 25 : 22,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search for a location...",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: MediaQuery.of(context).size.width > 600 ? 16 : 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade600,
                            size: MediaQuery.of(context).size.width > 600 ? 24 : 20,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.my_location,
                              color: Colors.grey.shade600,
                              size: MediaQuery.of(context).size.width > 600 ? 24 : 20,
                            ),
                            onPressed: _onCurrentLocationPressed,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width > 600 ? 20 : 16,
                            vertical: MediaQuery.of(context).size.width > 600 ? 15 : 12,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width > 600 ? 16 : 14,
                          color: Colors.black87,
                        ),
                        onChanged: _onSearchChanged,
                        onSubmitted: _onSearchSubmitted,
                      ),
                    ),
                  ),
                ],
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
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Getting address...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Suggestions dropdown
            if (_showSuggestions)
              Positioned(
                top: MediaQuery.of(context).padding.top + 60,
                left: 12,
                right: 12,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  shadowColor: Colors.black.withValues(alpha: 0.1),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 280),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _isSearching ? 'Searching...' : 'Suggestions',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, size: 18, color: Colors.grey.shade600),
                                onPressed: () => setState(() => _showSuggestions = false),
                                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                              ),
                            ],
                          ),
                        ),
                        Divider(height: 1, color: Colors.grey.shade100),
                        
                        // Content
                        if (_isSearching)
                          const Padding(
                            padding: EdgeInsets.all(32),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        else if (_suggestions.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              'No results found',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 13,
                              ),
                            ),
                          )
                        else
                          Flexible(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              shrinkWrap: true,
                              itemCount: _suggestions.length,
                              itemBuilder: (context, index) {
                                final item = _suggestions[index];
                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => _selectSuggestion(item),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      child: Row(
                                        children: [
                                          Icon(
                                            item.icon, 
                                            size: 16, 
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                if (item.address.isNotEmpty) ...[
                                                  const SizedBox(height: 1),
                                                  Text(
                                                    item.address,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey.shade600,
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                          if (item.distance > 0)
                                            Text(
                                              '${item.distance.toStringAsFixed(1)}km',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey.shade500,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

            // Swipeable bottom sheet (non-scrollable)
            DraggableScrollableSheet(
              controller: _bottomSheetController,
              initialChildSize: 0.15,
              minChildSize: 0.15,
              maxChildSize: 0.4,
              snap: true,
              snapSizes: const [0.15, 0.4],
              builder: (context, scrollController) {
                final screenHeight = MediaQuery.of(context).size.height;
                final isWeb = MediaQuery.of(context).size.width > 600;
                final bottomPadding = MediaQuery.of(context).padding.bottom;
                
                return GestureDetector(
                  onTap: () {}, // Prevents tap-through to map
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const ClampingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: screenHeight * 0.4,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              // Drag handle
                              GestureDetector(
                                onPanUpdate: (details) {
                                  // Enable dragging on the handle area
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: Center(
                                    child: Container(
                                      width: 40,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              
                              // Content
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    isWeb ? 32 : 20, 
                                    0, 
                                    isWeb ? 32 : 20, 
                                    0
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Location display
                                      Row(
                                        children: [
                                          Container(
                                            width: 12,
                                            height: 12,
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _isReverseGeocoding
                                                ? Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 14,
                                                        height: 14,
                                                        child: CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade600),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Flexible(
                                                        child: Text(
                                                          'Getting address...',
                                                          style: TextStyle(
                                                            fontSize: isWeb ? 16 : 14,
                                                            color: Colors.grey.shade600,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Text(
                                                    _locationLabel,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: isWeb ? 17 : 15,
                                                      color: Colors.black87,
                                                    ),
                                                    maxLines: 3,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                          ),
                                        ],
                                      ),
                                      
                                      SizedBox(height: isWeb ? 16 : 12),
                                      
                                      // Additional location details
                                      Text(
                                        'Coordinates',
                                        style: TextStyle(
                                          fontSize: isWeb ? 14 : 12,
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${_selectedLocation.latitude.toStringAsFixed(6)}, ${_selectedLocation.longitude.toStringAsFixed(6)}',
                                        style: TextStyle(
                                          fontSize: isWeb ? 15 : 13,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      
                                      // Flexible spacer
                                      SizedBox(height: isWeb ? 24 : 16),
                                      
                                      // Choose location button
                                      Padding(
                                        padding: EdgeInsets.only(
                                          bottom: math.max(bottomPadding, isWeb ? 16 : 12),
                                        ),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: isWeb ? 56 : 52,
                                          child: ElevatedButton(
                                            onPressed: _chooseLocation,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF002642),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              elevation: 0,
                                              shadowColor: Colors.transparent,
                                            ),
                                            child: Text(
                                              "Choose this location",
                                              style: TextStyle(
                                                fontSize: isWeb ? 18 : 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}