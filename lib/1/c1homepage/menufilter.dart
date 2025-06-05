import 'package:flutter/material.dart';
import 'mass_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedFilter = 'all'; // 'all', 'service', 'event', 'reading'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Column(
        children: [
          // Filter buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                _buildFilterButton('All', 'all'),
                _buildFilterButton('Appointments', 'service'),
                _buildFilterButton('Events', 'event'),
                _buildFilterButton('Readings', 'reading'),
              ],
            ),
          ),
          // Content
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedFilter) {
      case 'service':
        return _buildUpcomingServicesSection();
      case 'event':
        return _buildEventsSection();
      case 'reading':
        return _buildReadingsSection();
      default:
        return ListView(
          children: [
            _buildUpcomingServicesSection(),
            _buildEventsSection(),
            _buildReadingsSection(),
          ],
        );
    }
  }

  Widget _buildUpcomingServicesSection() {
    final services = MassData.getServices();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Upcoming Services',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ...services.map(
          (mass) => Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(mass.title),
              subtitle: Text('${mass.time} - ${mass.location}'),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventsSection() {
    final events = MassData.getEvents();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Events',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ...events.map(
          (mass) => Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(mass.title),
              subtitle: Text('${mass.time} - ${mass.location}'),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadingsSection() {
    final readings = MassData.getReadings();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Readings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ...readings.map(
          (mass) => Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(mass.title),
              subtitle: Text('${mass.time} - ${mass.location}'),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton(String label, String filter) {
    final isSelected = _selectedFilter == filter;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedFilter = filter;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
          foregroundColor: isSelected ? Colors.white : Colors.black,
        ),
        child: Text(label),
      ),
    );
  }
}
