import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:teleo_organized_new/prayer_wall/FE/prayerwall/home_screen.dart';
import 'package:teleo_organized_new/prayer_wall/BE/providers/prayer_provider.dart';
import 'package:teleo_organized_new/prayer_wall/BE/providers/prayer_request_provider.dart';
import 'package:teleo_organized_new/login/login_screen.dart'; // <-- make sure the path is correct
import 'package:teleo_organized_new/prayer_wall/BE/providers/history_prayer_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PrayerProvider()),
        ChangeNotifierProvider(create: (_) => PrayerRequestProvider()),
        ChangeNotifierProvider(create: (_) => UserPostsViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Teleo App',
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
        home: const AuthWrapper(), // 👈 replace HomeScreen with this
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // User is logged in
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          return user == null ? const LoginScreen() : const HomeScreen();
        }

        // Loading state
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
