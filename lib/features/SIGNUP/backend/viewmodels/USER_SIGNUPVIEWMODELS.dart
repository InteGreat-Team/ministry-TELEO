// lib/features/SIGNUP/backend/viewmodels/USER_SIGNUPVIEWMODELS.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:teleo_app/features/SIGNUP/backend/models/USER_SIGNUPMODELS.dart';
import 'package:teleo_app/features/SIGNUP/backend/services/email_service.dart';
import 'package:teleo_app/features/SIGNUP/backend/services/user_registration_api_service.dart';
import 'package:teleo_app/features/SIGNUP/backend/services/profile_upload_service.dart';
import 'package:teleo_app/features/SIGNUP/geolocation/backend/GEO_LOCATIONMODEL.dart'; // Import GeoLocationModel
import 'package:teleo_app/features/SIGNUP/geolocation/frontend/search_result_item.dart'; // For SearchResultItem
import 'package:teleo_app/features/SIGNUP/frontend/screens/USER_NAMESCREEN_2.dart';
import 'package:teleo_app/features/SIGNUP/frontend/screens/USER_BIRTHDAYSCREEN_3.dart';
import 'package:teleo_app/features/SIGNUP/frontend/screens/USER_GENDERSCREEN_4.dart';
import 'package:teleo_app/features/SIGNUP/frontend/screens/USER_USERNAMESCREEN_5.dart';
import 'package:teleo_app/features/SIGNUP/frontend/screens/USER_LOCATIONQUESTIONSCREEN_6.dart';
import 'package:teleo_app/features/SIGNUP/geolocation/frontend/GEO_GEOLOCATIONSCREEN_7.dart';
import 'package:teleo_app/features/SIGNUP/frontend/screens/USER_CONTACTINFOSCREEN_8.dart';
import 'package:teleo_app/features/SIGNUP/frontend/screens/USER_PASSWORDSCREEN_9.dart';
import 'package:teleo_app/features/SIGNUP/frontend/screens/USER_TERMSANDCONDITIONSSCREEN_10.dart'; // Updated name
import 'package:teleo_app/features/SIGNUP/frontend/screens/USER_VERIFICATIONCODESCREEN_11.dart'; // Updated name
import 'package:teleo_app/features/SIGNUP/frontend/screens/USER_PROFILEPICTURESCREEN_12.dart'; // Updated name
import 'package:teleo_app/features/SIGNUP/frontend/screens/USER_SIGNUPCOMPLETESCREEN_13.dart'; // Updated name
import 'package:teleo_app/features/START/frontend/screens/SHARED_LOGINSCREEN.dart'; // For navigation after signup
import 'package:teleo_app/features/SIGNUP/frontend/screens/CHURCH_WELCOMESCREEN_1.dart'; // For navigation to church setup
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For File

class UserSignupViewModel extends ChangeNotifier {
  UserSignupData _signupData = UserSignupData();
  final EmailService _emailService;
  final UserRegistrationApiService _registrationApiService;
  final ProfileUploadService _profileUploadService;

  // Controllers for text fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _verificationCodeController = TextEditingController();

  // Error messages for validation
  String? _firstNameError;
  String? _lastNameError;
  String? _birthdayError;
  String? _genderError;
  String? _usernameError;
  String? _locationError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _verificationCodeError;
  String? _termsError;
  String? _profilePictureError;

  // Loading states
  bool _isLoading = false;
  bool _isCheckingUsername = false;
  bool _isSendingCode = false;
  bool _isVerifyingCode = false;
  bool _isRegisteringUser = false;
  bool _isUploadingProfilePicture = false;

  // Cooldown for resending verification code
  int _cooldownSeconds = 0;
  Timer? _cooldownTimer;

  // Profile picture
  File? _selectedProfilePicture;

