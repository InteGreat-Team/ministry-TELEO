import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class FAQsScreen extends StatefulWidget {
  const FAQsScreen({super.key});

  @override
  State<FAQsScreen> createState() => _FAQsScreenState();
}

class _FAQsScreenState extends State<FAQsScreen> {
  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How do I add a new event?',
      'answer':
          'To add a new event, go to the Events section from the admin dashboard and tap the "+" button. Fill in the event details including title, date, time, location, and description. You can also add an image for the event.',
      'isExpanded': false,
    },
    {
      'question': 'How do I manage user roles?',
      'answer':
          'You can manage user roles by going to the "Set Roles" section. Search for a user by their username, then select the appropriate role (Pastor, Leader, or Member) for that user.',
      'isExpanded': false,
    },
    {
      'question': 'How do I create a new post?',
      'answer':
          'To create a new post, navigate to the Posts section and tap the "+" button. You can add text, images, and links to your post. Once published, it will be visible to your church members.',
      'isExpanded': false,
    },
    {
      'question': 'How do I view analytics for my church?',
      'answer':
          'The admin dashboard provides an overview of key metrics including login activity, daily follows, daily visits, and bookings. For more detailed analytics, tap on any of these metrics to see historical data and trends.',
      'isExpanded': false,
    },
    {
      'question': 'How do I update my church profile?',
      'answer':
          'To update your church profile, go to the Settings section from the admin dashboard. Here you can edit your church name, logo, contact information, and other details.',
      'isExpanded': false,
    },
    {
      'question': 'How do I manage community members?',
      'answer':
          'You can manage community members through the Community section. Here you can view all members, search for specific members, and take actions such as messaging them or updating their information.',
      'isExpanded': false,
    },
    {
      'question': 'How do I schedule a recurring event?',
      'answer':
          'When creating a new event, toggle the "Recurring" option and select the frequency (daily, weekly, monthly). You can also set an end date for the recurring event series.',
      'isExpanded': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF002642),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Find answers to common questions about the admin dashboard.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // FAQ Accordion
              ...List.generate(_faqs.length, (index) {
                return Column(
                  children: [
                    _buildFaqItem(index),
                    if (index < _faqs.length - 1) const Divider(height: 1),
                  ],
                );
              }),

              const SizedBox(height: 40),

              // Contact support section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Still need help?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF002642),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Contact our support team for assistance with any issues not covered in the FAQs.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Contact support functionality
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF002642),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Contact Support',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _faqs[index]['isExpanded'] = !_faqs[index]['isExpanded'];
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _faqs[index]['question'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF002642),
                    ),
                  ),
                ),
                Icon(
                  _faqs[index]['isExpanded']
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ],
            ),
            if (_faqs[index]['isExpanded']) ...[
              const SizedBox(height: 12),
              Text(
                _faqs[index]['answer'],
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
