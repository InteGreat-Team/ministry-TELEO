//SHARED_LOGINSCREEN.dart
//IMPORT PACKAGES
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart'; 

//IMPORT MVVM UPDATED 
import '../../backend/viewmodels/SHARED_STARTVIEWMODELS.dart'; // Import the ViewModel and enums
import '../../backend/models/SHARED_STARTMODELS.dart'; // Import the Models

// If imports are not working, temporarily define enum here:
// enum NavigationDestination {
//   none,
//   adminHome,
//   userHome,
//   guest,
// }

// Fixed import paths based on your file structure
import '../../../../3/widget_login/login_widget.dart';  // Fixed path
import '../../../../3/navigation_service.dart'; // Fixed path 
import '../../../../1/c1homepage/home_page.dart'; // User home page
import '../../../../2/c1homepage/home_page.dart' as AdminHomePage; // Admin home page with alias

class LogoHeader extends StatelessWidget {
  final double logoHeight;
  const LogoHeader({super.key, required this.logoHeight});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/teleo_logo.png', height: logoHeight);
  }
}

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  final bool obscureText;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;

  const InputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.errorText,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        border: const OutlineInputBorder(),
        suffixIcon: suffixIcon,
      ),
      obscureText: obscureText,
      onChanged: onChanged,
      keyboardType: keyboardType,
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF002642),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 0,
      ),
    );
  }
}

class OutlinedGuestButton extends StatelessWidget {
  final VoidCallback onPressed;

  const OutlinedGuestButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: const Text('Continue as Guest'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF002642),
        side: const BorderSide(color: Color(0xFF002642)),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}

class FooterLinks extends StatelessWidget {
  const FooterLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {},
            child: const Text('Privacy Policy'),
          ),
          const Text('•'),
          TextButton(
            onPressed: () {},
            child: const Text('Terms of Service'),
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Listen to changes in the ViewModel and update local controllers
    // This is important for initial state and if ViewModel updates its internal email/password
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  void _onEmailChanged() {
    Provider.of<LoginViewModel>(context, listen: false).setEmail(_emailController.text);
  }

  void _onPasswordChanged() {
    Provider.of<LoginViewModel>(context, listen: false).setPassword(_passwordController.text);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onEmailChanged);
    _passwordController.removeListener(_onPasswordChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _continueAsGuest() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Continue as Guest'),
        content: const Text(
          'You will have limited access to admin features. Some functions may require authentication.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Use existing NavigationService for guest (goes to admin page)
              NavigationService.navigateToAdminHome(context);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Color(0xFF002642)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Consumer<LoginViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: screenSize.height * 0.04),
                  LogoHeader(logoHeight: screenSize.height * 0.15),
                  SizedBox(height: screenSize.height * 0.06),
                  const Text(
                    'Email Address',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF002642)),
                  ),
                  const SizedBox(height: 8),
                  InputField(
                    controller: _emailController,
                    hintText: 'Email',
                    errorText: viewModel.emailError,
                    onChanged: viewModel.setEmail, // ViewModel handles validation
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Password',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF002642)),
                  ),
                  const SizedBox(height: 8),
                  InputField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: _obscurePassword,
                    errorText: viewModel.passwordError,
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    onChanged: viewModel.setPassword, // ViewModel handles validation
                  ),
                  if (viewModel.firebaseError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(viewModel.firebaseError!,
                          style: const TextStyle(color: Colors.red, fontSize: 12)),
                    ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    onPressed: viewModel.isFormValid && !viewModel.isLoading
                        ? () async {
                            bool success = await viewModel.loginWithFirebase();
                            if (success && mounted) {
                              // Use existing NavigationService based on user role
                              final userRole = viewModel.userRole;
                              
                              if (userRole == 'admin') {
                                NavigationService.navigateToAdminHome(context);
                              } else if (userRole == 'user') {
                                NavigationService.navigateToUserHome(context);
                              } else {
                                // Default to user home for unknown roles
                                NavigationService.navigateToUserHome(context);
                              }
                            }
                          }
                        : null,
                    isLoading: viewModel.isLoading,
                    label: 'LOGIN',
                  ),
                  const SizedBox(height: 16),
                  OutlinedGuestButton(onPressed: _continueAsGuest),
                  const FooterLinks(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}