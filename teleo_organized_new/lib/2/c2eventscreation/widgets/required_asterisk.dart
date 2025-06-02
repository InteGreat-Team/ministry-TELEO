import 'package:flutter/material.dart';

class RequiredAsterisk extends StatelessWidget {
  const RequiredAsterisk({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      ' *',
      style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