  UserSignupViewModel({
    required EmailService emailService,
    required UserRegistrationApiService registrationApiService,
    required ProfileUploadService profileUploadService,
  })  : _emailService = emailService,
        _registrationApiService = registrationApiService,
        _profileUploadService = profileUploadService {
    _firstNameController.addListener(() => validateFirstName(_firstNameController.text));
    _lastNameController.addListener(() => validateLastName(_lastNameController.text));
    _usernameController.addListener(() => validateUsername(_usernameController.text));
    _emailController.addListener(() => validateEmail(_emailController.text));
    _phoneController.addListener(() => validatePhoneNumber(_phoneController.text));
    _passwordController.addListener(() => validatePassword(_passwordController.text));
    _confirmPasswordController.addListener(() => validateConfirmPassword(_confirmPasswordController.text));
    _verificationCodeController.addListener(() => validateVerificationCode(_verificationCodeController.text));
  }

  // Getters for signup data
  UserSignupData get signupData => _signupData;

  // Getters for controllers
  TextEditingController get firstNameController => _firstNameController;
  TextEditingController get lastNameController => _lastNameController;
  TextEditingController get usernameController => _usernameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get confirmPasswordController => _confirmPasswordController;
  TextEditingController get verificationCodeController => _verificationCodeController;

  // Getters for errors
  String? get firstNameError => _firstNameError;
  String? get lastNameError => _lastNameError;
  String? get birthdayError => _birthdayError;
  String? get genderError => _genderError;
  String? get usernameError => _usernameError;
  String? get locationError => _locationError;
  String? get emailError => _emailError;
  String? get phoneError => _phoneError;
  String? get passwordError => _passwordError;
  String? get confirmPasswordError => _confirmPasswordError;
  String? get verificationCodeError => _verificationCodeError;
  String? get termsError => _termsError;
  String? get profilePictureError => _profilePictureError;

  // Getters for loading states
  bool get isLoading => _isLoading;
  bool get isSendingCode => _isSendingCode;
  bool get isVerifyingCode => _isVerifyingCode;
  bool get isRegisteringUser => _isRegisteringUser;
  bool get isUploadingProfilePicture => _isUploadingProfilePicture;

