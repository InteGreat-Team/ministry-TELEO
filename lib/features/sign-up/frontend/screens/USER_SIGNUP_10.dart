import 'package:flutter/material.dart';
import 'USER_SIGNUP_VERIFICATION.dart'; // Updated import for the new verification screen
import '../../backend/models/USER_SIGNUP_VAR.dart'; // Import for UserProfile
import '../widgets/index.dart'; // Corrected import for TeleoBackButton and CustomElevatedButton

class TermsConditionsScreen extends StatefulWidget {
  final UserProfile userProfile;
  final String email;
  final String phone;
  final String? password;
  final String? sentCode; // The code sent for verification
  final bool isViewOnly;

  const TermsConditionsScreen({
    super.key,
    required this.userProfile,
    required this.email,
    required this.phone,
    this.password,
    this.sentCode,
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
                  child: CustomElevatedButton(
                    text: 'I Accept',
                    onPressed: () {
                      final updatedUserProfile = UserProfile(
                        firstName: widget.userProfile.firstName,
                        lastName: widget.userProfile.lastName,
                        birthday: widget.userProfile.birthday,
                        gender: widget.userProfile.gender,
                        username: widget.userProfile.username,
                        address: widget.userProfile.address,
                        location: widget.userProfile.location,
                        // Add email, phone, password to UserProfile if you want to persist them
                        // email: widget.email,
                        // phone: widget.phone,
                        // password: widget.password,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserSignupVerificationScreen( // Changed to new screen
                            userProfile: updatedUserProfile,
                            email: widget.email,
                            phone: widget.phone,
                            password: widget.password!,
                            sentCode: widget.sentCode,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              // Done button (only shown in view-only mode when reached end)
              if (widget.isViewOnly && _hasReachedEnd)
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: CustomElevatedButton(
                    text: 'Done',
                    onPressed: () {
                      // Return true to indicate user has read the terms
                      Navigator.pop(context, true);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
