import 'dart:convert';
import 'package:http/http.dart' as http;

class VerificationService {
  static String? _lastEmailSentTo;
  static DateTime? _lastSentTime;

  static Future<String> sendVerificationCode(String toEmail, String toName) async {
    const apiUrl = 'https://api.brevo.com/v3/smtp/email';
    const apiKey = ''; //insert api key

    final code = (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString();

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'api-key': apiKey,
      },
      body: jsonEncode({
        'sender': {'name': 'Teleo', 'email': 'your@email.com'},
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
    if (_lastEmailSentTo == toEmail &&
        _lastSentTime != null &&
        DateTime.now().difference(_lastSentTime!) < const Duration(seconds: 60)) {
      return "cooldown";
    }

    try {
      await sendVerificationCode(toEmail, toName);
      return "sent";
    } catch (_) {
      return "error";
    }
  }
}
