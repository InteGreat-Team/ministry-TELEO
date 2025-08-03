// lib/features/SIGNUP/backend/services/email_service.dart
// This file is assumed to be correct and does not need modifications.
// Placeholder content for brevity, replace with actual content if available.
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

class EmailService {
  // Replace with your actual Cloud Function URL for sending verification codes
  static const String _sendCodeUrl = 'YOUR_SEND_VERIFICATION_CODE_CLOUD_FUNCTION_URL';
  // Replace with your actual Cloud Function URL for verifying codes
  static const String _verifyCodeUrl = 'YOUR_VERIFY_CODE_CLOUD_FUNCTION_URL';

  // In a real application, you would store and manage these codes securely on the backend.
  // For demonstration purposes, we'll simulate storing them in memory.
  static final Map<String, String> _verificationCodes = {};

  Future<String> sendVerificationCode(String email, String userName) async {
    try {
      // Generate a 6-digit code
      final String code = (100000 + Random().nextInt(900000)).toString();

      // Simulate sending email via a backend service
      // In a real scenario, this would be an HTTP POST request to your Cloud Function
      // final response = await http.post(
      //   Uri.parse(_sendCodeUrl),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode({
      //     'email': email,
      //     'userName': userName,
      //     'code': code,
      //   }),
      // );

      // if (response.statusCode == 200) {
      //   _verificationCodes[email] = code; // Store the code temporarily
      //   return code;
      // } else {
      //   throw Exception('Failed to send verification code: ${response.body}');
      // }

      // --- Simulation for frontend testing ---
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
      _verificationCodes[email] = code; // Store the code temporarily
      print('Simulated: Sent code $code to $email for $userName');
      return code;
      // --- End Simulation ---

    } catch (e) {
      print('Error sending verification code: $e');
      rethrow;
    }
  }

  Future<bool> verifyCode(String email, String enteredCode) async {
    try {
      // Simulate verifying code via a backend service
      // In a real scenario, this would be an HTTP POST request to your Cloud Function
      // final response = await http.post(
      //   Uri.parse(_verifyCodeUrl),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode({
      //     'email': email,
      //     'enteredCode': enteredCode,
      //   }),
      // );

      // if (response.statusCode == 200) {
      //   final bool isMatch = json.decode(response.body)['isMatch'];
      //   if (isMatch) {
      //     _verificationCodes.remove(email); // Remove code after successful verification
      //   }
      //   return isMatch;
      // } else {
      //   throw Exception('Failed to verify code: ${response.body}');
      // }

      // --- Simulation for frontend testing ---
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      final storedCode = _verificationCodes[email];
      final isMatch = storedCode == enteredCode;
      if (isMatch) {
        _verificationCodes.remove(email); // Remove code after successful verification
        print('Simulated: Code for $email verified successfully.');
      } else {
        print('Simulated: Invalid code $enteredCode for $email. Expected $storedCode');
      }
      return isMatch;
      // --- End Simulation ---

    } catch (e) {
      print('Error verifying code: $e');
      rethrow;
    }
  }
}
