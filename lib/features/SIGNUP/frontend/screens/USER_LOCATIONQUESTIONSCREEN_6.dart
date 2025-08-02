// lib/features/SIGNUP/frontend/screens/USER_LOCATIONQUESTIONSCREEN_6.dart
//IMPORT PACKAGES
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//IMPORT MVVM UPDATED
import '../../../../3/c1widgets/back_button.dart'; // Assuming this path for TeleoBackButton
import '../../backend/viewmodels/USER_SIGNUPVIEWMODELS.dart'; // Import UserSignupViewModel
import '../../geolocation/backend/GEO_LOCATIONVIEWMODEL.dart'; // UPDATED: Import GeoLocationViewModel
import '../../geolocation/backend/GEO_LOCATIONMODEL.dart'; // UPDATED: Import GeoLocationModel from backend
import '../../geolocation/frontend/GEO_DEBOUNCEDSEARCHFIELD.dart'; // UPDATED: Import GeoDebouncedSearchField
import '../../geolocation/frontend/GEO_LOADINGOVERLAY.dart'; // UPDATED: Import GeoLoadingOverlay
import '../../geolocation/frontend/GEO_ERRORWIDGET.dart'; // UPDATED: Import GeoErrorWidget
import '../../geolocation/frontend/GEO_SEARCHRESULTITEM.dart'; 
import '../../geolocation/frontend/GEO_LOCATIONCUBIT.dart'; 

//IMPORT NOT MVVM UPDATED 
import '../../../../3/c1widgets/back_button.dart'; // Assuming this path for TeleoBackButton
import '../../../../1/c1registrationflow/c1s5_2geolocation_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // For LatLng



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
    // Optionally load nearby churches or current location on init
    context.read<LocationViewModel>().loadNearbyChurches(); // UPDATED: Use LocationViewModel
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userSignupViewModel = context.watch<UserSignupViewModel>();
    final locationViewModel = context.watch<LocationViewModel>(); // UPDATED: Use LocationViewModel

    return Scaffold(
      appBar: AppBar(
        title: const Text('Where are you located?'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GeoLoadingOverlay(
        isLoading: locationViewModel.isLoading,
        loadingText: locationViewModel.state == LocationState.loading && locationViewModel.suggestions.isEmpty
            ? "Searching locations..."
            : "Loading...",
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GeoDebouncedSearchField(
                controller: _searchController,
                onChanged: (query) => locationViewModel.searchLocations(query), // UPDATED: Use LocationViewModel
                onSubmitted: (query) => locationViewModel.searchLocations(query), // UPDATED: Use LocationViewModel
                onCurrentLocationPressed: () => locationViewModel.loadNearbyChurches(), // UPDATED: Use LocationViewModel
                hintText: "Search for a location...",
              ),
              const SizedBox(height: 16),
              if (locationViewModel.state == LocationState.error)
                GeoErrorWidget(
                  message: locationViewModel.errorMessage ?? 'An unknown error occurred.',
                  onRetry: () => locationViewModel.loadNearbyChurches(),
                )
              else if (locationViewModel.state == LocationState.loaded || locationViewModel.state == LocationState.selected)
                Expanded(
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: locationViewModel.suggestions.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = locationViewModel.suggestions[index];
                        final isSelected = locationViewModel.selectedLocation?.name == item.name;
                        return ListTile(
                          leading: Icon(item.icon, color: isSelected ? Theme.of(context).primaryColor : null),
                          title: Text(
                            item.name,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                            ),
                          ),
                          subtitle: item.address.isNotEmpty ? Text(item.address) : null,
                          trailing: item.distance > 0
                              ? Text('${item.distance.toStringAsFixed(1)}km')
                              : null,
                          onTap: () {
                            locationViewModel.selectLocation(item); // UPDATED: Use LocationViewModel
                            // Update ViewModel with selected location
                            userSignupViewModel.setAddress(item.address.isNotEmpty ? item.address : item.name);
                            userSignupViewModel.setLat(item.location.latitude);
                            userSignupViewModel.setLng(item.location.longitude);
                          },
                        );
                      },
                    ),
                  ),
                )
              else
                const Spacer(), // Placeholder for initial state or no results
              
              const Spacer(),
              ElevatedButton(
                onPressed: locationViewModel.selectedLocation != null && !locationViewModel.isLoading
                    ? () {
                        userSignupViewModel.setAddress(locationViewModel.selectedLocation!.address);
                        userSignupViewModel.setLat(locationViewModel.selectedLocation!.location.latitude);
                        userSignupViewModel.setLng(locationViewModel.selectedLocation!.location.longitude);
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
