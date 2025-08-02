// lib/features/SIGNUP/backend/viewmodels/USER_SIGNUPVIEWMODELS.dart
//IMPORT PACKAGES
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

//IMPORT MVVM UPDATED
// Assuming these are the paths to your screens
import '../../../../features/START/frontend/screens/SHARED_LOGINSCREEN.dart' as main_welcome;
import '../../frontend/screens/USER_WELCOMESCREEN_1.dart'; 
import '../../frontend/screens/USER_NAMESCREEN_2.dart'; 
import '../../frontend/screens/USER_BIRTHDAYSCREEN_3.dart'; 
import '../../frontend/screens/USER_GENDERSCREEN_4.dart'; 
import '../../frontend/screens/USER_USERNAMESCREEN_5.dart'; 
import '../../frontend/screens/USER_LOCATIONQUESTIONSCREEN_6.dart'; 
import '../../frontend/screens/USER_GEOLOCATIONSCREEN_7.dart';
//import '../../frontend/screens/USER_CONTACTINFOSCREEN_8.dart'; 
import '../../geolocation/backend/GEO_LOCATIONVIEWMODEL.dart';
import '../../geolocation/frontend/GEO_LOCATIONCUBIT.dart'; 
import '../../../SIGNUP/backend/models/USER_SIGNUPMODELS.dart';

// IMPORT NOT MVVM UPDATED
import '../../../../1/c1registrationflow/c1s5_2geolocation_screen.dart'; 
import '../models/USER_SIGNUPMODELS.dart';


class UserSignupViewModel extends ChangeNotifier {
  late AnimationController _textAnimationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;
  Timer? _navigationTimer;
  bool _showSkipButton = false;
  BuildContext? _context; // Store context to navigate

  // Data model for signup
  UserSignupData _signupData = UserSignupData();

  // TextEditingControllers for the name input screen
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(); // NEW
  final TextEditingController _passwordController = TextEditingController(); // NEW

  // Getters for UI to consume
  Animation<double> get fadeInAnimation => _fadeInAnimation;
  Animation<double> get scaleAnimation => _scaleAnimation;
  bool get showSkipButton => _showSkipButton;
  AnimationController get textAnimationController => _textAnimationController;

  String get firstName => _signupData.firstName;
  String get lastName => _signupData.lastName;
  DateTime? get birthday => _signupData.birthday;
  String? get gender => _signupData.gender;
  String? get username => _signupData.username;
  String? get address => _signupData.address;
  double? get lat => _signupData.lat;
  double? get lng => _signupData.lng;
  String get email => _signupData.email; // NEW
  String get password => _signupData.password; // NEW

  bool get isNameFormValid => _signupData.isValid;
  bool get isNameInputValid => _signupData.firstName.isNotEmpty && _signupData.lastName.isNotEmpty;
  bool get isGenderSelected => _signupData.gender != null;
  bool get isUsernameInputValid => _signupData.username != null && _signupData.username!.isNotEmpty;
  bool get isLocationSelected => _signupData.address != null && _signupData.address!.isNotEmpty;
  bool get isEmailPasswordValid => _signupData.email.isNotEmpty && _signupData.password.isNotEmpty; // NEW

  // Expose controllers for the UI to use
  TextEditingController get firstNameController => _firstNameController;
  TextEditingController get lastNameController => _lastNameController;
  TextEditingController get usernameController => _usernameController;
  TextEditingController get emailController => _emailController; // NEW
  TextEditingController get passwordController => _passwordController; // NEW

  UserSignupViewModel() {
    // Listen to changes in controllers and update model
    _firstNameController.addListener(() {
      if (_signupData.firstName != _firstNameController.text) {
        _signupData.firstName = _firstNameController.text;
        notifyListeners();
      }
    });
    _lastNameController.addListener(() {
      if (_signupData.lastName != _lastNameController.text) {
        _signupData.lastName = _lastNameController.text;
        notifyListeners();
      }
    });
    _usernameController.addListener(() {
      if (_signupData.username != _usernameController.text) {
        _signupData.username = _usernameController.text;
        notifyListeners();
      }
    });
    _emailController.addListener(() { // NEW
      if (_signupData.email != _emailController.text) {
        _signupData.email = _emailController.text;
        notifyListeners();
      }
    });
    _passwordController.addListener(() { // NEW
      if (_signupData.password != _passwordController.text) {
        _signupData.password = _passwordController.text;
        notifyListeners();
      }
    });
  }

