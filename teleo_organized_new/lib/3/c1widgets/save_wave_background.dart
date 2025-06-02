import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math; // Add this import for math functions

/// This utility function can be used to save the wave background as an image file
/// Note: This is for development purposes only and should be removed in production
Future<void> saveWaveBackgroundAsImage(BuildContext context) async {
  final size = MediaQuery.of(context).size;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  // Draw the background
  final backgroundPaint =
      Paint()
        ..shader = ui.Gradient.linear(
          const Offset(0, 0),
          Offset(0, size.height),
          [
            const Color(0xFF0077BE), // Light blue at top
            const Color(0xFF002642), // Dark blue at bottom
          ],
        );

  canvas.drawRect(
    Rect.fromLTWH(0, 0, size.width, size.height),
    backgroundPaint,
  );

  // Draw top wave
  final topWavePaint =
      Paint()
        ..color = const Color(0xFF0066A6)
        ..style = PaintingStyle.fill;

  final topWavePath = Path();
  topWavePath.moveTo(0, 0);
  topWavePath.lineTo(size.width, 0);
  topWavePath.lineTo(size.width, size.height * 0.25);

  topWavePath.quadraticBezierTo(
    size.width * 0.7,
    size.height * 0.3,
    size.width * 0.5,
    size.height * 0.25,
  );

  topWavePath.quadraticBezierTo(
    size.width * 0.3,
    size.height * 0.2,
    0,
    size.height * 0.3,
  );

  topWavePath.close();
  canvas.drawPath(topWavePath, topWavePaint);

  // Draw middle wave
  final middleWavePaint =
      Paint()
        ..color = const Color(0xFF004C7F)
        ..style = PaintingStyle.fill;

  final middleWavePath = Path();
  for (double x = 0; x <= size.width; x++) {
    final y =
        size.height * 0.5 +
        size.height * 0.05 * math.sin((x / size.width) * 2 * math.pi);

    if (x == 0) {
      middleWavePath.moveTo(x, y);
    } else {
      middleWavePath.lineTo(x, y);
    }
  }

  middleWavePath.lineTo(size.width, size.height);
  middleWavePath.lineTo(0, size.height);
  middleWavePath.close();

  canvas.drawPath(middleWavePath, middleWavePaint);

  // Draw bottom wave
  final bottomWavePaint =
      Paint()
        ..color = const Color(0xFF003A61)
        ..style = PaintingStyle.fill;

  final bottomWavePath = Path();
  bottomWavePath.moveTo(0, size.height);
  bottomWavePath.lineTo(size.width, size.height);
  bottomWavePath.lineTo(size.width, size.height * 0.75);

  bottomWavePath.quadraticBezierTo(
    size.width * 0.8,
    size.height * 0.7,
    size.width * 0.6,
    size.height * 0.8,
  );

  bottomWavePath.quadraticBezierTo(
    size.width * 0.2,
    size.height * 0.8,
    0,
    size.height * 0.75,
  );

  bottomWavePath.close();
  canvas.drawPath(bottomWavePath, bottomWavePaint);

  // Convert to image
  final picture = recorder.endRecording();
  final img = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  final pngBytes = byteData!.buffer.asUint8List();

  // Save to file (this part would need platform-specific code)
  // For example, using path_provider package:
  // final directory = await getApplicationDocumentsDirectory();
  // final file = File('${directory.path}/wave_background.png');
  // await file.writeAsBytes(pngBytes);

  // For now, just print the byte length
  print('Generated PNG image: ${pngBytes.length} bytes');
}