  // Getters for cooldown
  bool get isResendingCode => _cooldownSeconds > 0;
  String get formatCooldownTime {
    final minutes = (_cooldownSeconds / 60).floor();
    final seconds = _cooldownSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Getters for profile picture
  File? get selectedProfilePicture => _selectedProfilePicture;

  // --- Validation Getters ---
  bool get isNameValid =>
      _firstNameError == null &&
      _lastNameError == null &&
      _firstNameController.text.isNotEmpty &&
      _lastNameController.text.isNotEmpty;

  bool get isBirthdayValid => _birthdayError == null && _signupData.birthday != null;

  bool get isGenderValid => _genderError == null && _signupData.gender != null;

  bool get isUsernameValid => _usernameError == null && _usernameController.text.isNotEmpty;

  bool get isLocationValid => _locationError == null && _signupData.location != null;

  bool get isContactInfoValid =>
      _emailError == null &&
      _phoneError == null &&
      _emailController.text.isNotEmpty;

  bool get isPasswordFormValid =>
      _passwordError == null &&
      _confirmPasswordError == null &&
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty &&
      _passwordController.text == _confirmPasswordController.text;

  bool get isVerificationCodeValid => _verificationCodeError == null && _verificationCodeController.text.isNotEmpty;

  bool get areTermsAccepted => _signupData.termsAccepted;

  // --- Setters and Validation Logic ---

  void setFirstName(String value) {
    _signupData = _signupData.copyWith(firstName: value);
    validateFirstName(value);
  }

  bool validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      _firstNameError = 'First name is required';
    } else {
      _firstNameError = null;
    }
    notifyListeners();
    return _firstNameError == null;
  }

  void setLastName(String value) {
    _signupData = _signupData.copyWith(lastName: value);
    validateLastName(value);
  }

  bool validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      _lastNameError = 'Last name is required';
    } else {
      _lastNameError = null;
    }
    notifyListeners();
    return _lastNameError == null;
  }

  Future<void> selectBirthday(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _signupData.birthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _signupData.birthday) {
      _signupData = _signupData.copyWith(birthday: picked);
      validateBirthday(picked);
    }
  }

  bool validateBirthday(DateTime? value) {
    if (value == null) {
      _birthdayError = 'Birthday is required';
    } else {
      _birthdayError = null;
    }
    notifyListeners();
    return _birthdayError == null;
  }

  void setGender(String value) {
    _signupData = _signupData.copyWith(gender: value);
    validateGender(value);
  }

  bool validateGender(String? value) {
    if (value == null || value.isEmpty) {
      _genderError = 'Gender is required';
    } else {
      _genderError = null;
    }
    notifyListeners();
    return _genderError == null;
  }

  void setUsername(String value) {
    _signupData = _signupData.copyWith(username: value);
    validateUsername(value);
  }

  bool validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      _usernameError = 'Username is required';
    } else if (value.length < 3) {
      _usernameError = 'Username must be at least 3 characters';
    } else {
      _usernameError = null;
    }
    notifyListeners();
    return _usernameError == null;
  }

  void setLocation(GeoLocationModel selectedLocation) {
    _signupData = _signupData.copyWith(location: selectedLocation);
    validateLocation();
  }

  bool validateLocation() {
    if (_signupData.location == null || _signupData.location!.address.isEmpty) {
      _locationError = 'Location is required';
    } else {
      _locationError = null;
    }
    notifyListeners();
    return _locationError == null;
  }

  bool validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      _emailError = 'Email is required';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      _emailError = 'Enter a valid email address';
    } else {
      _emailError = null;
    }
    notifyListeners();
    return _emailError == null;
  }

  bool validatePhoneNumber(String? value) {
    if (value != null && value.isNotEmpty) {
      final phoneRegex = RegExp(r'^\+63\d{10}$');
      if (!phoneRegex.hasMatch(value)) {
        _phoneError = 'Enter a valid +63XXXXXXXXXX number';
      } else {
        _phoneError = null;
      }
    } else {
      _phoneError = null; // Optional field, no error if empty
    }
    notifyListeners();
    return _phoneError == null;
  }

  bool validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      _passwordError = 'Password is required';
    } else if (value.length < 6) {
      _passwordError = 'Password must be at least 6 characters';
    } else {
      _passwordError = null;
    }
    notifyListeners();
    return _passwordError == null;
  }

  bool validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      _confirmPasswordError = 'Confirm password is required';
    } else if (value != _passwordController.text) {
      _confirmPasswordError = 'Passwords do not match';
    } else {
      _confirmPasswordError = null;
    }
    notifyListeners();
    return _confirmPasswordError == null;
  }

  bool validateVerificationCode(String? value) {
    if (value == null || value.isEmpty) {
      _verificationCodeError = 'Verification code is required';
    } else if (value.length != 6) { // Assuming a 6-digit code
      _verificationCodeError = 'Code must be 6 digits';
    } else {
      _verificationCodeError = null;
    }
    notifyListeners();
    return _verificationCodeError == null;
  }

  void toggleTermsAccepted(bool? value) {
    _signupData = _signupData.copyWith(termsAccepted: value ?? false);
    validateTermsAccepted();
  }

  bool validateTermsAccepted() {
    if (!_signupData.termsAccepted) {
      _termsError = 'You must accept the terms and conditions';
    } else {
      _termsError = null;
    }
    notifyListeners();
    return _termsError == null;
  }

  void setSelectedProfilePicture(File? file) {
    _selectedProfilePicture = file;
    _profilePictureError = null; // Clear error when a picture is selected
    notifyListeners();
  }

  bool validateProfilePicture() {
    if (_selectedProfilePicture == null) {
      _profilePictureError = 'Profile picture is required';
    } else {
      _profilePictureError = null;
    }
    notifyListeners();
    return _profilePictureError == null;
  }

  // --- Business Logic & Navigation ---

  void navigateToNameScreen(BuildContext context) {
    Navigator.pushNamed(context, UserNamescreen2.routeName);
  }

  void navigateToBirthdayScreen(BuildContext context) {
    if (validateFirstName(_firstNameController.text) && validateLastName(_lastNameController.text)) {
      _signupData = _signupData.copyWith(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
      );
      Navigator.pushNamed(context, UserBirthdayScreen3.routeName);
    }
  }

  void navigateToGenderScreen(BuildContext context) {
    if (validateBirthday(_signupData.birthday)) {
      Navigator.pushNamed(context, UserGenderScreen4.routeName);
    }
  }

  void navigateToUsernameScreen(BuildContext context) {
    if (validateGender(_signupData.gender)) {
      Navigator.pushNamed(context, UserUsernameScreen5.routeName);
    }
  }

  void navigateToLocationQuestionScreen(BuildContext context) {
    if (validateUsername(_usernameController.text)) {
      _signupData = _signupData.copyWith(username: _usernameController.text);
      Navigator.pushNamed(context, UserLocationQuestionScreen6.routeName);
    }
  }

  void navigateToGeolocationScreen(BuildContext context) {
    Navigator.pushNamed(context, UserGeolocationScreen7.routeName);
  }

  void handleLocationConfirmed(BuildContext context, GeoLocationModel location) {
    setLocation(location);
    // After confirming location on map, navigate to contact info screen
    Navigator.pushNamed(context, UserContactInfoScreen8.routeName);
  }

  Future<void> handleContactInfoNext(BuildContext context) async {
    if (!validateEmail(_emailController.text) || !validatePhoneNumber(_phoneController.text)) {
      return;
    }

    _isSendingCode = true;
    notifyListeners();

    try {
      _signupData = _signupData.copyWith(
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      );

      final sentCode = await _emailService.sendVerificationCode(
        _signupData.email!,
        '${_signupData.firstName} ${_signupData.lastName}',
      );
      _signupData = _signupData.copyWith(sentCode: sentCode); // Store the sent code for verification
      _startCooldownTimer(); // Start cooldown after sending code

      if (context.mounted) {
        Navigator.pushNamed(context, UserPasswordScreen9.routeName);
      }
    } catch (e) {
      _emailError = 'Failed to send verification code: ${e.toString()}';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_emailError!), backgroundColor: Colors.red),
      );
    } finally {
      _isSendingCode = false;
      notifyListeners();
    }
  }

  Future<void> resendVerificationCode(BuildContext context) async {
    if (_cooldownSeconds > 0) return; // Prevent resending during cooldown

    _isSendingCode = true;
    notifyListeners();
    _startCooldownTimer(); // Start cooldown immediately

    try {
      final sentCode = await _emailService.sendVerificationCode(
        _signupData.email!,
        '${_signupData.firstName} ${_signupData.lastName}',
      );
      _signupData = _signupData.copyWith(sentCode: sentCode);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification code re-sent!')),
        );
      }
    } catch (e) {
      _emailError = 'Failed to resend verification code: ${e.toString()}';
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_emailError!), backgroundColor: Colors.red),
        );
      }
      _cooldownTimer?.cancel(); // Cancel timer if resend fails
      _cooldownSeconds = 0; // Reset cooldown
      _isSendingCode = false; // Reset loading state
      notifyListeners();
    } finally {
      _isSendingCode = false; // This will be set to false after the try/catch
      notifyListeners();
    }
  }

  void _startCooldownTimer() {
    _cooldownSeconds = 60; // Set initial cooldown
    _cooldownTimer?.cancel(); // Cancel any existing timer
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_cooldownSeconds > 0) {
        _cooldownSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
        notifyListeners();
      }
    });
  }

  void handlePasswordNext(BuildContext context) {
    if (!validatePassword(_passwordController.text) || !validateConfirmPassword(_confirmPasswordController.text)) {
      return;
    }
    _signupData = _signupData.copyWith(password: _passwordController.text);
    Navigator.pushNamed(context, UserTermsAndConditionsScreen10.routeName);
  }

  void handleTermsConditionsNext(BuildContext context) {
    if (!validateTermsAccepted()) {
      return;
    }
    Navigator.pushNamed(context, UserVerificationCodescreen11.routeName);
  }

  Future<void> verifyCodeAndProceed(BuildContext context) async {
    if (!validateVerificationCode(_verificationCodeController.text)) {
      return;
    }

    _isVerifyingCode = true;
    notifyListeners();

    try {
      final isVerified = await _emailService.verifyCode(
        _signupData.email!,
        _verificationCodeController.text.trim(),
      );

      if (isVerified) {
        if (context.mounted) {
          Navigator.pushNamed(context, UserProfilePictureScreen12.routeName);
        }
      } else {
        _verificationCodeError = 'Invalid verification code';
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid verification code'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      _verificationCodeError = 'Verification failed: ${e.toString()}';
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_verificationCodeError!), backgroundColor: Colors.red),
        );
      }
    } finally {
      _isVerifyingCode = false;
      notifyListeners();
    }
  }

  Future<void> pickAndUploadProfilePicture(BuildContext context, ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setSelectedProfilePicture(File(image.path));
      if (!validateProfilePicture()) {
        return; // Should not happen if image is picked
      }

      _isUploadingProfilePicture = true;
      notifyListeners();
      try {
        final imageUrl = await _profileUploadService.uploadProfilePicture(_selectedProfilePicture!);
        if (imageUrl != null) {
          _signupData = _signupData.copyWith(profilePictureUrl: imageUrl);
          // Proceed to final registration after successful upload
          await registerUser(context);
        } else {
          throw Exception('Failed to get image URL after upload.');
        }
      } catch (e) {
        _profilePictureError = 'Error uploading picture: ${e.toString()}';
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_profilePictureError!), backgroundColor: Colors.red),
          );
        }
      } finally {
        _isUploadingProfilePicture = false;
        notifyListeners();
      }
    } else {
      _profilePictureError = 'No image selected.';
      notifyListeners();
    }
  }

  Future<void> registerUser(BuildContext context) async {
    _isRegisteringUser = true;
    notifyListeners();

    try {
      // Ensure all required data is present before registering
      if (_signupData.firstName == null ||
          _signupData.lastName == null ||
          _signupData.birthday == null ||
          _signupData.gender == null ||
          _signupData.username == null ||
          _signupData.email == null ||
          _signupData.password == null ||
          _signupData.location == null ||
          !_signupData.termsAccepted) {
        throw Exception('Missing required signup data for registration.');
      }

      // Set a default user role before sending to backend
      _signupData = _signupData.copyWith(userRole: 'user');

      final response = await _registrationApiService.registerUser(_signupData.toJson());

      if (response.statusCode == 200) {
        if (context.mounted) {
          Navigator.pushNamed(context, UserSignupCompleteScreen13.routeName);
        }
      } else {
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${e.toString()}')),
        );
      }
    } finally {
      _isRegisteringUser = false;
      notifyListeners();
    }
  }

  void navigateToChurchWelcomeScreen(BuildContext context) {
    // This method handles navigation to the church setup screen
    Navigator.pushNamed(context, ChurchWelcomeScreen1.routeName);
  }

  void navigateToAppAfterSignup(BuildContext context) {
    // This method handles navigation to the main app (e.g., login screen)
    resetSignupFlow(); // Clear signup data
    Navigator.pushNamedAndRemoveUntil(
      context,
      SharedLoginScreen.routeName,
      (route) => false, // Remove all previous routes
    );
  }

  void resetSignupFlow() {
    _signupData.reset();
    _firstNameController.clear();
    _lastNameController.clear();
    _usernameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _verificationCodeController.clear();
    _selectedProfilePicture = null;

    _firstNameError = null;
    _lastNameError = null;
    _birthdayError = null;
    _genderError = null;
    _usernameError = null;
    _locationError = null;
    _emailError = null;
    _phoneError = null;
    _passwordError = null;
    _confirmPasswordError = null;
    _verificationCodeError = null;
    _termsError = null;
    _profilePictureError = null;

    _isLoading = false;
    _isCheckingUsername = false;
    _isSendingCode = false;
    _isVerifyingCode = false;
    _isRegisteringUser = false;
    _isUploadingProfilePicture = false;
    _cooldownSeconds = 0;
    _cooldownTimer?.cancel();

    notifyListeners();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _verificationCodeController.dispose();
    _cooldownTimer?.cancel(); // Cancel the cooldown timer
    super.dispose();
  }
}
