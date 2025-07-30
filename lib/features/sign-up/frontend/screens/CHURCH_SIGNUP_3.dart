import 'package:flutter/material.dart';
import '../../backend/models/CHURCH_SIGNUP_VAR.dart'; // For ChurchModel
import '../widgets/index.dart'; // For TeleoBackButton, CustomElevatedButton, CustomTextFormField
import 'CHURCH_SIGNUP_4.dart'; // For next screen

class ChurchNameScreen extends StatefulWidget {
  final ChurchModel church;

  const ChurchNameScreen({
    super.key,
    required this.church,
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
    if (widget.church.churchName != null && widget.church.churchName!.isNotEmpty) {
      _nameController.text = widget.church.churchName!;
      _validateForm();
    }
    
    // Add listener to update form validity
    _nameController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameController.removeListener(_validateForm); // Remove listener
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
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: TeleoBackButton(),
              ),
              const SizedBox(height: 24),
              
              // Title
              const CustomHeader(
                title: "What's your church name?",
                icon: Icons.church, // Optional icon
                iconColor: Colors.black, // Adjust color if needed
              ),
              const SizedBox(height: 48),
              
              // Church name input
              CustomTextFormField(
                controller: _nameController,
                labelText: 'Church Name',
                hintText: 'Enter church name',
                icon: Icons.church,
                validator: (value) => FormValidation.validateRequired(value, 'church name'),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
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
                child: CustomElevatedButton(
                  onPressed: _isFormValid ? _navigateToNextScreen : null,
                  text: 'Next',
                  backgroundColor: const Color(0xFF002642),
                  foregroundColor: Colors.white,
                  height: 56,
                  width: double.infinity,
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
      churchName: _nameController.text.trim(),
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
