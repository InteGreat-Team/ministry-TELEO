import 'package:flutter/material.dart';
import 'c2s4bsbaptismform.dart';

class MapScreen extends StatefulWidget {
  final bool showChurches;
  
  const MapScreen({super.key, this.showChurches = false});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Baptism Form',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: TextButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 14,
          ),
          label: const Text(
            'Back',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        leadingWidth: 70,
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top + 56, // Status bar + AppBar height
            decoration: const BoxDecoration(
              color: Color(0xFF0A0A4A),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                // Map placeholder (to be replaced with actual map implementation)
                Image.asset(
                  'assets/map_placeholder.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(
                          Icons.map,
                          size: 100,
                          color: Colors.grey[400],
                        ),
                      ),
                    );
                  },
                ),
                
                // Current location indicator and church indicators if showChurches is true
                Stack(
                  children: [
                    // Current location indicator
                    Center(
                      child: Icon(
                        Icons.location_on,
                        color: const Color(0xFF0A0A4A),
                        size: 50,
                      ),
                    ),
                    
                    // Church indicators (only shown if showChurches is true)
                    if (widget.showChurches) ...[
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.3,
                        left: MediaQuery.of(context).size.width * 0.3,
                        child: _buildChurchIcon(),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.4,
                        right: MediaQuery.of(context).size.width * 0.3,
                        child: _buildChurchIcon(),
                      ),
                      Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.3,
                        left: MediaQuery.of(context).size.width * 0.4,
                        child: _buildChurchIcon(),
                      ),
                    ],
                  ],
                ),
                
                // Search bar
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.menu, color: Colors.grey[600]),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            widget.showChurches ? 'Find churches nearby' : 'Select Location',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Icon(Icons.search, color: Colors.grey[600]),
                      ],
                    ),
                  ),
                ),
                
                // Location card
                Positioned(
                  bottom: 80,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.showChurches ? 'Nearby Churches' : 'Current Location',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.showChurches 
                              ? 'Select a church from the map'
                              : 'Your location will be used for the service',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '0.0km',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Choose location button
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PersonalDetailsScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A0A4A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      widget.showChurches ? 'Select This Church' : 'Use Current Location',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
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
  
  Widget _buildChurchIcon() {
    return Container(
      width: 35, // Slightly bigger
      height: 35, // Slightly bigger
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.church,
          color: Color(0xFF0A4A8F), // Changed to blue
          size: 22, // Slightly bigger
        ),
      ),
    );
  }
}
