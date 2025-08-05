import 'package:flutter/material.dart';
import 'c1s5username_screen.dart';
import '../../3/c1widgets/back_button.dart';

class GenderScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final DateTime birthday;
    
  const GenderScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.birthday,
  });

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String? _selectedGender;

  void _navigateToNext() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => UsernameScreen(
          firstName: widget.firstName,
          lastName: widget.lastName,
          birthday: widget.birthday,
          gender: _selectedGender!,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          
          var tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          
          // Add fade transition for smoother effect
          var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
              .animate(CurvedAnimation(parent: animation, curve: curve));
          
          return FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(position: offsetAnimation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWeb = size.width > 600;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Back button at absolute top-left corner (unchanged)
            const Positioned(
              top: 8.0,
              left: 8.0,
              child: TeleoBackButton(),
            ),
            
            // Main content - positioned similar to birthday screen height
            if (isWeb)
              Center(
                child: SizedBox(
                  width: 400,
                  child: _buildForm(isWeb),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildForm(isWeb),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(bool isWeb) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: isWeb ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        SizedBox(height: isWeb ? 20 : 60), // Same height as birthday screen
        
        // Title with better spacing
        Text(
          "How do you identify as?",
          style: TextStyle(
            fontSize: isWeb ? 40.0 : 32.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            height: 1.1,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isWeb ? 16 : 12),
        
        // Subtitle
        Text(
          "We want to be respectful!",
          style: TextStyle(
            fontSize: isWeb ? 22.0 : 18.0,
            color: Colors.black54,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isWeb ? 60 : 50),
        
        // Gender selection options - more aesthetic spacing
        _buildGenderOptions(isWeb),
        
        SizedBox(height: isWeb ? 48 : 80), // Same spacing as birthday screen
        
        // Next button - exact measurements and placement from birthday screen
        Padding(
          padding: EdgeInsets.only(bottom: isWeb ? 20.0 : 40.0),
          child: SizedBox(
            width: double.infinity,
            height: isWeb ? 60.0 : 56.0, // Same height as birthday screen
            child: ElevatedButton(
              onPressed: _selectedGender != null ? _navigateToNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF002642), // Same color as birthday screen
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Same border radius as birthday screen
                ),
                elevation: 0, // Same elevation as birthday screen
                shadowColor: Colors.transparent,
              ),
              child: Text(
                'Next',
                style: TextStyle(
                  fontSize: isWeb ? 18.0 : 16.0, // Same font size as birthday screen
                  fontWeight: FontWeight.w600, // Same font weight as birthday screen
                ),
              ),
            ),
          ),
        ),
        
        if (isWeb) const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildGenderOptions(bool isWeb) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildGenderOption('Male', 'Male', Icons.male, isWeb),
        _buildGenderOption('Female', 'Female', Icons.female, isWeb),
        _buildGenderOption('Non_binary', 'Non-binary', Icons.person, isWeb),
      ],
    );
  }
    
  Widget _buildGenderOption(String value, String label, IconData icon, bool isWeb) {
    final isSelected = _selectedGender == value;
    final size = isWeb ? 85.0 : 75.0;
    final iconSize = isWeb ? 38.0 : 34.0;
        
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: isSelected 
                ? const Color(0xFF002642) 
                : Colors.grey.shade300, // Much lighter when not selected
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isSelected ? 0.12 : 0.06),
                  blurRadius: isSelected ? 8 : 4,
                  offset: Offset(0, isSelected ? 3 : 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey.shade600,
              size: iconSize,
            ),
          ),
          const SizedBox(height: 12),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              color: isSelected ? const Color(0xFF002642) : Colors.grey.shade500,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: isWeb ? 15.0 : 14.0,
              letterSpacing: 0.2,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}
