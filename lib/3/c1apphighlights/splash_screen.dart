import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'interest_selection_screen.dart';

class AppHighlightsSplashScreen extends StatefulWidget {
  const AppHighlightsSplashScreen({super.key});

  @override
  State<AppHighlightsSplashScreen> createState() => _AppHighlightsSplashScreenState();
}

class _AppHighlightsSplashScreenState extends State<AppHighlightsSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Set system UI overlay style to match the blue background
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    // Create fade-in animation
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    
    // Create scale animation
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    
    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _animationController.forward();
      }
    });
    
    // Navigate to next screen after animation completes
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // Use a simple navigation approach
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const InterestSelectionScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E88E5), // Lighter blue at top
              Color(0xFF0D47A1), // Darker blue at bottom
            ],
          ),
        ),
        child: Stack(
          children: [
            // Cloud and mountain background
            Positioned.fill(
              child: Image.asset(
                'assets/images/blue_background.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.transparent,
                  );
                },
              ),
            ),
            
            // Logo centered
            Center(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeInAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/fish_logo.png',
                          width: 200,
                          height: 200,
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
    );
  }
}
