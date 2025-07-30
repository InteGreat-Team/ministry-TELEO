import 'package:flutter/material.dart';
import '../../backend/models/CHURCH_SIGNUP_VAR.dart'; // For ChurchModel
import '../widgets/index.dart'; // For custom widgets
import 'CHURCH_SIGNUP_3.dart'; // For next screen

class ChurchLocationScreen extends StatelessWidget {
  final ChurchModel church;

  const ChurchLocationScreen({
    super.key,
    required this.church,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // App bar with search
          SafeArea(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  const TeleoBackButton(),
                  Expanded(
                    child: CustomSearchBar(
                      hintText: "Select church location",
                      onChanged: (query) {
                        // Implement search logic here if needed
                      },
                      // No controller needed if just displaying hint
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Map area (expanded to fill available space)
          Expanded(
            child: MapContainer(
              imageUrl: 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-dLJvlSGmeZ41gRBDq23mWKb5AONNZp.png',
              // You can add overlay widgets here if needed, e.g., markers
            ),
          ),
          
          // Bottom info section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Sunny Treasure Detroit Church",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "1.0km · 941 Sunny Treasure Line, Detroit, CA 95120",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 20,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Main Entrance",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "1.0km",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomElevatedButton(
                  onPressed: () {
                    // Create updated church with location info
                    final updatedChurch = church.copyWith(
                      churchName: "Sunny Treasure Detroit Church",
                      address: "941 Sunny Treasure Line, Detroit, CA 95120",
                      // Assuming these fields exist in ChurchModel
                    );
                    
                    // Navigate to the next screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChurchNameScreen(
                          church: updatedChurch,
                        ),
                      ),
                    );
                  },
                  text: "Choose this location",
                  backgroundColor: const Color(0xFF002642),
                  foregroundColor: Colors.white,
                  height: 48,
                  width: double.infinity,
                  // Removed shape and elevation from here as it's handled by CustomElevatedButton
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder for MapContainer, assuming it's in index.dart
class MapContainer extends StatelessWidget {
  final String imageUrl;
  final List<Widget>? overlayWidgets;

  const MapContainer({
    super.key,
    required this.imageUrl,
    this.overlayWidgets,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          imageUrl,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 64, color: Colors.grey[600]),
                    const SizedBox(height: 8),
                    Text(
                      'Map not available',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        if (overlayWidgets != null) ...overlayWidgets!,
      ],
    );
  }
}
