import 'package:flutter/material.dart';
import 'data/cancellation_reasons.dart';

class CancelBookingPage extends StatefulWidget {
  final String facilitatorName;

  const CancelBookingPage({
    super.key,
    this.facilitatorName = 'Lebron',
  });

  @override
  State<CancelBookingPage> createState() => _CancelBookingPageState();
}

class _CancelBookingPageState extends State<CancelBookingPage> {
  String? _selectedReason = 'Unavailable Facilitator';
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _feedbackController.text =
        'Sorry, Fr. ${widget.facilitatorName} is too busy.';
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define the exact color to ensure consistency
    const Color navyBlue = Color(0xFF000233);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          color: navyBlue,
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
      body: SingleChildScrollView(
        child: Padding(
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

              // Radio buttons for cancellation reasons
              for (String reason in cancellationReasons)
                _buildRadioOption(reason),

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
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _feedbackController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12),
                    border: InputBorder.none,
                    hintText: 'Add any additional comments...',
                  ),
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle send cancellation notice
                    // For now, just go back to the previous screens
                    Navigator.pop(context); // Go back to booking details
                    Navigator.pop(context); // Go back to upcoming services
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navyBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    'Send Cancellation Notice',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
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

  Widget _buildRadioOption(String option) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedReason = option;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Radio<String>(
                value: option,
                groupValue: _selectedReason,
                onChanged: (value) {
                  setState(() {
                    _selectedReason = value;
                  });
                },
                activeColor: const Color(0xFF000233),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              option,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
