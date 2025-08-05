import 'package:flutter/material.dart';
import 'c1s3birthday_screen.dart';
import '../../3/c1widgets/back_button.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  bool get _isFormValid =>
      _firstNameController.text.isNotEmpty &&
      _lastNameController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWeb = size.width > 600;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Back button at absolute top-left corner
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
        
        // Hello! title
        Text(
          'Hello!',
          style: TextStyle(
            fontSize: isWeb ? 56.0 : 48.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: isWeb ? 20 : 16),
        
        // What's your name? subtitle
        Text(
          "What's your name?",
          style: TextStyle(
            fontSize: isWeb ? 20.0 : 18.0,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        SizedBox(height: isWeb ? 48 : 40),
        
        // First Name field
        _buildTextField(
          controller: _firstNameController,
          hintText: 'First Name',
          isWeb: isWeb,
        ),
        SizedBox(height: isWeb ? 24 : 20),
        
        // Last Name field
        _buildTextField(
          controller: _lastNameController,
          hintText: 'Last Name',
          isWeb: isWeb,
        ),
        
        SizedBox(height: isWeb ? 48 : 80),
        
        // Next button
        Padding(
          padding: EdgeInsets.only(bottom: isWeb ? 20.0 : 40.0),
          child: SizedBox(
            width: double.infinity,
            height: isWeb ? 60.0 : 56.0,
            child: ElevatedButton(
              onPressed: _isFormValid
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BirthdayScreen(
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                          ),
                        ),
                      );
                    }
                  : null,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isWeb,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: _hintStyle,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isWeb ? 24.0 : 20.0,
          vertical: isWeb ? 20.0 : 18.0,
        ),
        filled: true,
        fillColor: _fillColor,
        border: _inputBorder,
        enabledBorder: _inputBorder,
        focusedBorder: _focusedBorder,
      ),
      style: TextStyle(
        fontSize: isWeb ? 18.0 : 16.0,
        color: Colors.black,
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  // Cached styles for better performance
  static final _fillColor = Colors.grey.shade50;
  static final _hintStyle = TextStyle(
    color: Colors.grey.shade500,
    fontSize: 16.0,
  );
  static final _inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.grey.shade200),
  );
  static final _focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFF002642), width: 2),
  );
  static final _buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF002540),
    foregroundColor: Colors.white,
    disabledBackgroundColor: Colors.grey.shade300,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
    shadowColor: Colors.transparent,
  );
}
