import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../nav_bar.dart'; // Import NavBar
import '../../sidebar.dart'; // Import Sidebar
import '../../../../utils/app_navigator.dart'; // Import the new navigation helper

class ReadPage extends StatelessWidget {
  const ReadPage({super.key}); // Use super.key

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent swiping back from this page
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Read Page'),
          backgroundColor: Colors.orange,
        ),
        body: const Center(
          child: Text(
            'Read Page - Coming Soon!',
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
        bottomNavigationBar: NavBar(
          currentIndex: 3, // Set current index for Read
          onTap: (index) => navigateToMainPage(context, index),
        ),
        drawer: const Sidebar(), // Add Sidebar to this page
      ),
    );
  }
}
