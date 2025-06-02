import 'package:flutter/material.dart';
import '../userhomepage/home_page.dart';

class InterestSelectionScreen extends StatefulWidget {
  const InterestSelectionScreen({super.key});

  @override
  State<InterestSelectionScreen> createState() =>
      _InterestSelectionScreenState();
}

class _InterestSelectionScreenState extends State<InterestSelectionScreen> {
  final int _requiredSelections = 3;
  final List<String> _selectedInterests = [];
  final int _currentPage = 0;
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _interestCategories = [
    {
      'title': 'Interest check!',
      'subtitle': 'Pick 3 topics that spark your interests!',
      'interests': [
        {'name': 'ART', 'color': const Color(0xFFD2A76C)},
        {'name': 'BUSINESS', 'color': const Color(0xFF5B9B8E)},
        {'name': 'CULTURE', 'color': const Color(0xFF8D7E63)},
        {'name': 'EDUCATION', 'color': const Color(0xFF7986CB)},
        {'name': 'FINANCE', 'color': const Color(0xFF66BB6A)},
        {'name': 'HEALTH', 'color': const Color(0xFFEF5350)},
        {'name': 'MUSIC', 'color': const Color(0xFF9575CD)},
        {'name': 'SCIENCE', 'color': const Color(0xFF4FC3F7)},
        {'name': 'SPORTS', 'color': const Color(0xFFFF9800)},
      ],
    },
    {
      'title': 'Church activities',
      'subtitle': 'Select activities you\'re interested in',
      'interests': [
        {'name': 'WORSHIP', 'color': const Color(0xFFD2A76C)},
        {'name': 'PRAYER', 'color': const Color(0xFF5B9B8E)},
        {'name': 'BIBLE STUDY', 'color': const Color(0xFF8D7E63)},
        {'name': 'COMMUNITY', 'color': const Color(0xFF7986CB)},
        {'name': 'MISSIONS', 'color': const Color(0xFF66BB6A)},
        {'name': 'YOUTH', 'color': const Color(0xFFEF5350)},
        {'name': 'FAMILY', 'color': const Color(0xFF9575CD)},
        {'name': 'LEADERSHIP', 'color': const Color(0xFF4FC3F7)},
        {'name': 'SERVICE', 'color': const Color(0xFFFF9800)},
      ],
    },
  ];

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        if (_selectedInterests.length < _requiredSelections) {
          _selectedInterests.add(interest);
        }
      }
    });
  }

  // Modified to go directly to HomePage
  void _goToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E88E5), // Lighter blue at top
              Color(0xFF90CAF9), // Very light blue at bottom
            ],
          ),
        ),
        child: Stack(
          children: [
            // Cloud background
            Positioned.fill(
              child: Image.asset(
                'assets/images/blue_background.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: Colors.transparent);
                },
              ),
            ),

            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Title and subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _interestCategories[_currentPage]['title'],
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _interestCategories[_currentPage]['subtitle'],
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Interests grid
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        itemCount:
                            _interestCategories[_currentPage]['interests']
                                .length,
                        itemBuilder: (context, index) {
                          final interest =
                              _interestCategories[_currentPage]['interests'][index];
                          final isSelected = _selectedInterests.contains(
                            interest['name'],
                          );

                          return GestureDetector(
                            onTap: () => _toggleInterest(interest['name']),
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? interest['color']
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  // Interest icon and name
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Use a placeholder for the icon
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color:
                                                isSelected
                                                    ? Colors.white.withOpacity(
                                                      0.3,
                                                    )
                                                    : interest['color']
                                                        .withOpacity(0.3),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            _getIconForInterest(
                                              interest['name'],
                                            ),
                                            color:
                                                isSelected
                                                    ? Colors.white
                                                    : interest['color'],
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          interest['name'],
                                          style: TextStyle(
                                            color:
                                                isSelected
                                                    ? Colors.white
                                                    : Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Selection indicator
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.transparent,
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? Colors.transparent
                                                  : Colors.grey.shade300,
                                          width: 2,
                                        ),
                                      ),
                                      child:
                                          isSelected
                                              ? const Icon(
                                                Icons.check,
                                                color: Colors.blue,
                                                size: 16,
                                              )
                                              : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Page indicator and next button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Page indicator
                        Row(
                          children: List.generate(
                            _interestCategories.length,
                            (index) => Container(
                              width: index == _currentPage ? 24 : 8,
                              height: 8,
                              margin: const EdgeInsets.only(right: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color:
                                    index == _currentPage
                                        ? Colors.black
                                        : Colors.black.withOpacity(0.2),
                              ),
                            ),
                          ),
                        ),

                        // Next button - Modified to go directly to HomePage when 3 interests are selected
                        GestureDetector(
                          onTap:
                              _selectedInterests.length == _requiredSelections
                                  ? _goToHomePage
                                  : null,
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  _selectedInterests.length ==
                                          _requiredSelections
                                      ? const Color(0xFFFF5722)
                                      : Colors.grey,
                              boxShadow: [
                                BoxShadow(
                                  color: (_selectedInterests.length ==
                                              _requiredSelections
                                          ? const Color(0xFFFF5722)
                                          : Colors.grey)
                                      .withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForInterest(String interest) {
    switch (interest) {
      case 'ART':
        return Icons.palette;
      case 'BUSINESS':
        return Icons.business;
      case 'CULTURE':
        return Icons.public;
      case 'EDUCATION':
        return Icons.school;
      case 'FINANCE':
        return Icons.attach_money;
      case 'HEALTH':
        return Icons.favorite;
      case 'MUSIC':
        return Icons.music_note;
      case 'SCIENCE':
        return Icons.science;
      case 'SPORTS':
        return Icons.sports_basketball;
      case 'WORSHIP':
        return Icons.music_note;
      case 'PRAYER':
        return Icons.volunteer_activism;
      case 'BIBLE STUDY':
        return Icons.book;
      case 'COMMUNITY':
        return Icons.people;
      case 'MISSIONS':
        return Icons.public;
      case 'YOUTH':
        return Icons.child_care;
      case 'FAMILY':
        return Icons.family_restroom;
      case 'LEADERSHIP':
        return Icons.trending_up;
      case 'SERVICE':
        return Icons.handshake;
      default:
        return Icons.interests;
    }
  }
}