  void initAnimations(TickerProvider vsync) {
    _textAnimationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _textAnimationController.forward();
    });

    // Show skip button after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      _showSkipButton = true;
      notifyListeners();
    });

    // Set timer to navigate to next screen after 3 seconds
    _navigationTimer = Timer(const Duration(milliseconds: 3000), () {
      if (_context != null) {
        navigateToNameScreen(_context!);
      }
    });
  }

  void setContext(BuildContext context) {
    _context = context;
  }

  // Navigation methods
  void navigateToNameScreen(BuildContext context) {
    _navigationTimer?.cancel(); // Cancel any pending timers
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ChangeNotifierProvider.value(
          value: this, // Provide the same ViewModel instance
          child: const UserNamescreen2(), // Navigate to the name screen
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void navigateToBirthdayScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: this, // Provide the same ViewModel instance
          child: const UserBirthdayScreen3(), // Navigate to the birthday screen
        ),
      ),
    );
  }

  void navigateToGenderScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: this, // Provide the same ViewModel instance
          child: const UserGenderScreen4(), // Navigate to the gender screen
        ),
      ),
    );
  }

  void navigateToUsernameScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: this, // Provide the same ViewModel instance
          child: const UserUsernameScreen5(), // Navigate to the username screen
        ),
      ),
    );
  }

  void navigateToLocationQuestionScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiProvider( // Provide both ViewModels
          providers: [
            ChangeNotifierProvider.value(value: this), // UserSignupViewModel
            ChangeNotifierProvider(create: (_) => LocationViewModel()), // UPDATED: Reverted to LocationViewModel
          ],
          child: const UserLocationQuestionScreen6(), // Navigate to the location question screen
        ),
      ),
    );
  }

  void navigateToGeolocationScreen(BuildContext context) { // UPDATED: Navigation to GeolocationScreen
    // Ensure location data is set before navigating
    if (_signupData.address == null || _signupData.lat == null || _signupData.lng == null) {
      // This should ideally not happen if previous screen validation is correct
      print('Error: Location data missing for GeolocationScreen navigation.');
      // Optionally, navigate back or show an error
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: this), // UserSignupViewModel
            BlocProvider(create: (_) => LocationCubit( // UPDATED: Still using Cubit for map screen
              LatLng(_signupData.lat!, _signupData.lng!),
              _signupData.address!,
            )),
          ],
          child: const UserGeolocationScreen7(), // Navigate to the new geolocation map screen
        ),
      ),
    );
  }

  void navigateToContactInfoScreen(BuildContext context) { // NEW: Navigation to ContactInfoScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: this, // Provide the same ViewModel instance
          child: const UserContactInfoScreen8(), // Navigate to the contact info screen
        ),
      ),
    );
  }

  void navigateBackToWelcome(BuildContext context) {
    _navigationTimer?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const main_welcome.LoginScreen(),
      ),
    );
  }

  void skipWelcome(BuildContext context) {
    _navigationTimer?.cancel();
    navigateToNameScreen(context);
  }

  // Name input handlers (for USER_NAMESCREEN_2.dart)
  void setFirstName(String value) {
    _signupData.firstName = value;
    notifyListeners();
  }

  void setLastName(String value) {
    _signupData.lastName = value;
    notifyListeners();
  }

  // Birthday input handler (for USER_BIRTHDAYSCREEN_3.dart)
  void setBirthday(DateTime date) {
    _signupData.birthday = date;
    notifyListeners();
  }

  // Gender input handler (for USER_GENDERSCREEN_4.dart)
  void setGender(String value) {
    _signupData.gender = value;
    notifyListeners();
  }

  // Username input handler (for USER_USERNAMESCREEN_5.dart)
  void setUsername(String value) {
    _signupData.username = value;
    notifyListeners();
  }

  // Location input handlers (for USER_LOCATIONQUESTIONSCREEN_6.dart and USER_GEOLOCATIONSCREEN_7.dart)
  void setAddress(String value) {
    _signupData.address = value;
    notifyListeners();
  }

  void setLat(double value) {
    _signupData.lat = value;
    notifyListeners();
  }

  void setLng(double value) {
    _signupData.lng = value;
    notifyListeners();
  }

  // Email and Password handlers (NEW)
  void setEmail(String value) {
    _signupData.email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _signupData.password = value;
    notifyListeners();
  }

  // Finalize location from map and navigate
  void finalizeLocationFromMap(String address, double lat, double lng, BuildContext context) {
    setAddress(address);
    setLat(lat);
    setLng(lng);
    navigateToContactInfoScreen(context);
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    _navigationTimer?.cancel();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose(); // NEW
    _passwordController.dispose(); // NEW
    super.dispose();
  }
}

