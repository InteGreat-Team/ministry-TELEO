import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teleo_organized_new/3/prayerwall/home_screen.dart';
import 'package:teleo_organized_new/3/providers/prayer_provider.dart';
import 'package:teleo_organized_new/3/providers/prayer_request_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PrayerProvider()),
      ChangeNotifierProvider(create: (_) => PrayerRequestProvider()),

      ],
      
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Teleo App',
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
        // 👇 use builder here to get a valid context
        builder: (context, child) {
          return child!; // ✅ return the built widget
        },
        home: const HomeScreen(),
      ),
    );
  }
}
