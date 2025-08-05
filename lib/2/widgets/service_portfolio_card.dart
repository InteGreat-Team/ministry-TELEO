import 'package:flutter/material.dart';
import '../c2spp/c2s2_edit_service_page.dart';

class ServicePortfolioCard extends StatelessWidget {
  final String title;
  final String description;
  final String location;
  final List<String> tags;
  final String cId;
  final String servName;
  final String servId;

  const ServicePortfolioCard({
    super.key,
    required this.title,
    required this.description,
    required this.location,
    required this.tags,
    required this.cId,
    required this.servName,
    required this.servId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditServicePage(
              title: title,
              description: description,
              cId: cId,
              servName: servName,
              servId: servId,
            ),
          ),
        );
      },
      child: Container(
        width: 160, // Fixed width for horizontal scroll
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0), // Placeholder grey
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                image: DecorationImage(
                  image: NetworkImage('/placeholder.svg?height=100&width=160'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: tags.map((tag) {
                      Color backgroundColor;
                      Color textColor;
                      if (tag == 'Fast' || tag == 'Later') {
                        backgroundColor = const Color(0xFFE0F7FA); // Light blue
                        textColor = const Color(0xFF00796B); // Dark teal
                      } else if (tag.startsWith('P')) {
                        backgroundColor = const Color(0xFFE8F5E9); // Light green
                        textColor = const Color(0xFF388E3C); // Dark green
                      } else {
                        backgroundColor = Colors.grey.shade200;
                        textColor = Colors.grey.shade800;
                      }
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(4),
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
          ],
        ),
      ),
    );
  }
}
