import 'package:flutter/material.dart';
import '../../2/church_model.dart';
import '../../3/c1widgets/back_button.dart';
import 'c1s4church_established_screen.dart';

class ChurchNameScreen extends StatefulWidget {
  final ChurchModel church;
  final String? firstName;

  const ChurchNameScreen({
    super.key,
    required this.church,
    this.firstName,
  });

  @override
  State<ChurchNameScreen> createState() => _ChurchNameScreenState();
}

class _ChurchNameScreenState extends State<ChurchNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill if name exists
    if (widget.church.name.isNotEmpty) {
      _nameController.text = widget.church.name;
      _validateForm();
    }
    
    // Add listener to update form validity
    _nameController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _nameController.text.trim().isNotEmpty;
    });
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
                child: TeleoBackButton(),
              ),
              const SizedBox(height: 24),
              
              // Title
              const Center(
                child: Text(
                  "What's your church name?",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 48),
              
              // Church name input
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter church name',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF002642)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.red.shade300),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  if (_isFormValid) {
                    _navigateToNextScreen();
                  }
                },
              ),
              
              const Spacer(),
              
              // Next button
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isFormValid ? _navigateToNextScreen : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002642),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withAlpha(77),
                    ),
                    child: const Text(
                      'Next',
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

  void _navigateToNextScreen() {
    final updatedChurch = widget.church.copyWith(
      name: _nameController.text.trim(),
    );
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChurchEstablishedScreen(
          church: updatedChurch,
        ),
      ),
    );
  }
}