// SHARED_STARTVIEWMODELS.dart
import 'package:flutter/material.dart';
import '../models/SHARED_STARTMODELS.dart';

// Enum for different UI states
enum LoginState {
  initial,
  loading,
  success,
  error,
}

// Enum for different user roles/navigation destinations
enum NavigationDestination {
  none,
  adminHome,
  userHome,
  guest,
}

// LoginViewModel - Manages login screen state and business logic
class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  // Private state variables
  String _email = '';
  String _password = '';
  String? _emailError;
  String? _passwordError;
  String? _firebaseError;
  LoginState _loginState = LoginState.initial;
  UserModel? _currentUser;
  NavigationDestination _navigationDestination = NavigationDestination.none;

  // Constructor with dependency injection
  LoginViewModel({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository();

  // Getters for the View to access state
  String get email => _email;
  String get password => _password;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get firebaseError => _firebaseError;
  LoginState get loginState => _loginState;
  bool get isLoading => _loginState == LoginState.loading;
  UserModel? get currentUser => _currentUser;
  NavigationDestination get navigationDestination => _navigationDestination;
  
  // Get user role if user is logged in
  String? get userRole => _currentUser?.role;

  // Check if form is valid (no errors and both fields filled)
  bool get isFormValid {
    return _emailError == null && 
           _passwordError == null && 
           _email.isNotEmpty && 
           _password.isNotEmpty;
  }

  // Update email with validation
  void setEmail(String value) {
    _email = value;
    _emailError = ValidationHelper.validateEmail(value);
    _clearFirebaseError(); // Clear any previous Firebase errors
    notifyListeners();
  }

  // Update password with validation
  void setPassword(String value) {
    _password = value;
    _passwordError = ValidationHelper.validatePassword(value);
    _clearFirebaseError(); // Clear any previous Firebase errors
    notifyListeners();
  }

  // Clear Firebase error when user starts typing
  void _clearFirebaseError() {
    if (_firebaseError != null) {
      _firebaseError = null;
    }
  }

  // Reset all form data and errors
  void resetForm() {
    _email = '';
    _password = '';
    _emailError = null;
    _passwordError = null;
    _firebaseError = null;
    _loginState = LoginState.initial;
    _navigationDestination = NavigationDestination.none;
    notifyListeners();
  }

  // Main login method
  Future<bool> loginWithFirebase() async {
    // Validate form before proceeding
    if (!isFormValid) {
      _firebaseError = 'Please fix the form errors.';
      _loginState = LoginState.error;
      notifyListeners();
      return false;
    }

    // Set loading state
    _loginState = LoginState.loading;
    _firebaseError = null;
    _navigationDestination = NavigationDestination.none;
    notifyListeners();

    try {
      // Create login request
      final loginRequest = LoginRequest(
        email: _email,
        password: _password,
      );

      // Attempt login through repository
      final loginResponse = await _authRepository.signInWithEmailAndPassword(loginRequest);

      if (loginResponse.success && loginResponse.user != null) {
        // Login successful
        _currentUser = loginResponse.user;
        _loginState = LoginState.success;
        
        // Determine navigation destination based on user role
        switch (_currentUser!.role) {
          case 'admin':
            _navigationDestination = NavigationDestination.adminHome;
            break;
          case 'user':
            _navigationDestination = NavigationDestination.userHome;
            break;
          default:
            _navigationDestination = NavigationDestination.userHome; // Default fallback
        }
        
        notifyListeners();
        return true;
        
      } else {
        // Login failed
        _firebaseError = loginResponse.errorMessage ?? 'Login failed. Please try again.';
        _loginState = LoginState.error;
        notifyListeners();
        return false;
      }
      
    } catch (e) {
      // Unexpected error
      _firebaseError = 'An unexpected error occurred: $e';
      _loginState = LoginState.error;
      notifyListeners();
      return false;
    }
  }

  // Guest login method
  void continueAsGuest() {
    _navigationDestination = NavigationDestination.guest;
    _loginState = LoginState.success;
    notifyListeners();
  }

  // Reset navigation destination after navigation is handled
  void clearNavigationDestination() {
    _navigationDestination = NavigationDestination.none;
    notifyListeners();
  }

  // Logout method
  Future<void> logout() async {
    await _authRepository.signOut();
    _currentUser = null;
    resetForm();
  }

  // Check if user is already authenticated
  Future<bool> checkAuthenticationStatus() async {
    try {
      final user = await _authRepository.getCurrentUserWithRole();
      if (user != null) {
        _currentUser = user;
        _loginState = LoginState.success;
        
        // Set navigation based on current user role
        switch (user.role) {
          case 'admin':
            _navigationDestination = NavigationDestination.adminHome;
            break;
          case 'user':
            _navigationDestination = NavigationDestination.userHome;
            break;
        }
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error checking authentication status: $e');
      return false;
    }
  }

  // Password reset method
  Future<bool> resetPassword(String email) async {
    if (ValidationHelper.validateEmail(email) != null) {
      return false;
    }
    
    return await _authRepository.resetPassword(email);
  }

  // Dispose method to clean up resources
  @override
  void dispose() {
    _authRepository.dispose();
    super.dispose();
  }
}

// ForgotPasswordViewModel - Manages forgot password screen
class ForgotPasswordViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  
  String _email = '';
  String? _emailError;
  String? _message;
  bool _isLoading = false;
  bool _isSuccess = false;

  ForgotPasswordViewModel({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository();

  // Getters
  String get email => _email;
  String? get emailError => _emailError;
  String? get message => _message;
  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;
  bool get isFormValid => _emailError == null && _email.isNotEmpty;

  // Set email with validation
  void setEmail(String value) {
    _email = value;
    _emailError = ValidationHelper.validateEmail(value);
    _clearMessage();
    notifyListeners();
  }

  void _clearMessage() {
    if (_message != null) {
      _message = null;
      _isSuccess = false;
    }
  }

  // Send password reset email
  Future<bool> sendPasswordResetEmail() async {
    if (!isFormValid) {
      _message = 'Please enter a valid email address.';
      _isSuccess = false;
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _message = null;
    notifyListeners();

    try {
      final success = await _authRepository.resetPassword(_email);
      
      if (success) {
        _message = 'Password reset email sent successfully. Check your inbox.';
        _isSuccess = true;
      } else {
        _message = 'Failed to send password reset email. Please try again.';
        _isSuccess = false;
      }
      
      return success;
    } catch (e) {
      _message = 'An error occurred: $e';
      _isSuccess = false;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset form
  void resetForm() {
    _email = '';
    _emailError = null;
    _message = null;
    _isLoading = false;
    _isSuccess = false;
    notifyListeners();
  }
}
