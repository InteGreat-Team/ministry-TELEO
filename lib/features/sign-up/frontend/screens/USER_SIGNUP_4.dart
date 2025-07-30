import 'package:flutter/material.dart';
import 'USER_SIGNUP_7.dart'; // Updated import for UsernameScreen
import '../widgets/index.dart'; // Corrected import for TeleoBackButton and CustomElevatedButton
import '../../backend/models/USER_SIGNUP_VAR.dart'; // Import for UserProfile

class GenderScreen extends StatefulWidget {
  final UserProfile userProfile;

  const GenderScreen({
    super.key,
    required this.userProfile,
  });

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String? _selectedGender;

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
                "How do you identify as?",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "We want to be respectful!",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              // Gender selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGenderOption('male', 'Male', Icons.male),
                  _buildGenderOption('female', 'Female', Icons.female),
                  _buildGenderOption('non_binary', 'Non-binary', Icons.person),
                ],
              ),
              const Spacer(),
              // Next button using CustomElevatedButton
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: CustomElevatedButton(
                  text: 'Next',
                  onPressed: _selectedGender != null
                      ? () {
                          final updatedUserProfile = UserProfile(
                            firstName: widget.userProfile.firstName,
                            lastName: widget.userProfile.lastName,
                            birthday: widget.userProfile.birthday,
                            gender: _selectedGender!,
                            username: '', // Placeholder, will be updated in next screen
                          );
                          // Navigate to UsernameScreen (USER_SIGNUP_7.dart)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UsernameScreen(
                                userProfile: updatedUserProfile,
                              ),
                            ),
                          );
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderOption(String value, String label, IconData icon) {
    final isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF002642) : Colors.grey.shade600,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF002642) : Colors.grey.shade600,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
