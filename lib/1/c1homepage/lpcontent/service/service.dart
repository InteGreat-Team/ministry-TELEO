import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../nav_bar.dart'; // Import NavBar
import '../../sidebar.dart'; // Import Sidebar
import '../../../../utils/app_navigator.dart'; // Import the new navigation helper

class ServicePage extends StatelessWidget {
  const ServicePage({super.key}); // Use super.key

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent swiping back from this page
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Service Page'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction, size: 80.sp, color: Colors.grey[400]),
              SizedBox(height: 20.h),
              Text(
                'Service Page - Coming Soon!',
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
            ],
          ),
        ),
        bottomNavigationBar: NavBar(
          currentIndex: 1, // Set current index for Service
          onTap: (index) => navigateToMainPage(context, index),
        ),
        drawer: const Sidebar(), // Add Sidebar to this page
      ),
    );
  }
}
