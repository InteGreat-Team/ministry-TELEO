import 'package:flutter/material.dart';
import 'USER_SIGNUP_3.dart'; // Import for BirthdayScreen
import '../widgets/index.dart'; // Corrected import for TeleoBackButton and CustomElevatedButton
import '../../backend/models/USER_SIGNUP_VAR.dart'; // Import for UserProfile

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  bool get _isFormValid =>
      _firstNameController.text.isNotEmpty &&
      _lastNameController.text.isNotEmpty;

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
                'Hello!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "What's your name?",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              // First Name field
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  hintText: 'First Name',
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
              const SizedBox(height: 16),
              // Last Name field
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  hintText: 'Last Name',
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
                          final userProfile = UserProfile(
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            birthday: DateTime.now(), // Placeholder, will be updated in next screen
                            gender: '', // Placeholder, will be updated in next screen
                            username: '', // Placeholder, will be updated in next screen
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BirthdayScreen(
                                userProfile: userProfile,
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
