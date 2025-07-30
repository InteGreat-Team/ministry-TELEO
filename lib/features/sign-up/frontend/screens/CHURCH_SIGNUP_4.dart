import 'package:flutter/material.dart';
import '../../backend/models/CHURCH_SIGNUP_VAR.dart'; // For ChurchModel
import '../widgets/index.dart'; // For TeleoBackButton, CustomDatePicker, CustomElevatedButton
import 'CHURCH_SIGNUP_5.dart'; // For next screen

class ChurchEstablishedScreen extends StatefulWidget {
  final ChurchModel church;

  const ChurchEstablishedScreen({
    super.key,
    required this.church,
  });

  @override
  State<ChurchEstablishedScreen> createState() => _ChurchEstablishedScreenState();
}

class _ChurchEstablishedScreenState extends State<ChurchEstablishedScreen> {
  DateTime _selectedDate = DateTime.now();
  
  @override
  void initState() {
    super.initState();
    // Initialize with the date from the church model if available, otherwise current date
    _selectedDate = widget.church.yearEstablished != null
        ? DateTime(widget.church.yearEstablished!)
        : DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: TeleoBackButton(),
              ),
              const SizedBox(height: 24),
              
              // Title
              const CustomHeader(
                title: "When was your church established?",
                icon: Icons.calendar_month, // Optional icon
                iconColor: Colors.black, // Adjust color if needed
              ),
              const SizedBox(height: 48),
              
              // Date display
              CustomDatePicker(
                selectedDate: _selectedDate,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
                labelText: 'Select Establishment Date',
                firstDate: DateTime(1500),
                lastDate: DateTime.now(),
              ),
              
              const Spacer(),
              
              // Next button
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: CustomElevatedButton(
                  onPressed: () {
                    final updatedChurch = widget.church.copyWith(
                      yearEstablished: _selectedDate.year,
                    );
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChurchLogoScreen(
                          church: updatedChurch,
                        ),
                      ),
                    );
                  },
                  text: 'Next',
                  backgroundColor: const Color(0xFF002642),
                  foregroundColor: Colors.white,
                  height: 56,
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
