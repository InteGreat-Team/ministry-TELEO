import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../backend/models/CHURCH_SIGNUP_VAR.dart';
import '../widgets/index.dart';
import '../../3/login_screen.dart';

class DynamicWaveBackground extends StatefulWidget {
  final Widget child;

  const DynamicWaveBackground({super.key, required this.child});

  @override
  State<DynamicWaveBackground> createState() => _DynamicWaveBackgroundState();
}

class _DynamicWaveBackgroundState extends State<DynamicWaveBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF002642),
                  Color(0xFF0353A4),
                ],
              ),
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: WavePainter(_controller.value),
                  size: Size.infinite,
                );
              },
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;
  
  WavePainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // First wave with animation
    final waveShift = animationValue * size.width * 0.5;
    
    path.moveTo(0, size.height * 0.75);
    
    for (var i = 0.0; i <= size.width; i++) {
      path.lineTo(
        i, 
        size.height * 0.75 + 
        math.sin((i / size.width * 4 * math.pi) + waveShift) * 
        size.height * 0.05
      );
    }
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
    
    // Second wave with different phase
    final path2 = Path();
    paint.color = Colors.white.withOpacity(0.05);
    
    path2.moveTo(0, size.height * 0.8);
    
    for (var i = 0.0; i <= size.width; i++) {
      path2.lineTo(
        i, 
        size.height * 0.8 + 
        math.sin((i / size.width * 3 * math.pi) - waveShift) * 
        size.height * 0.04
      );
    }
    
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
    
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
    
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicWaveBackground(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeInAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "\"The closer we are to the shepherd, the safer we are from the wolves.\"",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.25),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
            const Spacer(flex: 1),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeInAnimation.value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF002642),
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.3),
                      ),
                      child: const Text(
                        'Go to Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
