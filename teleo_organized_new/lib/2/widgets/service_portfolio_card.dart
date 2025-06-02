import 'package:flutter/material.dart';
import '../c2spp/c2s2_edit_service_page.dart';

class ServicePortfolioCard extends StatelessWidget {
  final String title;
  final List<String> tags;
  final bool isAddCard;
  final String description;
  final String location;
  final String cId; // ✅ add this
  final String servName; // ✅ add this
  final String servId;

  const ServicePortfolioCard({
    super.key,
    this.title = '',
    this.tags = const [],
    this.isAddCard = false,
    this.description =
        'Welcomes an individual into Christianity with a water-blessing ceremony.',
    this.location = 'Church or set location',
    required this.cId, // ✅ add this
    required this.servName, // ✅ add this
    required this.servId, // ✅ Add this
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width to make cards responsive
    final screenWidth = MediaQuery.of(context).size.width;
    // Calculate card width based on screen size (2 cards per row with padding)
    final cardWidth =
        (screenWidth - 56) /
        2; // 20px padding on each side + 16px between cards

    if (isAddCard) {
      return Container(
        width: cardWidth,
        height: cardWidth * 1.2, // Maintain aspect ratio
        decoration: BoxDecoration(
          color: const Color(0xFFFFAF00), // Golden yellow color
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Colors.white, size: 28),
              SizedBox(height: 8),
              Text(
                'Add a Service',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Updated card design to match the second image
    return GestureDetector(
      onTap: () {
        // Navigate to EditServicePage when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => EditServicePage(
                  title: title,
                  description: description,
                  cId: cId, // ✅ Ensure this is passed
                  servName: servName, // ✅ Ensure this is passed
                  servId: servId, // ✅ Ensure this is passed
                ),
          ),
        );
      },
      child: Container(
        width: screenWidth - 32, // Full width minus padding
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Orange left border
              Container(
                width: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFFF59052), // Orange
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and edit icon with line
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),
                          // Edit icon with line underneath
                          SizedBox(
                            width: 30,
                            height: 20,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Icon(
                                    Icons.edit_outlined,
                                    size: 20,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                Positioned(
                                  bottom: 2,
                                  right: 0,
                                  child: Container(
                                    height: 1.5,
                                    width: 10,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Description
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      // Location with double checkmark
                      Row(
                        children: [
                          // Double checkmark with overlap
                          SizedBox(
                            width: 18,
                            height: 16,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  left: 0,
                                  child: Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Positioned(
                                  left: 2.5, // Closer overlap
                                  child: Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            location,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),
                      // Tags
                      Row(
                        children:
                            tags.map((tag) {
                              Color bgColor;
                              Color textColor;

                              if (tag == 'Fast' || tag == 'Later') {
                                bgColor = const Color(0xFFE6F4FF);
                                textColor = const Color(0xFF0078D4);
                              } else {
                                bgColor = const Color(0xFFE6FFE6);
                                textColor = const Color(0xFF00A300);
                              }

                              return Container(
                                margin: const EdgeInsets.only(right: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: textColor,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ],
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
