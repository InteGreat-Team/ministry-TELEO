import 'package:flutter/material.dart';
import '../../../2/church_model.dart';
import 'c1s3church_name_screen.dart';

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
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          const Text(
                            "Select church location",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.search,
                            color: Colors.grey.shade700,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Map area (expanded to fill available space)
          Expanded(
            child: Stack(
              children: [
                // Map background
                Image.network(
                  'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-dLJvlSGmeZ41gRBDq23mWKb5AONNZp.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ],
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
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      // Create updated church with location info
                      final updatedChurch = church.copyWith(
                        name: "Sunny Treasure Detroit Church",
                        location: "941 Sunny Treasure Line, Detroit, CA 95120",
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002642),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      "Choose this location",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}