import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:teleo_organized_new/mapkey.dart';
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
  late GooglePlace googlePlace;
  List<SearchResultItem> suggestions = [];
  late TextEditingController _searchController;
  LatLng? selectedLatLng;
  String selectedAddress = '';

  @override
  void initState() {
    super.initState();
    googlePlace = GooglePlace(googleApiKey);
    _searchController = TextEditingController();
    _loadInitialSuggestions();
  }

  void _loadInitialSuggestions() async {
    // Get user's current location
    final locPerm = await Geolocator.requestPermission();
    if (locPerm == LocationPermission.whileInUse ||
        locPerm == LocationPermission.always) {
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final response = await googlePlace.search.getNearBySearch(
        Location(lat: pos.latitude, lng: pos.longitude),
        2000,
        keyword: "Christian Church",
      );
      if (response != null && response.results != null) {
        setState(() {
          suggestions = [
            SearchResultItem(
              name: "Current location",
              address: "Using device GPS location",
              icon: Icons.my_location,
              location: LatLng(pos.latitude, pos.longitude),
              distance: 0,
            ),
            ...response.results!.map((r) {
              final loc = r.geometry?.location;
              return SearchResultItem(
                name: r.name ?? '',
                address: r.vicinity ?? '',
                icon: Icons.location_on_outlined,
                location: LatLng(loc?.lat ?? 0, loc?.lng ?? 0),
                distance: _calculateDistance(
                  pos.latitude,
                  pos.longitude,
                  loc?.lat ?? 0,
                  loc?.lng ?? 0,
                ),
              );
            }).toList()
          ];
        });
      }
    }
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    final distanceInMeters = Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
    return distanceInMeters / 1000;
  }

  void _onSearchChanged(String value) async {
    if (value.isNotEmpty) {
      final result = await googlePlace.autocomplete.get(value,
          components: [Component("country", "ph")]);
      if (result != null && result.predictions != null) {
        setState(() {
          suggestions = result.predictions!
              .map((p) => SearchResultItem(
                    name: p.description ?? '',
                    address: '',
                    placeId: p.placeId,
                    icon: Icons.location_on,
                  ))
              .toList();
        });
      }
    } else {
      _loadInitialSuggestions();
    }
  }

  void _onSelectSuggestion(SearchResultItem item) async {
    if (item.placeId != null) {
      final details = await googlePlace.details.get(item.placeId!);
      if (details != null && details.result != null) {
        final location = details.result!.geometry!.location!;
        final latLng = LatLng(location.lat!, location.lng!);
        setState(() {
          selectedLatLng = latLng;
          selectedAddress = details.result!.formattedAddress ?? '';
          _searchController.text = selectedAddress;
        });
      }
    } else if (item.name == "Current location") {
      _useCurrentLocation();
    } else {
      setState(() {
        selectedLatLng = item.location;
        selectedAddress = item.name;
        _searchController.text = item.name;
      });
    }
  }

  Future<void> _useCurrentLocation() async {
    final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final response = await googlePlace.search.getNearBySearch(
      Location(lat: pos.latitude, lng: pos.longitude),
      1,
    );

    String resolvedAddress = 'Current Location';
    if (response != null &&
        response.results != null &&
        response.results!.isNotEmpty) {
      resolvedAddress = response.results!.first.name ?? resolvedAddress;
    }

    setState(() {
      selectedLatLng = LatLng(pos.latitude, pos.longitude);
      selectedAddress = resolvedAddress;
      _searchController.text = resolvedAddress;
    });
  }

  void _goToMapScreen() {
    if (selectedLatLng == null || selectedAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select or search a location")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GeolocationScreen(
          firstName: widget.firstName,
          lastName: widget.lastName,
          birthday: widget.birthday,
          gender: widget.gender,
          username: widget.username,
          address: selectedAddress,
          lat: selectedLatLng!.latitude,
          lng: selectedLatLng!.longitude,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select your area")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onTap: _loadInitialSuggestions,
              decoration: InputDecoration(
                hintText: "Search your address",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.my_location),
                  onPressed: _useCurrentLocation,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final s = suggestions[index];
                  return ListTile(
                    leading: Icon(s.icon),
                    title: Text(s.name),
                    subtitle: Text(s.address),
                    trailing: s.distance > 0
                        ? Text("${s.distance.toStringAsFixed(1)} km")
                        : null,
                    onTap: () => _onSelectSuggestion(s),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _goToMapScreen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResultItem {
  final String name;
  final String address;
  final IconData icon;
  final double distance;
  final LatLng location;
  final String? placeId;

  SearchResultItem({
    required this.name,
    required this.address,
    required this.icon,
    this.distance = 0,
    this.placeId,
    this.location = const LatLng(0, 0),
  });
}
