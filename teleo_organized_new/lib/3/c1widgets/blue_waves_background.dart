import 'package:flutter/material.dart';
import 'dart:math' as math;

class BlueWavesBackground extends StatefulWidget {
  final Widget? child;
  
  const BlueWavesBackground({super.key, this.child});

  @override
  State<BlueWavesBackground> createState() => _BlueWavesBackgroundState();
}

class _BlueWavesBackgroundState extends State<BlueWavesBackground> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    
    // Create animation controller for subtle wave movement
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Base gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0077BE), // Light blue at top
                Color(0xFF005A9C), // Medium blue in middle
                Color(0xFF002642), // Dark blue at bottom
              ],
            ),
          ),
        ),
        
        // Animated waves
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return CustomPaint(
              painter: _WavesPainter(
                animation: _animationController.value,
              ),
              size: Size.infinite,
            );
          },
        ),
        
        // Child widget
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class _WavesPainter extends CustomPainter {
  final double animation;
  
  _WavesPainter({required this.animation});
  
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    
    // Top wave
    final Paint topWavePaint = Paint()
      ..color = const Color(0xFF0066A6)
      ..style = PaintingStyle.fill;
    
    final Path topWavePath = Path();
    topWavePath.moveTo(0, 0);
    topWavePath.lineTo(width, 0);
    topWavePath.lineTo(width, height * 0.3);
    
    // Create a curved bottom edge with subtle animation
    final double animOffset = math.sin(animation * math.pi) * 20;
    
    topWavePath.quadraticBezierTo(
      width * 0.7, height * 0.4 + animOffset, 
      width * 0.5, height * 0.35
    );
    topWavePath.quadraticBezierTo(
      width * 0.3, height * 0.3 - animOffset, 
      0, height * 0.4
    );
    
    topWavePath.close();
    canvas.drawPath(topWavePath, topWavePaint);
    
    // Bottom wave
    final Paint bottomWavePaint = Paint()
      ..color = const Color(0xFF004C7F)
      ..style = PaintingStyle.fill;
    
    final Path bottomWavePath = Path();
    bottomWavePath.moveTo(0, height);
    bottomWavePath.lineTo(width, height);
    bottomWavePath.lineTo(width, height * 0.7);
    
    // Create a curved top edge with subtle animation
    final double animOffset2 = math.cos(animation * math.pi) * 15;
    
    bottomWavePath.quadraticBezierTo(
      width * 0.8, height * 0.6 - animOffset2, 
      width * 0.6, height * 0.65
    );
    bottomWavePath.quadraticBezierTo(
      width * 0.4, height * 0.7 + animOffset2, 
      width * 0.2, height * 0.65
    );
    bottomWavePath.quadraticBezierTo(
      width * 0.1, height * 0.6 - animOffset2, 
      0, height * 0.7
    );
    
    bottomWavePath.close();
    canvas.drawPath(bottomWavePath, bottomWavePaint);
    
    // Add some highlights
    final Paint highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    
    final Path highlightPath = Path();
    highlightPath.moveTo(width * 0.5, height * 0.4);
    highlightPath.quadraticBezierTo(
      width * 0.6, height * 0.45 + animOffset, 
      width * 0.7, height * 0.5
    );
    highlightPath.quadraticBezierTo(
      width * 0.8, height * 0.55 - animOffset, 
      width, height * 0.5
    );
    highlightPath.lineTo(width, height * 0.45);
    highlightPath.quadraticBezierTo(
      width * 0.7, height * 0.4 + animOffset, 
      width * 0.5, height * 0.4
    );
    
    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant _WavesPainter oldDelegate) => 
      oldDelegate.animation != animation;
}