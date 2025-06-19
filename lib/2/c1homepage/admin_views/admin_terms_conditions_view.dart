import 'package:flutter/material.dart';
import '../admin_types.dart';

class AdminTermsConditionsView extends StatelessWidget {
  final void Function(AdminView) onNavigate;
  const AdminTermsConditionsView({Key? key, required this.onNavigate})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'This is a basic placeholder for the Terms and Conditions.\n\n'
                  '1. Use of this app is subject to the following terms...\n'
                  '2. All data is handled according to our privacy policy...\n'
                  '3. Do not misuse the app or its features...\n\n'
                  'For more information, contact your administrator.',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
