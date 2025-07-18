import 'package:flutter/material.dart';

class UnfollowDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String churchName;

  const UnfollowDialog({
    Key? key,
    required this.onConfirm,
    required this.onCancel,
    required this.churchName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Unfollow Church'),
      content: Text('Are you sure you want to unfollow $churchName?'),
      actions: [
        TextButton(onPressed: onCancel, child: const Text('Cancel')),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Unfollow'),
        ),
      ],
    );
  }
}
