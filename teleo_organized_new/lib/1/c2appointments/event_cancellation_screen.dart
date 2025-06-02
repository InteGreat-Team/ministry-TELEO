import 'package:flutter/material.dart';
import '../c2events/models/registered_event.dart';

class EventCancellationScreen extends StatefulWidget {
  final RegisteredEvent registeredEvent;

  const EventCancellationScreen({super.key, required this.registeredEvent});

  @override
  State<EventCancellationScreen> createState() =>
      _EventCancellationScreenState();
}

class _EventCancellationScreenState extends State<EventCancellationScreen> {
  String? _selectedReason;
  final TextEditingController _feedbackController = TextEditingController();

  // List of cancellation reasons
  final List<String> _cancellationReasons = [
    'Change of plans',
    'Conflict in schedule',
    'Health Issues',
    'Family Emergency',
    'Location Issues',
    'Transportation Issues',
    'Could not fulfill request',
    'Other Reason',
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  // Show confirmation dialog
  void _showConfirmationDialog() {
    if (_selectedReason == null) {
      // Show error if no reason selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a reason for cancellation'),
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
              const Text('Cancel Booking'),
            ],
          ),
          content: const Text(
            'Are you sure you want to cancel this service appointment?',
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
                _confirmCancellation();
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

  // Confirm cancellation
  void _confirmCancellation() {
    // Update the registered event with cancellation details
    widget.registeredEvent.cancellationReason = _selectedReason;
    widget.registeredEvent.cancellationFeedback = _feedbackController.text;
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
          'Cancel Appointment',
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
              'Why do you want to cancel?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Cancellation reasons
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children:
                      _cancellationReasons.map((reason) {
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

            // Feedback text field
            const Text(
              'Provide Feedback',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _feedbackController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Tell us more about why you\'re cancelling...',
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
