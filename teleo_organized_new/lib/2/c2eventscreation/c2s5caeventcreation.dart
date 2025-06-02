import 'package:flutter/material.dart';
import 'dart:io';
import 'models/event.dart';
import 'widgets/step_indicator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'c2s6_1caeventcreation.dart';
import 'widgets/event_app_bar.dart';

class EventSummaryScreen extends StatelessWidget {
  final Event event;

  const EventSummaryScreen({super.key, required this.event});

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFF8F0F0), // Light pink/beige background
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Centered title with icon
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, size: 24, color: Color.fromARGB(255, 254, 254, 254)), // Changed to navy blue
                    SizedBox(width: 8),
                    Text(
                      'Confirm Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Do you want to proceed to the next step of event creation?',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF444444), // Dark gray but not too dark
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'No',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventRegistrationFormScreen(event: event),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A0A4A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';
    
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EventAppBar(
        onBackPressed: () => Navigator.pop(context), title: '',
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StepIndicator(
                    currentStep: 4,
                    totalSteps: 7,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Event summary',
                          style: TextStyle(
                            color: Color(0xFF0A0A4A), // Changed to navy blue
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Event Image - Handle both web and mobile with black border
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0, // Keeping border width at 1.0 as requested
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7), // Adjusted to account for border
                            child: _buildEventImage(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Event Details
                        _buildDetailRow('Event Title', event.title ?? 'To be answered'),
                        _buildDetailRow('Tags', event.tags.isEmpty ? 'None selected' : event.tags.join(', ')),
                        _buildDetailRow('Event Description', event.description ?? 'To be answered'),
                        _buildDetailRow('Speaker', event.speakers.isEmpty ? 'None specified' : event.speakers.join(', ')),
                        _buildDetailRow('Event Date', event.isOneDay ? 'One day event' : 'Multiple day event'),
                        _buildDetailRow(
                          'Date', 
                          event.isOneDay 
                              ? _formatDate(event.startDate)
                              : '${_formatDate(event.startDate)} - ${_formatDate(event.endDate)}'
                        ),
                        _buildDetailRow(
                          'Time', 
                          '${_formatTime(event.startTime)} - ${_formatTime(event.endTime)}'
                        ),
                        _buildDetailRow('Event Setting', event.isOnline ? 'Online' : 'Onsite'),
                        _buildDetailRow(
                          'Venue/Location', 
                          event.isOnline 
                              ? (event.eventLink ?? 'No link provided')
                              : (event.isOutsourcedVenue 
                                  ? 'Outsourced Event API (link)'
                                  : (event.venueName ?? 'No venue specified'))
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Updated button section to match the provided code snippet
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0A0A4A),
                      side: const BorderSide(color: Color(0xFF0A0A4A)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showConfirmDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A0A4A),
                      foregroundColor: Colors.white, // Set text color to white
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Confirm Details',
                      style: TextStyle(fontSize: 16, color: Colors.white), // Ensure text is white
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventImage() {
    if (event.imageBytes != null && event.imageBytes!.isNotEmpty) {
      return Image.memory(
        event.imageBytes!,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover, // Use cover to fill the width while maintaining aspect ratio
      );
    } else if (event.imageUrl != null && event.imageUrl!.isNotEmpty) {
      return Image.network(
        event.imageUrl!,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover, // Use cover to fill the width while maintaining aspect ratio
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
      );
    } else if (event.imagePath != null && !kIsWeb) {
      return Image.file(
        File(event.imagePath!),
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover, // Use cover to fill the width while maintaining aspect ratio
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
      );
    } else {
      return _buildPlaceholderImage();
    }
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.image,
          size: 50,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}