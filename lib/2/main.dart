// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'c2homepage/schedule_tab.dart';
import 'c1homepage/main.dart' as c1homepage;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );

  // Also make sure to disable any debug banners
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teleo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF000233),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF000233),
          primary: const Color(0xFF000233),
        ),
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(elevation: 0),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ScheduleTab(),
        '/c1homepage': (context) => c1homepage.MyApp(),
      },
      builder: (context, child) {
        return Scaffold(
          drawer: Drawer(
            child: ListView(
              children: [
                const DrawerHeader(child: Text('Teleo App Navigation')),
                ListTile(
                  title: const Text('ScheduleTab'),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                ),
                ListTile(
                  title: const Text('C1Homepage (Admin Dashboard)'),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/c1homepage');
                  },
                ),
              ],
            ),
          ),
          body: child,
        );
      },
    );
  }
}

// Import the c1homepage entry point
import 'c1homepage/main.dart' as c1homepage;
