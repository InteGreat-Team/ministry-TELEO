import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../backend/viewmodels/USER_SIGNUPVIEWMODELS.dart';
import '../../geolocation/backend/GEO_LOCATIONVIEWMODEL.dart'; // FIXED: Updated import path
import '../../geolocation/frontend/ErrorDisplay.dart';
import '../../geolocation/frontend/LoadingOverlay.dart';
import '../../geolocation/frontend/GEO_DEBOUNCEDSEARCHFIELD.dart';
import '../../geolocation/frontend/GEO_LOCATIONUTILS.dart';

class UserLocationQuestionScreen6 extends StatefulWidget {
  const UserLocationQuestionScreen6({super.key});

  @override
  State<UserLocationQuestionScreen6> createState() => _UserLocationQuestionScreen6State();
}

class _UserLocationQuestionScreen6State extends State<UserLocationQuestionScreen6> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load nearby churches initially
    context.read<LocationViewModel>().loadNearbyChurches(); // FIXED: Use LocationViewModel
    // Set initial search controller text if a location was already selected in the ViewModel
    final userSignupViewModel = context.read<UserSignupViewModel>();
    if (userSignupViewModel.address != null && userSignupViewModel.address!.isNotEmpty) {
      _searchController.text = userSignupViewModel.address!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userSignupViewModel = context.watch<UserSignupViewModel>();
    final locationViewModel = context.watch<LocationViewModel>(); // FIXED: Use LocationViewModel

    return Scaffold(
      appBar: AppBar(
        title: const Text('Where are you located?'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LoadingOverlay(
        isLoading: locationViewModel.isLoading, // FIXED: Use locationViewModel
        loadingText: locationViewModel.state == LocationState.loading && locationViewModel.suggestions.isEmpty
            ? "Searching locations..."
            : "Loading...",
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GeoDebouncedSearchField( // FIXED: Use correct class name
                controller: _searchController,
                onChanged: (query) => locationViewModel.searchLocations(query), // FIXED: Use locationViewModel
                onSubmitted: (query) => locationViewModel.searchLocations(query), // FIXED: Use locationViewModel
                onCurrentLocationPressed: () {
                  locationViewModel.loadNearbyChurches(); // FIXED: Use locationViewModel
                  _searchController.clear(); // Clear search text when getting current location
                },
                hintText: "Search for a location...",
              ),
              const SizedBox(height: 12),
              // Add instruction text from old file
              if (!locationViewModel.hasSearched) // FIXED: Use locationViewModel
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
              if (locationViewModel.hasSearched) const SizedBox(height: 12), // FIXED: Use locationViewModel
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (locationViewModel.state == LocationState.error) { // FIXED: Use locationViewModel
                      return ErrorDisplay(
                        message: locationViewModel.errorMessage ?? 'An unknown error occurred.', // FIXED: Use locationViewModel
                        onRetry: () => locationViewModel.loadNearbyChurches(), // FIXED: Use locationViewModel
                      );
                    }
                    if (locationViewModel.state == LocationState.loaded || locationViewModel.state == LocationState.selected) { // FIXED: Use locationViewModel
                      if (locationViewModel.suggestions.isEmpty) { // FIXED: Use locationViewModel
                        return const Center(
                          child: Text("No locations found. Try a different search term."),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: locationViewModel.suggestions.length, // FIXED: Use locationViewModel
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = locationViewModel.suggestions[index]; // FIXED: Use locationViewModel
                          final isSelected = locationViewModel.selectedLocation?.name == item.name; // FIXED: Use locationViewModel
                          return Card(
                            color: isSelected ? Colors.indigo.shade50 : null,
                            child: ListTile(
                              leading: Icon(
                                item.icon,
                                color: isSelected ? Colors.indigo : null,
                              ),
                              title: Text(
                                item.name,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? Colors.indigo : Colors.black87,
                                ),
                              ),
                              subtitle: item.address.isNotEmpty ? Text(item.address) : null,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (item.distance > 0)
                                    Text(LocationUtils.formatDistance(item.distance)),
                                  if (isSelected) ...[
                                    const SizedBox(width: 8),
                                    Icon(Icons.check_circle, color: Colors.indigo),
                                  ],
                                ],
                              ),
                              onTap: () {
                                locationViewModel.selectLocation(item); // FIXED: Use locationViewModel
                                // Update ViewModel with selected location
                                userSignupViewModel.setAddress(item.address.isNotEmpty ? item.address : item.name);
                                userSignupViewModel.setLat(item.location.latitude);
                                userSignupViewModel.setLng(item.location.longitude);
                                _searchController.text = item.address.isNotEmpty ? item.address : item.name; // Update search field
                              },
                            ),
                          );
                        },
                      );
                    }
                    // Initial state or no search performed
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
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: locationViewModel.selectedLocation != null && !locationViewModel.isLoading // FIXED: Use locationViewModel
                    ? () {
                        userSignupViewModel.setAddress(locationViewModel.selectedLocation!.address.isNotEmpty ? locationViewModel.selectedLocation!.address : locationViewModel.selectedLocation!.name); // FIXED: Use locationViewModel
                        userSignupViewModel.setLat(locationViewModel.selectedLocation!.location.latitude); // FIXED: Use locationViewModel
                        userSignupViewModel.setLng(locationViewModel.selectedLocation!.location.longitude); // FIXED: Use locationViewModel
                        userSignupViewModel.navigateToGeolocationScreen(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Continue to Map'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Handle "Skip for now" or navigate to next screen without location
                  userSignupViewModel.navigateToContactInfoScreen(context);
                },
                child: const Text('Skip for now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}