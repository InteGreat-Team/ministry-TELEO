import 'package:flutter/material.dart';
import 'main_report_screen.dart' as screens;
import '../../2/c1homepage/admin_types.dart';

typedef OnNavigate = void Function(AdminView view);

void main() {
  runApp(ReportApp());
}

class ReportApp extends StatelessWidget {
  final OnNavigate? onNavigate;
  const ReportApp({Key? key, this.onNavigate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Report System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
      ),
      home: screens.MainReportScreen(
        onBack:
            onNavigate != null ? () => onNavigate!(AdminView.settings) : null,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
