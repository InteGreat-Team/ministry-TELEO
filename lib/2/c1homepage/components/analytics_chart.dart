import 'package:flutter/material.dart';

class AnalyticsChart extends StatefulWidget {
  const AnalyticsChart({Key? key}) : super(key: key);

  @override
  State<AnalyticsChart> createState() => _AnalyticsChartState();
}

class _AnalyticsChartState extends State<AnalyticsChart> {
  int _activeAnalyticsTab = 0;

  Widget _buildBarChartColumn(double height, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: 160 * height,
          decoration: BoxDecoration(
            color: Colors.blue[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTimeSpentColumn(double height, String label, bool isHighlighted) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: 160 * height,
          decoration: BoxDecoration(
            color: isHighlighted ? Colors.blue[300] : Colors.blue[300]?.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildBarChartContent() {
    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('30K', style: TextStyle(color: Colors.white, fontSize: 12)),
              Text('20K', style: TextStyle(color: Colors.white, fontSize: 12)),
              Text('10K', style: TextStyle(color: Colors.white, fontSize: 12)),
              Text('0', style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          const SizedBox(width: 10),
          _buildBarChartColumn(0.5, 'Jan'),
          _buildBarChartColumn(0.8, 'Feb'),
          _buildBarChartColumn(0.6, 'Mar'),
          _buildBarChartColumn(0.9, 'Apr'),
          _buildBarChartColumn(0.4, 'May'),
          _buildBarChartColumn(0.7, 'Jun'),
        ],
      ),
    );
  }

  Widget _buildTimeSpentContent() {
    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTimeSpentColumn(0.3, 'Jan', false),
          _buildTimeSpentColumn(0.5, 'Feb', false),
          _buildTimeSpentColumn(0.4, 'Mar', false),
          _buildTimeSpentColumn(0.2, 'April', false),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              _buildTimeSpentColumn(0.9, 'May', true),
              Container(
                margin: const EdgeInsets.only(bottom: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '243K',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          _buildTimeSpentColumn(0.1, 'June', false),
        ],
      ),
    );
  }

  Widget _buildFollowersContent() {
    return Column(
      children: [
        Center(
          child: Text(
            '7,265',
            style: TextStyle(
              color: Colors.blue[300],
              fontSize: 72,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '+11.01%',
                style: TextStyle(
                  color: Colors.blue[300],
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.trending_up, color: Colors.blue[300], size: 24),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF002642),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _activeAnalyticsTab = 0),
                child: Text(
                  'Total Reads',
                  style: TextStyle(
                    color: _activeAnalyticsTab == 0 ? Colors.blue[300] : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => setState(() => _activeAnalyticsTab = 1),
                child: Text(
                  'Total Watches',
                  style: TextStyle(
                    color: _activeAnalyticsTab == 1 ? Colors.blue[300] : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => setState(() => _activeAnalyticsTab = 2),
                child: Text(
                  'Total Followers',
                  style: TextStyle(
                    color: _activeAnalyticsTab == 2 ? Colors.blue[300] : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_activeAnalyticsTab == 0) _buildBarChartContent(),
          if (_activeAnalyticsTab == 1) _buildTimeSpentContent(),
          if (_activeAnalyticsTab == 2) _buildFollowersContent(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _activeAnalyticsTab == 0
                      ? Colors.blue[300]
                      : Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _activeAnalyticsTab == 1
                      ? Colors.blue[300]
                      : Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _activeAnalyticsTab == 2
                      ? Colors.blue[300]
                      : Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}