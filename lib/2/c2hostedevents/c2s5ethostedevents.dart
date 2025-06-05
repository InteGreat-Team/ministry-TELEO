import 'package:flutter/material.dart';
import 'dart:math' show pi;

class EventAnalyticsPage extends StatelessWidget {
  final Map<String, dynamic> eventData;

  const EventAnalyticsPage({
    super.key,
    required this.eventData,
  });

  @override
  Widget build(BuildContext context) {
    // Dummy data for engagement analytics
    final List<Map<String, dynamic>> engagementData = [
      {'category': 'Likes', 'value': 2500, 'percentage': 52, 'color': Colors.blue[300]},
      {'category': 'Comments', 'value': 1100, 'percentage': 23, 'color': Colors.orange[300]},
      {'category': 'Shares', 'value': 1200, 'percentage': 25, 'color': Colors.amber[300]},
    ];
    
    // Dummy data for attendance analytics
    final int totalRegistered = 175;
    final int totalAttended = 100;
    final int notAttended = 75;
    final double attendanceRate = 57;
    final int totalVolunteers = 30;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Analytics',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0A0E3D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: EventAnalyticsContent(eventData: eventData),
    );
  }

  Widget _buildBarChartRow({
    required String label,
    required int value,
    required int maxValue,
    required Color color,
  }) {
    final double percentage = maxValue > 0 ? value / maxValue : 0;
    
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              // Background bar
              Container(
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              // Value bar
              FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String value,
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  
  DonutChartPainter(this.data);
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    
    double startAngle = -90 * (pi / 180); // Start from top (270 degrees)
    
    for (var item in data) {
      final sweepAngle = (item['percentage'] / 100) * 2 * pi;
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = item['color'];
      
      // Draw arc segment
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      
      // Update start angle for next segment
      startAngle += sweepAngle;
    }
    
    // Draw center hole
    final holePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;
    
    canvas.drawCircle(center, radius * 0.6, holePaint);
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class EventAnalyticsContent extends StatelessWidget {
  final Map<String, dynamic> eventData;

  const EventAnalyticsContent({
    super.key,
    required this.eventData,
  });

  @override
  Widget build(BuildContext context) {
    // Dummy data for engagement analytics
    final List<Map<String, dynamic>> engagementData = [
      {'category': 'Likes', 'value': 2500, 'percentage': 52, 'color': Colors.blue[300]},
      {'category': 'Comments', 'value': 1100, 'percentage': 23, 'color': Colors.orange[300]},
      {'category': 'Shares', 'value': 1200, 'percentage': 25, 'color': Colors.amber[300]},
    ];
    
    // Dummy data for attendance analytics
    final int totalRegistered = 175;
    final int totalAttended = 100;
    final int notAttended = 75;
    final double attendanceRate = 57.0;
    final int totalVolunteers = 30;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event title
          Text(
            eventData['title'],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A0E3D),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'FEB 14, 7PM',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          
          // Engagement Analytics Section
          const Text(
            'ENGAGEMENT ANALYTICS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          
          // Engagement Donut Chart
          SizedBox(
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Donut chart
                CustomPaint(
                  size: const Size(200, 200),
                  painter: DonutChartPainter(engagementData),
                ),
                // Center hole
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          
          // Legend
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: engagementData.map((data) {
                return Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: data['color'],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['category'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${data['value']} (${data['percentage']}%)',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Attendance Analytics Section
          const Text(
            'ATTENDANCE ANALYTICS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          
          // Attendance Bar Chart
          Column(
            children: [
              // Registered Bar
              _buildBarChartRow(
                label: 'Registered',
                value: totalRegistered,
                maxValue: totalRegistered,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              
              // Attended Bar
              _buildBarChartRow(
                label: 'Attended',
                value: totalAttended,
                maxValue: totalRegistered,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              
              // Not Attended Bar
              _buildBarChartRow(
                label: 'Not Attended',
                value: notAttended,
                maxValue: totalRegistered,
                color: Colors.grey[700]!,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Metrics Cards
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  value: totalRegistered.toString(),
                  label: 'Total Registered',
                  color: Colors.blue[50]!,
                  textColor: Colors.blue[700]!,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  value: totalAttended.toString(),
                  label: 'Total Attended',
                  color: Colors.green[50]!,
                  textColor: Colors.green[700]!,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  value: '$attendanceRate%',
                  label: 'Attendance Rate',
                  color: Colors.purple[50]!,
                  textColor: Colors.purple[700]!,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  value: totalVolunteers.toString(),
                  label: 'Total Volunteers',
                  color: Colors.orange[50]!,
                  textColor: Colors.orange[700]!,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarChartRow({
    required String label,
    required int value,
    required int maxValue,
    required Color color,
  }) {
    final double percentage = maxValue > 0 ? value / maxValue : 0;
    
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              // Background bar
              Container(
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              // Value bar
              FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String value,
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
