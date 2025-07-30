import 'package:flutter/material.dart';
import 'USER_SIGNUP_5.dart'; // Import for LocationQuestionScreen
import '../../backend/models/USER_SIGNUP_VAR.dart'; // Import for UserProfile
import '../widgets/index.dart'; // Corrected import for TeleoBackButton and CustomElevatedButton

class UsernameScreen extends StatefulWidget {
  final UserProfile userProfile;

  const UsernameScreen({
    super.key,
    required this.userProfile,
  });

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  bool get _isFormValid => _usernameController.text.isNotEmpty;

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
                "How should we call you?",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "Give yourself a cool nickname",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Username field
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF002642)),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const Spacer(),
              // Next button using CustomElevatedButton
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: CustomElevatedButton(
                  text: 'Next',
                  onPressed: _isFormValid
                      ? () {
                          final updatedUserProfile = UserProfile(
                            firstName: widget.userProfile.firstName,
                            lastName: widget.userProfile.lastName,
                            birthday: widget.userProfile.birthday,
                            gender: widget.userProfile.gender,
                            username: _usernameController.text,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LocationQuestionScreen(
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
}
