import 'package:flutter/material.dart';
import '../admin_types.dart';

class MetricsGrid extends StatelessWidget {
  final AdminData adminData;

  const MetricsGrid({Key? key, required this.adminData}) : super(key: key);

  Widget _buildMetricCard(
    String title,
    String value,
    String percentage,
    IconData icon, {
    required bool isPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A3A5A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Icon(
                icon,
                color: isPositive ? Colors.orange : Colors.pink,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            percentage,
            style: TextStyle(
              color: isPositive
                  ? percentage.startsWith('+')
                      ? Colors.green
                      : Colors.red
                  : percentage.startsWith('-')
                      ? Colors.red
                      : Colors.green,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Login Activity',
                  adminData.loginActivity,
                  adminData.loginActivityPercentage,
                  Icons.trending_up,
                  isPositive: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Daily Follows',
                  adminData.dailyFollows,
                  adminData.dailyFollowsPercentage,
                  Icons.favorite,
                  isPositive: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Daily Visits',
                  adminData.dailyVisits,
                  adminData.dailyVisitsPercentage,
                  Icons.access_time,
                  isPositive: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Bookings',
                  adminData.bookings,
                  adminData.bookingsPercentage,
                  Icons.calendar_today,
                  isPositive: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}