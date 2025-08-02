// lib/landing_page/frontend/components/landing_page_components.dart

import 'package:flutter/material.dart';

// Placeholder for MetricsGrid
class MetricsGrid extends StatelessWidget {
  const MetricsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildMetricCard(context, 'Total Members', '1,234'),
        _buildMetricCard(context, 'Active Users', '876'),
        _buildMetricCard(context, 'New Signups', '50'),
        _buildMetricCard(context, 'Donations', '\$5,000'),
      ],
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D1B42),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for AnalyticsChart
class AnalyticsChart extends StatelessWidget {
  const AnalyticsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D1B42),
              ),
            ),
            const SizedBox(height: 16),
            // Placeholder for a chart visualization
            Container(
              height: 200,
              color: Colors.grey[200],
              child: const Center(
                child: Text(
                  'Chart Placeholder',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for ContentManagement
class ContentManagement extends StatelessWidget {
  const ContentManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Content Management',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D1B42),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text('Manage Posts'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to posts management
              },
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Manage Events'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to events management
              },
            ),
            ListTile(
              leading: const Icon(Icons.library_books),
              title: const Text('Manage Library'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to library management
              },
            ),
          ],
        ),
      ),
    );
  }
}
