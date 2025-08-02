//IMPORT PACKAGE
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

//IMPORT MVVM UPDATED
import '../../../START/frontend/screens/SHARED_WELCOMESCREEN.dart' as main_welcome;
import '../../backend/viewmodels/USER_SIGNUPVIEWMODELS.dart';

// NOT MVVM UPDATED IMPORTS
import '../../../../3/c1widgets/animated_wave_background.dart'; // Corrected import
import '../../../../1/c1registrationflow/c1s2name_screen.dart';

// Assuming NameScreen is a placeholder for the next step in user signup
class NameScreen extends StatelessWidget {
  const NameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Name Screen'),
      ),
      body: const Center(
        child: Text('Enter your name'),
      ),
    );
  }
}

class WelcomeScreen extends StatefulWidget { // Keep as StatefulWidget to provide TickerProvider
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<UserSignupViewModel>(context, listen: false);
    viewModel.initAnimations(this); // Pass TickerProvider
    viewModel.setContext(context); // Pass context to ViewModel
  }

  @override
  void dispose() {
    Provider.of<UserSignupViewModel>(context, listen: false).dispose(); // Dispose ViewModel's resources
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
                onTap: () => viewModel.skipWelcome(context),
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
                          animation: viewModel.textAnimationController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: viewModel.fadeInAnimation.value,
                              child: Transform.scale(
                                scale: viewModel.scaleAnimation.value,
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
              onPressed: () => Provider.of<UserSignupViewModel>(context, listen: false).navigateBackToWelcome(context),
              tooltip: 'Back',
            ),
          ),
        ],
      ),
    );
  }
}
