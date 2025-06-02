import 'package:flutter/material.dart';

class AppHighlightsSplashScreen extends StatelessWidget {
  const AppHighlightsSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
} 