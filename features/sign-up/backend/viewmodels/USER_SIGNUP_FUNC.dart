import 'package:flutter/material.dart';
import '../models/USER_SIGNUP_VAR.dart'; // Import all necessary models
import 'dart:convert'; // Added for VerificationService
import 'package:http/http.dart' as http; // Added for VerificationService

// Import the dotenv package if you are using it for environment variables
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// Replace hardcoded API keys with environment variable access
// const String googleApiKey = "YOUR_GOOGLE_MAPS_API_KEY"; // REMOVE THIS LINE
// const String googleApiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? 'DEFAULT_FALLBACK_KEY'; // ADD THIS LINE

// Google Maps API Key - Moved here as it's used by backend/API logic
const String googleApiKey = "YOUR_GOOGLE_MAPS_API_KEY";

class PersonViewModel extends ChangeNotifier {
  List<Person> _persons = [];

  List<Person> get persons => _persons;

  void addPerson(Person person) {
    _persons.add(person);
    notifyListeners();
    // API call example:
    // await ApiService.addPerson(person);
  }

  void removePerson(Person person) {
    _persons.remove(person);
    notifyListeners();
    // API call example:
    // await ApiService.removePerson(person.id);
  }

  void updatePerson(Person oldPerson, Person newPerson) {
    final index = _persons.indexOf(oldPerson);
    if (index != -1) {
      _persons[index] = newPerson;
      notifyListeners();
      // API call example:
      // await ApiService.updatePerson(newPerson);
    }
  }

  // Add other view models or functions here as needed.
  // Example:
  // Future<void> signUpUser(String email, String password) async {
  //   // Logic for user registration, potentially calling an authentication API
  //   print('Signing up user: $email');
  //   // await AuthApiService.register(email, password);
  //   // notifyListeners(); // Notify UI of registration status
  // }

  // Example of a method that would fetch data from a backend API
  // Future<void> fetchPersons() async {
  //   try {
  //     final fetchedData = await ApiService.getPersons();
  //     _persons = fetchedData.map((json) => Person.fromJson(json)).toList();
  //     notifyListeners();
  //   } catch (e) {
  //     print('Error fetching persons: $e');
  //   }
  // }
}

// Moved VerificationService into USER_SIGNUP_FUNC.dart as requested
class VerificationService {
  static String? _lastEmailSentTo;
  static DateTime? _lastSentTime;

  static Future<String> sendVerificationCode(String toEmail, String toName) async {
    const apiUrl = 'https://api.brevo.com/v3/smtp/email';
    // IMPORTANT: Replace with your actual Brevo API key.
    // In a real app, this should be loaded from environment variables.
    const apiKey = ''; //insert api key
    final code = (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString();

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'api-key': apiKey,
      },
      body: jsonEncode({
        'sender': {'name': 'Teleo', 'email': 'your@email.com'}, // Change sender email
        'to': [
          {'email': toEmail, 'name': toName}
        ],
        'subject': 'Your Teleo Verification Code',
        'htmlContent': '''
          <h3>Hello $toName,</h3>
          <p>Your verification code is:</p>
          <h2 style="color:#002642;">$code</h2>
          <p>This code is valid for 5 minutes.</p>
        ''',
      }),
    );

    if (response.statusCode == 201) {
      _lastEmailSentTo = toEmail;
      _lastSentTime = DateTime.now();
      return code;
    } else {
      throw Exception('Failed to send code: ${response.body}');
    }
  }

  static Future<String> resendCode(String toEmail, String toName) async {
    // Implement a cooldown to prevent spamming
    if (_lastEmailSentTo == toEmail &&
        _lastSentTime != null &&
        DateTime.now().difference(_lastSentTime!) < const Duration(seconds: 60)) {
      return "cooldown"; // Indicate that a cooldown is active
    }
    try {
      await sendVerificationCode(toEmail, toName);
      return "sent"; // Indicate that the code was sent
    } catch (_) {
      return "error"; // Indicate an error occurred
    }
  }
}
