import 'package:flutter/material.dart';
import 'dart:math' as math;

class DynamicWaveBackground extends StatefulWidget {
  final Widget child;
  
  const DynamicWaveBackground({
    super.key,
    required this.child,
  });

  @override
  State<DynamicWaveBackground> createState() => _DynamicWaveBackgroundState();
}

class _DynamicWaveBackgroundState extends State<DynamicWaveBackground> with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  
  @override
  void initState() {
    super.initState();
    
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
    
    _controller3 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
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
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0077BE), // Darker blue
                  Color(0xFF1E90FF), // Medium blue
                ],
              ),
            ),
          ),
          
          // First wave
          AnimatedBuilder(
            animation: _controller1,
            builder: (context, child) {
              return CustomPaint(
                painter: WavePainter(
                  animation: _controller1,
                  waveColor: const Color(0xFF002642).withOpacity(0.5),
                  waveHeight: 200,
                  frequency: 1.5,
                  phase: 0,
                ),
                child: Container(),
              );
            },
          ),
          
          // Second wave
          AnimatedBuilder(
            animation: _controller2,
            builder: (context, child) {
              return CustomPaint(
                painter: WavePainter(
                  animation: _controller2,
                  waveColor: const Color(0xFF004080).withOpacity(0.3),
                  waveHeight: 300,
                  frequency: 2.0,
                  phase: math.pi / 2,
                ),
                child: Container(),
              );
            },
          ),
          
          // Third wave
          AnimatedBuilder(
            animation: _controller3,
            builder: (context, child) {
              return CustomPaint(
                painter: WavePainter(
                  animation: _controller3,
                  waveColor: const Color(0xFF0077BE).withOpacity(0.2),
                  waveHeight: 250,
                  frequency: 1.0,
                  phase: math.pi,
                ),
                child: Container(),
              );
            },
          ),
          
          // Content
          SafeArea(child: widget.child),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final Animation<double> animation;
  final Color waveColor;
  final double waveHeight;
  final double frequency;
  final double phase;
  
  WavePainter({
    required this.animation,
    required this.waveColor,
    required this.waveHeight,
    required this.frequency,
    required this.phase,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill;
    
    final path = Path();
    
    // Start at the bottom left
    path.moveTo(0, size.height);
    
    // Draw the wave
    for (double x = 0; x < size.width; x++) {
      double y = math.sin((x / size.width * frequency * 2 * math.pi) + 
                          (animation.value * 2 * math.pi) + phase) * 
                 waveHeight + size.height / 2;
      path.lineTo(x, y);
    }
    
    // Complete the path
    path.lineTo(size.width, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}