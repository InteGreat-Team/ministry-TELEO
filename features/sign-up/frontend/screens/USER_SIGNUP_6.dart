import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../backend/viewmodels/USER_SIGNUP_FUNC.dart'; // Updated import for googleApiKey
import 'USER_SIGNUP_8.dart'; // Assuming USER_SIGNUP_8.dart will contain ContactInfoScreen
import '../../backend/models/USER_SIGNUP_VAR.dart'; // Import for UserProfile
import '../widgets/index.dart'; // Import for CustomElevatedButton

class GeolocationScreen extends StatefulWidget {
  final UserProfile userProfile;

  const GeolocationScreen({
    super.key,
    required this.userProfile,
  });

  @override
  State<GeolocationScreen> createState() => _GeolocationScreenState();
}

class _GeolocationScreenState extends State<GeolocationScreen> {
  late GoogleMapController _mapController;
  late LatLng _selectedLocation;
  String _locationLabel = '';
  bool _showSuggestions = false;
  List<Map<String, dynamic>> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.userProfile.location ?? const LatLng(0, 0); // Use existing location or default
    _locationLabel = widget.userProfile.address ?? ''; // Use existing address or default
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _updateSuggestions() async {
    List<Map<String, dynamic>> results = [];
    // Current location
    Position position = await Geolocator.getCurrentPosition();
    results.add({
      'type': 'current',
      'title': '📍 Current location',
      'subtitle': 'Tap to use your current location',
      'lat': position.latitude,
      'lng': position.longitude,
    });
    // Christian churches nearby
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${position.latitude},${position.longitude}'
        '&radius=5000'
        '&type=church'
        '&keyword=christian'
        '&key=$googleApiKey');
    final res = await http.get(url);
    final data = jsonDecode(res.body);
    if (data['status'] == 'OK') {
      for (var result in data['results']) {
        results.add({
          'type': 'place',
          'title': '⛪ ${result['name']}',
          'subtitle': result['vicinity'] ?? '',
          'lat': result['geometry']['location']['lat'],
          'lng': result['geometry']['location']['lng'],
        });
      }
    }
    setState(() {
      _suggestions = results;
    });
  }

  Future<void> _reverseGeocode(LatLng location) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=$googleApiKey&region=ph');
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 &&
        data['status'] == 'OK' &&
        data['results'].isNotEmpty) {
      setState(() {
        _locationLabel = data['results'][0]['formatted_address'];
      });
    }
  }

  void _selectSuggestion(Map<String, dynamic> item) {
    setState(() {
      _selectedLocation = LatLng(item['lat'], item['lng']);
      _locationLabel = item['title'].replaceAll('📍 ', '').replaceAll('⛪ ', '');
      _showSuggestions = false;
    });
    _mapController.animateCamera(CameraUpdate.newLatLng(_selectedLocation));
    _reverseGeocode(_selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _selectedLocation,
              zoom: 15,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onTap: (LatLng tapped) {
              setState(() {
                _selectedLocation = tapped;
              });
              _reverseGeocode(tapped);
            },
            onCameraIdle: () => _reverseGeocode(_selectedLocation),
            onCameraMove: (position) {
              setState(() {
                _selectedLocation = position.target;
              });
            },
          ),
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                _updateSuggestions();
                setState(() {
                  _showSuggestions = true;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _locationLabel,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          if (_showSuggestions)
            Positioned(
              top: 110,
              left: 0,
              right: 0,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 300),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _suggestions.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = _suggestions[index];
                    return ListTile(
                      leading: Text(item['type'] == 'current' ? '📍' : '⛪', style: const TextStyle(fontSize: 18)),
                      title: Text(item['title']),
                      subtitle: Text(item['subtitle']),
                      onTap: () => _selectSuggestion(item),
                    );
                  },
                ),
              ),
            ),
          const Center(
            child: Icon(Icons.location_pin, size: 50, color: Colors.red),
          ),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_locationLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  CustomElevatedButton(
                    text: "Choose this location",
                    onPressed: () {
                      final updatedUserProfile = UserProfile(
                        firstName: widget.userProfile.firstName,
                        lastName: widget.userProfile.lastName,
                        birthday: widget.userProfile.birthday,
                        gender: widget.userProfile.gender,
                        username: widget.userProfile.username,
                        address: _locationLabel,
                        location: _selectedLocation,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ContactInfoScreen(
                            userProfile: updatedUserProfile,
                          ),
                        ),
                      );
                    },
                    backgroundColor: Colors.indigo, // Override default color
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
