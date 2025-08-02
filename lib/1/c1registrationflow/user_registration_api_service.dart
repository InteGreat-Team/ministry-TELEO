import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class UserRegistrationApiService {
  static const String baseUrl = 'https://asia-southeast1-teleo-church-application.cloudfunctions.net/signupApi'; // Replace with your actual endpoint

  static Future<http.Response> registerUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: { 'Content-Type': 'application/json' },
      body: jsonEncode(userData),
    );
    return response;
  }
}
