import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'USER_SIGNUP_4.dart'; // Import for GenderScreen
import '../widgets/index.dart'; // Corrected import for TeleoBackButton and CustomElevatedButton
import '../../backend/models/USER_SIGNUP_VAR.dart'; // Import for UserProfile

class BirthdayScreen extends StatefulWidget {
  final UserProfile userProfile;

  const BirthdayScreen({
    super.key,
    required this.userProfile,
  });

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  DateTime _selectedDate = DateTime(2000, 1, 1);

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
                "When's your birthday?",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                "We'd love to know!",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Date picker
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _selectedDate,
                  minimumYear: 1900,
                  maximumYear: DateTime.now().year,
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      _selectedDate = newDate;
                    });
                  },
                ),
              ),
              const Spacer(),
              // Next button using CustomElevatedButton
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: CustomElevatedButton(
                  text: 'Next',
                  onPressed: () {
                    final updatedUserProfile = UserProfile(
                      firstName: widget.userProfile.firstName,
                      lastName: widget.userProfile.lastName,
                      birthday: _selectedDate,
                      gender: widget.userProfile.gender,
                      username: widget.userProfile.username,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GenderScreen(
                          userProfile: updatedUserProfile,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
