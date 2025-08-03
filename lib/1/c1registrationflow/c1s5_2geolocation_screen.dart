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

class _GeolocationScreenState extends State<GeolocationScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  
  // Optimizations
  @override
  bool get wantKeepAlive => true;

  GoogleMapController? _mapController;
  late LatLng _selectedLocation;
  late LatLng _initialLocation;
  String _locationLabel = '';
  bool _showSuggestions = false;
  bool _isLoading = false;
  bool _isReverseGeocoding = false;
  bool _isSearching = false;
  bool _hasUserMovedMap = false;
  bool _isDisposed = false;
  
  List<SearchResultItem> _suggestions = [];
  
  // Services and controllers
  late final LocationService _locationService;
  late final TextEditingController _searchController;
  
  // Timers and completer
  Timer? _reverseGeocodeTimer;
  Timer? _searchDebounceTimer;
  Completer<GoogleMapController>? _mapControllerCompleter;
  
  // Performance optimizations
  late final AnimationController _pinAnimationController;
  late final Animation<double> _pinAnimation;
  
  // Cache for network requests
  final Map<String, String> _geocodeCache = {};
  final Map<String, List<SearchResultItem>> _searchCache = {};
  
  // Connection management
  StreamSubscription<http.Client>? _httpClientSubscription;
  
  @override
  void initState() {
    super.initState();
    _initializeState();
    _setupAnimations();
  }

  void _initializeState() {
    _selectedLocation = LatLng(widget.lat, widget.lng);
    _initialLocation = LatLng(widget.lat, widget.lng);
    _locationLabel = widget.address;
    _searchController = TextEditingController(text: widget.address);
    _locationService = LocationService();
    _mapControllerCompleter = Completer<GoogleMapController>();
  }

  void _setupAnimations() {
    _pinAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _pinAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pinAnimationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _isDisposed = true;
    _cleanup();
    super.dispose();
  }

  void _cleanup() {
    _reverseGeocodeTimer?.cancel();
    _searchDebounceTimer?.cancel();
    _httpClientSubscription?.cancel();
    _searchController.dispose();
    _pinAnimationController.dispose();
    _mapController?.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    if (_isDisposed) return;
    
    _mapController = controller;
    if (!_mapControllerCompleter!.isCompleted) {
      _mapControllerCompleter!.complete(controller);
    }
    
    // Optimize map performance
    _optimizeMapPerformance();
  }

  void _optimizeMapPerformance() {
    _mapController?.setMapStyle('''
      [
        {
          "featureType": "poi",
          "stylers": [{"visibility": "simplified"}]
        }
      ]
    ''');
  }

  // Optimized search with debouncing and caching
  void _onSearchChanged(String query) {
    if (_isDisposed) return;
    
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (!_isDisposed && query.length > 2) {
        // Optional: Show search suggestions in real-time
      }
    });
  }

  void _onSearchSubmitted(String query) async {
    if (_isDisposed) return;
    
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      _loadNearbyChurches();
      return;
    }

    // Check cache first
    if (_searchCache.containsKey(trimmedQuery)) {
      setState(() {
        _suggestions = _searchCache[trimmedQuery]!;
        _showSuggestions = true;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _showSuggestions = true;
    });

    try {
      final results = await _performSearchWithRetry(trimmedQuery);
      if (_isDisposed) return;

      // Cache the results
      _searchCache[trimmedQuery] = results;
      
      setState(() {
        _suggestions = results;
        _isSearching = false;
      });
    } catch (error) {
      if (!_isDisposed) {
        _handleError('Search failed: ${error.toString()}', () {
          _onSearchSubmitted(query);
        });
      }
    }
  }

  Future<List<SearchResultItem>> _performSearchWithRetry(String query, [int retries = 3]) async {
    for (int i = 0; i < retries; i++) {
      try {
        return await _locationService.searchPlaces(query);
      } catch (e) {
        if (i == retries - 1) rethrow;
        await Future.delayed(Duration(milliseconds: 500 * (i + 1)));
      }
    }
    throw Exception('Search failed after retries');
  }

  void _loadNearbyChurches() async {
    if (_isDisposed) return;
    
    setState(() {
      _isLoading = true;
      _showSuggestions = true;
    });

    try {
      final position = await _locationService.getCurrentPosition();
      final results = await _locationService.getNearbyChurches(position);
      
      if (!_isDisposed) {
        setState(() {
          _suggestions = results;
          _isLoading = false;
        });
      }
    } catch (error) {
      if (!_isDisposed) {
        _handleError('Failed to load suggestions: ${error.toString()}', _loadNearbyChurches);
      }
    }
  }

  void _onCurrentLocationPressed() async {
    if (_isDisposed) return;
    
    try {
      setState(() => _isLoading = true);
      
      final position = await _locationService.getCurrentPosition();
      final newLocation = LatLng(position.latitude, position.longitude);
      
      if (_isDisposed) return;
      
      await _updateLocation(newLocation, shouldAnimate: true);
      
      setState(() {
        _hasUserMovedMap = true;
        _showSuggestions = false;
        _isLoading = false;
      });
      
    } catch (error) {
      if (!_isDisposed) {
        setState(() => _isLoading = false);
        _handleError('Failed to get current location: ${error.toString()}', null);
      }
    }
  }

  Future<void> _updateLocation(LatLng newLocation, {bool shouldAnimate = false}) async {
    if (_isDisposed) return;
    
    setState(() {
      _selectedLocation = newLocation;
    });
    
    if (_mapController != null) {
      if (shouldAnimate) {
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(newLocation, 15),
        );
      } else {
        await _mapController!.moveCamera(
          CameraUpdate.newLatLng(newLocation),
        );
      }
    }
    
    _triggerPinAnimation();
    _reverseGeocode(newLocation);
  }

  void _triggerPinAnimation() {
    _pinAnimationController.forward().then((_) {
      _pinAnimationController.reverse();
    });
  }

  // Optimized reverse geocoding with caching and retry logic
  void _reverseGeocode(LatLng location) {
    if (_isDisposed) return;
    
    _reverseGeocodeTimer?.cancel();
    
    final cacheKey = '${location.latitude.toStringAsFixed(4)},${location.longitude.toStringAsFixed(4)}';
    
    // Check cache first
    if (_geocodeCache.containsKey(cacheKey)) {
      setState(() {
        _locationLabel = _geocodeCache[cacheKey]!;
        _searchController.text = _locationLabel;
        _isReverseGeocoding = false;
      });
      return;
    }
    
    setState(() => _isReverseGeocoding = true);
    
    _reverseGeocodeTimer = Timer(const Duration(milliseconds: 800), () async {
      if (_isDisposed) return;
      
      try {
        String address = await _performReverseGeocodeWithRetry(location);
        
        if (!_isDisposed) {
          // Cache the result
          _geocodeCache[cacheKey] = address;
          
          setState(() {
            _locationLabel = address;
            _searchController.text = address;
            _isReverseGeocoding = false;
          });
        }
      } catch (e) {
        if (!_isDisposed) {
          final errorMessage = 'Unable to get address';
          setState(() {
            _locationLabel = errorMessage;
            _searchController.text = errorMessage;
            _isReverseGeocoding = false;
          });
        }
      }
    });
  }

  Future<String> _performReverseGeocodeWithRetry(LatLng location, [int retries = 2]) async {
    for (int i = 0; i < retries; i++) {
      try {
        // Try direct geocoding first (faster)
        return await _directReverseGeocode(location);
      } catch (directError) {
        try {
          // Fallback to location service
          _locationService.clearCache();
          return await _locationService.reverseGeocode(location);
        } catch (serviceError) {
          if (i == retries - 1) {
            throw Exception('Geocoding failed: $serviceError');
          }
          await Future.delayed(Duration(milliseconds: 500 * (i + 1)));
        }
      }
    }
    throw Exception('Geocoding failed after retries');
  }

  Future<String> _directReverseGeocode(LatLng location) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=$googleApiKey&region=ph&result_type=street_address|premise|subpremise'
    );

    final response = await http.get(url).timeout(
      const Duration(seconds: 10),
      onTimeout: () => throw TimeoutException('Request timeout'),
    );
    
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
  }

  void _selectSuggestion(SearchResultItem item) async {
    if (_isDisposed) return;
    
    setState(() {
      _isLoading = true;
      _showSuggestions = false;
    });

    try {
      SearchResultItem selectedItem = item;
      
      if (item.placeId != null) {
        final details = await _locationService.getPlaceDetails(item.placeId!);
        if (details != null) {
          selectedItem = details;
        }
      }
      
      if (!_isDisposed) {
        final newLocation = selectedItem.location;
        final address = selectedItem.address.isNotEmpty ? selectedItem.address : selectedItem.name;
        
        setState(() {
          _selectedLocation = newLocation;
          _locationLabel = address;
          _searchController.text = address;
          _hasUserMovedMap = true;
          _isReverseGeocoding = false;
          _isLoading = false;
        });
        
        _reverseGeocodeTimer?.cancel();
        await _mapController?.animateCamera(CameraUpdate.newLatLng(newLocation));
        _triggerPinAnimation();
      }
    } catch (error) {
      if (!_isDisposed) {
        _handleError('Failed to select location: ${error.toString()}', null);
      }
    }
  }

  void _onMapTap(LatLng tapped) {
    if (_isDisposed) return;
    
    setState(() {
      _selectedLocation = tapped;
      _hasUserMovedMap = true;
      _showSuggestions = false;
    });
    
    _triggerPinAnimation();
    _reverseGeocode(tapped);
  }

  void _onCameraMove(CameraPosition position) {
    if (_isDisposed) return;
    
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
    if (_isDisposed) return;
    
    if (_hasUserMovedMap) {
      _reverseGeocode(_selectedLocation);
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    final distanceInMeters = Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
    return distanceInMeters / 1000;
  }

  void _chooseLocation() {
    if (_isDisposed) return;
    
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

  void _handleError(String message, VoidCallback? retry) {
    if (!mounted || _isDisposed) return;
    
    setState(() {
      _isLoading = false;
      _isSearching = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        action: retry != null
            ? SnackBarAction(
                label: 'Retry',
                onPressed: retry,
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    return Scaffold(
      body: LoadingOverlay(
        isLoading: _isLoading,
        loadingText: "Loading...",
        child: Stack(
          children: [
            _buildMap(),
            _buildBackButton(),
            _buildSearchBar(),
            _buildCenterPin(),
            if (_showSuggestions) _buildSuggestionsPanel(),
            _buildBottomSheet(),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return GoogleMap(
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
      compassEnabled: false,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      // Performance optimizations
      liteModeEnabled: false,
      buildingsEnabled: true,
      indoorViewEnabled: false,
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 50,
      left: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: 50,
      left: 70,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2))
          ],
        ),
        child: DebouncedSearchField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          onSubmitted: _onSearchSubmitted,
          onCurrentLocationPressed: _onCurrentLocationPressed,
          hintText: "Search for a location...",
          enabled: !_isLoading && !_isSearching,
        ),
      ),
    );
  }

  Widget _buildCenterPin() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isReverseGeocoding)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Getting address...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          AnimatedBuilder(
            animation: _pinAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pinAnimation.value,
                child: Icon(
                  Icons.location_pin,
                  size: 50,
                  color: _isReverseGeocoding ? Colors.orange : Colors.red,
                  shadows: const [
                    Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsPanel() {
    return Positioned(
      top: 110,
      left: 16,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 350),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isSearching ? 'Searching...' : 'Search Results',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => setState(() => _showSuggestions = false),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ],
                ),
              ),
              
              // Content
              if (_isSearching)
                Container(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: Colors.indigo),
                      const SizedBox(height: 16),
                      const Text('Searching locations...'),
                    ],
                  ),
                )
              else if (_suggestions.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      const Text(
                        'No results found',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shrinkWrap: true,
                    itemCount: _suggestions.length,
                    separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
                    itemBuilder: (context, index) {
                      final item = _suggestions[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(item.icon, size: 20, color: Colors.indigo),
                        ),
                        title: Text(
                          item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: item.address.isNotEmpty 
                          ? Text(
                              item.address,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                          : null,
                        trailing: item.distance > 0 
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.green.shade200),
                              ),
                              child: Text(
                                '${item.distance.toStringAsFixed(1)}km',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
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
    );
  }

  Widget _buildBottomSheet() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -5),
            )
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location indicator
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.location_on, color: Colors.red, size: 20),
                  ),
                  const SizedBox(width: 12),
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
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
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
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Choose location button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isReverseGeocoding ? null : _chooseLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: _isReverseGeocoding ? 0 : 2,
                  ),
                  child: Text(
                    _isReverseGeocoding ? "Getting address..." : "Choose this location",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}