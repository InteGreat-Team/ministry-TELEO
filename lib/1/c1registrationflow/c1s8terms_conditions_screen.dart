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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TeleoBackButton(
                  onPressed: () {
                    Navigator.pop(context, _hasReachedEnd);
                  },
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Terms and Conditions",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "1. Acceptance of Terms",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "By accessing and using this application...",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
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
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF002642),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('I Accept', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              if (widget.isViewOnly && _hasReachedEnd)
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
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
                      ),
                      child: const Text('Done', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
