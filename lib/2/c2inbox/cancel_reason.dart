import 'package:flutter/material.dart';
import '../c2spp/upcoming_bookings_page.dart';

class CancelReasonPage extends StatefulWidget {
  final String reference;
  final String requesterName;
  final String location;
  final String serviceType;
  final String date;
  final String time;
  final bool isScheduledForLater;
  final String venue;
  final String assignedTo;

  const CancelReasonPage({
    super.key,
    required this.reference,
    required this.requesterName,
    required this.location,
    required this.serviceType,
    required this.date,
    required this.time,
    required this.isScheduledForLater,
    required this.venue,
    required this.assignedTo,
  });

  @override
  State<CancelReasonPage> createState() => _CancelReasonPageState();
}

class _CancelReasonPageState extends State<CancelReasonPage> {
  String? _selectedReason;
  final TextEditingController _feedbackController = TextEditingController();

  final List<String> _cancellationReasons = [
    'Change of plans',
    'Unavailable Facilitator',
    'Conflict in schedule',
    'Health Issues',
    'Family Emergency',
    'Financial Constraints',
    'Transportation Issues',
    'Could not fulfill request',
    'Other Reason',
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          color: const Color(0xFF000233), // Navy blue color
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Cancel Booking',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the header
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Why do you want to cancel?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Radio button list
                  ...List.generate(_cancellationReasons.length, (index) {
                    final reason = _cancellationReasons[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: reason,
                            groupValue: _selectedReason,
                            onChanged: (value) {
                              setState(() {
                                _selectedReason = value;
                              });
                            },
                            activeColor: const Color(0xFF000233),
                          ),
                          Text(reason),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 16),
                  const Text(
                    'Provide Feedback',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _feedbackController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Add additional details here...',
                        contentPadding: EdgeInsets.all(12),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Extract facilitator name from assignedTo (remove the @ symbol)
                String facilitatorName = widget.assignedTo.startsWith('@')
                    ? widget.assignedTo.substring(1)
                    : widget.assignedTo;

                // Navigate directly to UpcomingBookingsPage with cancellation details
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpcomingBookingsPage(
                      reference: widget.reference,
                      requesterName: widget.requesterName,
                      location: widget.location,
                      serviceType: widget.serviceType,
                      date: widget.date,
                      time: widget.time,
                      isScheduledForLater: widget.isScheduledForLater,
                      venue: widget.venue,
                      assignedTo: widget.assignedTo,
                      cancelReason:
                          _selectedReason ?? 'Unavailable Facilitator',
                      feedback: _feedbackController.text.isNotEmpty
                          ? _feedbackController.text
                          : 'Sorry, Fr. $facilitatorName is too busy.',
                      cancelledBy: 'Church Name - Church Admin',
                      cancelledDate: '[Date] at [Time]',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000233),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Send Cancellation Notice'),
            ),
          ),
        ],
      ),
    );
  }
}
