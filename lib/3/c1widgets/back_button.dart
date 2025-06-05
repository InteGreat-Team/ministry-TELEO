import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TeleoBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  
  const TeleoBackButton({
    super.key,
    this.onPressed,
    this.color = const Color(0xFF002642),
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        CupertinoIcons.back,
        color: color,
        size: 24,
      ),
      onPressed: onPressed ?? () {
        Navigator.of(context).pop();
      },
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashRadius: 24,
    );
  }
}