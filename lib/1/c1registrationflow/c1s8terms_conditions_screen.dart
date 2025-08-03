import 'package:flutter/material.dart';
import '../../3/c1widgets/back_button.dart';
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
  double _titleOpacity = 0.0;
  double _descriptionOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    // Check if already at the end on initial load (e.g., for very short content)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.position.maxScrollExtent == 0) {
        setState(() {
          _hasReachedEnd = true;
        });
      }
      // Start fade-in animations
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          _titleOpacity = 1.0;
        });
      });
      Future.delayed(const Duration(milliseconds: 400), () {
        setState(() {
          _descriptionOpacity = 1.0;
        });
      });
    });
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _hasReachedEnd = true;
      });
    } else {
      // Optional: if you want the button to become disabled again if they scroll up
      // setState(() {
      //   _hasReachedEnd = false;
      // });
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button at the top
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 8.0),
              child: TeleoBackButton(
                onPressed: () {
                  Navigator.pop(context, _hasReachedEnd);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  AnimatedOpacity(
                    opacity: _titleOpacity,
                    duration: const Duration(milliseconds: 500),
                    child: const Text(
                      "Terms and Conditions",
                      style: TextStyle(
                        fontSize: 30, // Slightly reduced for better fit
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Adjusted spacing
                  AnimatedOpacity(
                    opacity: _descriptionOpacity,
                    duration: const Duration(milliseconds: 500),
                    child: const Text(
                      "Please read our terms to understand your rights and responsibilities.",
                      style: TextStyle(
                        fontSize: 15, // Slightly reduced for better fit
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Adjusted spacing
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome to Teleo, a mobile application designed to connect and empower our church community. By accessing or using the Teleo application, you agree to be bound by these Terms and Conditions. Please read them carefully.",
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "1. Acceptance of Terms",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "By creating an account or using any feature of Teleo, you signify your agreement to these Terms and Conditions, our Privacy Policy, and all applicable laws and regulations. If you do not agree with any part of these terms, you must not use the application.",
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "2. User Conduct",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "You agree to use Teleo only for lawful purposes and in a way that does not infringe the rights of, restrict, or inhibit anyone else's use and enjoyment of the application. Prohibited behavior includes harassing or causing distress or inconvenience to any other user, transmitting obscene or offensive content, or disrupting the normal flow of dialogue within Teleo.",
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "3. Account Security",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "You are responsible for maintaining the confidentiality of your account login information and are fully responsible for all activities that occur under your account. You agree to immediately notify Teleo of any unauthorized use of your account or any other breach of security.",
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "4. Content and Intellectual Property",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "All content provided on Teleo, including text, graphics, logos, images, and software, is the property of Teleo or its content suppliers and protected by intellectual property laws. You may not reproduce, distribute, modify, or create derivative works of any content without explicit permission.",
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "5. Disclaimers and Limitation of Liability",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Teleo is provided on an 'as is' and 'as available' basis. We do not warrant that the application will be uninterrupted, error-free, or free of viruses or other harmful components. To the fullest extent permitted by law, Teleo disclaims all warranties, express or implied, and shall not be liable for any damages arising from your use of the application.",
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "6. Changes to Terms",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Teleo reserves the right to modify these Terms and Conditions at any time. Your continued use of the application after any such changes constitutes your acceptance of the new Terms and Conditions. It is your responsibility to review these terms periodically.",
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "7. Governing Law",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "These Terms and Conditions shall be governed by and construed in accordance with the laws of the Philippines, without regard to its conflict of law provisions.",
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 40), // Ensure enough space at the bottom for scrolling to trigger _hasReachedEnd
                  ],
                ),
              ),
            ),
            if (!widget.isViewOnly)
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0, left: 24.0, right: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _hasReachedEnd
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
                        : null, // Button is disabled if not scrolled to end
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _hasReachedEnd
                          ? const Color(0xFF002642) // Blue when enabled
                          : Colors.grey.shade400, // Grey when disabled
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.3),
                    ),
                    child: const Text(
                      'I Accept',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            if (widget.isViewOnly && _hasReachedEnd)
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0, left: 24.0, right: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002642),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.3),
                    ),
                    child: const Text('Done', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}