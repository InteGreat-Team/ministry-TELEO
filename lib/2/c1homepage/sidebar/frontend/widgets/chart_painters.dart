// lib/sidebar/frontend/widgets/chart_painters.dart

import 'package:flutter/material.dart';
import 'dart:math';

class LineChartPainter extends CustomPainter {
  final List<double> data;
  final double maxValue;
  final Color lineColor;
  final Color gradientStartColor;
  final Color gradientEndColor;
  final Color dotColor;
  final double strokeWidth;
  final double dotRadius;

  LineChartPainter({
    required this.data,
    required this.maxValue,
    this.lineColor = Colors.red,
    this.gradientStartColor = Colors.blue,
    this.gradientEndColor = Colors.transparent,
    this.dotColor = Colors.blue,
    this.strokeWidth = 2.0,
    this.dotRadius = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..style = PaintingStyle.fill;

    final dotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    final path = Path();
    final points = <Offset>[];

    final double stepX = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - (data[i] / maxValue) * size.height;
      points.add(Offset(x, y));
    }

    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    // Draw the line
    canvas.drawPath(path, paint);

    // Draw the gradient fill
    if (points.isNotEmpty) {
      final fillPath = Path.from(path);
      fillPath.lineTo(points.last.dx, size.height);
      fillPath.lineTo(points.first.dx, size.height);
      fillPath.close();

      fillPaint.shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [gradientStartColor.withOpacity(0.3), gradientEndColor.withOpacity(0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      canvas.drawPath(fillPath, fillPaint);
    }

    // Draw dots
    for (final point in points) {
      canvas.drawCircle(point, dotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is LineChartPainter) {
      return oldDelegate.data != data ||
             oldDelegate.maxValue != maxValue ||
             oldDelegate.lineColor != lineColor ||
             oldDelegate.gradientStartColor != gradientStartColor ||
             oldDelegate.gradientEndColor != gradientEndColor ||
             oldDelegate.dotColor != dotColor ||
             oldDelegate.strokeWidth != strokeWidth ||
             oldDelegate.dotRadius != dotRadius;
    }
    return true;
  }
}

class BarChartPainter extends CustomPainter {
  final List<double> data;
  final double maxValue;
  final Color barColor;
  final double barWidth;
  final double spacing;

  BarChartPainter({
    required this.data,
    required this.maxValue,
    this.barColor = Colors.green,
    this.barWidth = 20.0,
    this.spacing = 10.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = barColor
      ..style = PaintingStyle.fill;

    double currentX = spacing;
    for (final value in data) {
      final barHeight = (value / maxValue) * size.height;
      final rect = Rect.fromLTWH(
        currentX,
        size.height - barHeight,
        barWidth,
        barHeight,
      );
      canvas.drawRect(rect, paint);
      currentX += barWidth + spacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is BarChartPainter) {
      return oldDelegate.data != data ||
             oldDelegate.maxValue != maxValue ||
             oldDelegate.barColor != barColor ||
             oldDelegate.barWidth != barWidth ||
             oldDelegate.spacing != spacing;
    }
    return true;
  }
}

class PieChartPainter extends CustomPainter {
  final List<double> data;
  final List<Color> colors;
  final double strokeWidth;

  PieChartPainter({
    required this.data,
    required this.colors,
    this.strokeWidth = 20.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || colors.isEmpty) return;

    final total = data.fold(0.0, (sum, item) => sum + item);
    double startAngle = -pi / 2; // Start from the top

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - strokeWidth / 2;

    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i] / total) * 2 * pi;
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is PieChartPainter) {
      return oldDelegate.data != data ||
             oldDelegate.colors != colors ||
             oldDelegate.strokeWidth != strokeWidth;
    }
    return true;
  }
}
