import 'package:flutter/material.dart';
import 'package:teleo_organized_new/3/prayerwall/home_screen.dart'; // make sure this path matches your structure

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Teleo App',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
      home: const HomeScreen(),
    );
  }
}

//