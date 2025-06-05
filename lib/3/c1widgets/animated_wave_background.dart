import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedWaveBackground extends StatefulWidget {
  final Widget? child;
  final Color backgroundColor;
  final List<Color> waveColors;
  
  const AnimatedWaveBackground({
    super.key, 
    this.child,
    this.backgroundColor = const Color(0xFF0077BE),
    this.waveColors = const [
      Color(0xFF0066A6),
      Color(0xFF004C7F),
      Color(0xFF003A61),
    ],
  });

  @override
  State<AnimatedWaveBackground> createState() => _AnimatedWaveBackgroundState();
}

class _AnimatedWaveBackgroundState extends State<AnimatedWaveBackground> with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  
  @override
  void initState() {
    super.initState();
    
    // Create multiple animation controllers with different durations for varied wave movement
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    
    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
    
    _controller3 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }
  
  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                widget.backgroundColor,
                const Color(0xFF002642),
              ],
            ),
          ),
        ),
        
        // Multiple animated wave layers
        AnimatedBuilder(
          animation: Listenable.merge([_controller1, _controller2, _controller3]),
          builder: (context, child) {
            return CustomPaint(
              painter: WavePainter(
                waveColors: widget.waveColors,
                animationValue1: _controller1.value,
                animationValue2: _controller2.value,
                animationValue3: _controller3.value,
              ),
              size: Size.infinite,
            );
          },
        ),
        
        // Child widget (Hello! text)
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class WavePainter extends CustomPainter {
  final List<Color> waveColors;
  final double animationValue1;
  final double animationValue2;
  final double animationValue3;
  
  WavePainter({
    required this.waveColors,
    required this.animationValue1,
    required this.animationValue2,
    required this.animationValue3,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    
    // Draw multiple wave layers with different colors, amplitudes, and phases
    _drawWave(
      canvas: canvas,
      size: size,
      color: waveColors[0],
      amplitude: height * 0.05,
      frequency: 0.5,
      phase: animationValue1 * 2 * math.pi,
      yOffset: height * 0.3,
    );
    
    _drawWave(
      canvas: canvas,
      size: size,
      color: waveColors[1],
      amplitude: height * 0.06,
      frequency: 0.7,
      phase: animationValue2 * 2 * math.pi,
      yOffset: height * 0.5,
    );
    
    _drawWave(
      canvas: canvas,
      size: size,
      color: waveColors[2],
      amplitude: height * 0.07,
      frequency: 0.6,
      phase: animationValue3 * 2 * math.pi,
      yOffset: height * 0.7,
    );
    
    // Draw additional curved shapes for the top and bottom
    _drawTopCurve(canvas, size);
    _drawBottomCurve(canvas, size);
  }
  
  void _drawWave({
    required Canvas canvas,
    required Size size,
    required Color color,
    required double amplitude,
    required double frequency,
    required double phase,
    required double yOffset,
  }) {
    final width = size.width;
    final height = size.height;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final path = Path();
    path.moveTo(0, yOffset);
    
    // Create wave pattern using sine function
    for (double x = 0; x <= width; x++) {
      final y = yOffset + amplitude * math.sin((x * frequency / width) * 2 * math.pi + phase);
      path.lineTo(x, y);
    }
    
    // Complete the path
    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();
    
    canvas.drawPath(path, paint);
  }
  
  void _drawTopCurve(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final paint = Paint()
      ..color = waveColors[0].withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(width, 0);
    path.lineTo(width, height * 0.25);
    
    // Create a curved bottom edge with animation
    final controlPoint1 = Offset(
      width * 0.7,
      height * 0.3 + 10 * math.sin(animationValue1 * math.pi),
    );
    final controlPoint2 = Offset(
      width * 0.3,
      height * 0.2 + 10 * math.sin(animationValue2 * math.pi),
    );
    
    path.quadraticBezierTo(
      controlPoint1.dx, controlPoint1.dy,
      width * 0.5, height * 0.25,
    );
    
    path.quadraticBezierTo(
      controlPoint2.dx, controlPoint2.dy,
      0, height * 0.3,
    );
    
    path.close();
    canvas.drawPath(path, paint);
  }
  
  void _drawBottomCurve(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final paint = Paint()
      ..color = waveColors[2].withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    final path = Path();
    path.moveTo(0, height);
    path.lineTo(width, height);
    path.lineTo(width, height * 0.75);
    
    // Create a curved top edge with animation
    final controlPoint1 = Offset(
      width * 0.8,
      height * 0.7 + 10 * math.sin(animationValue3 * math.pi),
    );
    final controlPoint2 = Offset(
      width * 0.2,
      height * 0.8 + 10 * math.sin(animationValue1 * math.pi),
    );
    
    path.quadraticBezierTo(
      controlPoint1.dx, controlPoint1.dy,
      width * 0.6, height * 0.8,
    );
    
    path.quadraticBezierTo(
      controlPoint2.dx, controlPoint2.dy,
      0, height * 0.75,
    );
    
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) =>
      oldDelegate.animationValue1 != animationValue1 ||
      oldDelegate.animationValue2 != animationValue2 ||
      oldDelegate.animationValue3 != animationValue3;
}