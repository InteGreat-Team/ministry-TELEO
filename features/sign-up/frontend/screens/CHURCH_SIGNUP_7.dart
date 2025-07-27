import 'package:flutter/material.dart';
import '../../backend/models/CHURCH_SIGNUP_VAR.dart'; // For ChurchModel, PasswordValidation
import '../widgets/index.dart'; // For TeleoBackButton, CustomHeader, CustomTextFormField, CustomElevatedButton

class ChurchSecureAccountScreen extends StatefulWidget {
  final ChurchModel church;

  const ChurchSecureAccountScreen({super.key, required this.church});

  @override
  State<ChurchSecureAccountScreen> createState() =>
      _ChurchSecureAccountScreenState();
}

class _ChurchSecureAccountScreenState extends State<ChurchSecureAccountScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    // Add listeners to update form validity
    _passwordController.addListener(_updateFormValidity);
    _confirmPasswordController.addListener(_updateFormValidity);
    
    // Initial validation check
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateFormValidity());
  }

  @override
  void dispose() {
    _passwordController.removeListener(_updateFormValidity);
    _confirmPasswordController.removeListener(_updateFormValidity);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updateFormValidity() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            onChanged: () {
              _updateFormValidity();
            },
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
                  title: "Secure your\nAccount",
                  icon: Icons.lock_outline,
                  iconColor: Colors.black,
                ),
                const SizedBox(height: 32),
                
                // Password
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  labelText: 'Password',
                  hintText: 'password',
                  icon: Icons.lock,
                  validator: (value) => PasswordValidation.validatePassword(value),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                
                // Confirm Password
                const Text(
                  'Confirm Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  labelText: 'Confirm Password',
                  hintText: 'confirm password',
                  icon: Icons.lock,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm password is required';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                
                const Spacer(),
                
                // Next button
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: CustomElevatedButton(
                    onPressed: _isFormValid
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              final updatedChurch = widget.church.copyWith(
                                password: _passwordController.text, // Assuming ChurchModel has a password field
                              );
                              
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChurchAdminInfoScreen(
                                    church: updatedChurch,
                                  ),
                                ),
                              );
                            }
                          }
                        : null,
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
      ),
    );
  }
}
