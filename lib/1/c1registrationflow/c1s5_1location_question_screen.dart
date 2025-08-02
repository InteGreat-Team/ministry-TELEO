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

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _locationCubit,
      child: Scaffold(
        appBar: AppBar(title: const Text("Select your area")),
        body: BlocConsumer<LocationCubit, LocationState>(
          listener: (context, state) {
            if (state is LocationSelected) {
              _navigateToMapScreen(state.selectedLocation);
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
                    DebouncedSearchField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      onSubmitted: _onSearchSubmitted, // NEW: Search on submit
                      onCurrentLocationPressed: _onCurrentLocationPressed,
                      enabled: state is! LocationLoading,
                    ),
                    const SizedBox(height: 12),
                    // Add instruction text
                    if (!_hasSearched)
                      Container(
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
                      ),
                    if (_hasSearched) const SizedBox(height: 12),
                    Expanded(
                      child: _buildContent(state),
                    ),
                    const SizedBox(height: 16),
                    // Next Button
                    SizedBox(
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
                        ),
                        child: const Text("Next"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
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
        itemCount: state.suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = state.suggestions[index];
          final isSelected = _selectedLocation?.name == suggestion.name;
          
          return Card(
            color: isSelected ? Colors.indigo.shade50 : null,
            child: ListTile(
              leading: Icon(
                suggestion.icon,
                color: isSelected ? Colors.indigo : null,
              ),
              title: Text(
                suggestion.name,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.indigo : null,
                ),
              ),
              subtitle: Text(suggestion.address),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (suggestion.distance > 0)
                    Text("${suggestion.distance.toStringAsFixed(1)} km"),
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

    // Show initial state with nearby churches or instruction
    if (!_hasSearched) {
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

    return const Center(
      child: Text("No locations found. Try a different search term."),
    );
  }
}