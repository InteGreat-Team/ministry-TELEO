import 'package:flutter/material.dart';
import 'dart:async';
import 'c1s2name_screen.dart';
import '../../3/c1widgets/animated_wave_background.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _textAnimationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;
  Timer? _navigationTimer;
  bool _showSkipButton = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for text
    _textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Create fade-in animation
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Create scale animation
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _textAnimationController.forward();
    });

    // Show skip button after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showSkipButton = true;
        });
      }
    });

    // Set timer to navigate to next screen after 3 seconds
    _navigationTimer = Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        _navigateToNextScreen();
      }
    });
  }

  void _navigateToNextScreen() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => const NameScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _navigationTimer?.cancel();
          _navigateToNextScreen();
        },
        child: AnimatedWaveBackground(
          backgroundColor: const Color(0xFF0077BE),
          waveColors: const [
            Color(0xFF0066A6),
            Color(0xFF004C7F),
            Color(0xFF003A61),
          ],
          child: Stack(
            children: [
              // Hello! text with animation
              Center(
                child: AnimatedBuilder(
                  animation: _textAnimationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeInAnimation.value,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: const Text(
                          'Hello!',
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black26,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Skip button with fade-in animation
              if (_showSkipButton)
                AnimatedOpacity(
                  opacity: _showSkipButton ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Positioned(
                    bottom: 40,
                    right: 24,
                    child: TextButton(
                      onPressed: () {
                        _navigationTimer?.cancel();
                        _navigateToNextScreen();
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
