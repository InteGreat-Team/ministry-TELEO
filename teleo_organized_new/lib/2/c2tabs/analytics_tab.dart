import 'package:flutter/material.dart';

class AnalyticsTab extends StatefulWidget {
  const AnalyticsTab({Key? key}) : super(key: key);

  @override
  State<AnalyticsTab> createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends State<AnalyticsTab> {
  String _selectedTimeframe = 'Day';
  final List<String> _timeframes = ['Day', 'Week', 'Month', 'Year'];
  
  // Dummy data for different timeframes
  final Map<String, Map<String, dynamic>> _timeframeData = {
    'Day': {
      'date': 'Feb 14, Friday',
      'morningBookings': 24,
      'peakHours': '10AM',
      'trackingRate': '99.2%',
      'services': [
        {'name': 'Baptism', 'count': 12, 'trending': true},
        {'name': 'Anointment & Healing', 'count': 10, 'trending': false},
        {'name': 'House Blessing', 'count': 8, 'trending': true},
        {'name': 'Prayer Request', 'count': 6, 'trending': false},
        {'name': 'Wedding', 'count': 2, 'trending': false},
      ],
      'locations': [
        {'name': 'Downtown', 'count': 24, 'color': Colors.red},
        {'name': 'San Juan', 'count': 20, 'color': Colors.redAccent},
        {'name': 'Makati', 'count': 12, 'color': Colors.orange},
        {'name': 'Manila', 'count': 10, 'color': Colors.orangeAccent},
        {'name': 'Quezon City', 'count': 4, 'color': Colors.yellow},
      ],
      'peakHoursData': [0, 0, 0, 0, 0, 1, 2, 5, 10, 6, 7, 4, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    },
    'Week': {
      'date': 'Feb 10-16',
      'morningBookings': 142,
      'peakHours': '11AM',
      'trackingRate': '97.8%',
      'services': [
        {'name': 'Baptism', 'count': 45, 'trending': true},
        {'name': 'Prayer Request', 'count': 38, 'trending': true},
        {'name': 'House Blessing', 'count': 32, 'trending': false},
        {'name': 'Anointment & Healing', 'count': 28, 'trending': false},
        {'name': 'Wedding', 'count': 15, 'trending': true},
      ],
      'locations': [
        {'name': 'Downtown', 'count': 85, 'color': Colors.red},
        {'name': 'San Juan', 'count': 72, 'color': Colors.redAccent},
        {'name': 'Makati', 'count': 56, 'color': Colors.orange},
        {'name': 'Manila', 'count': 43, 'color': Colors.orangeAccent},
        {'name': 'Quezon City', 'count': 28, 'color': Colors.yellow},
      ],
      'peakHoursData': [0, 0, 0, 0, 0, 3, 5, 8, 12, 15, 10, 8, 6, 4, 3, 2, 1, 0, 0, 0, 0, 0, 0, 0],
    },
    'Month': {
      'date': 'February 2023',
      'morningBookings': 620,
      'peakHours': '9AM',
      'trackingRate': '95.5%',
      'services': [
        {'name': 'Prayer Request', 'count': 180, 'trending': true},
        {'name': 'Baptism', 'count': 165, 'trending': false},
        {'name': 'House Blessing', 'count': 140, 'trending': true},
        {'name': 'Anointment & Healing', 'count': 95, 'trending': false},
        {'name': 'Wedding', 'count': 40, 'trending': true},
      ],
      'locations': [
        {'name': 'Downtown', 'count': 210, 'color': Colors.red},
        {'name': 'San Juan', 'count': 185, 'color': Colors.redAccent},
        {'name': 'Makati', 'count': 125, 'color': Colors.orange},
        {'name': 'Manila', 'count': 80, 'color': Colors.orangeAccent},
        {'name': 'Quezon City', 'count': 20, 'color': Colors.yellow},
      ],
      'peakHoursData': [0, 0, 0, 0, 0, 4, 7, 12, 15, 10, 8, 6, 5, 4, 3, 2, 1, 0, 0, 0, 0, 0, 0, 0],
    },
    'Year': {
      'date': '2023',
      'morningBookings': 7850,
      'peakHours': '10AM',
      'trackingRate': '93.7%',
      'services': [
        {'name': 'Prayer Request', 'count': 2450, 'trending': true},
        {'name': 'Baptism', 'count': 1980, 'trending': true},
        {'name': 'House Blessing', 'count': 1540, 'trending': false},
        {'name': 'Anointment & Healing', 'count': 1280, 'trending': false},
        {'name': 'Wedding', 'count': 600, 'trending': true},
      ],
      'locations': [
        {'name': 'Downtown', 'count': 2800, 'color': Colors.red},
        {'name': 'San Juan', 'count': 2100, 'color': Colors.redAccent},
        {'name': 'Makati', 'count': 1500, 'color': Colors.orange},
        {'name': 'Manila', 'count': 950, 'color': Colors.orangeAccent},
        {'name': 'Quezon City', 'count': 500, 'color': Colors.yellow},
      ],
      'peakHoursData': [0, 0, 0, 0, 0, 5, 8, 12, 14, 16, 12, 9, 7, 5, 4, 3, 2, 1, 0, 0, 0, 0, 0, 0],
    },
  };

  // Metro Manila districts with their coordinates
  final List<Map<String, dynamic>> _metroManilaDistricts = [
    {'name': 'Downtown', 'lat': 14.5995, 'lng': 120.9842, 'intensity': 0.9}, // High intensity
    {'name': 'San Juan', 'lat': 14.6000, 'lng': 121.0300, 'intensity': 0.8},
    {'name': 'Makati', 'lat': 14.5547, 'lng': 121.0244, 'intensity': 0.6},
    {'name': 'Manila', 'lat': 14.5995, 'lng': 120.9842, 'intensity': 0.5},
    {'name': 'Quezon City', 'lat': 14.6760, 'lng': 121.0437, 'intensity': 0.3}, // Low intensity
  ];

  Map<String, dynamic> get _currentData => _timeframeData[_selectedTimeframe]!;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center the column contents
          children: [
            // Date and title - Centered
            Center(
              child: Column(
                children: [
                  Text(
                    _currentData['date'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Services Summary Report',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Timeframe selector - Centered
            Center(
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Make row only as wide as needed
                  children: _timeframes.map((timeframe) {
                    final isSelected = timeframe == _selectedTimeframe;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTimeframe = timeframe;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          timeframe,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Top 5 services - Full width
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Top 5 Most Popular Services',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._currentData['services'].asMap().entries.map((entry) {
                    final index = entry.key;
                    final service = entry.value;
                    return _buildServiceItem(
                      index + 1,
                      service['name'],
                      service['count'],
                      service['trending'],
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Key metrics - Single row with 3 cards
            Row(
              children: [
                // Morning Bookings
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.people,
                    iconColor: Colors.blue,
                    title: 'Morning Bookings',
                    value: _currentData['morningBookings'].toString(),
                  ),
                ),
                const SizedBox(width: 12),
                // Peak Hours
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.access_time,
                    iconColor: Colors.orange,
                    title: 'Peak Hours',
                    value: _currentData['peakHours'],
                  ),
                ),
                const SizedBox(width: 12),
                // Service Tracking Rate
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                    title: 'Service Tracking Rate',
                    value: _currentData['trackingRate'],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Location heatmap
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Location Heatmap of Booking Density',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: Stack(
                      children: [
                        // Metro Manila map
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            // Using Google Static Maps API to get a map of Metro Manila
                            'https://maps.googleapis.com/maps/api/staticmap?center=14.5995,120.9842&zoom=11&size=600x400&maptype=roadmap&style=feature:all|element:labels|visibility:on',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback if map loading fails
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.map, size: 48, color: Colors.grey[400]),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Metro Manila Map',
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        
                        // Heatmap overlay
                        Positioned.fill(
                          child: CustomPaint(
                            painter: MetroManilaHeatmapPainter(_metroManilaDistricts),
                          ),
                        ),
                        
                        // Legend
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(4),
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
                                const Text(
                                  'Top Cities No. of Bookings',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                ..._currentData['locations'].map((location) {
                                  return _buildLegendItem(
                                    location['name'],
                                    location['count'],
                                    location['color'],
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Peak booking hours chart
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Peak Booking Hours',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: _buildLineChart(_currentData['peakHoursData']),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      height: 130,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: iconColor, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildServiceItem(int index, String name, int count, bool isIncreasing) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 20,
            alignment: Alignment.center,
            child: Text(
              '$index',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF000080), // Navy blue color for service names
              ),
            ),
          ),
          Icon(
            isIncreasing ? Icons.trending_up : Icons.trending_down,
            color: isIncreasing ? Colors.green : Colors.grey,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(List<int> data) {
    return CustomPaint(
      painter: LineChartPainter(data),
      size: const Size(double.infinity, 200),
    );
  }

  Widget _buildLegendItem(String location, int count, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            location,
            style: const TextStyle(fontSize: 10),
          ),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Metro Manila specific heatmap painter
class MetroManilaHeatmapPainter extends CustomPainter {
  final List<Map<String, dynamic>> districts;
  
  MetroManilaHeatmapPainter(this.districts);
  
  @override
  void paint(Canvas canvas, Size size) {
    // Map coordinates to screen coordinates
    // These are approximate transformations for Metro Manila area
    double latMin = 14.5000; // Southernmost point
    double latMax = 14.7500; // Northernmost point
    double lngMin = 120.9000; // Westernmost point
    double lngMax = 121.1000; // Easternmost point
    
    for (final district in districts) {
      // Convert lat/lng to x/y coordinates on the canvas
      final lat = district['lat'] as double;
      final lng = district['lng'] as double;
      
      // Normalize coordinates to [0,1] range
      final normalizedX = (lng - lngMin) / (lngMax - lngMin);
      final normalizedY = 1.0 - (lat - latMin) / (latMax - latMin); // Invert Y because lat increases northward
      
      // Convert to canvas coordinates
      final x = normalizedX * size.width;
      final y = normalizedY * size.height;
      
      final intensity = district['intensity'] as double;
      final radius = size.width * 0.15 * intensity;
      
      // Create a radial gradient for each district
      final paint = Paint();
      final gradient = RadialGradient(
        center: const Alignment(0.0, 0.0),
        radius: 1.0,
        colors: [
          Colors.red.withOpacity(intensity),
          Colors.orange.withOpacity(intensity * 0.8),
          Colors.yellow.withOpacity(intensity * 0.6),
          Colors.transparent,
        ],
        stops: const [0.2, 0.5, 0.7, 1.0],
      );
      
      paint.shader = gradient.createShader(
        Rect.fromCircle(center: Offset(x, y), radius: radius),
      );
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Line chart painter
class LineChartPainter extends CustomPainter {
  final List<int> data;
  
  LineChartPainter(this.data);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
      
    final dotPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;
      
    final path = Path();
    
    // Find the maximum value for scaling
    final maxValue = data.reduce((curr, next) => curr > next ? curr : next).toDouble();
    
    // Draw axes
    final axesPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;
      
    // X-axis
    canvas.drawLine(
      Offset(0, size.height - 20),
      Offset(size.width, size.height - 20),
      axesPaint,
    );
    
    // Y-axis
    canvas.drawLine(
      const Offset(30, 0),
      Offset(30, size.height - 20),
      axesPaint,
    );
    
    // Draw time labels on x-axis
    final textStyle = TextStyle(
      color: Colors.grey[600],
      fontSize: 8,
    );
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    
    // Draw hour labels (every 3 hours)
    for (int i = 0; i < 24; i += 3) {
      final x = 30 + (i / 23) * (size.width - 40);
      final hour = i == 0 ? '12AM' : i < 12 ? '${i}AM' : i == 12 ? '12PM' : '${i-12}PM';
      
      textPainter.text = TextSpan(text: hour, style: textStyle);
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - 15),
      );
      
      // Small tick mark
      canvas.drawLine(
        Offset(x, size.height - 20),
        Offset(x, size.height - 23),
        axesPaint,
      );
    }
    
    // Draw value labels on y-axis
    for (int i = 0; i <= 5; i++) {
      final y = (size.height - 20) - (i / 5) * (size.height - 30);
      final value = (i * maxValue / 5).round();
      
      textPainter.text = TextSpan(text: value.toString(), style: textStyle);
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(25 - textPainter.width, y - textPainter.height / 2),
      );
      
      // Small tick mark
      canvas.drawLine(
        Offset(27, y),
        Offset(30, y),
        axesPaint,
      );
    }
    
    // Draw the data line
    if (maxValue > 0) {
      for (int i = 0; i < data.length; i++) {
        final x = 30 + (i / (data.length - 1)) * (size.width - 40);
        final y = (size.height - 20) - (data[i] / maxValue) * (size.height - 30);
        
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
        
        // Draw point
        canvas.drawCircle(Offset(x, y), 3, dotPaint);
      }
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}
