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
  final String phone;
  final String? password;
  final String location;
  final bool isViewOnly;

  const TermsConditionsScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.username,
    required this.email,
    required this.phone,
    this.password,
    required this.location,
    required this.isViewOnly,
  });

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hasReachedEnd = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _hasReachedEnd = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TeleoBackButton(
                  onPressed: () {
                    // Return true if user has read to the end
                    Navigator.pop(context, _hasReachedEnd);
                  },
                ),
              ),
              const SizedBox(height: 40),
              
              const Text(
                "Terms and Conditions",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              
              // Terms and conditions content
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "1. Acceptance of Terms",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "By accessing and using this application, you accept and agree to be bound by the terms and provision of this agreement. In addition, when using this application's particular services, you shall be subject to any posted guidelines or rules applicable to such services.",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      
                      Text(
                        "2. User Account",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "To use certain features of the application, you must register for an account. You must provide accurate and complete information and keep your account information updated. You are responsible for maintaining the confidentiality of your account and password.",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      
                      Text(
                        "3. Privacy Policy",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Your privacy is important to us. Our Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our application. By using our application, you agree to the collection and use of information in accordance with our Privacy Policy.",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      
                      Text(
                        "4. User Content",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "You are solely responsible for the content that you upload, post, email, transmit or otherwise make available via the application. You agree not to post content that is illegal, obscene, threatening, defamatory, invasive of privacy, infringing of intellectual property rights, or otherwise injurious to third parties.",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      
                      Text(
                        "5. Limitation of Liability",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "In no event shall we be liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from your access to or use of or inability to access or use the application.",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      
                      Text(
                        "6. Changes to Terms",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material we will provide at least 30 days' notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion.",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      
                      Text(
                        "7. Governing Law",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "These Terms shall be governed and construed in accordance with the laws, without regard to its conflict of law provisions.",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      
                      Text(
                        "8. Contact Us",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "If you have any questions about these Terms, please contact us.",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              
              // Accept button (only shown in non-view-only mode)
              if (!widget.isViewOnly)
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
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
                              phone: widget.phone,
                              password: widget.password!,
                              location: widget.location,
                            ),
                          ),
                        );
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
                      child: const Text(
                        'I Accept',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              
              // Done button (only shown in view-only mode when reached end)
              if (widget.isViewOnly && _hasReachedEnd)
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Return true to indicate user has read the terms
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
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
