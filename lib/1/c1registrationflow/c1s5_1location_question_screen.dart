import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'location_cubit.dart';
import 'location_service.dart';
import 'search_result_item.dart';
import 'debounced_search_field.dart';
import 'loading_overlay.dart';
import 'error_widget.dart';
import 'c1s5_2geolocation_screen.dart';
import '../../3/c1widgets/back_button.dart';

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

class _LocationQuestionScreenState extends State<LocationQuestionScreen> {
  late TextEditingController _searchController;
  late LocationCubit _locationCubit;
  SearchResultItem? _selectedLocation;
  bool _hasSearched = false; // Track if user has performed a search

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _locationCubit = LocationCubit(LocationService());
    _locationCubit.loadNearbyChurches(); // Load nearby churches initially
  }

  @override
  void dispose() {
    _searchController.dispose();
    _locationCubit.close();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // Optional: Handle real-time changes (e.g., clear selection if text changes)
    if (_selectedLocation != null && _selectedLocation!.name != value) {
      setState(() {
        _selectedLocation = null;
      });
    }
  }

  void _onSearchSubmitted(String value) {
    setState(() {
      _hasSearched = true;
    });
        
    if (value.trim().isEmpty) {
      _locationCubit.loadNearbyChurches();
    } else {
      _locationCubit.searchLocations(value.trim());
    }
  }

  void _onCurrentLocationPressed() {
    setState(() {
      _hasSearched = true;
    });
    _locationCubit.loadNearbyChurches();
    _searchController.clear();
  }

  void _onSelectSuggestion(SearchResultItem item) {
    setState(() {
      _selectedLocation = item;
      _searchController.text = item.name;
    });
  }

  void _goToMapScreen() {
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a location first")),
      );
      return;
    }
    // If it's a place with placeId, get details first
    if (_selectedLocation!.placeId != null) {
      _locationCubit.selectLocation(_selectedLocation!);
    } else {
      _navigateToMapScreen(_selectedLocation!);
    }
  }

  void _navigateToMapScreen(SearchResultItem selectedLocation) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => GeolocationScreen(
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
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          
          var tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          
          // Add fade transition for smoother effect
          var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
              .animate(CurvedAnimation(parent: animation, curve: curve));
          
          return FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(position: offsetAnimation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWeb = size.width > 600;
    
    return BlocProvider.value(
      value: _locationCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              // Back button - unchanged position
              const Positioned(
                top: 8.0,
                left: 8.0,
                child: TeleoBackButton(),
              ),
              
              // Title positioned at same height as back button
              Positioned(
                top: 8.0, // Same height as back button
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    "Select your area",
                    style: TextStyle(
                      fontSize: isWeb ? 36.0 : 28.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              
              // Main content - starts below the title
              Positioned.fill(
                top: 60, // Space for back button and title
                child: isWeb
                  ? Center(
                      child: SizedBox(
                        width: 500,
                        child: _buildForm(isWeb),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: _buildForm(isWeb),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(bool isWeb) {
    return BlocConsumer<LocationCubit, LocationState>(
      listener: (context, state) {
        if (state is LocationSelected) {
          _navigateToMapScreen(state.selectedLocation);
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is LocationLoading,
          loadingText: "Searching locations...",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // No top spacing needed since title is positioned above
              
              // Subtitle with softer styling
              Text(
                "Find your location or nearby places",
                style: TextStyle(
                  fontSize: isWeb ? 18.0 : 16.0,
                  color: Colors.black45,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isWeb ? 24 : 20), // Space before search
              
              // Search field
              DebouncedSearchField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                onSubmitted: _onSearchSubmitted,
                onCurrentLocationPressed: _onCurrentLocationPressed,
                enabled: state is! LocationLoading,
              ),
              const SizedBox(height: 12),
              
              // Lighter instruction text
              if (!_hasSearched)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade100, width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline, 
                        color: Colors.grey.shade400,
                        size: 16
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Type your address and press Enter to search",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              
              SizedBox(height: _hasSearched ? 16 : 12),
              
              // Content area - takes up most of the remaining space
              Expanded(
                flex: 1,
                child: _buildContent(state),
              ),
              
              // Next button
              Padding(
                padding: EdgeInsets.only(
                  bottom: isWeb ? 20.0 : 24.0,
                  top: 12.0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: isWeb ? 60.0 : 56.0,
                  child: ElevatedButton(
                    onPressed: _selectedLocation != null ? _goToMapScreen : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002642),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: Text(
                      "Next",
                      style: TextStyle(
                        fontSize: isWeb ? 18.0 : 16.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(LocationState state) {
    if (state is LocationError) {
      return ErrorDisplay(
        message: state.message,
        onRetry: () => _locationCubit.loadNearbyChurches(),
      );
    }

    if (state is LocationLoaded) {
      return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: state.suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = state.suggestions[index];
          final isSelected = _selectedLocation?.name == suggestion.name;
                    
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: isSelected 
                ? const Color(0xFF002642).withValues(alpha: 0.03) 
                : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _onSelectSuggestion(suggestion),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                        ? const Color(0xFF002642).withValues(alpha: 0.3)
                        : Colors.grey.shade100,
                      width: isSelected ? 1.5 : 1,
                    ),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected 
                            ? const Color(0xFF002642).withValues(alpha: 0.1)
                            : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          suggestion.icon,
                          color: isSelected 
                            ? const Color(0xFF002642) 
                            : Colors.grey.shade500,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              suggestion.name,
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected 
                                  ? const Color(0xFF002642) 
                                  : Colors.black87,
                                fontSize: 15,
                                letterSpacing: 0.1,
                              ),
                            ),
                            if (suggestion.address.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                suggestion.address,
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 13,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (suggestion.distance > 0) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${suggestion.distance.toStringAsFixed(1)} km",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      if (isSelected)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF002642),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    // Show initial state
    if (!_hasSearched) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.location_searching, 
                size: 40,
                color: Colors.grey.shade300
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Nearby places will appear here",
              style: TextStyle(
                fontSize: 16, 
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Or search for your specific address",
              style: TextStyle(
                fontSize: 13, 
                color: Colors.grey.shade400,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          "No locations found. Try a different search term.",
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 15,
            letterSpacing: 0.2,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
