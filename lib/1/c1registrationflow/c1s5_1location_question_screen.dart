import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'location_cubit.dart';
import 'location_service.dart';
import 'search_result_item.dart';
import 'debounced_search_field.dart';
import 'loading_overlay.dart';
import 'error_widget.dart';
import 'c1s5_2geolocation_screen.dart';

class LocationQuestionScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final DateTime birthday;
  final String gender;
  final String username;

  const LocationQuestionScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.username,
  });

  @override
  State<LocationQuestionScreen> createState() => _LocationQuestionScreenState();
}

class _LocationQuestionScreenState extends State<LocationQuestionScreen>
    with AutomaticKeepAliveClientMixin {
  // Optimizations
  @override
  bool get wantKeepAlive => true;

  late final TextEditingController _searchController;
  late final LocationCubit _locationCubit;
  
  SearchResultItem? _selectedLocation;
  bool _hasSearched = false;
  bool _isDisposed = false;
  
  // Cache for improved performance
  List<SearchResultItem>? _cachedNearbyChurches;
  String? _lastSearchQuery;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _locationCubit = LocationCubit(LocationService());
    
    // Pre-load nearby churches with error handling
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    if (_isDisposed) return;
    
    try {
      await _locationCubit.loadNearbyChurches();
    } catch (e) {
      if (mounted && !_isDisposed) {
        // Silent fail for initial load - user can retry manually
        debugPrint('Initial load failed: $e');
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _searchController.dispose();
    _locationCubit.close();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_isDisposed) return;
    
    // Clear selection only if text has significantly changed
    if (_selectedLocation != null && 
        !_selectedLocation!.name.toLowerCase().contains(value.toLowerCase()) &&
        value.length > 2) {
      setState(() {
        _selectedLocation = null;
      });
    }
  }

  void _onSearchSubmitted(String value) {
    if (_isDisposed) return;
    
    final trimmedValue = value.trim();
    
    // Avoid duplicate searches
    if (_lastSearchQuery == trimmedValue) return;
    _lastSearchQuery = trimmedValue;
    
    setState(() {
      _hasSearched = true;
    });
    
    if (trimmedValue.isEmpty) {
      _loadNearbyChurches();
    } else {
      _performSearch(trimmedValue);
    }
  }

  Future<void> _performSearch(String query) async {
    if (_isDisposed) return;
    
    try {
      await _locationCubit.searchLocations(query);
    } catch (e) {
      if (mounted && !_isDisposed) {
        _showErrorSnackBar('Search failed. Please try again.');
      }
    }
  }

  void _loadNearbyChurches() {
    if (_isDisposed) return;
    
    // Use cached data if available
    if (_cachedNearbyChurches != null) {
      // Simulate state update with cached data
      // Note: This would need to be handled properly in your LocationCubit
      setState(() {
        _hasSearched = true;
      });
    }
    
    _locationCubit.loadNearbyChurches();
  }

  void _onCurrentLocationPressed() {
    if (_isDisposed) return;
    
    setState(() {
      _hasSearched = true;
    });
    
    _loadNearbyChurches();
    _searchController.clear();
    _lastSearchQuery = null;
  }

  void _onSelectSuggestion(SearchResultItem item) {
    if (_isDisposed) return;
    
    setState(() {
      _selectedLocation = item;
      _searchController.text = item.name;
    });
    
    // Haptic feedback for better UX
    // HapticFeedback.lightImpact(); // Uncomment if you want haptic feedback
  }

  void _goToMapScreen() {
    if (_isDisposed) return;
    
    if (_selectedLocation == null) {
      _showErrorSnackBar("Please select a location first");
      return;
    }

    // Improved navigation with proper error handling
    try {
      if (_selectedLocation!.placeId != null) {
        _locationCubit.selectLocation(_selectedLocation!);
      } else {
        _navigateToMapScreen(_selectedLocation!);
      }
    } catch (e) {
      _showErrorSnackBar("Failed to proceed. Please try again.");
    }
  }

  void _navigateToMapScreen(SearchResultItem selectedLocation) {
    if (_isDisposed) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GeolocationScreen(
          firstName: widget.firstName,
          lastName: widget.lastName,
          birthday: widget.birthday,
          gender: widget.gender,
          username: widget.username,
          address: selectedLocation.address.isNotEmpty 
              ? selectedLocation.address 
              : selectedLocation.name,
          lat: selectedLocation.location.latitude,
          lng: selectedLocation.location.longitude,
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted || _isDisposed) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    return BlocProvider.value(
      value: _locationCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Select your area"),
          elevation: 0,
        ),
        body: BlocConsumer<LocationCubit, LocationState>(
          listener: (context, state) {
            if (_isDisposed) return;
            
            if (state is LocationSelected) {
              _navigateToMapScreen(state.selectedLocation);
            }
            
            // Cache nearby churches for better performance
            if (state is LocationLoaded && !_hasSearched) {
              _cachedNearbyChurches = state.suggestions;
            }
          },
          builder: (context, state) {
            return LoadingOverlay(
              isLoading: state is LocationLoading,
              loadingText: "Searching locations...",
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Optimized search field with better performance
                    DebouncedSearchField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      onSubmitted: _onSearchSubmitted,
                      onCurrentLocationPressed: _onCurrentLocationPressed,
                      enabled: state is! LocationLoading,
                    ),
                    const SizedBox(height: 12),
                    
                    // Instruction container - only show when needed
                    if (!_hasSearched) ...[
                      _buildInstructionCard(),
                      const SizedBox(height: 12),
                    ],
                    
                    // Main content area
                    Expanded(
                      child: _buildContent(state),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Next Button - optimized
                    _buildNextButton(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInstructionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              "Type your address and press Enter or tap the search button",
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _selectedLocation != null ? _goToMapScreen : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBackgroundColor: Colors.grey.shade300,
          elevation: _selectedLocation != null ? 2 : 0,
        ),
        child: const Text(
          "Next",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(LocationState state) {
    if (state is LocationError) {
      return ErrorDisplay(
        message: state.message,
        onRetry: () {
          if (_lastSearchQuery != null && _lastSearchQuery!.isNotEmpty) {
            _performSearch(_lastSearchQuery!);
          } else {
            _locationCubit.loadNearbyChurches();
          }
        },
      );
    }

    if (state is LocationLoaded) {
      return _buildLocationList(state.suggestions);
    }

    // Show initial state with nearby churches or instruction
    if (!_hasSearched) {
      return _buildEmptyState();
    }

    return const Center(
      child: Text(
        "No locations found. Try a different search term.",
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  Widget _buildLocationList(List<SearchResultItem> suggestions) {
    return ListView.builder(
      // Performance optimizations
      cacheExtent: 1000, // Cache more items
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        final isSelected = _selectedLocation?.name == suggestion.name;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: isSelected ? 4 : 1,
          color: isSelected ? Colors.indigo.shade50 : null,
          child: ListTile(
            leading: Icon(
              suggestion.icon,
              color: isSelected ? Colors.indigo : Colors.grey.shade600,
            ),
            title: Text(
              suggestion.name,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.indigo : null,
              ),
            ),
            subtitle: Text(
              suggestion.address,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (suggestion.distance > 0)
                  Text(
                    "${suggestion.distance.toStringAsFixed(1)} km",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                if (isSelected) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.check_circle, color: Colors.indigo),
                ],
              ],
            ),
            onTap: () => _onSelectSuggestion(suggestion),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_searching, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "Nearby churches will appear here",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            "Or search for your specific address",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}