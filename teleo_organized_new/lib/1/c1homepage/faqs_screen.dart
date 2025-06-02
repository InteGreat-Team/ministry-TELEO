import 'package:flutter/material.dart';

class FAQsScreen extends StatefulWidget {
  const FAQsScreen({super.key});

  @override
  State<FAQsScreen> createState() => _FAQsScreenState();
}

class _FAQsScreenState extends State<FAQsScreen> {
  // Track which sections are expanded
  final Map<String, bool> _expandedSections = {
    'General Questions': false,
    'Prayer Wall': false,
    'Looking for a Church': false,
    'Events': false,
    'Library': false,
  };

  // Search controller
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // FAQ data structure
  final Map<String, List<Map<String, String>>> _faqData = {
    'General Questions': [
      {
        'question': 'What is Teleo?',
        'answer': 'Teleo is a church community platform designed to connect believers with churches and each other. It provides tools for spiritual growth, community engagement, and church discovery.'
      },
      {
        'question': 'How do I create an account?',
        'answer': 'You can create an account by downloading the Teleo app, clicking "Sign Up" on the welcome screen, and following the registration steps. You\'ll need to provide your name, email, and create a password.'
      },
      {
        'question': 'Is Teleo free to use?',
        'answer': 'Yes, Teleo is completely free for individual users. Churches may have premium features available through subscription plans.'
      },
    ],
    'Prayer Wall': [
      {
        'question': 'How do I post a prayer request?',
        'answer': 'To post a prayer request, navigate to the Prayer Wall section, tap the "+" button, enter your prayer request details, and tap "Submit". You can choose to post anonymously if desired.'
      },
      {
        'question': 'Can I pray for others?',
        'answer': 'Yes! You can view prayer requests from your community on the Prayer Wall and indicate that you\'ve prayed for someone by tapping the "Pray" button on their request.'
      },
      {
        'question': 'Are prayer requests private?',
        'answer': 'Prayer requests can be set as public (visible to your church community) or private (visible only to church leaders). You control the privacy settings when posting.'
      },
    ],
    'Looking for a Church': [
      {
        'question': 'How do I find a church near me?',
        'answer': 'Use the Church Finder feature by tapping "Find a Church" and allowing location access. You can filter churches by denomination, service times, and available ministries.'
      },
      {
        'question': 'Can I see service times?',
        'answer': 'Yes, each church profile includes service times, address information, and contact details to help you plan your visit.'
      },
      {
        'question': 'How do I connect with a church I\'ve found?',
        'answer': 'Once you\'ve found a church you\'re interested in, you can tap "Connect" on their profile to receive information about upcoming events and services.'
      },
    ],
    'Events': [
      {
        'question': 'How do I register for an event?',
        'answer': 'To register for an event, navigate to the Events section, select the event you\'re interested in, and tap "Register". Follow the prompts to complete your registration.'
      },
      {
        'question': 'Can I invite others to events?',
        'answer': 'Yes, you can share events with friends by tapping the "Share" button on any event page, which allows you to send invitations via text, email, or social media.'
      },
      {
        'question': 'How do I add events to my calendar?',
        'answer': 'When viewing an event, tap "Add to Calendar" to sync the event with your device\'s calendar app. You\'ll receive notifications based on your calendar settings.'
      },
    ],
    'Library': [
      {
        'question': 'What content is available in the Library?',
        'answer': 'The Library contains devotionals, Bible studies, sermon recordings, and other spiritual growth resources provided by your church and the Teleo platform.'
      },
      {
        'question': 'Can I download content for offline use?',
        'answer': 'Yes, most Library content can be downloaded for offline access. Look for the download icon on content you wish to save for later.'
      },
      {
        'question': 'How do I find specific topics?',
        'answer': 'Use the search function in the Library to find content by topic, speaker, or Bible passage. You can also browse by categories and collections.'
      },
    ],
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter FAQs based on search query
  List<Map<String, String>> _getFilteredFAQs(String category) {
    if (_searchQuery.isEmpty) {
      return _faqData[category] ?? [];
    }
    
    return (_faqData[category] ?? []).where((faq) {
      return faq['question']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             faq['answer']!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Set this to hide the system back button
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text(
          'FAQs',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF002642),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
          ),
          
          // FAQ sections
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: _expandedSections.length,
              itemBuilder: (context, index) {
                final category = _expandedSections.keys.elementAt(index);
                final isExpanded = _expandedSections[category] ?? false;
                final filteredFAQs = _getFilteredFAQs(category);
                
                // Skip empty sections when searching
                if (_searchQuery.isNotEmpty && filteredFAQs.isEmpty) {
                  return const SizedBox.shrink();
                }
                
                return Column(
                  children: [
                    // Category header
                    Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF002642),
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          title: Text(
                            category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Icon(
                            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                          onExpansionChanged: (expanded) {
                            setState(() {
                              _expandedSections[category] = expanded;
                            });
                          },
                          initiallyExpanded: isExpanded,
                          children: [
                            // Only build the children when expanded to improve performance
                            if (isExpanded)
                              Container(
                                color: Colors.white,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: filteredFAQs.length,
                                  separatorBuilder: (context, index) => const Divider(height: 1),
                                  itemBuilder: (context, faqIndex) {
                                    final faq = filteredFAQs[faqIndex];
                                    return _buildFAQItem(faq);
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(Map<String, String> faq) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: Text(
          faq['question'] ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            child: Text(
              faq['answer'] ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
