import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'c1s4gender_screen.dart';
import '../../3/c1widgets/back_button.dart';

class BirthdayScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
    
  const BirthdayScreen({
    super.key,
    required this.firstName,
    required this.lastName,
  });

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  DateTime _selectedDate = DateTime(2000, 1, 1);

  void _navigateToNext() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => GenderScreen(
          firstName: widget.firstName,
          lastName: widget.lastName,
          birthday: _selectedDate,
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
            // Back button at absolute top-left corner (same as name screen)
            const Positioned(
              top: 8.0,
              left: 8.0,
              child: TeleoBackButton(),
            ),
            
            // Main content - optimized layout
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
        SizedBox(height: isWeb ? 20 : 60),
        
        // Title
        Text(
          "When's your birthday?",
          style: TextStyle(
            fontSize: isWeb ? 40.0 : 32.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isWeb ? 20 : 16),
        
        // Subtitle
        Text(
          "We'd love to know!",
          style: TextStyle(
            fontSize: isWeb ? 22.0 : 20.0,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isWeb ? 48 : 40),
        
        // Clean Date picker without border, same background color
        SizedBox(
          height: isWeb ? 220 : 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: _selectedDate,
            minimumYear: 1900,
            maximumYear: DateTime.now().year,
            use24hFormat: true,
            showDayOfWeek: false,
            backgroundColor: Colors.white,
            onDateTimeChanged: (DateTime newDate) {
              // Optimized state update with minimal rebuilds
              if (_selectedDate != newDate) {
                setState(() {
                  _selectedDate = newDate;
                });
              }
            },
          ),
        ),
        
        SizedBox(height: isWeb ? 48 : 80),
        
        // Next button with animation
        Padding(
          padding: EdgeInsets.only(bottom: isWeb ? 20.0 : 40.0),
          child: SizedBox(
            width: double.infinity,
            height: isWeb ? 60.0 : 56.0,
            child: ElevatedButton(
              onPressed: _navigateToNext,
              style: _buttonStyle,
              child: Text(
                'Next',
                style: TextStyle(
                  fontSize: isWeb ? 18.0 : 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        
        if (isWeb) const SizedBox(height: 40),
      ],
    );
  }

  // Cached styles for better performance
  static final _buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF002642),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
    shadowColor: Colors.transparent,
  );
}
