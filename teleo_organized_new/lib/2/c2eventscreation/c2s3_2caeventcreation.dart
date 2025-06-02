import 'package:flutter/material.dart';
import 'models/event.dart';
import 'widgets/event_app_bar.dart';

class EventApiErrorScreen extends StatelessWidget {
  final Event event;

  const EventApiErrorScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EventAppBar(
        onBackPressed: () => Navigator.pop(context), title: '',
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: Color(0xFF0A0A4A),
              ),
              const SizedBox(height: 24),
              const Text(
                'External System Not Integrated',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'The "Outsource Event" feature connects to an external system that is not yet integrated with this application.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity, // Make button full width
                height: 56, // Set a fixed height for the button
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate back to the location screen
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A0A4A), // Navy blue color
                    foregroundColor: Colors.white, // White text
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    elevation: 0, // No shadow
                    padding: const EdgeInsets.symmetric(vertical: 16), // Vertical padding
                  ),
                  child: const Text(
                    'Go Back',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Ensure text is white
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