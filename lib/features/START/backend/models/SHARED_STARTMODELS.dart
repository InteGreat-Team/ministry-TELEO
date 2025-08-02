// SHARED_STARTMODELS.dart
import '../models/SHARED_STARTMODELS.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// User Model - Represents user data structure
class UserModel {
  final String uid;
  final String email;
  final String role;
  final String? displayName;
  final String? photoURL;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    this.displayName,
    this.photoURL,
  });

  factory UserModel.fromFirebaseUser(User user, String role) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      role: role,
      displayName: user.displayName,
      photoURL: user.photoURL,
    );
  }

  // Convert to JSON for storage/transmission
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'displayName': displayName,
      'photoURL': photoURL,
    };
  }

  // Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      displayName: json['displayName'],
      photoURL: json['photoURL'],
    );
  }
}

// Login Request Model - Represents login form data
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  // Validation methods
  bool get isEmailValid {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return email.isNotEmpty && emailRegex.hasMatch(email);
  }

  bool get isPasswordValid {
    return password.isNotEmpty;
  }

  bool get isValid => isEmailValid && isPasswordValid;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

// Login Response Model - Represents API response structure
class LoginResponse {
  final bool success;
  final UserModel? user;
  final String? errorMessage;
  final String? token;

  LoginResponse({
    required this.success,
    this.user,
    this.errorMessage,
    this.token,
  });

  factory LoginResponse.success(UserModel user, String? token) {
    return LoginResponse(
      success: true,
      user: user,
      token: token,
    );
  }

  factory LoginResponse.failure(String errorMessage) {
    return LoginResponse(
      success: false,
      errorMessage: errorMessage,
    );
  }
}

// Auth Repository - Handles all authentication-related data operations
class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final http.Client _httpClient;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    http.Client? httpClient,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _httpClient = httpClient ?? http.Client();

  // Get current user if logged in
  User? get currentUser => _firebaseAuth.currentUser;

  // Stream of authentication state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Fetch user role from API
  Future<String?> fetchUserRole(String email) async {
    try {
      // Special case for test admin
      if (email.toLowerCase() == 'admin@test.com') {
        return 'admin';
      }

      final uri = Uri.parse(
        'https://asia-southeast1-teleo-church-application.cloudfunctions.net/getUserRole?email=$email',
      );
      
      final response = await _httpClient.get(uri);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['role'] as String?;
      } else {
        throw Exception('Failed to fetch user role: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user role: $e');
      return null;
    }
  }

  // Sign in with email and password
  Future<LoginResponse> signInWithEmailAndPassword(LoginRequest request) async {
    try {
      if (!request.isValid) {
        return LoginResponse.failure('Invalid email or password format');
      }

      // Authenticate with Firebase
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: request.email.trim(),
        password: request.password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        return LoginResponse.failure('Authentication failed');
      }

      // Fetch user role
      final role = await fetchUserRole(request.email.trim());
      if (role == null) {
        return LoginResponse.failure('User role not found or not authorized');
      }

      // Get ID token
      final idToken = await firebaseUser.getIdToken();
      
      // Create user model
      final user = UserModel.fromFirebaseUser(firebaseUser, role);
      
      return LoginResponse.success(user, idToken);
      
    } on FirebaseAuthException catch (e) {
      return LoginResponse.failure(e.message ?? 'Authentication failed');
    } catch (e) {
      return LoginResponse.failure('An unexpected error occurred: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Error sending password reset email: $e');
      return false;
    }
  }

  // Check if user is currently authenticated
  bool get isAuthenticated => currentUser != null;

  // Get current user with role
  Future<UserModel?> getCurrentUserWithRole() async {
    final firebaseUser = currentUser;
    if (firebaseUser == null) return null;

    final role = await fetchUserRole(firebaseUser.email ?? '');
    if (role == null) return null;

    return UserModel.fromFirebaseUser(firebaseUser, role);
  }

  // Dispose resources
  void dispose() {
    _httpClient.close();
  }
}

// Validation Helper - Centralized validation logic
class ValidationHelper {
  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email cannot be empty';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    
    return null; // No error
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty';
    }
    
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null; // No error
  }

  static String? validateRequired(String value, String fieldName) {
    if (value.trim().isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null;
  }
}
