import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdminNotificationSettingsView extends StatefulWidget {
  final VoidCallback onBack;

  const AdminNotificationSettingsView({super.key, required this.onBack});

  @override
  State<AdminNotificationSettingsView> createState() =>
      _AdminNotificationSettingsViewState();
}

class _AdminNotificationSettingsViewState
    extends State<AdminNotificationSettingsView>
    with TickerProviderStateMixin {
  bool _pushNotificationsEnabled = true;
  bool _emailNotificationsEnabled = true;

  late AnimationController _pushAnimationController;
  late AnimationController _emailAnimationController;
  late Animation<double> _pushAnimation;
  late Animation<double> _emailAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _pushAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _emailAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Create animations
    _pushAnimation = CurvedAnimation(
      parent: _pushAnimationController,
      curve: Curves.easeInOut,
    );
    _emailAnimation = CurvedAnimation(
      parent: _emailAnimationController,
      curve: Curves.easeInOut,
    );

    // Set initial states
    if (_pushNotificationsEnabled) _pushAnimationController.value = 1.0;
    if (_emailNotificationsEnabled) _emailAnimationController.value = 1.0;
  }

  @override
  void dispose() {
    _pushAnimationController.dispose();
    _emailAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: widget.onBack,
                  ),
                  const Expanded(
                    child: Text(
                      'Notification Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Empty SizedBox to balance the row
                  const SizedBox(width: 48),
                ],
              ),
            ),

            const Divider(),

            // Notification toggles
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Push Notifications toggle
                  _buildAnimatedNotificationToggle(
                    title: 'Push Notifications',
                    subtitle: 'Receive push notifications',
                    value: _pushNotificationsEnabled,
                    animation: _pushAnimation,
                    onChanged: (value) {
                      setState(() {
                        _pushNotificationsEnabled = value;
                      });
                      if (value) {
                        _pushAnimationController.forward();
                      } else {
                        _pushAnimationController.reverse();
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  // Email Notifications toggle
                  _buildAnimatedNotificationToggle(
                    title: 'Email Notifications',
                    subtitle: 'Receive email notifications',
                    value: _emailNotificationsEnabled,
                    animation: _emailAnimation,
                    onChanged: (value) {
                      setState(() {
                        _emailNotificationsEnabled = value;
                      });
                      if (value) {
                        _emailAnimationController.forward();
                      } else {
                        _emailAnimationController.reverse();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedNotificationToggle({
    required String title,
    required String subtitle,
    required bool value,
    required Animation<double> animation,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title and subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),

        // Custom animated toggle switch
        GestureDetector(
          onTap: () => onChanged(!value),
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Container(
                width: 60,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Color.lerp(
                    const Color(0xFFE0E0E0), // Gray when off
                    const Color(0xFF4CD964), // Green when on
                    animation.value,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Background track with subtle gradient
                    Container(
                      width: 60,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            Color.lerp(
                              const Color(0xFFD0D0D0),
                              const Color(0xFF45C85A),
                              animation.value,
                            )!,
                            Color.lerp(
                              const Color(0xFFE8E8E8),
                              const Color(0xFF52D966),
                              animation.value,
                            )!,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    // Animated thumb
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      left: value ? 30 : 2,
                      top: 2,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 150),
                          scale: value ? 1.0 : 0.9,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: RadialGradient(
                                colors: [
                                  Colors.white,
                                  Colors.grey.withOpacity(0.1),
                                ],
                              ),
                            ),
                            child: Icon(
                              value ? Icons.check : Icons.close,
                              size: 16,
                              color: Color.lerp(
                                const Color(0xFFFF4444), // Red when off
                                const Color(0xFF4CD964), // Green when on
                                animation.value,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Ripple effect overlay
                    AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color:
                                  value
                                      ? Colors.green.withOpacity(
                                        0.1 * animation.value,
                                      )
                                      : Colors.red.withOpacity(
                                        0.1 * (1 - animation.value),
                                      ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
