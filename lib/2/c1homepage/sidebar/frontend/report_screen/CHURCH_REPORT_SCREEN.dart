// lib/sidebar/frontend/report_screen/CHURCH_REPORT_SCREEN.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/admin_models.dart';
import '../../../sidebar/backend/report_screen/church_report_screen_viewmodel.dart';

class ChurchReportScreen extends StatelessWidget {
  final Function(AdminView) onNavigate;

  const ChurchReportScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChurchReportScreenViewModel(onNavigate: onNavigate),
      child: Consumer<ChurchReportScreenViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Report an Issue'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Report an Issue',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'If you are experiencing any issues with the app, please let us know.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 24),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Describe the issue',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: null,
                    child: Text('Submit Report'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
