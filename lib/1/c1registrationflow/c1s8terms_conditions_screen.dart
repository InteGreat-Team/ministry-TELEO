import 'package:flutter/material.dart';
import '../../3/c1widgets/back_button.dart'; // Import the back button
import 'c1s9verification_code_screen.dart';

class TermsConditionsScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final DateTime birthday;
  final String gender;
  final String username;
  final String email;
  final String? phoneNumber;
  final String? password;
  final String address;
  final double lat;
  final double lng;
  final bool isViewOnly;
  final String sentCode;

  const TermsConditionsScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.username,
    required this.email,
    this.phoneNumber,
    this.password,
    required this.address,
    required this.lat,
    required this.lng,
    required this.isViewOnly,
    required this.sentCode,
  });

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hasReachedEnd = false;
  bool _titleVisible = false; // For fade-in animation of the title
  bool _descriptionVisible = false; // For fade-in animation of the description

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    // Trigger fade-in animation for title immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _titleVisible = true;
      });
      // Trigger fade-in animation for description after a short delay
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _descriptionVisible = true;
          });
        }
      });
    });
  }

  void _scrollListener() {
    // Check if the user has scrolled to the very end of the content
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (!_hasReachedEnd) {
        setState(() {
          _hasReachedEnd = true;
        });
      }
    } else {
      // If scrolled away from the end, reset _hasReachedEnd
      if (_hasReachedEnd) {
        setState(() {
          _hasReachedEnd = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
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
            // Back button at absolute top-left corner, consistent with previous screens
            const Positioned(
              top: 8.0,
              left: 8.0,
              child: TeleoBackButton(),
            ),
            
            // Main content area
            if (isWeb)
              Center(
                child: SizedBox(
                  width: 400, // Constrain width for web
                  child: _buildContent(isWeb),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildContent(isWeb),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(bool isWeb) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // Centered for title and button
      mainAxisAlignment: isWeb ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        SizedBox(height: isWeb ? 20 : 60), // Adjust spacing based on web/mobile
        
        // Terms and Conditions Title with Fade-in Animation
        AnimatedOpacity(
          opacity: _titleVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500), // Fade-in duration
          child: Text(
            "Terms and Conditions",
            style: TextStyle(
              fontSize: isWeb ? 32.0 : 28.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center, // Ensure text is centered
          ),
        ),
        SizedBox(height: isWeb ? 24 : 24),
        
        // Scrollable Description with Fade-in Animation
        Expanded(
          child: AnimatedOpacity(
            opacity: _descriptionVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500), // Fade-in duration
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Description remains left-aligned
                children: [
                  // Clarification for testing app - now part of the scrollable content
                  Text(
                    "Please note: This is a testing application. The terms and conditions provided below are for demonstration purposes only and are currently under development. They do not represent a legally binding agreement.",
                    style: TextStyle(
                      fontSize: isWeb ? 16.0 : 14.0,
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isWeb ? 24 : 16),

                  Text(
                    "1. Acceptance of Terms",
                    style: TextStyle(fontSize: isWeb ? 20.0 : 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: isWeb ? 12 : 8),
                  Text(
                    "By accessing and using this application, you acknowledge that this is a test environment. Your use of this application is solely for testing and evaluation purposes. Any data entered may be reset or deleted without prior notice. We reserve the right to modify or discontinue this testing application at any time without liability. This section outlines the user's agreement to the terms of service, emphasizing that continued use implies acceptance of any updates or changes. It also covers the legal framework governing the use of the application, including disclaimers and limitations of liability.",
                    style: TextStyle(fontSize: isWeb ? 16.0 : 16.0),
                  ),
                  SizedBox(height: isWeb ? 24 : 16),

                  Text(
                    "2. User Responsibilities",
                    style: TextStyle(fontSize: isWeb ? 20.0 : 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: isWeb ? 12 : 8),
                  Text(
                    "Users are responsible for their actions within this testing application. Do not enter any sensitive or personal information that you are not comfortable sharing in a test environment. Any feedback provided will be used to improve the application. This section details the user's obligations, such as maintaining account security, refraining from prohibited activities, and adhering to community guidelines. It also clarifies the responsibilities regarding content uploaded or shared by the user.",
                    style: TextStyle(fontSize: isWeb ? 16.0 : 16.0),
                  ),
                  SizedBox(height: isWeb ? 24 : 16),

                  Text(
                    "3. Disclaimer of Warranties",
                    style: TextStyle(fontSize: isWeb ? 20.0 : 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: isWeb ? 12 : 8),
                  Text(
                    "This testing application is provided 'as is' without any warranties, express or implied. We do not guarantee the accuracy, completeness, or reliability of any content or functionality within the application. Your use of the application is at your sole risk. This section explicitly states that the application is provided without guarantees of any kind, protecting the service provider from claims related to performance, accuracy, or availability. It emphasizes that users assume all risks associated with using the application.",
                    style: TextStyle(fontSize: isWeb ? 16.0 : 16.0),
                  ),
                  SizedBox(height: isWeb ? 24 : 16),

                  Text(
                    "4. Limitation of Liability",
                    style: TextStyle(fontSize: isWeb ? 20.0 : 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: isWeb ? 12 : 8),
                  Text(
                    "In no event shall we be liable for any damages arising out of or in connection with the use or inability to use this testing application, including but not limited to direct, indirect, incidental, consequential, or punitive damages. This section sets limits on the service provider's financial and legal responsibility for any damages or losses incurred by users, even if the damages are a result of negligence or a defect in the application.",
                    style: TextStyle(fontSize: isWeb ? 16.0 : 16.0),
                  ),
                  SizedBox(height: isWeb ? 24 : 16),

                  Text(
                    "5. Changes to Terms",
                    style: TextStyle(fontSize: isWeb ? 20.0 : 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: isWeb ? 12 : 8),
                  Text(
                    "We reserve the right to update or modify these terms and conditions at any time without prior notice. Your continued use of the testing application after any such changes constitutes your acceptance of the new terms. This section informs users that the terms of service may be updated periodically and that their continued use of the application after such updates signifies their agreement to the revised terms. It also outlines the process for notifying users of significant changes.",
                    style: TextStyle(fontSize: isWeb ? 16.0 : 16.0),
                  ),
                  SizedBox(height: isWeb ? 60 : 80), // Increased gap before the button
                ],
              ),
            ),
          ),
        ),
        
        // "I Accept" Button
        if (!widget.isViewOnly) // Only show if not in view-only mode
          Padding(
            padding: EdgeInsets.only(bottom: isWeb ? 20.0 : 40.0), // Consistent padding
            child: SizedBox(
              width: double.infinity,
              height: isWeb ? 60.0 : 56.0, // Consistent height
              child: ElevatedButton(
                onPressed: _hasReachedEnd // Only enabled when scrolled to end
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerificationCodeScreen(
                              firstName: widget.firstName,
                              lastName: widget.lastName,
                              birthday: widget.birthday,
                              gender: widget.gender,
                              username: widget.username,
                              email: widget.email,
                              phoneNumber: widget.phoneNumber,
                              password: widget.password!,
                              address: widget.address,
                              lat: widget.lat,
                              lng: widget.lng,
                              sentCode: widget.sentCode,
                              hasAcceptedTerms: true,
                            ),
                          ),
                        );
                      }
                    : null, // Disabled if not scrolled to end
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF002540), // Consistent color
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300, // Greyed out when disabled
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Consistent border radius
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  'I Accept',
                  style: TextStyle(
                    fontSize: isWeb ? 18.0 : 16.0, // Consistent font size
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        // If in view-only mode, and scrolled to end, show a 'Done' button
        if (widget.isViewOnly && _hasReachedEnd)
          Padding(
            padding: EdgeInsets.only(bottom: isWeb ? 20.0 : 40.0),
            child: SizedBox(
              width: double.infinity,
              height: isWeb ? 60.0 : 56.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true); // Pop with true to indicate acceptance
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF002540),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  'Done',
                  style: TextStyle(
                    fontSize: isWeb ? 18.0 : 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}