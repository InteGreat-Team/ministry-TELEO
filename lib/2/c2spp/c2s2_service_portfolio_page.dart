import 'package:flutter/material.dart';

class ServicePortfolioPage extends StatefulWidget {
  @override
  _ServicePortfolioPageState createState() => _ServicePortfolioPageState();
}

class _ServicePortfolioPageState extends State<ServicePortfolioPage> {
  List<Map<String, dynamic>> _services = [];

  void _showAddServiceBottomSheet(BuildContext context) {
    // Implementation for showing bottom sheet
  }

  List<String> _generateTags(Map<String, dynamic> service) {
    List<String> tags = [];
    switch (service['serv_type']) {
      case 'C0001':
        tags.add('Later');
        break;
      case 'C0002':
        tags.add('Fast');
        break;
      case 'C0003':
        tags.add('Fast');
        tags.add('Later');
        break;
    }
    // Add amount tag if available and not zero
    if (service.containsKey('amount') && service['amount'] != null && service['amount'] != 0) {
      tags.add('P${service['amount']}');
    }
    return tags;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Portfolio'),
      ),
      body: ListView.builder(
        itemCount: _services.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_services[index]['name']),
            subtitle: Text(_services[index]['description']),
            trailing: Wrap(
              spacing: 8,
              children: _generateTags(_services[index]).map((tag) {
                return Chip(
                  label: Text(tag),
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: Container(
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFF000233),
          borderRadius: BorderRadius.circular(6),
        ),
        child: TextButton.icon(
          onPressed: () {
            _showAddServiceBottomSheet(context);
          },
          icon: const Icon(
            Icons.add,
            color: Colors.white,
            size: 16,
          ),
          label: const Text(
            'Add a Service',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
        ),
      ),
    );
  }
}
