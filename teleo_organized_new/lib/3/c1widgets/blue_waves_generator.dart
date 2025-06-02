import 'package:flutter/material.dart';
import 'dart:ui' as ui;

/// This is a utility class to generate a blue waves background
/// You can use this to create a custom painter that draws the waves
/// or to export the image to a file
class BlueWavesGenerator extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Create gradient background
    final Paint backgroundPaint =
        Paint()
          ..shader = ui.Gradient.linear(const Offset(0, 0), Offset(0, height), [
            const Color(0xFF0077BE), // Light blue at top
            const Color(0xFF005A9C), // Medium blue in middle
            const Color(0xFF002642), // Dark blue at bottom
          ]);

    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), backgroundPaint);

    // Draw wave shapes
    final Paint wavePaint1 =
        Paint()
          ..color = const Color(0xFF0066A6)
          ..style = PaintingStyle.fill;

    final Paint wavePaint2 =
        Paint()
          ..color = const Color(0xFF004C7F)
          ..style = PaintingStyle.fill;

    // Top wave
    final Path topWavePath = Path();
    topWavePath.moveTo(0, 0);
    topWavePath.lineTo(width, 0);
    topWavePath.lineTo(width, height * 0.3);

    // Create a curved bottom edge
    topWavePath.quadraticBezierTo(
      width * 0.7,
      height * 0.4,
      width * 0.5,
      height * 0.35,
    );
    topWavePath.quadraticBezierTo(width * 0.3, height * 0.3, 0, height * 0.4);

    topWavePath.close();
    canvas.drawPath(topWavePath, wavePaint1);

    // Bottom wave
    final Path bottomWavePath = Path();
    bottomWavePath.moveTo(0, height);
    bottomWavePath.lineTo(width, height);
    bottomWavePath.lineTo(width, height * 0.7);

    // Create a curved top edge
    bottomWavePath.quadraticBezierTo(
      width * 0.8,
      height * 0.6,
      width * 0.6,
      height * 0.65,
    );
    bottomWavePath.quadraticBezierTo(
      width * 0.4,
      height * 0.7,
      width * 0.2,
      height * 0.65,
    );
    bottomWavePath.quadraticBezierTo(
      width * 0.1,
      height * 0.6,
      0,
      height * 0.7,
    );

    bottomWavePath.close();
    canvas.drawPath(bottomWavePath, wavePaint2);

    // Add some highlights
    final Paint highlightPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..style = PaintingStyle.fill;

    final Path highlightPath = Path();
    highlightPath.moveTo(width * 0.5, height * 0.4);
    highlightPath.quadraticBezierTo(
      width * 0.6,
      height * 0.45,
      width * 0.7,
      height * 0.5,
    );
    highlightPath.quadraticBezierTo(
      width * 0.8,
      height * 0.55,
      width,
      height * 0.5,
    );
    highlightPath.lineTo(width, height * 0.45);
    highlightPath.quadraticBezierTo(
      width * 0.7,
      height * 0.4,
      width * 0.5,
      height * 0.4,
    );

    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Usage example:
// 1. Create a CustomPaint widget with this painter
// CustomPaint(
//   painter: BlueWavesGenerator(),
//   size: Size(width, height),
// )
//
// 2. Or use it to generate an image file (requires additional code)
