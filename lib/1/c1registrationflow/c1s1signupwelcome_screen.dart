import 'package:flutter/material.dart';
import 'dart:async';
import 'c1s2name_screen.dart';
import '../../3/c1widgets/animated_wave_background.dart';
import '../../3/welcome_screen.dart' as main_welcome;

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _textAnimationController;
  late AnimationController _skipButtonController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _skipButtonAnimation;
  late Animation<Offset> _textSlideAnimation;
  Timer? _navigationTimer;
  bool _showSkipButton = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize main text animation controller
    _textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Initialize skip button animation controller with gentler timing
    _skipButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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

    // Create gentle slide animation
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Very gentle skip button fade animation
    _skipButtonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _skipButtonController,
        curve: Curves.easeOut,
      ),
    );

    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _textAnimationController.forward();
      }
    });

    // Show skip button after text animation completes
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          _showSkipButton = true;
        });
        _skipButtonController.forward();
      }
    });

    // NO AUTOMATIC NAVIGATION - User must tap to continue
  }

  void _navigateToNextScreen() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const NameScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          
          var tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _navigateBackToWelcome() {
    _navigationTimer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const main_welcome.WelcomeScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    _skipButtonController.dispose();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content (tap to skip)
          GestureDetector(
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
                  // Hello! text with BIGGER and BOLDER styling
                  Center(
                    child: AnimatedBuilder(
                      animation: _textAnimationController,
                      builder: (context, child) {
                        return SlideTransition(
                          position: _textSlideAnimation,
                          child: Opacity(
                            opacity: _fadeInAnimation.value,
                            child: Transform.scale(
                              scale: _scaleAnimation.value,
                              child: const Text(
                                'Hello!',
                                style: TextStyle(
                                  fontSize: 70, // Increased from 64
                                  fontWeight: FontWeight.w500, // Much bolder
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
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Gentle "tap to continue" indicator
                  if (_showSkipButton)
                    Positioned(
                      bottom: 80,
                      left: 0,
                      right: 0,
                      child: AnimatedBuilder(
                        animation: _skipButtonController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _skipButtonAnimation.value * 0.8,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.15),
                                    width: 0.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.touch_app_outlined,
                                      color: Colors.white.withOpacity(0.6),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Tap to continue',
                                      style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Back button with subtle styling
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
                  width: 0.5,
                ),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: _navigateBackToWelcome,
                tooltip: 'Back',
                splashRadius: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
