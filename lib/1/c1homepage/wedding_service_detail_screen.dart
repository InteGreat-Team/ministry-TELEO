import 'package:flutter/material.dart';

class WeddingServiceDetailScreen extends StatelessWidget {
  const WeddingServiceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wedding Service Details')),
      body: const Center(child: Text('Wedding Service Information')),
    );
  }
}
