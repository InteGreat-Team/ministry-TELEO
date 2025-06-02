import 'package:flutter/material.dart';
import '../c2events/models/registered_event.dart';

class VolunteerExitFormScreen extends StatefulWidget {
  final RegisteredEvent registeredEvent;

  const VolunteerExitFormScreen({super.key, required this.registeredEvent});

  @override
  State<VolunteerExitFormScreen> createState() =>
      _VolunteerExitFormScreenState();
}

class _VolunteerExitFormScreenState extends State<VolunteerExitFormScreen> {
  String? _selectedReason;
  final TextEditingController _descriptionController = TextEditingController();

  // List of exit reasons
  final List<String> _exitReasons = [
    'Personal reasons',
    'Family Commitments',
    'Health Issues',
    'Work/Schedule Conflict',
    'Relocation',
    'Burnout',
    'Other Reason',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  // Show confirmation dialog
  void _showConfirmationDialog() {
    if (_selectedReason == null) {
      // Show error if no reason selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a reason for stepping down'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.amber),
              const SizedBox(width: 10),
              const Text('Cancel Volunteering'),
            ],
          ),
          content: const Text(
            'Are you sure you want to cancel your volunteer commitment for this event?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: Colors.grey[800]),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _confirmExit();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000233),
                foregroundColor: Colors.white,
              ),
              child: const Text('Yes, proceed'),
            ),
          ],
        );
      },
    );
  }

  // Confirm exit
  void _confirmExit() {
    // Update the registered event with exit details
    widget.registeredEvent.cancellationReason = _selectedReason;
    widget.registeredEvent.cancellationFeedback = _descriptionController.text;
    widget.registeredEvent.cancellationDate = DateTime.now();

    // Update in the manager
    RegisteredEventManager.updateRegisteredEvent(widget.registeredEvent);

    // Return to the previous screen with success result
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF000233),
        title: const Text(
          'Volunteer Exit Form',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reasons for stepping down',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Exit reasons
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children:
                      _exitReasons.map((reason) {
                        return RadioListTile<String>(
                          title: Text(reason),
                          value: reason,
                          groupValue: _selectedReason,
                          onChanged: (value) {
                            setState(() {
                              _selectedReason = value;
                            });
                          },
                          activeColor: const Color(0xFF000233),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        );
                      }).toList(),
                ),
              ),
            ),

            // Description text field
            const Text(
              'Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Tell us more about why you\'re stepping down...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Back and Confirm buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFF000233)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(color: Color(0xFF000233)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _showConfirmationDialog,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF000233),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Confirm Cancellation',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
