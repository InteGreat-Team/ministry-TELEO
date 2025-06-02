import 'package:flutter/material.dart';
import '../../3/c1widgets/back_button.dart';
import 'c1s5_2geolocation_screen.dart';
import 'c1s6contact_info_screen.dart';

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
  String _selectedLocation = '';
  bool get _isFormValid => _selectedLocation.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back button row
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: TeleoBackButton(),
                ),
              ),
              const SizedBox(height: 40),
              
              const Text(
                "Where are you based?",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "Where did you plant your roots?",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Location selection field
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GeolocationScreen(),
                    ),
                  );
                  
                  if (result != null) {
                    setState(() {
                      _selectedLocation = result;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedLocation.isEmpty ? 'Select your area' : _selectedLocation,
                          style: TextStyle(
                            color: _selectedLocation.isEmpty ? Colors.grey.shade400 : Colors.black,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Next button
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isFormValid
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContactInfoScreen(
                                  firstName: widget.firstName,
                                  lastName: widget.lastName,
                                  birthday: widget.birthday,
                                  gender: widget.gender,
                                  username: widget.username,
                                  location: _selectedLocation,
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002642),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.3),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 16,
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
    );
  }
}
