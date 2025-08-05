import 'package:flutter/material.dart';
import '../1/c1homepage/lpcontent/homepage/landingpage.dart';
import '../1/c1homepage/lpcontent/service/service.dart';
import '../1/c1homepage/lpcontent/connect/connect.dart';
import '../1/c1homepage/lpcontent/read/read.dart';
import '../1/c1homepage/lpcontent/you/you.dart';

/// A global helper function to navigate to main application pages.
/// This uses pushReplacement to ensure a clean navigation stack,
/// preventing an endless history and always leading to the correct main page.
void navigateToMainPage(BuildContext context, int index) {
  Widget targetPage;
  switch (index) {
    case 0: // Home
      targetPage = const LandingPage();
      break;
    case 1: // Service
      targetPage = const ServicePage();
      break;
    case 2: // Connect
      targetPage = const ConnectPage();
      break;
    case 3: // Read
      targetPage = const ReadPage();
      break;
    case 4: // You
      targetPage = const YouPage();
      break;
    default:
      return; // Should not happen
  }

  // Use pushReplacement to replace the current route, ensuring a clean stack
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => targetPage),
  );
}
