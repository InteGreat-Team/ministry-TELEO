import 'dart:convert';
import 'package:http/http.dart' as http;

/// Handles sending and verifying email codes via Firebase Functions.
class EmailService {
  // Replace with your actual Cloud Function URL
  static const _baseUrl = 'https://asia-southeast1-teleo-church-application.cloudfunctions.net/sendCodeEmail';

  /// Sends a code to the given email.
  /// In production, no code is returned — only success or failure.
  static Future<String> sendVerificationCode(String email, String name) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/sendVerificationCode'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'name': name,
    }),
  );

  if (response.statusCode == 200) {
    // Parse the response to get the actual code for development
    final responseData = jsonDecode(response.body);
    return responseData['code'] ?? 'SENT';
  } else {
    throw Exception('Failed to send verification code: ${response.body}');
  }
}

  /// Verifies the given code for the email address.
  static Future<bool> verifyCode(String email, String code) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/verifyCode'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'code': code,
      }),
    );

    return response.statusCode == 200;
  }
}
