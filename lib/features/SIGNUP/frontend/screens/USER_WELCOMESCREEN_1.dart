//IMPORT PACKAGE
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//IMPORT MVVM UPDATED
import '../../backend/viewmodels/USER_SIGNUPVIEWMODELS.dart';

// NOT MVVM UPDATED IMPORTS
import '../../../../3/c1widgets/animated_wave_background.dart'; 
//import '../../../../1/c1registrationflow/c1s2name_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    // Get the ViewModel and initialize animations and context
    final viewModel = Provider.of<UserSignupViewModel>(context, listen: false);
    viewModel.initAnimations(this); // Pass TickerProvider
    viewModel.setContext(context); // Pass context to ViewModel
  }

  @override
  void dispose() {
    // Dispose the ViewModel's resources
    Provider.of<UserSignupViewModel>(context, listen: false).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content (tap to skip)
          Consumer<UserSignupViewModel>(
            builder: (context, viewModel, child) {
              return GestureDetector(
                onTap: () => viewModel.skipWelcome(context), // Delegate to ViewModel
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
                          animation: viewModel.textAnimationController, // Use ViewModel's controller
                          builder: (context, child) {
                            return Opacity(
                              opacity: viewModel.fadeInAnimation.value, // Use ViewModel's animation
                              child: Transform.scale(
                                scale: viewModel.scaleAnimation.value, // Use ViewModel's animation
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
                    ],
                  ),
                ),
              );
            },
          ),
          // Back button at top left (always on top)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () => Provider.of<UserSignupViewModel>(context, listen: false).navigateBackToWelcome(context), // Delegate to ViewModel
              tooltip: 'Back',
            ),
          ),
        ],
      ),
    );
  }
}
