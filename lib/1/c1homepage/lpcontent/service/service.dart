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
          title: const Text('Service'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.construction, 
                size: 80.sp, 
                color: Colors.grey[400]
              ),
              SizedBox(height: 20.h),
              Text(
                'This page is currently being developed.\nComing soon!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
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