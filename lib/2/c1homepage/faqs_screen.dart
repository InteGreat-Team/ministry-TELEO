import 'package:flutter/material.dart';
import '../c1homepage/admin_types.dart';

class FAQsScreen extends StatefulWidget {
  final Function(AdminView) onNavigate;
  const FAQsScreen({super.key, required this.onNavigate});

  @override
  State<FAQsScreen> createState() => _FAQsScreenState();
}

class FaqItem {
  FaqItem({
    required this.headerValue,
    required this.expandedValue,
    this.isExpanded = false,
  });

  String headerValue;
  String expandedValue;
  bool isExpanded;
}

class FaqCategory {
  FaqCategory({
    required this.title,
    required this.questions,
    this.isExpanded = false,
  });

  String title;
  List<FaqItem> questions;
  bool isExpanded;
}

class _FAQsScreenState extends State<FAQsScreen> {
  final List<FaqCategory> _faqCategories = [
    FaqCategory(
      title: 'General Questions',
      isExpanded: true,
      questions: [
        FaqItem(
          headerValue: 'What is Teleo?',
          expandedValue:
              'Teleo is a platform to connect people with their church community.',
        ),
        FaqItem(
          headerValue: 'Do I need to be a church member to use the app?',
          expandedValue: 'No, everyone is welcome to use Teleo.',
        ),
        FaqItem(
          headerValue: 'Can I connect with more than one church?',
          expandedValue: 'Yes, you can connect with multiple churches.',
        ),
        FaqItem(
          headerValue: 'Can I register as a member of a church?',
          expandedValue: 'Yes, you can register through the church\'s page.',
        ),
        FaqItem(
          headerValue: 'Are the churches registered in this app verified?',
          expandedValue: 'Yes, we verify all churches on our platform.',
        ),
        FaqItem(
          headerValue: 'Is the app free to use?',
          expandedValue: 'Yes, Teleo is free to download and use.',
        ),
        FaqItem(
          headerValue: 'How is my data protected?',
          expandedValue:
              'We use industry-standard encryption to protect your data.',
        ),
        FaqItem(
          headerValue: 'Can I use the app on my phone and computer?',
          expandedValue: 'Currently, Teleo is available on mobile devices.',
        ),
        FaqItem(
          headerValue: 'I forgot my password. What should I do?',
          expandedValue: 'You can reset your password from the login screen.',
        ),
        FaqItem(
          headerValue: 'How do I update my personal information?',
          expandedValue: 'You can update your profile from the settings menu.',
        ),
        FaqItem(
          headerValue: 'Can I report a user?',
          expandedValue:
              'Yes, you can report users who violate our community guidelines.',
        ),
        FaqItem(
          headerValue: 'Can I report a Pastor/Leader?',
          expandedValue:
              'Yes, you can report any user through the reporting feature.',
        ),
        FaqItem(
          headerValue: 'Where do my donations go?',
          expandedValue:
              'Donations go directly to the church or organization you choose.',
        ),
      ],
    ),
    FaqCategory(
      title: 'Prayer Wall',
      questions: [
        FaqItem(
          headerValue: 'How do I post a prayer request?',
          expandedValue:
              'Navigate to the Prayer Wall and tap the "Add" button.',
        ),
      ],
    ),
    FaqCategory(
      title: 'Looking for a Church',
      questions: [
        FaqItem(
          headerValue: 'How do I find a church?',
          expandedValue:
              'Use the search and filter options in the "Churches" section.',
        ),
      ],
    ),
    FaqCategory(
      title: 'Events',
      questions: [
        FaqItem(
          headerValue: 'How do I register for an event?',
          expandedValue: 'Go to the event details page and tap "Register".',
        ),
      ],
    ),
    FaqCategory(
      title: 'Library',
      questions: [
        FaqItem(
          headerValue: 'How do I access the library?',
          expandedValue: 'The library is available in the main menu.',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B42),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => widget.onNavigate(AdminView.home),
        ),
        title: const Text(
          'FAQs',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildFaqList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqList() {
    return Column(
      children:
          _faqCategories.map((FaqCategory category) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      category.isExpanded = !category.isExpanded;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D1B42),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          category.isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                if (category.isExpanded)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children:
                          category.questions.map((FaqItem item) {
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ExpansionTile(
                                title: Text(
                                  item.headerValue,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      item.expandedValue,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                                onExpansionChanged: (bool expanded) {
                                  setState(() {
                                    item.isExpanded = expanded;
                                  });
                                },
                                initiallyExpanded: item.isExpanded,
                                trailing: Icon(
                                  item.isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                const SizedBox(height: 10),
              ],
            );
          }).toList(),
    );
  }
}
