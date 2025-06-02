import 'package:flutter/material.dart';
import '../1/c1homepage/home_page.dart';
import '../2/c1homepage/home_page.dart';

class NavigationService {
  static void navigateToAdminHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AdminHomePage()),
    );
  }

  static void navigateToUserHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }
}
