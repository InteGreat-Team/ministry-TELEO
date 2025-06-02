import 'package:flutter/material.dart';
import 'main_report_screen.dart' as screens;

void main() {
  runApp(ReportApp());
}

class ReportApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Report System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
      ),
      home: screens.MainReportScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
